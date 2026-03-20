from __future__ import annotations

import argparse
import datetime as dt
import difflib
import re
import unicodedata
import xml.etree.ElementTree as ET
import json
import zipfile
from collections import Counter, defaultdict, deque
from dataclasses import dataclass
from functools import lru_cache
from pathlib import Path
from typing import Dict, Iterable, List, Optional, Sequence, Tuple


NS = {"main": "http://schemas.openxmlformats.org/spreadsheetml/2006/main"}
WORKBOOK_REL_NS = "{http://schemas.openxmlformats.org/officeDocument/2006/relationships}id"


@dataclass
class PersonRow:
    tt: int
    full_name: str
    gender_raw: Optional[str]
    dob_raw: Optional[str]
    dod_raw: Optional[str]
    generation: Optional[int]
    branch_raw: Optional[str]
    relation_raw: Optional[str]
    father_name: Optional[str]
    mother_name: Optional[str]
    spouse_name: Optional[str]
    child_cells: List[str]
    hometown: Optional[str]
    residence: Optional[str]
    occupation: Optional[str]
    note: Optional[str]

    branch_key: str
    full_name_canon: str
    birth_year: Optional[int]
    death_year: Optional[int]
    child_names: List[str]


def normalize_text(value: Optional[object]) -> Optional[str]:
    if value is None:
        return None
    text = re.sub(r"\s+", " ", str(value).strip())
    return text or None


@lru_cache(maxsize=None)
def canonicalize(value: Optional[str]) -> str:
    text = normalize_text(value)
    if not text:
        return ""
    text = text.replace("\u0111", "d").replace("\u0110", "D")
    text = unicodedata.normalize("NFD", text)
    text = "".join(ch for ch in text if unicodedata.category(ch) != "Mn")
    text = text.lower().replace("đ", "d")
    text = re.sub(r"[^a-z0-9 ]+", " ", text)
    text = re.sub(r"\s+", " ", text).strip()
    return text


@lru_cache(maxsize=None)
def similarity(left: Optional[str], right: Optional[str]) -> float:
    left_canon = canonicalize(left)
    right_canon = canonicalize(right)
    if not left_canon or not right_canon:
        return 0.0
    if left_canon == right_canon:
        return 1.0
    return difflib.SequenceMatcher(None, left_canon, right_canon).ratio()


@lru_cache(maxsize=None)
def canonical_tokens(value: Optional[str]) -> List[str]:
    canon = canonicalize(value)
    return canon.split() if canon else []


@lru_cache(maxsize=None)
def strong_name_match(reference_name: Optional[str], target_name: Optional[str]) -> bool:
    ref_tokens = canonical_tokens(reference_name)
    target_tokens = canonical_tokens(target_name)
    if not ref_tokens or not target_tokens:
        return False
    if ref_tokens == target_tokens:
        return True
    if len(ref_tokens) >= 2 and len(target_tokens) >= 2 and ref_tokens[-2:] == target_tokens[-2:]:
        return True
    if len(ref_tokens) == len(target_tokens) and len(ref_tokens) >= 2 and ref_tokens[:-1] == target_tokens[:-1]:
        last_ratio = difflib.SequenceMatcher(None, ref_tokens[-1], target_tokens[-1]).ratio()
        if last_ratio >= 0.72:
            return True
    return similarity(reference_name, target_name) >= 0.93


def split_child_names(values: Sequence[str]) -> List[str]:
    names: List[str] = []
    for value in values:
        if not value:
            continue
        for part in re.split(r"\s*,\s*|\s*;\s*", value):
            piece = normalize_text(part)
            if piece:
                names.append(piece)
    return names


def contains_name(haystack: Optional[str], needle: Optional[str]) -> bool:
    haystack_canon = canonicalize(haystack)
    needle_canon = canonicalize(needle)
    return bool(haystack_canon and needle_canon and needle_canon in haystack_canon)


def is_simple_spouse_name(value: Optional[str]) -> bool:
    text = normalize_text(value)
    if not text:
        return False
    canon = canonicalize(text)
    if canon in {"chua ro", "khong ro", "chua biet"}:
        return False
    noisy_tokens = (
        "ba 1",
        "ba1",
        "ba 2",
        "ba2",
        "ba 3",
        "ba3",
        "ba 4",
        "ba4",
        "vo 1",
        "vo1",
        "vo 2",
        "vo2",
        "vo 3",
        "vo3",
        "vo 4",
        "vo4",
        "ba ca",
        "vo ca",
    )
    if any(token in canon for token in noisy_tokens):
        return False
    return "," not in text and ":" not in text


def branch_key(value: Optional[str]) -> str:
    canon = canonicalize(value)
    if not canon:
        return "chinh"
    if "chi 1" in canon:
        return "1"
    if "chi 2" in canon:
        return "2"
    return canon


def branch_sql_name(key: str) -> str:
    if key == "1":
        return "1"
    if key == "2":
        return "2"
    return "Chinh"


@lru_cache(maxsize=None)
def normalize_gender_key(value: Optional[str]) -> Optional[str]:
    canon = canonicalize(value)
    if canon in {"nam", "male"}:
        return "male"
    if canon in {"nu", "female"}:
        return "female"
    return None


@lru_cache(maxsize=None)
def infer_gender_from_relation(relation_raw: Optional[str]) -> Optional[str]:
    canon = canonicalize(relation_raw)
    if not canon:
        return None
    if canon.startswith("vo "):
        return "female"
    if canon.startswith("chong "):
        return "male"
    return None


