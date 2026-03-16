package com.javaweb.familytree.domain;

import java.time.LocalDate;

public final class FamilyMember {
    private final Long id;
    private final Long branchId;
    private final String branchName;
    private final Long userId;
    private final String fullName;
    private final String gender;
    private final String avatar;
    private final LocalDate dob;
    private final LocalDate dod;
    private final Integer generation;
    private final String hometown;
    private final String currentResidence;
    private final String occupation;
    private final String otherNote;
    private final Long fatherId;
    private final Long motherId;
    private final Long spouseId;

    public FamilyMember(Long id,
                        Long branchId,
                        String branchName,
                        Long userId,
                        String fullName,
                        String gender,
                        String avatar,
                        LocalDate dob,
                        LocalDate dod,
                        Integer generation,
                        String hometown,
                        String currentResidence,
                        String occupation,
                        String otherNote,
                        Long fatherId,
                        Long motherId,
                        Long spouseId) {
        this.id = id;
        this.branchId = branchId;
        this.branchName = branchName;
        this.userId = userId;
        this.fullName = fullName;
        this.gender = gender;
        this.avatar = avatar;
        this.dob = dob;
        this.dod = dod;
        this.generation = generation;
        this.hometown = hometown;
        this.currentResidence = currentResidence;
        this.occupation = occupation;
        this.otherNote = otherNote;
        this.fatherId = fatherId;
        this.motherId = motherId;
        this.spouseId = spouseId;
    }

    public Long getId() {
        return id;
    }

    public Long getBranchId() {
        return branchId;
    }

    public String getBranchName() {
        return branchName;
    }

    public Long getUserId() {
        return userId;
    }

    public String getFullName() {
        return fullName;
    }

    public String getGender() {
        return gender;
    }

    public String getAvatar() {
        return avatar;
    }

    public LocalDate getDob() {
        return dob;
    }

    public LocalDate getDod() {
        return dod;
    }

    public Integer getGeneration() {
        return generation;
    }

    public String getHometown() {
        return hometown;
    }

    public String getCurrentResidence() {
        return currentResidence;
    }

    public String getOccupation() {
        return occupation;
    }

    public String getOtherNote() {
        return otherNote;
    }

    public Long getFatherId() {
        return fatherId;
    }

    public Long getMotherId() {
        return motherId;
    }

    public Long getSpouseId() {
        return spouseId;
    }
}
