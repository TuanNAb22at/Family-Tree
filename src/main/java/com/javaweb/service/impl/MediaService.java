package com.javaweb.service.impl;

import com.javaweb.entity.BranchEntity;
import com.javaweb.entity.MediaEntity;
import com.javaweb.entity.PersonEntity;
import com.javaweb.entity.UserEntity;
import com.javaweb.model.dto.MediaDTO;
import com.javaweb.repository.BranchRepository;
import com.javaweb.repository.MediaRepository;
import com.javaweb.repository.PersonRepository;
import com.javaweb.repository.UserRepository;
import com.javaweb.security.utils.SecurityUtils;
import com.javaweb.service.IMediaService;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class MediaService implements IMediaService {

    private static final String DEFAULT_FILE_SIZE = "Chua cap nhat";
    private static final String ACCESS_SCOPE_PUBLIC = "PUBLIC";
    private static final String ACCESS_SCOPE_PRIVATE = "PRIVATE";
    private static final DateTimeFormatter DATE_FORMAT =
            DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    private static final String MEDIA_FILE_API_PREFIX = "/api/media/file/";

    @Autowired
    private MediaRepository mediaRepository;

    @Autowired
    private BranchRepository branchRepository;

    @Autowired
    private PersonRepository personRepository;

    @Autowired
    private UserRepository userRepository;

    @Value("${media.upload.dir:uploads/media}")
    private String mediaUploadDir;

    @Override
    @Transactional(readOnly = true)
    public List<MediaDTO> findAllMediaForAdminView() {
        boolean privileged = hasMediaAdminPermission();
        return mediaRepository.findAllForAdminView()
                .stream()
                .filter(entity -> privileged || ACCESS_SCOPE_PUBLIC.equals(resolveAccessScope(entity.getFileUrl())))
                .map(this::toDto)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public List<MediaDTO> uploadMediaFiles(List<MultipartFile> files, List<String> displayNames, List<String> visibilityScopes, Long personId, Long branchId) {
        if (files == null || files.isEmpty()) {
            throw new IllegalArgumentException("Danh sach file upload dang rong");
        }

        UserEntity uploader = resolveCurrentUser();
        PersonEntity person = resolvePerson(personId);
        BranchEntity branch = resolveBranch(branchId, person);

        Path uploadRoot = getUploadRootPath();
        try {
            Files.createDirectories(uploadRoot);
        } catch (IOException ex) {
            throw new IllegalStateException("Khong the tao thu muc upload media", ex);
        }

        List<MediaEntity> savedEntities = files.stream()
                .filter(file -> file != null && !file.isEmpty())
                .map(file -> storeSingleFile(file, resolveDisplayName(file, files, displayNames), resolveAccessScopeValue(file, files, visibilityScopes), uploadRoot, uploader, person, branch))
                .collect(Collectors.toList());

        return savedEntities.stream().map(this::toDto).collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public MediaDTO findMediaById(Long mediaId) {
        MediaEntity entity = mediaRepository.findById(mediaId)
                .orElseThrow(() -> new IllegalArgumentException("Khong tim thay media id=" + mediaId));
        if (!canCurrentUserAccess(entity)) {
            throw new AccessDeniedException("Ban khong co quyen xem media nay");
        }
        return toDto(entity);
    }

    @Override
    @Transactional
    public void deleteMedia(Long mediaId) {
        MediaEntity entity = mediaRepository.findById(mediaId)
                .orElseThrow(() -> new IllegalArgumentException("Khong tim thay media id=" + mediaId));
        deletePhysicalFile(entity.getFileUrl());
        mediaRepository.delete(entity);
    }

    @Override
    @Transactional(readOnly = true)
    public void validateCurrentUserCanAccessStoredFile(String storedFileName) {
        if (StringUtils.isBlank(storedFileName)) {
            throw new AccessDeniedException("Ban khong co quyen xem media nay");
        }
        String lookupPrefix = MEDIA_FILE_API_PREFIX + storedFileName + "?";
        MediaEntity entity = mediaRepository.findFirstByFileUrlStartingWith(lookupPrefix)
                .orElseThrow(() -> new AccessDeniedException("Ban khong co quyen xem media nay"));
        if (!canCurrentUserAccess(entity)) {
            throw new AccessDeniedException("Ban khong co quyen xem media nay");
        }
    }

    @Override
    @Transactional(readOnly = true)
    public Map<Long, String> getBranchMap() {
        return branchRepository.findAll()
                .stream()
                .sorted((a, b) -> Long.compare(a.getId(), b.getId()))
                .collect(Collectors.toMap(
                        BranchEntity::getId,
                        BranchEntity::getName,
                        (left, right) -> left,
                        LinkedHashMap::new
                ));
    }

    @Override
    @Transactional(readOnly = true)
    public Map<Long, String> getUserMap() {
        return userRepository.findByStatusNotOrderByIdAsc(0)
                .stream()
                .collect(Collectors.toMap(
                        UserEntity::getId,
                        this::resolveUserDisplayName,
                        (left, right) -> left,
                        LinkedHashMap::new
                ));
    }

    @Override
    @Transactional(readOnly = true)
    public Map<Long, String> getPersonMap() {
        return personRepository.findAll()
                .stream()
                .sorted((a, b) -> Long.compare(a.getId(), b.getId()))
                .collect(Collectors.toMap(
                        PersonEntity::getId,
                        PersonEntity::getFullName,
                        (left, right) -> left,
                        LinkedHashMap::new
                ));
    }

    private MediaDTO toDto(MediaEntity entity) {
        MediaDTO dto = new MediaDTO();
        dto.setId(entity.getId());
        dto.setFileUrl(entity.getFileUrl());
        dto.setMediaType(resolveMediaType(entity.getMediaType(), entity.getFileUrl()));
        dto.setPersonId(entity.getPerson() != null ? entity.getPerson().getId() : null);
        dto.setBranchId(entity.getBranch() != null ? entity.getBranch().getId() : null);
        dto.setUploaderId(entity.getUploader() != null ? entity.getUploader().getId() : null);
        dto.setFileName(resolveFileName(entity.getFileUrl()));
        dto.setFileSize(resolveFileSize(entity.getFileUrl()));
        dto.setUploadDate(formatDate(entity.getCreatedDate()));
        dto.setDuration(null);
        dto.setAccessScope(resolveAccessScope(entity.getFileUrl()));
        return dto;
    }

    private String resolveUserDisplayName(UserEntity user) {
        if (StringUtils.isNotBlank(user.getFullName())) {
            return user.getFullName();
        }
        if (StringUtils.isNotBlank(user.getUserName())) {
            return user.getUserName();
        }
        return "User #" + user.getId();
    }

    private String resolveMediaType(String mediaType, String fileUrl) {
        if (StringUtils.isNotBlank(mediaType)) {
            return mediaType.trim().toUpperCase(Locale.ROOT);
        }
        String fileName = resolveFileName(fileUrl).toLowerCase(Locale.ROOT);
        if (fileName.endsWith(".mp4")
                || fileName.endsWith(".mov")
                || fileName.endsWith(".avi")
                || fileName.endsWith(".mkv")
                || fileName.endsWith(".webm")) {
            return "VIDEO";
        }
        if (fileName.endsWith(".mp3")
                || fileName.endsWith(".wav")
                || fileName.endsWith(".m4a")
                || fileName.endsWith(".ogg")
                || fileName.endsWith(".flac")) {
            return "AUDIO";
        }
        return "IMAGE";
    }

    private String resolveFileName(String fileUrl) {
        if (StringUtils.isBlank(fileUrl)) {
            return "unknown-file";
        }
        String fileNameInQuery = extractFileNameFromQuery(fileUrl);
        if (StringUtils.isNotBlank(fileNameInQuery)) {
            return fileNameInQuery;
        }
        String cleanedUrl = fileUrl;
        int queryIndex = cleanedUrl.indexOf('?');
        if (queryIndex >= 0) {
            cleanedUrl = cleanedUrl.substring(0, queryIndex);
        }
        int slashIndex = cleanedUrl.lastIndexOf('/');
        if (slashIndex >= 0 && slashIndex < cleanedUrl.length() - 1) {
            return cleanedUrl.substring(slashIndex + 1);
        }
        return cleanedUrl;
    }

    private String resolveFileSize(String fileUrl) {
        if (StringUtils.isBlank(fileUrl) || !fileUrl.startsWith(MEDIA_FILE_API_PREFIX)) {
            return DEFAULT_FILE_SIZE;
        }
        String storedFileName = extractStoredFileName(fileUrl);
        if (StringUtils.isBlank(storedFileName)) {
            return DEFAULT_FILE_SIZE;
        }
        Path filePath = getUploadRootPath().resolve(storedFileName).normalize();
        if (!Files.exists(filePath) || !Files.isRegularFile(filePath)) {
            return DEFAULT_FILE_SIZE;
        }
        try {
            return humanReadableSize(Files.size(filePath));
        } catch (IOException ex) {
            return DEFAULT_FILE_SIZE;
        }
    }

    private UserEntity resolveCurrentUser() {
        String username = SecurityUtils.getPrincipal().getUsername();
        UserEntity uploader = userRepository.findOneByUserName(username);
        if (uploader == null) {
            throw new IllegalArgumentException("Khong tim thay user upload: " + username);
        }
        return uploader;
    }

    private PersonEntity resolvePerson(Long personId) {
        if (personId == null) {
            return null;
        }
        return personRepository.findById(personId).orElse(null);
    }

    private BranchEntity resolveBranch(Long branchId, PersonEntity person) {
        if (branchId != null) {
            Optional<BranchEntity> branchEntity = branchRepository.findById(branchId);
            if (branchEntity.isPresent()) {
                return branchEntity.get();
            }
        }
        if (person != null && person.getBranch() != null) {
            return person.getBranch();
        }
        return null;
    }

    private MediaEntity storeSingleFile(MultipartFile file,
                                        String displayName,
                                        String accessScope,
                                        Path uploadRoot,
                                        UserEntity uploader,
                                        PersonEntity person,
                                        BranchEntity branch) {
        String originalName = file.getOriginalFilename();
        String extension = "";
        if (StringUtils.isNotBlank(originalName) && originalName.lastIndexOf('.') >= 0) {
            extension = originalName.substring(originalName.lastIndexOf('.')).toLowerCase(Locale.ROOT);
        }
        String safeDisplayName = sanitizeDisplayName(stripExtension(displayName));
        if (StringUtils.isBlank(safeDisplayName)) {
            safeDisplayName = sanitizeDisplayName(stripExtension(resolveOriginalName(originalName)));
        }
        if (StringUtils.isBlank(safeDisplayName)) {
            safeDisplayName = "media";
        }
        String displayFileName = safeDisplayName + extension;
        String storedFileName = safeDisplayName + "_" + UUID.randomUUID().toString().replace("-", "") + extension;
        Path targetPath = uploadRoot.resolve(storedFileName).normalize();

        try {
            Files.copy(file.getInputStream(), targetPath, StandardCopyOption.REPLACE_EXISTING);
        } catch (IOException ex) {
            throw new IllegalStateException("Khong the luu file: " + originalName, ex);
        }

        MediaEntity mediaEntity = new MediaEntity();
        mediaEntity.setFileUrl(MEDIA_FILE_API_PREFIX + storedFileName + "?name=" + encodeUtf8(displayFileName) + "&scope=" + accessScope);
        mediaEntity.setMediaType(resolveMediaTypeByMime(file.getContentType(), extension));
        mediaEntity.setUploader(uploader);
        mediaEntity.setPerson(person);
        mediaEntity.setBranch(branch);
        return mediaRepository.save(mediaEntity);
    }

    private String resolveMediaTypeByMime(String contentType, String extension) {
        if (StringUtils.isNotBlank(contentType)) {
            String lowered = contentType.toLowerCase(Locale.ROOT);
            if (lowered.startsWith("video/")) {
                return "VIDEO";
            }
            if (lowered.startsWith("image/")) {
                return "IMAGE";
            }
            if (lowered.startsWith("audio/")) {
                return "AUDIO";
            }
        }
        if (StringUtils.isNotBlank(extension)) {
            String ext = extension.toLowerCase(Locale.ROOT);
            if (".mp4".equals(ext) || ".mov".equals(ext) || ".avi".equals(ext) || ".mkv".equals(ext) || ".webm".equals(ext)) {
                return "VIDEO";
            }
            if (".mp3".equals(ext) || ".wav".equals(ext) || ".m4a".equals(ext) || ".ogg".equals(ext) || ".flac".equals(ext)) {
                return "AUDIO";
            }
        }
        return "IMAGE";
    }

    private String humanReadableSize(long bytes) {
        if (bytes < 1024) {
            return bytes + " B";
        }
        double kb = bytes / 1024.0;
        if (kb < 1024) {
            return String.format(Locale.US, "%.1f KB", kb);
        }
        double mb = kb / 1024.0;
        if (mb < 1024) {
            return String.format(Locale.US, "%.1f MB", mb);
        }
        double gb = mb / 1024.0;
        return String.format(Locale.US, "%.2f GB", gb);
    }

    private Path getUploadRootPath() {
        return Paths.get(mediaUploadDir).toAbsolutePath().normalize();
    }

    private String resolveDisplayName(MultipartFile file, List<MultipartFile> files, List<String> displayNames) {
        if (displayNames == null || displayNames.isEmpty()) {
            return stripExtension(resolveOriginalName(file.getOriginalFilename()));
        }
        int idx = files.indexOf(file);
        if (idx >= 0 && idx < displayNames.size()) {
            String provided = displayNames.get(idx);
            if (StringUtils.isNotBlank(provided)) {
                return provided.trim();
            }
        }
        return stripExtension(resolveOriginalName(file.getOriginalFilename()));
    }

    private String resolveAccessScopeValue(MultipartFile file, List<MultipartFile> files, List<String> visibilityScopes) {
        if (visibilityScopes == null || visibilityScopes.isEmpty()) {
            return ACCESS_SCOPE_PUBLIC;
        }
        int idx = files.indexOf(file);
        String raw = null;
        if (idx >= 0 && idx < visibilityScopes.size()) {
            raw = visibilityScopes.get(idx);
        }
        if (StringUtils.isBlank(raw)) {
            return ACCESS_SCOPE_PUBLIC;
        }
        String normalized = raw.trim().toUpperCase(Locale.ROOT);
        return ACCESS_SCOPE_PRIVATE.equals(normalized) ? ACCESS_SCOPE_PRIVATE : ACCESS_SCOPE_PUBLIC;
    }

    private String resolveOriginalName(String originalName) {
        return StringUtils.isBlank(originalName) ? "media" : originalName.trim();
    }

    private String stripExtension(String fileName) {
        if (StringUtils.isBlank(fileName)) {
            return "media";
        }
        int idx = fileName.lastIndexOf('.');
        if (idx <= 0) {
            return fileName;
        }
        return fileName.substring(0, idx);
    }

    private String sanitizeDisplayName(String input) {
        if (StringUtils.isBlank(input)) {
            return "";
        }
        String sanitized = input.trim().replaceAll("[\\\\/:*?\"<>|]", "_");
        sanitized = sanitized.replaceAll("\\s+", "_");
        sanitized = sanitized.replaceAll("_+", "_");
        return sanitized;
    }

    private String extractStoredFileName(String fileUrl) {
        if (StringUtils.isBlank(fileUrl) || !fileUrl.startsWith(MEDIA_FILE_API_PREFIX)) {
            return null;
        }
        String raw = fileUrl.substring(MEDIA_FILE_API_PREFIX.length());
        int q = raw.indexOf('?');
        return q >= 0 ? raw.substring(0, q) : raw;
    }

    private String extractFileNameFromQuery(String fileUrl) {
        int q = fileUrl.indexOf('?');
        if (q < 0 || q == fileUrl.length() - 1) {
            return null;
        }
        String query = fileUrl.substring(q + 1);
        String[] params = query.split("&");
        for (String param : params) {
            if (param.startsWith("name=") && param.length() > 5) {
                return decodeUtf8(param.substring(5));
            }
        }
        return null;
    }

    private String resolveAccessScope(String fileUrl) {
        if (StringUtils.isBlank(fileUrl)) {
            return ACCESS_SCOPE_PUBLIC;
        }
        int q = fileUrl.indexOf('?');
        if (q < 0 || q == fileUrl.length() - 1) {
            return ACCESS_SCOPE_PUBLIC;
        }
        String query = fileUrl.substring(q + 1);
        String[] params = query.split("&");
        for (String param : params) {
            if (param.startsWith("scope=") && param.length() > 6) {
                String value = decodeUtf8(param.substring(6)).toUpperCase(Locale.ROOT);
                return ACCESS_SCOPE_PRIVATE.equals(value) ? ACCESS_SCOPE_PRIVATE : ACCESS_SCOPE_PUBLIC;
            }
        }
        return ACCESS_SCOPE_PUBLIC;
    }

    private boolean hasMediaAdminPermission() {
        List<String> authorities = SecurityUtils.getAuthorities();
        return authorities.contains("ROLE_MANAGER") || authorities.contains("ROLE_EDITOR");
    }

    private boolean canCurrentUserAccess(MediaEntity entity) {
        if (entity == null) {
            return false;
        }
        if (hasMediaAdminPermission()) {
            return true;
        }
        return ACCESS_SCOPE_PUBLIC.equals(resolveAccessScope(entity.getFileUrl()));
    }

    private String encodeUtf8(String value) {
        try {
            return URLEncoder.encode(value, "UTF-8");
        } catch (UnsupportedEncodingException ex) {
            return value;
        }
    }

    private String decodeUtf8(String value) {
        try {
            return URLDecoder.decode(value, "UTF-8");
        } catch (UnsupportedEncodingException ex) {
            return value;
        }
    }

    private void deletePhysicalFile(String fileUrl) {
        String storedFileName = extractStoredFileName(fileUrl);
        if (StringUtils.isBlank(storedFileName)) {
            return;
        }
        Path target = getUploadRootPath().resolve(storedFileName).normalize();
        try {
            Files.deleteIfExists(target);
        } catch (IOException ignored) {
        }
    }

    private String formatDate(Date date) {
        if (date == null) {
            return "Chua cap nhat";
        }
        return date.toInstant()
                .atZone(ZoneId.systemDefault())
                .toLocalDateTime()
                .format(DATE_FORMAT);
    }
}