def build_gender_hints(people: Sequence[PersonRow]) -> Dict[int, str]:
    votes: Dict[int, Dict[str, int]] = defaultdict(lambda: {"male": 0, "female": 0})
    exact_name_index: Dict[str, List[int]] = defaultdict(list)
    for person in people:
        exact_name_index[person.full_name_canon].append(person.tt)

    def add_vote(target_tt: int, gender_key: Optional[str], weight: int) -> None:
        if target_tt is None or gender_key not in {"male", "female"}:
            return
        votes[target_tt][gender_key] += weight

    for person in people:
        explicit = normalize_gender_key(person.gender_raw)
        relation = infer_gender_from_relation(person.relation_raw)
        add_vote(person.tt, explicit, 4)
        add_vote(person.tt, relation, 10)

    for child in people:
        if child.father_name:
            for target_tt in exact_name_index.get(canonicalize(child.father_name), []):
                add_vote(target_tt, "male", 8)
        if child.mother_name:
            for target_tt in exact_name_index.get(canonicalize(child.mother_name), []):
                add_vote(target_tt, "female", 8)

        inferred_parent = extract_relation_parent_name(child.relation_raw)
        relation_role = extract_relation_parent_role_hint(child.relation_raw)
        if inferred_parent and relation_role == "father":
            for target_tt in exact_name_index.get(canonicalize(inferred_parent), []):
                add_vote(target_tt, "male", 6)
        if inferred_parent and relation_role == "mother":
            for target_tt in exact_name_index.get(canonicalize(inferred_parent), []):
                add_vote(target_tt, "female", 6)

    for person in people:
        own_gender = infer_gender_from_relation(person.relation_raw) or normalize_gender_key(person.gender_raw)
        if own_gender and person.spouse_name:
            spouse_gender = "female" if own_gender == "male" else "male"
            for target_tt in exact_name_index.get(canonicalize(person.spouse_name), []):
                add_vote(target_tt, spouse_gender, 6)

    resolved: Dict[int, str] = {}
    for tt, score_by_gender in votes.items():
        if score_by_gender["male"] > score_by_gender["female"]:
            resolved[tt] = "male"
        elif score_by_gender["female"] > score_by_gender["male"]:
            resolved[tt] = "female"
    return resolved


def effective_gender(person: PersonRow, gender_hints: Optional[Dict[int, str]] = None) -> Optional[str]:
    if gender_hints and person.tt in gender_hints:
        return gender_hints[person.tt]
    inferred = infer_gender_from_relation(person.relation_raw)
    explicit = normalize_gender_key(person.gender_raw)
    return inferred or explicit


@lru_cache(maxsize=None)
def extract_relation_parent_name(relation_raw: Optional[str]) -> Optional[str]:
    text = normalize_text(relation_raw)
    if not text:
        return None
    match = re.match(r"^\s*con\s+(?:cụ|cu|ông|ong|bà|ba)\s+(.+?)\s*$", text, flags=re.IGNORECASE)
    if not match:
        return None
    candidate = normalize_text(match.group(1))
    if not candidate:
        return None
    return re.sub(r"^[,;:.\-\s]+|[,;:.\-\s]+$", "", candidate).strip() or None


@lru_cache(maxsize=None)
def extract_relation_parent_role_hint(relation_raw: Optional[str]) -> Optional[str]:
    text = normalize_text(relation_raw)
    if not text:
        return None
    match = re.match(r"^\s*con\s+(cụ|cu|ông|ong|bà|ba)\s+", text, flags=re.IGNORECASE)
    if not match:
        return None
    token = canonicalize(match.group(1))
    if token == "ba":
        return "mother"
    if token == "ong":
        return "father"
    return None


def resolve_parent_reference_name(child: PersonRow, role: str) -> Optional[str]:
    explicit = child.father_name if role == "father" else child.mother_name
    if explicit:
        return explicit
    inferred = extract_relation_parent_name(child.relation_raw)
    if not inferred:
        return None
    role_hint = extract_relation_parent_role_hint(child.relation_raw)
    if role_hint and role_hint != role:
        return None
    return inferred


@lru_cache(maxsize=None)
def extract_relation_spouse_name(relation_raw: Optional[str]) -> Optional[str]:
    canon = canonicalize(relation_raw)
    if not canon:
        return None
    match = re.match(r"^(vo|chong)(?:\s+(?:ca|1|2|3|4|hai))?\s+(?:cu|ong|ba)\s+(.+?)\s*$", canon)
    if not match:
        return None
    return match.group(2).strip() or None


def resolve_spouse_reference(person: PersonRow) -> Optional[str]:
    return person.spouse_name or extract_relation_spouse_name(person.relation_raw)


def parse_excel_year(value: Optional[str]) -> Optional[int]:
    raw = normalize_text(value)
    if not raw:
        return None
    if re.fullmatch(r"\d{4}", raw):
        year = int(raw)
        if 1500 <= year <= 2100:
            return year
    if re.fullmatch(r"\d+(\.0+)?", raw):
        number = int(float(raw))
        if 1500 <= number <= 2100:
            return number
        if 1 < number < 100000:
            base = dt.date(1899, 12, 30)
            try:
                return (base + dt.timedelta(days=number)).year
            except OverflowError:
                return None
    match = re.match(r"^(\d{1,2})/(\d{1,2})/(\d{2,4})$", raw)
    if match:
        year = int(match.group(3))
        if year < 100:
            year += 1900 if year > 30 else 2000
        return year
    return None


