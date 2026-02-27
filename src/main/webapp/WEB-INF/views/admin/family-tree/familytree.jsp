<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/common/taglib.jsp"%>
<c:url var="homeUrl" value="/admin/home"/>
<title>Cây gia phả</title>
<!-- Icons (Bootstrap Icons) -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet"/>

<link rel="stylesheet" href="assets/css/family-tree-page.css" />

<% boolean canManageMember = request.isUserInRole("MANAGER") || request.isUserInRole("EDITOR"); %>

<div class="main-content">
    <div class="main-content-inner">
        <div class="breadcrumbs" id="breadcrumbs">
            <ul class="breadcrumb">
                <li>
                    <i class="ace-icon fa-solid fa-house-chimney home-icon"></i>
                    <a href="${homeUrl}">Trang chủ</a>
                </li>
                <li class="active">Cây gia phả</li>
            </ul>
        </div>
        <div class="page-content family-tree-page">
<div id="ftApp" class="bg-light">
    <div class="container-fluid">
        <div class="ft-canvas">
            <!-- LEFT TOOLBAR (Zoom) -->
            <div class="ft-toolbar-left">
                <button id="zoomIn" class="btn btn-sm btn-light" title="Phóng to"><i class="bi bi-zoom-in"></i></button>
                <div id="zoomLabel" class="text-secondary small fw-semibold">100%</div>
                <button id="zoomOut" class="btn btn-sm btn-light" title="Thu nhỏ"><i class="bi bi-zoom-out"></i></button>
                <div class="w-100 my-1" style="height:1px;background:#f1f5f9;"></div>
                <button id="zoomReset" class="btn btn-sm btn-light" title="Đặt lại"><i class="bi bi-aspect-ratio"></i></button>
            </div>

            <!-- RIGHT TOOLBAR -->
            <div class="ft-toolbar-right">
                <div class="dropdown" id="branchDropdown">
                    <button class="btn btn-white border dropdown-toggle d-flex align-items-center gap-2 filter-chip" type="button">
                        <i class="bi bi-diagram-3" style="color:#16a34a"></i>
                        <span id="activeBranchLabel">Tất cả các chi</span>
                    </button>
                    <ul id="branchMenu" class="dropdown-menu dropdown-menu-end"></ul>
                </div>

                <div class="dropdown" id="generationDropdown">
                    <button class="btn btn-white border dropdown-toggle d-flex align-items-center gap-2 filter-chip" type="button">
                        <i class="bi bi-funnel" style="color:#2563eb"></i>
                        <span id="activeGenerationLabel">Tất cả đời</span>
                    </button>
                    <ul id="generationMenu" class="dropdown-menu dropdown-menu-end"></ul>
                </div>

                <% if (canManageMember) { %>
                    <button id="btnCreateFirst" class="btn btn-dark d-flex align-items-center gap-2">
                        <i class="bi bi-person-plus"></i> Tạo thành viên đầu tiên
                    </button>
                <% } %>
            </div>

            <!-- CONTENT -->
            <div id="contentArea" class="ft-scroll">
                <div id="scaleWrap" class="ft-tree-scale">
                    <div class="d-flex justify-content-center">
                        <div id="treeRoot"></div>
                    </div>
                </div>
            </div>

            <!-- LEGEND -->
            <div id="legend" class="ft-legend">
                <span class="text-uppercase text-secondary fw-bold" style="font-size: 11px; letter-spacing: .12em;">Giới tính</span>
                <span class="d-inline-flex align-items-center gap-1"><span class="dot bg-male">♂</span> Nam</span>
                <span class="d-inline-flex align-items-center gap-1"><span class="dot bg-female">♀</span> Nữ</span>
                <span class="d-inline-flex align-items-center gap-1"><span class="dot bg-other">⚥</span> Khác</span>
                <span style="width:1px;height:16px;background:#e5e7eb;"></span>
                <span class="d-inline-flex align-items-center gap-2">
                    <span style="width:22px;border-top:2px dashed #f9a8d4;"></span> Vợ / Chồng
                </span>
                <span style="width:1px;height:16px;background:#e5e7eb;"></span>
                <span class="d-inline-flex align-items-center gap-2">
                    <span style="width:1px;height:14px;background:#6b7280;"></span> Con cái
                </span>
            </div>
        </div>
    </div>

    <!-- Member Modal -->
    <div class="modal" id="memberModal" aria-hidden="true">
        <div class="modal-backdrop" data-close="memberModal"></div>
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-light">
                    <h5 id="modalTitle" class="modal-title fw-semibold">Tạo thành viên</h5>
                    <button type="button" class="btn-close" data-close="memberModal" aria-label="Close"></button>
                </div>

                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-12">
                            <label class="form-label fw-semibold">Họ và tên <span class="text-danger">*</span></label>
                            <input id="mFullname" class="form-control" placeholder="Nhập họ và tên..." />
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Ngày sinh</label>
                            <input type="date" id="mDob" class="form-control" />
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Ngày mất (nếu có)</label>
                            <input type="date" id="mDod" class="form-control" />
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Đời (Thế hệ)</label>
                            <input id="mGeneration" type="number" min="1" max="50" class="form-control" />
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Chi / Nhánh</label>
                            <select id="mBranch" class="form-select">
                                <option value="">-- Chọn chi --</option>
                                <option value="1">Chi chính</option>
                                <option value="2">Chi 1</option>
                                <option value="3">Chi 2</option>
                                <option value="4">Chi 3</option>
                                <option value="5">Chi 4</option>
                            </select>
                        </div>

                        <div class="col-12">
                            <label class="form-label fw-semibold">Giới tính</label>
                            <div class="d-flex gap-2">
                                <label class="d-flex align-items-center gap-1">
                                    <input class="form-check-input" type="radio" name="mGender" id="gMale" value="male"> Nam
                                </label>
                                <label class="d-flex align-items-center gap-1">
                                    <input class="form-check-input" type="radio" name="mGender" id="gFemale" value="female"> Nữ
                                </label>
                                <label class="d-flex align-items-center gap-1">
                                    <input class="form-check-input" type="radio" name="mGender" id="gOther" value="other"> Khác
                                </label>
                            </div>
                        </div>

                        <div class="col-12">
                            <label class="form-label fw-semibold">Avatar URL </label>
                            <input id="mAvatar" class="form-control" placeholder="https://..." />
                            <div style="height:8px"></div>
                            <input id="mAvatarFile" type="file" accept="image/*" class="form-control" />
                        </div>
                    </div>
                </div>

                <div class="modal-footer bg-light">
                    <button class="btn btn-link text-secondary" data-close="memberModal">Hủy</button>
                    <button id="btnSaveMember" class="btn btn-dark"><i class="bi bi-plus-lg"></i> Lưu thành viên</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal action-modal" id="actionMemberModal" aria-hidden="true">
        <div class="modal-backdrop" data-close="actionMemberModal"></div>
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <div class="head-left">
                        <span class="head-icon" id="actionModalIcon"><i class="bi bi-person-plus"></i></span>
                        <h5 id="actionModalTitle" class="modal-title fw-semibold">Thêm thành viên</h5>
                    </div>
                    <button type="button" class="btn-close" data-close="actionMemberModal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-12">
                            <label class="form-label fw-semibold">HỌ VÀ TÊN <span class="text-danger">*</span></label>
                            <input id="aFullname" class="form-control" placeholder="Nhập họ và tên..." />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">NGÀY SINH</label>
                            <input type="date" id="aDob" class="form-control" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">NGÀY MẤT (NẾU CÓ)</label>
                            <input type="date" id="aDod" class="form-control" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">ĐỜI (THẾ HỆ)</label>
                            <input id="aGeneration" type="number" min="1" max="50" class="form-control" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">CHI / NHÁNH</label>
                            <select id="aBranch" class="form-select">
                                <option value="1">Chi chính</option>
                                <option value="2">Chi 1</option>
                                <option value="3">Chi 2</option>
                                <option value="4">Chi 3</option>
                                <option value="5">Chi 4</option>
                            </select>
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-semibold">GIỚI TÍNH</label>
                            <div class="gender-grid" id="actionGenderGrid">
                                <button type="button" class="gender-choice" data-gender="male">
                                    <i class="bi bi-gender-male"></i><span>Nam</span>
                                </button>
                                <button type="button" class="gender-choice" data-gender="female">
                                    <i class="bi bi-gender-female"></i><span>Nữ</span>
                                </button>
                                <button type="button" class="gender-choice" data-gender="other">
                                    <i class="bi bi-gender-ambiguous"></i><span>Khác</span>
                                </button>
                            </div>
                            <input type="hidden" id="aGender" />
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-semibold">AVATAR URL</label>
                            <input id="aAvatar" class="form-control" placeholder="https://..." />
                            <div style="height:8px"></div>
                            <input id="aAvatarFile" type="file" accept="image/*" class="form-control" />
                        </div>
                    </div>
                </div>
                <div class="action-footer">
                    <button class="btn btn-link text-secondary" data-close="actionMemberModal">Hủy</button>
                    <button id="btnSaveActionMember" class="btn btn-save-strong">
                        <i class="bi bi-plus-lg"></i> Lưu thành viên
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Detail Offcanvas -->
    <div class="offcanvas offcanvas-end" id="detailDrawer">
        <div class="offcanvas-header bg-light">
            <h6 class="offcanvas-title fw-semibold">Hồ sơ thành viên</h6>
            <button type="button" class="btn-close" data-close="detailDrawer"></button>
        </div>
        <div class="offcanvas-body" id="detailBody"></div>
        <div class="p-3 border-top d-flex gap-2" style="padding:12px 16px">
            <a id="detailLink" class="btn btn-dark w-50" href="#">Xem hồ sơ chi tiết</a>
            <button id="detailEdit" class="btn btn-outline-secondary w-50"><i class="bi bi-pencil"></i> Sửa thông tin</button>
        </div>
    </div>

    <script>
        // Nếu muốn truyền branchId từ server side:
        // const BRANCH_ID = "<%= request.getAttribute("branchId") %>";
        let BRANCH_ID = 1;
        const canManageMember = <%= canManageMember %>;

        // Dropdown minimal toggle (không phụ thuộc BS5)
        (function () {
            const dd = document.getElementById('branchDropdown');
            if (!dd) return;
            const btn = dd.querySelector('.dropdown-toggle');
            const menu = dd.querySelector('.dropdown-menu');
            btn.addEventListener('click', function (e) {
                e.stopPropagation();
                menu.classList.toggle('show');
            });
            document.addEventListener('click', function () {
                menu.classList.remove('show');
            });
        })();

        (function () {
            const dd = document.getElementById('generationDropdown');
            if (!dd) return;
            const btn = dd.querySelector('.dropdown-toggle');
            const menu = dd.querySelector('.dropdown-menu');
            btn.addEventListener('click', function (e) {
                e.stopPropagation();
                menu.classList.toggle('show');
            });
            document.addEventListener('click', function () {
                menu.classList.remove('show');
            });
        })();

        const NEW_BRANCH_OPTION = '__new_branch__';
        let BRANCH_CACHE = [];
        let CURRENT_TREE_ROOT = null;
        let CURRENT_GENERATION_FILTER = null;

        function setBranchFormOptions(branches) {
            const branchSelectIds = ['mBranch', 'aBranch'];
            branchSelectIds.forEach(function (selectId) {
                const selectEl = document.getElementById(selectId);
                if (!selectEl) return;
                selectEl.innerHTML = branches.map(function (branch) {
                    const id = String(branch.id);
                    const name = branch.name || ('Chi ' + id);
                    return '<option value="' + id + '">' + name + '</option>';
                }).join('') + '<option value="' + NEW_BRANCH_OPTION + '">+ Tạo chi nhánh mới</option>';
            });
        }

        async function createBranchAuto(name) {
            const res = await fetch('/api/branch', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    name: name,
                    description: 'Tạo nhanh từ form cây gia phả'
                })
            });
            if (!res.ok) {
                const errText = await res.text();
                throw new Error(errText || 'Tạo chi nhánh thất bại');
            }
            return await res.json();
        }

        function bindBranchCreateInSelect() {
            const branchSelectIds = ['mBranch', 'aBranch'];
            branchSelectIds.forEach(function (selectId) {
                const selectEl = document.getElementById(selectId);
                if (!selectEl || selectEl.dataset.boundCreateBranch === 'true') return;
                selectEl.dataset.boundCreateBranch = 'true';

                selectEl.addEventListener('change', async function () {
                    if (selectEl.value !== NEW_BRANCH_OPTION) return;
                    const rawName = prompt('Nhập tên chi nhánh mới:');
                    const branchName = (rawName || '').trim();
                    if (!branchName) {
                        selectEl.value = String(BRANCH_ID);
                        return;
                    }
                    try {
                        const created = await createBranchAuto(branchName);
                        const createdId = Number(created && created.id ? created.id : 0);
                        await loadBranches(createdId);
                    } catch (err) {
                        console.error('Create branch failed:', err);
                        alert('Không thể tạo chi nhánh mới.');
                        selectEl.value = String(BRANCH_ID);
                    }
                });
            });
        }

        function renderBranchMenu(branches, preferredBranchId) {
            const branchMenu = document.getElementById('branchMenu');
            const activeBranchLabel = document.getElementById('activeBranchLabel');
            if (!branchMenu || !activeBranchLabel) return;
            BRANCH_CACHE = Array.isArray(branches) ? branches : [];

            branchMenu.innerHTML = BRANCH_CACHE.map(function (branch) {
                const id = String(branch.id);
                const name = branch.name || ('Chi ' + id);
                return '<li><button type="button" class="dropdown-item" data-branch-id="' + id + '">' + name + '</button></li>';
            }).join('');

            const targetBranchId = preferredBranchId != null ? Number(preferredBranchId) : Number(BRANCH_ID);
            const currentBranch = BRANCH_CACHE.find(function (branch) {
                return Number(branch.id) === targetBranchId;
            }) || branches[0];

            if (currentBranch) {
                BRANCH_ID = Number(currentBranch.id);
                activeBranchLabel.textContent = currentBranch.name || ('Chi ' + currentBranch.id);
                const mBranch = document.getElementById('mBranch');
                const aBranch = document.getElementById('aBranch');
                if (mBranch) mBranch.value = String(BRANCH_ID);
                if (aBranch) aBranch.value = String(BRANCH_ID);
            }

            if (branchMenu.dataset.boundMenuClick !== 'true') {
                branchMenu.dataset.boundMenuClick = 'true';
                branchMenu.addEventListener('click', function (e) {
                    const target = e.target.closest('[data-branch-id]');
                    if (!target) return;
                    const nextBranchId = Number(target.getAttribute('data-branch-id'));
                    const selected = BRANCH_CACHE.find(function (branch) {
                        return Number(branch.id) === nextBranchId;
                    });
                    if (!selected) return;

                    BRANCH_ID = nextBranchId;
                    activeBranchLabel.textContent = selected.name || ('Chi ' + selected.id);
                    const mBranch = document.getElementById('mBranch');
                    const aBranch = document.getElementById('aBranch');
                    if (mBranch) mBranch.value = String(nextBranchId);
                    if (aBranch) aBranch.value = String(nextBranchId);
                    branchMenu.classList.remove('show');
                    loadRootPerson();
                });
            }
        }

        function getMaxGeneration(person) {
            if (!person) return 1;
            let maxGen = Number(person.generation || 1);
            const children = Array.isArray(person.children) ? person.children : [];
            children.forEach(function (child) {
                maxGen = Math.max(maxGen, getMaxGeneration(child));
            });
            return maxGen;
        }

        function renderGenerationMenu(maxGeneration) {
            const generationMenu = document.getElementById('generationMenu');
            const activeGenerationLabel = document.getElementById('activeGenerationLabel');
            if (!generationMenu || !activeGenerationLabel) return;

            const maxGen = Math.max(1, Number(maxGeneration || 1));
            if (CURRENT_GENERATION_FILTER != null && Number(CURRENT_GENERATION_FILTER) > maxGen) {
                CURRENT_GENERATION_FILTER = null;
            }
            let html = '<li><button type="button" class="dropdown-item" data-generation="">Tất cả đời</button></li>';
            for (let gen = 1; gen <= maxGen; gen++) {
                html += '<li><button type="button" class="dropdown-item" data-generation="' + gen + '">Đời ' + gen + '</button></li>';
            }
            generationMenu.innerHTML = html;
            activeGenerationLabel.textContent = CURRENT_GENERATION_FILTER ? ('Đời ' + CURRENT_GENERATION_FILTER) : 'Tất cả đời';

            if (generationMenu.dataset.boundGenerationClick !== 'true') {
                generationMenu.dataset.boundGenerationClick = 'true';
                generationMenu.addEventListener('click', function (e) {
                    const target = e.target.closest('[data-generation]');
                    if (!target) return;
                    const value = target.getAttribute('data-generation');
                    CURRENT_GENERATION_FILTER = value ? Number(value) : null;
                    activeGenerationLabel.textContent = CURRENT_GENERATION_FILTER ? ('Đời ' + CURRENT_GENERATION_FILTER) : 'Tất cả đời';
                    generationMenu.classList.remove('show');
                    applyGenerationFilterAndRender();
                });
            }
        }

        async function loadBranches(preferredBranchId) {
            try {
                const res = await fetch('/api/branch');
                if (!res.ok) return;
                const branches = await res.json();
                if (!Array.isArray(branches) || branches.length === 0) return;
                setBranchFormOptions(branches);
                bindBranchCreateInSelect();
                renderBranchMenu(branches, preferredBranchId);
            } catch (err) {
                console.error('Load branches failed:', err);
            }
        }

        // Modal / Offcanvas minimal open-close helpers (để family-tree.js gọi cũng được)
        window.ftUi = {
            openModal(id){ document.getElementById(id)?.classList.add('show'); },
            closeModal(id){ document.getElementById(id)?.classList.remove('show'); },
            openDrawer(id){ document.getElementById(id)?.classList.add('show'); },
            closeDrawer(id){ document.getElementById(id)?.classList.remove('show'); },
        };

        // close handlers
        document.addEventListener('click', function (e) {
            const closeId = e.target?.getAttribute?.('data-close');
            if (closeId) {
                const el = document.getElementById(closeId);
                el?.classList.remove('show');
            }
        });
        document.addEventListener('keydown', function(e){
            if (e.key === 'Escape') {
                document.getElementById('memberModal')?.classList.remove('show');
                document.getElementById('actionMemberModal')?.classList.remove('show');
                document.getElementById('detailDrawer')?.classList.remove('show');
                document.getElementById('branchMenu')?.classList.remove('show');
                document.getElementById('generationMenu')?.classList.remove('show');
            }
        });

        // Tạo thành viên đầu tiên
        (function () {
            const btn = document.getElementById('btnCreateFirst');
            if (!btn) return;
            // Default hidden; will be toggled after loading root person state.
            btn.style.setProperty('display', 'none', 'important');

            window.ftSetCreateFirstVisible = function (visible) {
                btn.style.setProperty('display', visible ? 'inline-flex' : 'none', 'important');
            };

            window.ftRefreshCreateFirstVisibility = async function (fallbackVisible) {
                try {
                    const countRes = await fetch('/api/person/count');
                    if (!countRes.ok) {
                        window.ftSetCreateFirstVisible(!!fallbackVisible);
                        return;
                    }
                    const total = Number(await countRes.json() || 0);
                    window.ftSetCreateFirstVisible(total === 0);
                } catch (e) {
                    window.ftSetCreateFirstVisible(!!fallbackVisible);
                }
            };

            btn.addEventListener('click', function () {
                // Mở modal
                if (window.ftUi && typeof window.ftUi.openModal === 'function') {
                    window.ftUi.openModal('memberModal');
                }

                // Set tiêu đề (đúng id là modalTitle)
                const title = document.getElementById('modalTitle');
                if (title) title.textContent = 'Tạo thành viên đầu tiên';

                // Reset fields
                const setVal = (id, v) => {
                    const el = document.getElementById(id);
                    if (el) el.value = v;
                };

                setVal('mFullname', '');
                setVal('mDob', '');
                setVal('mDod', '');
                setVal('mGeneration', '1');
                setVal('mBranch', String(BRANCH_ID));
                setVal('mAvatar', '');
                setVal('mAvatarFile', '');

                // Default giới tính
                const gMale = document.getElementById('gMale');
                if (gMale) gMale.checked = true;

                // Focus
                const fullname = document.getElementById('mFullname');
                if (fullname) fullname.focus();
            });
        })();

        // Lưu thành viên đầu tiên
        document.getElementById("btnSaveMember").addEventListener("click", async (e) => {
            e.preventDefault();
            const fullName = document.getElementById("mFullname").value.trim();
            const dob = document.getElementById("mDob").value || null;   // "YYYY-MM-DD"
            const dod = document.getElementById("mDod").value || null;   // "YYYY-MM-DD"
            const generation = document.getElementById("mGeneration").value;
            const branch = document.getElementById("mBranch").value || String(BRANCH_ID);
            const avatar = document.getElementById("mAvatar").value.trim() || null;

            const genderEl = document.querySelector('input[name="mGender"]:checked');
            const gender = genderEl ? genderEl.value : null;

            const payload = {
                fullName,
                dob,          // LocalDate nhận chuỗi yyyy-MM-dd OK
                dod,
                generation: generation ? parseInt(generation, 10) : null,
                branch,
                gender,
                avatar,
                fatherId: null,
                motherId: null,
                spouseId: null,
                mediaIds: [],
                childrenIds: []
            };

            // Validate tối thiểu
            if (!payload.fullName) {
                alert("Vui lòng nhập họ và tên");
                return;
            }

            try {
                const res = await fetch("/api/person", {
                    method: "POST",
                    headers: { "Content-Type": "application/json" },
                    body: JSON.stringify(payload)
                });

                if (!res.ok) {
                    const errText = await res.text();
                    console.error("Create person failed:", errText);
                    alert("Lưu thất bại!");
                    return;
                }

                const data = await res.json();
                console.log("Saved:", data);
                alert("Lưu thành công!");
                if (window.ftUi && typeof window.ftUi.closeModal === 'function') {
                    window.ftUi.closeModal('memberModal');
                }
                await loadRootPerson();
            } catch (err) {
                console.error(err);
                alert("Có lỗi kết nối server!");
            }
        });

        const actionState = {
            mode: null,
            person: null
        };

        function setActionGender(gender) {
            const target = gender || '';
            document.getElementById('aGender').value = target;
            document.querySelectorAll('#actionGenderGrid .gender-choice').forEach(function (btn) {
                btn.classList.toggle('active', btn.getAttribute('data-gender') === target);
            });
        }

        function openActionMemberModal(mode, person) {
            actionState.mode = mode;
            actionState.person = person || null;

            const titleEl = document.getElementById('actionModalTitle');
            const iconEl = document.getElementById('actionModalIcon');
            const saveBtn = document.getElementById('btnSaveActionMember');

            const fullName = person?.fullName || '';
            const generation = Number(person?.generation || 1);

            let title = 'Thêm thành viên';
            let icon = 'bi-person-plus';
            let defaultGen = generation;
            let defaultGender = '';

            if (mode === 'add-spouse') {
                title = 'Thêm vợ - ' + fullName;
                icon = 'bi-person-plus';
                defaultGen = generation;
                defaultGender = 'female';
            } else if (mode === 'add-child') {
                title = 'Thêm con - ' + fullName;
                icon = 'bi-person-plus';
                defaultGen = generation + 1;
            } else if (mode === 'edit-member') {
                title = 'Sửa thông tin - ' + fullName;
                icon = 'bi-pencil';
                defaultGen = generation;
                defaultGender = person?.gender || '';
            }

            titleEl.textContent = title;
            iconEl.innerHTML = '<i class="bi ' + icon + '"></i>';
            saveBtn.innerHTML = mode === 'edit-member'
                ? '<i class="bi bi-check2"></i> Lưu cập nhật'
                : '<i class="bi bi-plus-lg"></i> Lưu thành viên';
            saveBtn.disabled = false;

            document.getElementById('aFullname').value = mode === 'edit-member' ? fullName : '';
            document.getElementById('aDob').value = mode === 'edit-member' ? (person?.dob || '') : '';
            document.getElementById('aDod').value = mode === 'edit-member' ? (person?.dod || '') : '';
            document.getElementById('aGeneration').value = String(defaultGen);
            document.getElementById('aBranch').value = String(BRANCH_ID);
            document.getElementById('aAvatar').value = mode === 'edit-member' ? (person?.avatar || '') : '';
            document.getElementById('aAvatarFile').value = '';
            setActionGender(defaultGender);

            window.ftUi.openModal('actionMemberModal');
        }

        document.getElementById('actionGenderGrid').addEventListener('click', function (e) {
            const choice = e.target.closest('.gender-choice');
            if (!choice) return;
            setActionGender(choice.getAttribute('data-gender'));
        });

        document.getElementById('btnSaveActionMember').addEventListener('click', async function (e) {
            e.preventDefault();
            const mode = actionState.mode;
            const personId = actionState.person?.id;
            const fullName = document.getElementById('aFullname').value.trim();
            if (!fullName) {
                alert('Vui lòng nhập họ và tên');
                return;
            }

            const payload = {
                fullName: fullName,
                dob: document.getElementById('aDob').value || null,
                dod: document.getElementById('aDod').value || null,
                generation: Number(document.getElementById('aGeneration').value || 1),
                branch: String(document.getElementById('aBranch').value || BRANCH_ID),
                gender: document.getElementById('aGender').value || null,
                avatar: document.getElementById('aAvatar').value.trim() || null
            };

            if (mode === 'add-spouse') {
                try {
                    const res = await fetch('/api/person/' + personId + '/spouse', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify(payload)
                    });
                    if (!res.ok) {
                        const errText = await res.text();
                        console.error('Add spouse failed:', errText);
                        alert('Thêm vợ/chồng thất bại!');
                        return;
                    }
                    window.ftUi.closeModal('actionMemberModal');
                    await loadRootPerson();
                    return;
                } catch (err) {
                    console.error(err);
                    alert('Có lỗi kết nối server!');
                    return;
                }
            }

            if (mode === 'add-child') {
                try {
                    const res = await fetch('/api/person/' + personId + '/child', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify(payload)
                    });
                    if (!res.ok) {
                        const errText = await res.text();
                        console.error('Add child failed:', errText);
                        alert('Thêm con thất bại!');
                        return;
                    }
                    window.ftUi.closeModal('actionMemberModal');
                    await loadRootPerson();
                    return;
                } catch (err) {
                    console.error(err);
                    alert('Có lỗi kết nối server!');
                    return;
                }
            }

            if (mode === 'edit-member') {
                try {
                    const res = await fetch('/api/person/' + personId, {
                        method: 'PUT',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify(payload)
                    });
                    if (!res.ok) {
                        const errText = await res.text();
                        console.error('Update person failed:', errText);
                        alert('Cập nhật thất bại!');
                        return;
                    }
                    window.ftUi.closeModal('actionMemberModal');
                    await loadRootPerson();
                    return;
                } catch (err) {
                    console.error(err);
                    alert('Có lỗi kết nối server!');
                    return;
                }
            }
            window.ftUi.closeModal('actionMemberModal');
        });

        function formatDate(dateStr) {
            if (!dateStr) return '';
            const parts = dateStr.split('-');
            if (parts.length !== 3) return dateStr;
            return parts[2] + '/' + parts[1] + '/' + parts[0];
        }

        async function deleteMember(person) {
            if (!person || !person.id) return;
            const fullName = person.fullName || 'thành viên này';
            const okToDelete = confirm('Bạn chắc chắn muốn xóa ' + fullName + '?');
            if (!okToDelete) return;

            try {
                const res = await fetch('/api/person/' + person.id, {
                    method: 'DELETE'
                });

                if (!res.ok) {
                    const errText = (await res.text()) || 'Xóa thất bại!';
                    alert(errText);
                    return;
                }

                await loadRootPerson();
            } catch (err) {
                console.error('Delete person failed:', err);
                alert('Có lỗi kết nối server!');
            }
        }

        function buildPersonCard(person, options) {
            const opts = options || {};
            const isSpouse = !!opts.isSpouse;
            const gender = (person.gender || 'other').toLowerCase();
            const genderClass = gender === 'male' ? 'bg-male' : (gender === 'female' ? 'bg-female' : 'bg-other');
            const genderSymbol = gender === 'male' ? '\u2642' : (gender === 'female' ? '\u2640' : '\u26A5');
            const ringClass = gender === 'male' ? 'ring-male' : (gender === 'female' ? 'ring-female' : 'ring-other');
            const generation = person.generation || 1;
            const branchName = person.branchName || 'Chưa có chi';
            const fullName = person.fullName || 'Chưa có tên';
            const avatar = person.avatar || ('https://ui-avatars.com/api/?name=' + encodeURIComponent(fullName) + '&background=e5e7eb&color=111827');
            const dobText = formatDate(person.dob);
            const dodText = formatDate(person.dod);
            const encodedName = encodeURIComponent(fullName);
            const encodedAvatar = encodeURIComponent(avatar);
            const encodedDob = encodeURIComponent(person.dob || '');
            const encodedDod = encodeURIComponent(person.dod || '');
            const hasSpouse = !!person.spouseId;

            let menuItems = '';
            if (canManageMember) {
                menuItems = ''
                    + '<button type="button" class="btn-blue" data-action="edit-member"><i class="bi bi-pencil"></i> Sửa thông tin</button>'
                    + '<button type="button" class="btn-red" data-action="delete-member"><i class="bi bi-trash"></i> Xóa</button>';
                if (gender === 'male' && !hasSpouse) {
                    menuItems = '<button type="button" class="btn-amber" data-action="add-spouse"><i class="bi bi-heart"></i> Thêm vợ</button>' + menuItems;
                }
                if (gender === 'male') {
                    menuItems = '<button type="button" class="btn-emerald" data-action="add-child"><i class="bi bi-person-plus"></i> Thêm con</button>' + menuItems;
                }
            }

            return '' +
                '<div class="person-card' + (isSpouse ? ' spouse' : '') + '" data-id="' + person.id + '" data-full-name="' + encodedName + '" data-generation="' + generation + '" data-gender="' + gender + '" data-avatar="' + encodedAvatar + '" data-dob="' + encodedDob + '" data-dod="' + encodedDod + '" data-has-spouse="' + (hasSpouse ? '1' : '0') + '">' +
                    '<div class="badge-gender ' + genderClass + '">' + genderSymbol + '</div>' +
                    '<div class="d-flex align-items-center gap-2">' +
                        '<img class="avatar ' + ringClass + '" src="' + avatar + '" alt="' + fullName + '" onerror="this.src=\'https://ui-avatars.com/api/?name=' + encodeURIComponent(fullName) + '&background=e5e7eb&color=111827\'" />' +
                        '<div>' +
                            '<p class="person-name">' + fullName + '</p>' +
                            '<p class="person-meta">Chi: ' + branchName + '</p>' +
                            '<p class="person-meta">Sinh: ' + (dobText || '--') + '</p>' +
                            (dodText ? '<p class="person-meta">Mất: ' + dodText + '</p>' : '') +
                        '</div>' +
                    '</div>' +
                    '<span class="badge-gen">G' + generation + '</span>' +
                    (canManageMember ? ('<div class="card-menu">' + menuItems + '<span class="menu-caret"></span></div>') : '') +
                '</div>';
        }

        function renderTreeNode(person) {
            const spouse = person.spouseId ? {
                id: person.spouseId,
                fullName: person.spouseFullName,
                gender: person.spouseGender,
                generation: person.spouseGeneration || person.generation,
                branchName: person.spouseBranchName || person.branchName,
                avatar: person.spouseAvatar,
                dob: person.spouseDob,
                dod: person.spouseDod,
                spouseId: person.id
            } : null;

            const children = person.children || [];
            let childrenHtml = '';
            if (children.length > 0) {
                const childSlots = children.map(function (child, idx) {
                    return '' +
                        '<div class="child-slot">' +
                            (idx > 0 ? '<div class="hline-left"></div>' : '') +
                            (idx < children.length - 1 ? '<div class="hline-right"></div>' : '') +
                            '<div class="vline" style="height:18px;"></div>' +
                            renderTreeNode(child) +
                        '</div>';
                }).join('');

                childrenHtml =
                    '<div class="vline" style="height:20px;"></div>' +
                    '<div class="children-row">' + childSlots + '</div>';
            }

            return '' +
                '<div class="ft-node">' +
                    '<div class="ft-row">' +
                        buildPersonCard(person, { isSpouse: false }) +
                        (spouse
                            ? '<div class="marriage"><span class="dash"></span><i class="bi bi-heart-fill"></i><span class="dash"></span></div>' + buildPersonCard(spouse, { isSpouse: true })
                            : '') +
                    '</div>' +
                    childrenHtml +
                '</div>';
        }

        function collectMembersByGeneration(person, generationFilter, result) {
            if (!person) return;
            if (Number(person.generation || 0) === Number(generationFilter)) {
                result.push(person);
            }
            const children = Array.isArray(person.children) ? person.children : [];
            children.forEach(function (child) {
                collectMembersByGeneration(child, generationFilter, result);
            });
        }

        function renderGenerationOnly(members) {
            if (!members || members.length === 0) {
                return '' +
                    '<div class="ft-empty">' +
                    '<div class="fw-semibold">Không có thành viên ở đời này</div>' +
                    '</div>';
            }

            const rows = members.map(function (person) {
                const spouse = person.spouseId ? {
                    id: person.spouseId,
                    fullName: person.spouseFullName,
                    gender: person.spouseGender,
                    generation: person.spouseGeneration || person.generation,
                    branchName: person.spouseBranchName || person.branchName,
                    avatar: person.spouseAvatar,
                    dob: person.spouseDob,
                    dod: person.spouseDod,
                    spouseId: person.id
                } : null;

                return '' +
                    '<div class="ft-row" style="margin:0 12px 16px 12px;">' +
                        buildPersonCard(person, { isSpouse: false }) +
                        (spouse
                            ? '<div class="marriage"><span class="dash"></span><i class="bi bi-heart-fill"></i><span class="dash"></span></div>' + buildPersonCard(spouse, { isSpouse: true })
                            : '') +
                    '</div>';
            }).join('');

            return '<div class="d-flex" style="flex-wrap:wrap;justify-content:center;align-items:flex-start;">' + rows + '</div>';
        }

        function applyGenerationFilterAndRender() {
            const treeRoot = document.getElementById('treeRoot');
            if (!treeRoot) return;
            if (!CURRENT_TREE_ROOT) {
                treeRoot.innerHTML = '';
                return;
            }

            if (CURRENT_GENERATION_FILTER == null) {
                treeRoot.innerHTML = renderTreeNode(CURRENT_TREE_ROOT);
                return;
            }

            const members = [];
            collectMembersByGeneration(CURRENT_TREE_ROOT, CURRENT_GENERATION_FILTER, members);
            treeRoot.innerHTML = renderGenerationOnly(members);
        }

        async function loadRootPerson() {
            const treeRoot = document.getElementById('treeRoot');
            if (!treeRoot) return;

            try {
                const res = await fetch("/api/person/root?branchId=" + encodeURIComponent(BRANCH_ID));
                if (!res.ok) {
                    treeRoot.innerHTML = '';
                    if (typeof window.ftRefreshCreateFirstVisibility === 'function') {
                        await window.ftRefreshCreateFirstVisibility(true);
                    }
                    return;
                }

                const root = await res.json();
                if (!root || !root.id) {
                    CURRENT_TREE_ROOT = null;
                    renderGenerationMenu(1);
                    treeRoot.innerHTML = '';
                    if (typeof window.ftRefreshCreateFirstVisibility === 'function') {
                        await window.ftRefreshCreateFirstVisibility(true);
                    }
                    return;
                }
                CURRENT_TREE_ROOT = root;
                if (typeof window.ftRefreshCreateFirstVisibility === 'function') {
                    await window.ftRefreshCreateFirstVisibility(false);
                }
                renderGenerationMenu(getMaxGeneration(root));
                applyGenerationFilterAndRender();
            } catch (err) {
                console.error('Load root person failed:', err);
                CURRENT_TREE_ROOT = null;
                treeRoot.innerHTML = '';
                if (typeof window.ftRefreshCreateFirstVisibility === 'function') {
                    await window.ftRefreshCreateFirstVisibility(true);
                }
            }
        }

        function setupPersonCardActions() {
            const treeRoot = document.getElementById('treeRoot');
            if (!treeRoot || treeRoot.dataset.actionsBound === 'true') return;
            treeRoot.dataset.actionsBound = 'true';

            treeRoot.addEventListener('click', function (e) {
                const actionBtn = e.target.closest('button[data-action]');
                if (actionBtn) {
                    e.stopPropagation();
                    const action = actionBtn.getAttribute('data-action');
                    const card = actionBtn.closest('.person-card');
                    const person = card ? {
                        id: Number(card.getAttribute('data-id') || 0),
                        fullName: decodeURIComponent(card.getAttribute('data-full-name') || ''),
                        generation: Number(card.getAttribute('data-generation') || 1),
                        gender: (card.getAttribute('data-gender') || '').toLowerCase(),
                        avatar: decodeURIComponent(card.getAttribute('data-avatar') || ''),
                        dob: decodeURIComponent(card.getAttribute('data-dob') || ''),
                        dod: decodeURIComponent(card.getAttribute('data-dod') || ''),
                        spouseId: card.getAttribute('data-has-spouse') === '1' ? 1 : null
                    } : null;
                    document.querySelectorAll('#treeRoot .person-card.menu-open').forEach(function (el) {
                        el.classList.remove('menu-open');
                    });
                    if (action === 'delete-member') {
                        deleteMember(person);
                        return;
                    }
                    openActionMemberModal(action, person);
                    return;
                }

                const card = e.target.closest('.person-card');
                if (!card) return;
                e.stopPropagation();

                document.querySelectorAll('#treeRoot .person-card.menu-open').forEach(function (el) {
                    if (el !== card) el.classList.remove('menu-open');
                });
                card.classList.toggle('menu-open');
            });

            document.addEventListener('click', function () {
                document.querySelectorAll('#treeRoot .person-card.menu-open').forEach(function (el) {
                    el.classList.remove('menu-open');
                });
            });
        }

        function initZoomControls() {
            const scaleWrap = document.getElementById('scaleWrap');
            const zoomLabel = document.getElementById('zoomLabel');
            const zoomInBtn = document.getElementById('zoomIn');
            const zoomOutBtn = document.getElementById('zoomOut');
            const zoomResetBtn = document.getElementById('zoomReset');
            if (!scaleWrap || !zoomLabel || !zoomInBtn || !zoomOutBtn || !zoomResetBtn) return;

            let currentScale = 1;
            const step = 0.1;
            const minScale = 0.5;
            const maxScale = 2;

            const applyScale = function () {
                scaleWrap.style.transform = 'scale(' + currentScale.toFixed(2) + ')';
                zoomLabel.textContent = Math.round(currentScale * 100) + '%';
                zoomOutBtn.disabled = currentScale <= minScale;
                zoomInBtn.disabled = currentScale >= maxScale;
            };

            zoomInBtn.addEventListener('click', function () {
                currentScale = Math.min(maxScale, currentScale + step);
                applyScale();
            });

            zoomOutBtn.addEventListener('click', function () {
                currentScale = Math.max(minScale, currentScale - step);
                applyScale();
            });

            zoomResetBtn.addEventListener('click', function () {
                currentScale = 1;
                applyScale();
            });

            applyScale();
        }

        function bindAvatarPicker(fileInputId, targetInputId) {
            const fileInput = document.getElementById(fileInputId);
            const targetInput = document.getElementById(targetInputId);
            if (!fileInput || !targetInput) return;

            fileInput.addEventListener('change', function () {
                const file = fileInput.files && fileInput.files[0];
                if (!file) return;

                const reader = new FileReader();
                reader.onload = function (evt) {
                    const dataUrl = evt && evt.target ? evt.target.result : '';
                    if (typeof dataUrl === 'string' && dataUrl.length > 0) {
                        targetInput.value = dataUrl;
                    }
                };
                reader.readAsDataURL(file);
            });
        }

        bindAvatarPicker('mAvatarFile', 'mAvatar');
        bindAvatarPicker('aAvatarFile', 'aAvatar');
        initZoomControls();
        setupPersonCardActions();
        loadBranches();
        loadRootPerson();
</script>


</div>
        </div>
    </div>
</div>




