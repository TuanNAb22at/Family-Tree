package com.javaweb.service;

import com.javaweb.model.response.LivestreamWatchResponse;

public interface ILivestreamService {
    LivestreamWatchResponse startLive(String title, String streamUrl, Long branchId);
    LivestreamWatchResponse watch(Long livestreamId);
    LivestreamWatchResponse endLive(Long livestreamId);
    LivestreamWatchResponse getCurrentLiveForViewerBranch();
}