def parse_excel_date(value: Optional[str]) -> Optional[str]:
    raw = normalize_text(value)
    if not raw:
        return None
    if re.fullmatch(r"\d{4}", raw):
        year = int(raw)
        if 1500 <= year <= 2100:
            return f"{year:04d}-01-01"
    if re.fullmatch(r"\d+(\.0+)?", raw):
        number = int(float(raw))
        if 1500 <= number <= 2100:
            return f"{number:04d}-01-01"
        if 1 < number < 100000:
            base = dt.date(1899, 12, 30)
            try:
                return (base + dt.timedelta(days=number)).isoformat()
            except OverflowError:
                return None
    match = re.match(r"^(\d{1,2})/(\d{1,2})/(\d{2,4})$", raw)
    if match:
        day = int(match.group(1))
        month = int(match.group(2))
        year = int(match.group(3))
        if year < 100:
            year += 1900 if year > 30 else 2000
        try:
            return dt.date(year, month, day).isoformat()
        except ValueError:
            return None
    return None


def sql_string(value: Optional[str]) -> str:
    text = normalize_text(value)
    if text is None:
        return "NULL"
    escaped = text.replace("\\", "\\\\").replace("'", "''")
    return f"'{escaped}'"


def sql_date(value: Optional[str]) -> str:
    parsed = parse_excel_date(value)
    return sql_string(parsed) if parsed else "NULL"


def sql_gender(value: Optional[str]) -> str:
    canon = normalize_gender_key(value)
    if canon == "male":
        return "'male'"
    if canon == "female":
        return "'female'"
    return "NULL"


def col_to_index(ref: str) -> int:
    column = "".join(ch for ch in ref if ch.isalpha())
    result = 0
    for ch in column:
        result = result * 26 + (ord(ch.upper()) - 64)
    return result


def read_first_sheet_rows(xlsx_path: Path) -> List[Dict[int, Optional[str]]]:
    with zipfile.ZipFile(xlsx_path) as archive:
        shared_strings: List[str] = []
        if "xl/sharedStrings.xml" in archive.namelist():
            root = ET.fromstring(archive.read("xl/sharedStrings.xml"))
            for si in root.findall("main:si", NS):
                text = "".join(
                    node.text or ""
                    for node in si.iter("{http://schemas.openxmlformats.org/spreadsheetml/2006/main}t")
                )
                shared_strings.append(text)

        workbook = ET.fromstring(archive.read("xl/workbook.xml"))
        first_sheet = workbook.find("main:sheets", NS)[0]
        rel_id = first_sheet.attrib[WORKBOOK_REL_NS]
        rel_root = ET.fromstring(archive.read("xl/_rels/workbook.xml.rels"))
        rel_map = {
            rel.attrib["Id"]: rel.attrib["Target"]
            for rel in rel_root.findall("{http://schemas.openxmlformats.org/package/2006/relationships}Relationship")
        }
        target = rel_map[rel_id]
        xml_path = "xl/" + target if not target.startswith("xl/") else target
        sheet_root = ET.fromstring(archive.read(xml_path))

        rows: List[Dict[int, Optional[str]]] = []
        for row in sheet_root.findall(".//main:sheetData/main:row", NS):
            values: Dict[int, Optional[str]] = {}
            for cell in row.findall("main:c", NS):
                index = col_to_index(cell.attrib["r"])
                cell_type = cell.attrib.get("t")
                value: Optional[str]
                if cell_type == "s":
                    node = cell.find("main:v", NS)
                    value = shared_strings[int(node.text)] if node is not None else None
                elif cell_type == "inlineStr":
                    node = cell.find("main:is/main:t", NS)
                    value = node.text if node is not None else None
                else:
                    node = cell.find("main:v", NS)
                    value = node.text if node is not None else None
                values[index] = normalize_text(value)
            if values:
                rows.append({index: values.get(index) for index in range(1, 25)})
        return rows


def load_people(xlsx_path: Path) -> List[PersonRow]:
    rows = read_first_sheet_rows(xlsx_path)
    people: List[PersonRow] = []
    for row in rows[1:]:
        tt_raw = normalize_text(row.get(1))
        full_name = normalize_text(row.get(2))
        if not tt_raw or not full_name:
            continue
        child_cells = [row.get(index) for index in range(12, 21) if row.get(index)]
        generation_raw = normalize_text(row.get(6))
        generation = int(generation_raw) if generation_raw and generation_raw.isdigit() else None
        people.append(
            PersonRow(
                tt=int(tt_raw),
                full_name=full_name,
                gender_raw=normalize_text(row.get(3)),
                dob_raw=normalize_text(row.get(4)),
                dod_raw=normalize_text(row.get(5)),
                generation=generation,
                branch_raw=normalize_text(row.get(7)),
                relation_raw=normalize_text(row.get(8)),
                father_name=normalize_text(row.get(9)),
                mother_name=normalize_text(row.get(10)),
                spouse_name=normalize_text(row.get(11)),
                child_cells=child_cells,
                hometown=normalize_text(row.get(21)),
                residence=normalize_text(row.get(22)),
                occupation=normalize_text(row.get(23)),
                note=normalize_text(row.get(24)),
                branch_key=branch_key(row.get(7)),
                full_name_canon=canonicalize(full_name),
                birth_year=parse_excel_year(row.get(4)),
                death_year=parse_excel_year(row.get(5)),
                child_names=split_child_names(child_cells),
            )
        )
    return people


