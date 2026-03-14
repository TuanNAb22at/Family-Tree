package com.javaweb.service;

import com.javaweb.model.dto.MediaDTO;
import com.javaweb.model.dto.MediaAlbumDTO;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;

public interface IMediaService {
    List<MediaDTO> findAllMediaForAdminView();
    List<MediaDTO> uploadMediaFiles(List<MultipartFile> files, List<String> displayNames, List<String> visibilityScopes, Long personId, Long branchId, Long albumId);
    MediaDTO findMediaById(Long mediaId);
    void deleteMedia(Long mediaId);
    List<MediaAlbumDTO> findAllAlbumsForAdminView();
    MediaAlbumDTO createAlbum(String name, String description, String accessScope, Long personId, Long branchId);
    void deleteAlbum(Long albumId);
    void validateCurrentUserCanAccessStoredFile(String storedFileName);
    Map<Long, String> getBranchMap();
    Map<Long, String> getUserMap();
    Map<Long, String> getPersonMap();
}
