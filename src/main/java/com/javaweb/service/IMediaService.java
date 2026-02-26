package com.javaweb.service;

import com.javaweb.model.dto.MediaDTO;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;

public interface IMediaService {
    List<MediaDTO> findAllMediaForAdminView();
    List<MediaDTO> uploadMediaFiles(List<MultipartFile> files, List<String> displayNames, List<String> visibilityScopes, Long personId, Long branchId);
    MediaDTO findMediaById(Long mediaId);
    void deleteMedia(Long mediaId);
    void validateCurrentUserCanAccessStoredFile(String storedFileName);
    Map<Long, String> getBranchMap();
    Map<Long, String> getUserMap();
    Map<Long, String> getPersonMap();
}
