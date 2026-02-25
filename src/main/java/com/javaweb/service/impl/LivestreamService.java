package com.javaweb.service.impl;

import com.javaweb.entity.BranchEntity;
import com.javaweb.entity.LivestreamEntity;
import com.javaweb.entity.PersonEntity;
import com.javaweb.entity.UserEntity;
import com.javaweb.model.dto.MyUserDetail;
import com.javaweb.model.response.LivestreamWatchResponse;
import com.javaweb.repository.BranchRepository;
import com.javaweb.repository.LivestreamRepository;
import com.javaweb.repository.PersonRepository;
import com.javaweb.repository.UserRepository;
import com.javaweb.service.ILivestreamService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Objects;

@Service
public class LivestreamService implements ILivestreamService {
    private static final Integer STATUS_LIVE = 1;
    private static final Integer STATUS_ENDED = 0;

    @Autowired
    private LivestreamRepository livestreamRepository;

    @Autowired
    private PersonRepository personRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private BranchRepository branchRepository;

    @Override
    @Transactional
    public LivestreamWatchResponse startLive(String title, String streamUrl, Long branchId) {
        if (branchId == null) {
            throw new IllegalArgumentException("branch_id is required");
        }

        UserEntity currentUser = getCurrentUser();
        assertHostPermission(currentUser);

        PersonEntity hostPerson = getCurrentPerson(currentUser.getId());
        BranchEntity hostBranch = requireBranch(hostPerson);
        if (!Objects.equals(hostBranch.getId(), branchId)) {
            throw new IllegalArgumentException("Host can only start livestream for their own branch");
        }

        BranchEntity targetBranch = branchRepository.findById(branchId)
                .orElseThrow(() -> new IllegalArgumentException("Branch not found"));

        LivestreamEntity livestream = new LivestreamEntity();
        livestream.setTitle((title == null || title.trim().isEmpty())
                ? ("Livestream branch " + targetBranch.getId())
                : title.trim());
        String normalizedStream = (streamUrl == null || streamUrl.trim().isEmpty())
                ? ("webrtc://branch/" + targetBranch.getId())
                : streamUrl.trim();
        livestream.setStreamUrl(normalizedStream);
        livestream.setStatus(STATUS_LIVE);
        livestream.setBranch(targetBranch);
        livestream.setHost(currentUser);
        livestream = livestreamRepository.save(livestream);

        return toResponse(livestream);
    }

    @Override
    @Transactional(readOnly = true)
    public LivestreamWatchResponse watch(Long livestreamId) {
        UserEntity viewer = getCurrentUser();
        PersonEntity viewerPerson = getCurrentPerson(viewer.getId());
        BranchEntity viewerBranch = requireBranch(viewerPerson);

        LivestreamEntity livestream;
        if (livestreamId != null) {
            livestream = livestreamRepository.findByIdAndStatus(livestreamId, STATUS_LIVE)
                    .orElseThrow(() -> new IllegalArgumentException("Livestream not found or not live"));
        } else {
            livestream = livestreamRepository
                    .findFirstByBranch_IdAndStatusOrderByIdDesc(viewerBranch.getId(), STATUS_LIVE)
                    .orElseThrow(() -> new IllegalArgumentException("No livestream available for your branch"));
        }

        if (!Objects.equals(livestream.getBranch().getId(), viewerBranch.getId())) {
            throw new IllegalArgumentException("Access denied for this livestream");
        }
        return toResponse(livestream);
    }

    @Override
    @Transactional
    public LivestreamWatchResponse endLive(Long livestreamId) {
        if (livestreamId == null) {
            throw new IllegalArgumentException("livestream_id is required");
        }

        UserEntity currentUser = getCurrentUser();
        assertHostPermission(currentUser);

        LivestreamEntity livestream = livestreamRepository.findById(livestreamId)
                .orElseThrow(() -> new IllegalArgumentException("Livestream not found"));

        if (!Objects.equals(livestream.getHost().getId(), currentUser.getId())
                && !hasRole(currentUser, "MANAGER")) {
            throw new IllegalArgumentException("Only host (or manager) can end this livestream");
        }

        livestream.setStatus(STATUS_ENDED);
        livestream = livestreamRepository.save(livestream);
        return toResponse(livestream);
    }

    @Override
    @Transactional(readOnly = true)
    public LivestreamWatchResponse getCurrentLiveForViewerBranch() {
        return watch(null);
    }

    private LivestreamWatchResponse toResponse(LivestreamEntity livestream) {
        LivestreamWatchResponse response = new LivestreamWatchResponse();
        response.setLivestreamId(livestream.getId());
        response.setTitle(livestream.getTitle());
        response.setStatus(STATUS_LIVE.equals(livestream.getStatus()) ? "LIVE" : "ENDED");
        response.setBranchId(livestream.getBranch() != null ? livestream.getBranch().getId() : null);
        response.setStreamUrl(livestream.getStreamUrl());
        response.setRoomLink("/admin/livestream?livestreamId=" + livestream.getId());
        return response;
    }

    private void assertHostPermission(UserEntity user) {
        if (!hasRole(user, "MANAGER") && !hasRole(user, "EDITOR")) {
            throw new IllegalArgumentException("Host permission required (MANAGER or EDITOR)");
        }
    }

    private boolean hasRole(UserEntity user, String roleCode) {
        if (user.getRoles() == null) {
            return false;
        }
        return user.getRoles().stream()
                .anyMatch(role -> role.getCode() != null && roleCode.equalsIgnoreCase(role.getCode()));
    }

    private PersonEntity getCurrentPerson(Long userId) {
        return personRepository.findByUserId(userId)
                .orElseThrow(() -> new IllegalArgumentException("Current user is not mapped to person/branch"));
    }

    private BranchEntity requireBranch(PersonEntity person) {
        if (person.getBranch() == null || person.getBranch().getId() == null) {
            throw new IllegalArgumentException("Current user has no branch");
        }
        return person.getBranch();
    }

    private UserEntity getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            throw new IllegalArgumentException("Unauthenticated");
        }
        Object principal = authentication.getPrincipal();
        if (!(principal instanceof MyUserDetail)) {
            throw new IllegalArgumentException("Unauthenticated");
        }
        Long userId = ((MyUserDetail) principal).getId();
        if (userId == null) {
            throw new IllegalArgumentException("Unauthenticated");
        }
        return userRepository.findById(userId).orElseThrow(() -> new IllegalArgumentException("User not found"));
    }
}
