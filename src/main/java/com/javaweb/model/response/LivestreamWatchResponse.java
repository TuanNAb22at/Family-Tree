package com.javaweb.model.response;

public class LivestreamWatchResponse {
    private Long livestreamId;
    private String title;
    private String status;
    private Long branchId;
    private String streamUrl;
    private String roomLink;

    public Long getLivestreamId() {
        return livestreamId;
    }

    public void setLivestreamId(Long livestreamId) {
        this.livestreamId = livestreamId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Long getBranchId() {
        return branchId;
    }

    public void setBranchId(Long branchId) {
        this.branchId = branchId;
    }

    public String getStreamUrl() {
        return streamUrl;
    }

    public void setStreamUrl(String streamUrl) {
        this.streamUrl = streamUrl;
    }

    public String getRoomLink() {
        return roomLink;
    }

    public void setRoomLink(String roomLink) {
        this.roomLink = roomLink;
    }
}