def spouse_pair_score(source: PersonRow, candidate: PersonRow, gender_hints: Optional[Dict[int, str]] = None) -> float:
    ref = resolve_spouse_reference(source)
    if not ref or source.tt == candidate.tt:
        return -1.0
    if canonicalize(ref) in {"chua ro", "khong ro", "chua biet"}:
        return -1.0
    source_gender = effective_gender(source, gender_hints)
    candidate_gender = effective_gender(candidate, gender_hints)
    if source_gender and candidate_gender and source_gender == candidate_gender:
        return -1.0

    reciprocal = bool(candidate.spouse_name and contains_name(candidate.spouse_name, source.full_name))
    relation_mentions_candidate = bool(source.relation_raw and contains_name(source.relation_raw, candidate.full_name))
    relation_mentions_source = bool(candidate.relation_raw and contains_name(candidate.relation_raw, source.full_name))
    overlap = len({canonicalize(name) for name in source.child_names} & {canonicalize(name) for name in candidate.child_names})
    tail_match = tail_tokens_match(ref, candidate.full_name, 1)
    name_score = similarity(ref, candidate.full_name)
    exactish_name = strong_name_match(ref, candidate.full_name)
    if name_score < 0.80 and not relation_mentions_candidate and not exactish_name:
        return -1.0
    if name_score < 0.90 and not (relation_mentions_candidate or reciprocal or overlap > 0 or exactish_name):
        return -1.0
    if not tail_match and not (relation_mentions_candidate or reciprocal or overlap > 0 or exactish_name):
        return -1.0
    if name_score < 0.92 and not (relation_mentions_candidate or tail_match or exactish_name):
        return -1.0

    score = name_score * 100
    if exactish_name:
        score += 25
    if source.generation is not None and candidate.generation is not None and source.generation == candidate.generation:
        score += 25
    if source.branch_key == candidate.branch_key:
        score += 25
    if reciprocal:
        score += 40

    score += overlap * 14

    if relation_mentions_candidate:
        score += 24
    if relation_mentions_source:
        score += 16
    if abs(source.tt - candidate.tt) <= 3:
        score += 6

    relation_canon = canonicalize(source.relation_raw)
    if any(token in relation_canon for token in ("vo 2", "vo2", "vo hai", "ba 2", "ba2", "vo 3", "vo3", "vo 4", "vo4")):
        score -= 18
    if any(token in relation_canon for token in ("vo ca", "vo 1", "vo1", "ba ca", "ba 1", "ba1")):
        score += 8

    if source.birth_year and candidate.birth_year:
        gap = abs(source.birth_year - candidate.birth_year)
        if gap <= 20:
            score += 8
        else:
            score -= min(20, gap - 20)

    return score


def resolve_spouses(people: Sequence[PersonRow]) -> Dict[int, int]:
    by_tt = {person.tt: person for person in people}
    gender_hints = build_gender_hints(people)
    proposals: List[Tuple[float, int, int]] = []
    for source in people:
        if not resolve_spouse_reference(source):
            continue
        source_relation_canon = canonicalize(source.relation_raw)
        if not (
            is_simple_spouse_name(resolve_spouse_reference(source))
            or source_relation_canon.startswith("vo ")
            or source_relation_canon.startswith("chong ")
        ):
            continue

        for candidate in people:
            score = spouse_pair_score(source, candidate, gender_hints)
            if score >= 145:
                proposals.append((score, source.tt, candidate.tt))

    proposals.sort(reverse=True)
    spouse_map: Dict[int, int] = {}
    reserved: set[int] = set()

    for score, left_tt, right_tt in proposals:
        if left_tt in reserved or right_tt in reserved:
            continue
        left = by_tt[left_tt]
        right = by_tt[right_tt]
        reciprocal = bool(right.spouse_name and contains_name(right.spouse_name, left.full_name))
        overlap = len({canonicalize(name) for name in left.child_names} & {canonicalize(name) for name in right.child_names})
        if not reciprocal and overlap == 0 and left.branch_key != right.branch_key:
            continue
        reserved.add(left_tt)
        reserved.add(right_tt)
        spouse_map[left_tt] = right_tt
        spouse_map[right_tt] = left_tt

    return spouse_map


def validate_name_match(reference_name: Optional[str], target_name: str) -> bool:
    return strong_name_match(reference_name, target_name)


def tail_tokens_match(left: Optional[str], right: Optional[str], size: int) -> bool:
    left_tokens = canonicalize(left).split()
    right_tokens = canonicalize(right).split()
    if len(left_tokens) < size or len(right_tokens) < size:
        return False
    return left_tokens[-size:] == right_tokens[-size:]


