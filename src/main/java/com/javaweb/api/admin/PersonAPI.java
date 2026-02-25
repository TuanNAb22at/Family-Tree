package com.javaweb.api.admin;

import com.javaweb.model.dto.PersonDTO;
import com.javaweb.service.IPersonService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/person")
public class PersonAPI {
    @Autowired
    IPersonService iPersonService;
    @PostMapping
    public ResponseEntity<PersonDTO> createPerson(@RequestBody PersonDTO personDTO) {
        iPersonService.createPerson(personDTO);
        return ResponseEntity.ok(personDTO);
    }

    @GetMapping("/root")
    public ResponseEntity<PersonDTO> getRootPerson(
            @RequestParam(value = "branchId", defaultValue = "1") Long branchId
    ) {
        PersonDTO root = iPersonService.findRootPersonByBranchId(branchId);
        return ResponseEntity.ok(root);
    }

    @PostMapping("/{id}/spouse")
    public ResponseEntity<PersonDTO> addSpouse(
            @PathVariable("id") Long personId,
            @RequestBody PersonDTO spouseDTO
    ) {
        return ResponseEntity.ok(iPersonService.addSpouse(personId, spouseDTO));
    }

    @PostMapping("/{id}/child")
    public ResponseEntity<PersonDTO> addChild(
            @PathVariable("id") Long personId,
            @RequestBody PersonDTO childDTO
    ) {
        return ResponseEntity.ok(iPersonService.addChild(personId, childDTO));
    }

    @PutMapping("/{id}")
    public ResponseEntity<PersonDTO> updatePerson(
            @PathVariable("id") Long personId,
            @RequestBody PersonDTO personDTO
    ) {
        return ResponseEntity.ok(iPersonService.updatePerson(personId, personDTO));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deletePerson(@PathVariable("id") Long personId) {
        try {
            iPersonService.deletePerson(personId);
            return ResponseEntity.ok().build();
        } catch (IllegalArgumentException ex) {
            return ResponseEntity.badRequest().body(ex.getMessage());
        }
    }
}
