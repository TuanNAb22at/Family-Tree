package com.javaweb.api.web;

import com.javaweb.model.response.LivestreamWatchResponse;
import com.javaweb.service.ILivestreamService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class WatchAPI {
    @Autowired
    private ILivestreamService livestreamService;

    @GetMapping("/watch")
    public ResponseEntity<?> watch(@RequestParam(value = "livestreamId", required = false) Long livestreamId) {
        try {
            LivestreamWatchResponse response = livestreamService.watch(livestreamId);
            return ResponseEntity.ok(response);
        } catch (IllegalArgumentException ex) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(ex.getMessage());
        }
    }
}