def parent_score(
    child: PersonRow,
    candidate: PersonRow,
    role: str,
    spouse_map: Dict[int, int],
    people_by_tt: Dict[int, PersonRow],
    gender_hints: Optional[Dict[int, str]] = None,
) -> float:
    ref_name = resolve_parent_reference_name(child, role)
    if not ref_name:
        return -1.0

    gender_key = effective_gender(candidate, gender_hints)
    if role == "father" and gender_key != "male":
        return -1.0
    if role == "mother" and gender_key != "female":
        return -1.0

    name_score = similarity(ref_name, candidate.full_name)
    if not validate_name_match(ref_name, candidate.full_name):
        return -1.0

    score = name_score * 100
    if canonicalize(ref_name) == candidate.full_name_canon:
        score += 40
    else:
        score += 18

    if child.generation is not None and candidate.generation is not None:
        if candidate.generation == child.generation - 1:
            score += 35
        elif candidate.generation == child.generation:
            score += 5
        else:
            score -= min(40, abs((child.generation - 1) - candidate.generation) * 10)

    if candidate.branch_key == child.branch_key or candidate.branch_key == "chinh":
        score += 15

    if child.birth_year and candidate.birth_year:
        age_gap = child.birth_year - candidate.birth_year
        if age_gap >= 12:
            score += 20
        elif age_gap >= 0:
            score -= 20
        else:
            score -= 40

    if child.birth_year and candidate.death_year and candidate.death_year < child.birth_year:
        score -= 25

    spouse_tt = spouse_map.get(candidate.tt)
    own_child_link = any(validate_name_match(child.full_name, child_name) for child_name in candidate.child_names)
    spouse_child_link = False
    if not own_child_link and spouse_tt:
        spouse_child_link = any(
            validate_name_match(child.full_name, child_name)
            for child_name in people_by_tt[spouse_tt].child_names
        )
    if own_child_link:
        score += 55
    elif spouse_child_link:
        score += 15

    other_parent_name = child.mother_name if role == "father" else child.father_name
    if other_parent_name:
        if candidate.spouse_name and validate_name_match(other_parent_name, candidate.spouse_name):
            score += 18
        if spouse_tt and validate_name_match(other_parent_name, people_by_tt[spouse_tt].full_name):
            score += 45

    if child.relation_raw and contains_name(child.relation_raw, candidate.full_name):
        score += 15
    if candidate.tt >= child.tt:
        score -= 10

    return score


def parent_child_list_score(
    child: PersonRow,
    candidate: PersonRow,
    role: str,
    spouse_map: Dict[int, int],
    people_by_tt: Dict[int, PersonRow],
    gender_hints: Optional[Dict[int, str]] = None,
) -> float:
    gender_key = effective_gender(candidate, gender_hints)
    if role == "father" and gender_key != "male":
        return -1.0
    if role == "mother" and gender_key != "female":
        return -1.0

    spouse_tt = spouse_map.get(candidate.tt)
    own_child_link = any(validate_name_match(child.full_name, child_name) for child_name in candidate.child_names)
    spouse_child_link = False
    if not own_child_link and spouse_tt:
        spouse_child_link = any(
            validate_name_match(child.full_name, child_name)
            for child_name in people_by_tt[spouse_tt].child_names
        )
    if not own_child_link and not spouse_child_link:
        return -1.0

    ref_name = resolve_parent_reference_name(child, role)
    if ref_name and not validate_name_match(ref_name, candidate.full_name):
        return -1.0

    score = 150.0 if own_child_link else 110.0
    if ref_name:
        if canonicalize(ref_name) == candidate.full_name_canon:
            score += 60
        else:
            score += 25

    if child.generation is not None and candidate.generation is not None:
        if candidate.generation == child.generation - 1:
            score += 35
        elif candidate.generation == child.generation:
            score += 5

    if candidate.branch_key == child.branch_key or candidate.branch_key == "chinh":
        score += 20

    other_parent_name = child.mother_name if role == "father" else child.father_name
    if other_parent_name:
        if candidate.spouse_name and validate_name_match(other_parent_name, candidate.spouse_name):
            score += 20
        if spouse_tt and validate_name_match(other_parent_name, people_by_tt[spouse_tt].full_name):
            score += 45

    if candidate.tt >= child.tt:
        score -= 10
    return score


def choose_local_parent_candidate(
    child: PersonRow,
    scored: Sequence[Tuple[float, PersonRow]],
    role: str,
    resolved: Dict[int, int],
    people_by_tt: Dict[int, PersonRow],
) -> Optional[PersonRow]:
    if not scored:
        return None
    if len(scored) == 1:
        return scored[0][1]

    top_candidate = scored[0][1]
    second_candidate = scored[1][1]
    top_distance = abs(child.tt - top_candidate.tt)
    second_distance = abs(child.tt - second_candidate.tt)
    if top_distance <= 8 and second_distance - top_distance >= 3:
        return top_candidate

    ref_name = resolve_parent_reference_name(child, role)
    if not ref_name:
        return None
    for sibling_tt in (child.tt - 1, child.tt - 2, child.tt + 1, child.tt + 2):
        if sibling_tt not in resolved:
            continue
        sibling = people_by_tt.get(sibling_tt)
        if sibling is None:
            continue
        sibling_parent_ref = resolve_parent_reference_name(sibling, role)
        if sibling_parent_ref is None:
            continue
        if canonicalize(sibling_parent_ref) != canonicalize(ref_name):
            continue
        if resolved[sibling_tt] == top_candidate.tt:
            return top_candidate
    return None


def compute_relation_degree(
    father_map: Dict[int, int],
    mother_map: Dict[int, int],
    spouse_map: Dict[int, int],
) -> Dict[int, int]:
    degree: Dict[int, int] = defaultdict(int)
    for child_tt, parent_tt in father_map.items():
        degree[child_tt] += 1
        degree[parent_tt] += 1
    for child_tt, parent_tt in mother_map.items():
        degree[child_tt] += 1
        degree[parent_tt] += 1
    for left_tt, right_tt in spouse_map.items():
        degree[left_tt] += 1
        degree[right_tt] += 1
    return degree


