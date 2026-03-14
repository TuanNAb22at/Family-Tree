package com.javaweb.api.web;

import com.javaweb.model.request.LivestreamRequest;
import com.javaweb.model.response.LivestreamWatchResponse;
import com.javaweb.service.ILivestreamService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/livestream")
public class LivestreamAPI {
    @Autowired
    private ILivestreamService livestreamService;

    @PostMapping("/start")
    public ResponseEntity<?> start(@RequestBody LivestreamRequest request) {
        try {
            String streamUrl = request != null ? request.getStreamUrl() : null;
            String title = request != null ? request.getTitle() : null;
            Long branchId = request != null ? request.getBranchId() : null;
            LivestreamWatchResponse response = livestreamService.startLive(title, streamUrl, branchId);
            return ResponseEntity.ok(response);
        } catch (IllegalArgumentException ex) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(ex.getMessage());
        }
    }

    // backward-compatible endpoint
    @PostMapping
    public ResponseEntity<?> startCompat(@RequestBody LivestreamRequest request) {
        return start(request);
    }

    @GetMapping("/watch")
    public ResponseEntity<?> watch(@RequestParam(value = "livestreamId", required = false) Long livestreamId) {
        try {
            LivestreamWatchResponse response = livestreamService.watch(livestreamId);
            return ResponseEntity.ok(response);
        } catch (IllegalArgumentException ex) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ex.getMessage());
        }
    }

    @GetMapping("/live")
    public ResponseEntity<?> getCurrentLive() {
        try {
            LivestreamWatchResponse response = livestreamService.getCurrentLiveForViewerBranch();
            return ResponseEntity.ok(response);
        } catch (IllegalArgumentException ex) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ex.getMessage());
        }
    }

    @PutMapping("/{id}/end")
    public ResponseEntity<?> end(@PathVariable("id") Long livestreamId) {
        try {
            LivestreamWatchResponse response = livestreamService.endLive(livestreamId);
            return ResponseEntity.ok(response);
        } catch (IllegalArgumentException ex) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(ex.getMessage());
        }
    }
}
