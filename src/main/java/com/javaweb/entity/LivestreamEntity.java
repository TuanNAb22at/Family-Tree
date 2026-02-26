package com.javaweb.entity;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;

@Entity
@Table(name = "livestream")
@Getter
@Setter
public class LivestreamEntity extends BaseEntity {

    @Column(name = "title", nullable = false)
    private String title;

    @Column(name = "stream_url", nullable = false, length = 500)
    private String streamUrl;

    @Column(name = "status", nullable = false)
    private Integer status;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "branch_id", nullable = false)
    private BranchEntity branch;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "host_id", nullable = false)
    private UserEntity host;
}