def connect_orphan_spouses(
    people: Sequence[PersonRow],
    spouse_map: Dict[int, int],
    father_map: Dict[int, int],
    mother_map: Dict[int, int],
) -> Dict[int, int]:
    updated = dict(spouse_map)
    degree = compute_relation_degree(father_map, mother_map, updated)
    people_by_tt = {person.tt: person for person in people}

    for person in people:
        if degree.get(person.tt, 0) > 0:
            continue
        spouse_ref = resolve_spouse_reference(person)
        if not spouse_ref:
            continue

        candidates = [
            candidate for candidate in people
            if candidate.tt != person.tt and strong_name_match(spouse_ref, candidate.full_name)
        ]
        if not candidates:
            continue
        candidates.sort(
            key=lambda candidate: (
                canonicalize(spouse_ref) != candidate.full_name_canon,
                abs(person.tt - candidate.tt),
                candidate.tt,
            )
        )
        target = candidates[0]
        current_spouse_tt = updated.get(target.tt)
        if current_spouse_tt is not None and current_spouse_tt != person.tt:
            if degree.get(current_spouse_tt, 0) <= 1:
                continue
            updated.pop(current_spouse_tt, None)
            updated.pop(target.tt, None)
            degree[current_spouse_tt] = max(0, degree.get(current_spouse_tt, 0) - 1)
            degree[target.tt] = max(0, degree.get(target.tt, 0) - 1)

        updated[person.tt] = target.tt
        updated[target.tt] = person.tt
        degree[person.tt] = degree.get(person.tt, 0) + 1
        degree[target.tt] = degree.get(target.tt, 0) + 1

    return updated


def resolve_parents(
    people: Sequence[PersonRow],
    spouse_map: Dict[int, int],
    role: str,
) -> Dict[int, int]:
    people_by_tt = {person.tt: person for person in people}
    gender_hints = build_gender_hints(people)
    resolved: Dict[int, int] = {}

    for child in people:
        ref_name = resolve_parent_reference_name(child, role)
        if not ref_name:
            continue

        scored: List[Tuple[float, PersonRow]] = []
        for candidate in people:
            score = parent_score(child, candidate, role, spouse_map, people_by_tt, gender_hints)
            if score >= 118:
                scored.append((score, candidate))

        scored.sort(
            key=lambda item: (
                -item[0],
                abs((child.generation or 0) - (item[1].generation or 0)),
                abs(child.tt - item[1].tt),
            )
        )

        if not scored:
            continue
        if len(scored) > 1 and scored[0][0] - scored[1][0] < 6:
            chosen = choose_local_parent_candidate(child, scored, role, resolved, people_by_tt)
            if chosen is None:
                continue
        else:
            chosen = scored[0][1]
        if not validate_name_match(ref_name, chosen.full_name):
            continue
        resolved[child.tt] = chosen.tt

    for child in people:
        if child.tt in resolved:
            continue

        scored: List[Tuple[float, PersonRow]] = []
        for candidate in people:
            score = parent_child_list_score(child, candidate, role, spouse_map, people_by_tt, gender_hints)
            if score >= 185:
                scored.append((score, candidate))

        scored.sort(
            key=lambda item: (
                -item[0],
                abs((child.generation or 0) - (item[1].generation or 0)),
                abs(child.tt - item[1].tt),
            )
        )

        if not scored:
            continue
        if len(scored) > 1 and scored[0][0] - scored[1][0] < 12:
            chosen = choose_local_parent_candidate(child, scored, role, resolved, people_by_tt)
            if chosen is None:
                continue
        else:
            chosen = scored[0][1]
        resolved[child.tt] = chosen.tt

    return resolved


def resolve_family_graph(
    people: Sequence[PersonRow],
) -> Tuple[Dict[int, str], Dict[int, int], Dict[int, int], Dict[int, int]]:
    gender_hints = build_gender_hints(people)
    spouse_map = resolve_spouses(people)
    father_map = resolve_parents(people, spouse_map, "father")
    mother_map = resolve_parents(people, spouse_map, "mother")
    spouse_map = connect_orphan_spouses(people, spouse_map, father_map, mother_map)
    father_map = resolve_parents(people, spouse_map, "father")
    mother_map = resolve_parents(people, spouse_map, "mother")
    return gender_hints, spouse_map, father_map, mother_map


