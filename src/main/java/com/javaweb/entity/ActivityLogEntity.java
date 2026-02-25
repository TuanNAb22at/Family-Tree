package com.javaweb.entity;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "activitylog")
@Getter
@Setter
public class ActivityLogEntity extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private UserEntity user;

    @Column(name = "action", nullable = false)
    private String action;

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "timestamp", nullable = false)
    private Date timestamp;
}