def build_backend_audit_summary(
    people: Sequence[PersonRow],
    gender_hints: Dict[int, str],
    spouse_map: Dict[int, int],
    father_map: Dict[int, int],
    mother_map: Dict[int, int],
) -> Dict[str, object]:
    people_by_tt = {person.tt: person for person in people}
    issues: Counter[str] = Counter()
    sample_issues: List[Dict[str, object]] = []

    def record_issue(code: str, message: str, member_ids: Sequence[int]) -> None:
        issues[code] += 1
        if len(sample_issues) >= 20:
            return
        members = []
        for member_id in member_ids:
            person = people_by_tt.get(member_id)
            members.append(
                {
                    "tt": member_id,
                    "full_name": person.full_name if person else None,
                }
            )
        sample_issues.append(
            {
                "code": code,
                "message": message,
                "members": members,
            }
        )

    def parsed_date(raw: Optional[str]) -> Optional[dt.date]:
        parsed = parse_excel_date(raw)
        if not parsed:
            return None
        return dt.date.fromisoformat(parsed)

    def validate_parent(child_tt: int, parent_tt: int, role: str) -> None:
        child = people_by_tt.get(child_tt)
        parent = people_by_tt.get(parent_tt)
        if child is None or parent is None:
            return

        if child_tt == parent_tt:
            record_issue(
                "self_parent_reference",
                f"Member cannot reference itself as {role}",
                [child_tt],
            )
            return

        parent_gender = effective_gender(parent, gender_hints)
        if role == "father" and parent_gender == "female":
            record_issue(
                "father_gender_mismatch",
                "Father reference points to a member marked as female",
                [child_tt, parent_tt],
            )
        if role == "mother" and parent_gender == "male":
            record_issue(
                "mother_gender_mismatch",
                "Mother reference points to a member marked as male",
                [child_tt, parent_tt],
            )

        if child.generation is not None and parent.generation is not None and child.generation <= parent.generation:
            record_issue(
                "generation_conflict",
                "Child generation is not greater than parent generation",
                [parent_tt, child_tt],
            )

        child_dob = parsed_date(child.dob_raw)
        parent_dob = parsed_date(parent.dob_raw)
        parent_dod = parsed_date(parent.dod_raw)
        if child_dob and parent_dob and child_dob < parent_dob:
            record_issue(
                "birth_before_parent",
                "Child date of birth is before parent date of birth",
                [parent_tt, child_tt],
            )
        if child_dob and parent_dod and child_dob > parent_dod:
            record_issue(
                "birth_after_parent_death",
                "Child date of birth is after parent date of death",
                [parent_tt, child_tt],
            )

    for child_tt, parent_tt in father_map.items():
        validate_parent(child_tt, parent_tt, "father")
    for child_tt, parent_tt in mother_map.items():
        validate_parent(child_tt, parent_tt, "mother")

    seen_spouse_pairs: set[Tuple[int, int]] = set()
    for left_tt, right_tt in spouse_map.items():
        if left_tt == right_tt:
            record_issue(
                "self_spouse_reference",
                "Member cannot reference itself as spouse",
                [left_tt],
            )
            continue

        if spouse_map.get(right_tt) != left_tt:
            record_issue(
                "spouse_link_inconsistent",
                "Spouse relation is one-way or points to another member",
                [left_tt, right_tt],
            )
            continue

        pair = tuple(sorted((left_tt, right_tt)))
        if pair in seen_spouse_pairs:
            continue
        seen_spouse_pairs.add(pair)

    adjacency: Dict[int, set[int]] = defaultdict(set)
    for child_tt, parent_tt in father_map.items():
        adjacency[child_tt].add(parent_tt)
        adjacency[parent_tt].add(child_tt)
    for child_tt, parent_tt in mother_map.items():
        adjacency[child_tt].add(parent_tt)
        adjacency[parent_tt].add(child_tt)
    for left_tt, right_tt in spouse_map.items():
        adjacency[left_tt].add(right_tt)

    isolated = sorted(tt for tt in people_by_tt if not adjacency.get(tt))
    components: List[List[int]] = []
    visited: set[int] = set()
    for tt in people_by_tt:
        if tt in visited:
            continue
        queue = deque([tt])
        visited.add(tt)
        component: List[int] = []
        while queue:
            current = queue.popleft()
            component.append(current)
            for neighbor in adjacency.get(current, set()):
                if neighbor not in visited:
                    visited.add(neighbor)
                    queue.append(neighbor)
        components.append(sorted(component))
    components.sort(key=len, reverse=True)

    return {
        "rows": len(people),
        "resolved_father_refs": len(father_map),
        "resolved_mother_refs": len(mother_map),
        "resolved_spouse_rows": len(spouse_map),
        "resolved_spouse_pairs": len(seen_spouse_pairs),
        "connected_components": len(components),
        "largest_component_size": len(components[0]) if components else 0,
        "isolated_members": isolated,
        "issue_counts": dict(sorted(issues.items())),
        "sample_issues": sample_issues,
    }


def generate_sql_block(people: Sequence[PersonRow]) -> str:
    gender_hints, spouse_map, father_map, mother_map = resolve_family_graph(people)

    father_sources = sum(1 for person in people if person.father_name)
    mother_sources = sum(1 for person in people if person.mother_name)
    spouse_sources = sum(1 for person in people if resolve_spouse_reference(person))
    spouse_pairs = len(spouse_map) // 2

    lines: List[str] = [
        "-- PERSON IMPORT FROM XLSX",
        "-- Auto-generated by scripts/generate_person_import_sql.py",
        "-- Source: data.xlsx",
        f"-- Rows: {len(people)}",
        "-- Branch mapping: blank -> Chinh, Chi 1 -> 1, Chi 2/Chi 2-nganh* -> 2",
        f"-- Resolved refs: father={len(father_map)}/{father_sources}, mother={len(mother_map)}/{mother_sources}, spouse_rows={len(spouse_map)}/{spouse_sources}, spouse_pairs={spouse_pairs}",
        "-- Unresolved refs are kept empty only when the source row points to a person not present in the workbook or when the source is too ambiguous to map safely into the current schema.",
        "",
        "START TRANSACTION;",
        "SET SQL_SAFE_UPDATES = 0;",
        "",
        "-- Ensure required branches exist",
        "INSERT INTO `branch` (`name`, `description`, `createddate`, `modifieddate`, `createdby`, `modifiedby`)",
        "SELECT 'Chinh', 'Imported from data.xlsx', NOW(), NOW(), 'xlsx_import', 'xlsx_import'",
        "    WHERE NOT EXISTS (SELECT 1 FROM `branch` b WHERE b.`name` = 'Chinh');",
        "INSERT INTO `branch` (`name`, `description`, `createddate`, `modifieddate`, `createdby`, `modifiedby`)",
        "SELECT '1', 'Imported from data.xlsx', NOW(), NOW(), 'xlsx_import', 'xlsx_import'",
        "    WHERE NOT EXISTS (SELECT 1 FROM `branch` b WHERE b.`name` = '1');",
        "INSERT INTO `branch` (`name`, `description`, `createddate`, `modifieddate`, `createdby`, `modifiedby`)",
        "SELECT '2', 'Imported from data.xlsx', NOW(), NOW(), 'xlsx_import', 'xlsx_import'",
        "    WHERE NOT EXISTS (SELECT 1 FROM `branch` b WHERE b.`name` = '2');",
        "",
        "-- Insert persons (idempotent by createdby marker)",
    ]

    for person in people:
        marker = f"xlsx_tt_{person.tt}"
        branch_name = branch_sql_name(person.branch_key)
        lines.extend(
            [
                "INSERT INTO `person` (",
                "    `branch_id`, `user_id`, `fullname`, `gender`, `avatar`, `dob`, `dod`, `generation`,",
                "    `hometown`, `current_residence`, `occupation`, `other_note`,",
                "    `father_id`, `mother_id`, `spouse_id`, `createddate`, `modifieddate`, `createdby`, `modifiedby`",
                ")",
                "SELECT",
                f"    (SELECT b.`id` FROM `branch` b WHERE b.`name` = {sql_string(branch_name)} ORDER BY b.`id` ASC LIMIT 1),",
                "  NULL,",
                f"  {sql_string(person.full_name)},",
                f"  {sql_gender(effective_gender(person, gender_hints))},",
                "  NULL,",
                f"  {sql_date(person.dob_raw)},",
                f"  {sql_date(person.dod_raw)},",
                f"  {person.generation if person.generation is not None else 'NULL'},",
                f"  {sql_string(person.hometown)},",
                f"  {sql_string(person.residence)},",
                f"  {sql_string(person.occupation)},",
                f"  {sql_string(person.note)},",
                "  NULL,",
                "  NULL,",
                "  NULL,",
                "  NOW(),",
                "  NOW(),",
                f"  {sql_string(marker)},",
                f"  {sql_string(marker)}",
                f"WHERE NOT EXISTS (SELECT 1 FROM `person` p WHERE p.`createdby` = {sql_string(marker)});",
            ]
        )

    lines.extend(["", "-- Link father references"])
    for child_tt in sorted(father_map):
        parent_tt = father_map[child_tt]
        lines.extend(
            [
                "UPDATE `person` c",
                f"    JOIN `person` f ON f.`createdby` = 'xlsx_tt_{parent_tt}'",
                "    SET c.`father_id` = f.`id`",
                f"WHERE c.`createdby` = 'xlsx_tt_{child_tt}';",
            ]
        )

    lines.extend(["", "-- Link mother references"])
    for child_tt in sorted(mother_map):
        parent_tt = mother_map[child_tt]
        lines.extend(
            [
                "UPDATE `person` c",
                f"    JOIN `person` m ON m.`createdby` = 'xlsx_tt_{parent_tt}'",
                "    SET c.`mother_id` = m.`id`",
                f"WHERE c.`createdby` = 'xlsx_tt_{child_tt}';",
            ]
        )

    lines.extend(["", "-- Link spouse references (symmetric)"])
    emitted_pairs: set[Tuple[int, int]] = set()
    for left_tt, right_tt in spouse_map.items():
        pair = tuple(sorted((left_tt, right_tt)))
        if left_tt == right_tt or pair in emitted_pairs:
            continue
        emitted_pairs.add(pair)
        lines.extend(
            [
                "UPDATE `person` p",
                f"    JOIN `person` s ON s.`createdby` = 'xlsx_tt_{pair[1]}'",
                "    SET p.`spouse_id` = s.`id`",
                f"WHERE p.`createdby` = 'xlsx_tt_{pair[0]}';",
                "UPDATE `person` p",
                f"    JOIN `person` s ON s.`createdby` = 'xlsx_tt_{pair[0]}'",
                "    SET p.`spouse_id` = s.`id`",
                f"WHERE p.`createdby` = 'xlsx_tt_{pair[1]}';",
            ]
        )

    lines.extend(
        [
            "",
            "COMMIT;",
            "SET SQL_SAFE_UPDATES = 1;",
            "",
        ]
    )
    return "\n".join(lines)


def replace_import_block(sql_path: Path, new_block: str) -> None:
    text = sql_path.read_text(encoding="utf-8")
    start_marker = "-- PERSON IMPORT FROM XLSX"
    end_marker = "-- Optional cleanup after verification:"
    start = text.find(start_marker)
    end = text.find(end_marker)
    if start == -1 or end == -1 or end <= start:
        raise RuntimeError("Could not locate PERSON IMPORT FROM XLSX block in SQL file.")
    updated = text[:start] + new_block + text[end:]
    sql_path.write_text(updated, encoding="utf-8")


def main() -> None:
    parser = argparse.ArgumentParser(description="Generate PERSON IMPORT FROM XLSX block.")
    parser.add_argument("--xlsx", required=True, type=Path, help="Path to the source XLSX file.")
    parser.add_argument("--sql", required=True, type=Path, help="Path to family_tree_db.sql.")
    parser.add_argument("--write", action="store_true", help="Write the generated block back into the SQL file.")
    parser.add_argument(
        "--audit",
        action="store_true",
        help="Print a backend-style audit summary for the resolved family graph.",
    )
    args = parser.parse_args()

    people = load_people(args.xlsx)
    block = generate_sql_block(people)

    if args.write:
        replace_import_block(args.sql, block)

    print(f"rows={len(people)}")
    print(f"sql_path={args.sql}")
    print("write=yes" if args.write else "write=no")
    if args.audit:
        gender_hints, spouse_map, father_map, mother_map = resolve_family_graph(people)
        summary = build_backend_audit_summary(people, gender_hints, spouse_map, father_map, mother_map)
        print("audit=" + json.dumps(summary, ensure_ascii=False))


if __name__ == "__main__":
    main()
