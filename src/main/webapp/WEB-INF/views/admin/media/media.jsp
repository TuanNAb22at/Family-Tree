<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/common/taglib.jsp"%>
<c:url var="homeUrl" value="/admin/home"/>

<!-- Icons (Bootstrap Icons) -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet"/>
<title>Media</title>
<link rel="stylesheet" href="assets/css/media-page.css" />

<div class="main-content">
    <div class="breadcrumbs" id="breadcrumbs">
        <ul class="breadcrumb">
            <li>
                <i class="ace-icon fa-solid fa-house-chimney home-icon"></i>
                <a href="${homeUrl}">Trang chủ</a>
            </li>
            <li class="active">Media</li>
        </ul>
    </div>
    <div class="main-content-inner">
        <div class="page-content media-admin-page">
            <div id="mediaApp">
                    <!-- ========== MEDIA PAGE ========== -->
                    <div class="media-page">

                        <div class="media-main">
                            <div class="media-toolbar">
                                <div class="media-toolbar-left">
                                    <h2>Th&#432; vi&#7879;n Media</h2>
                                    <div class="media-search">
                                        <i class="fa-solid fa-magnifying-glass"></i>
                                        <input type="text" id="mediaSearch" placeholder="T&#236;m ki&#7871;m t&#7879;p...">
                                    </div>
                                </div>
                                <div class="btn-group">
                                    <select id="mediaTypeFilter" class="media-filter-select" aria-label="Lọc loại tệp">
                                        <option value="ALL">Tất cả loại tệp</option>
                                        <option value="IMAGE">Hình ảnh</option>
                                        <option value="VIDEO">Video</option>
                                        <option value="AUDIO">Âm thanh</option>
                                    </select>
                                    <security:authorize access="hasAnyRole('MANAGER','EDITOR')">
                                    <button class="btn-media-primary" id="btnUpload"><i class="fa-solid fa-cloud-arrow-up"></i> T&#7843;i l&#234;n</button>
                                    </security:authorize>
                                    <security:authorize access="hasRole('USER')">
                                    <button class="btn-media-outline" disabled style="opacity:0.8; cursor:not-allowed;"><i class="fa-solid fa-eye"></i> Ch&#7881; xem</button>
                                    </security:authorize>
                                </div>
                            </div>

                            <security:authorize access="hasAnyRole('MANAGER','EDITOR')">
                            <div class="media-upload-zone" id="dropZone">
                                <div class="upload-icon"><i class="fa-solid fa-cloud-arrow-up"></i></div>
                                <p>K&#233;o th&#7843; ho&#7863;c nh&#7845;n &#273;&#7875; t&#7843;i l&#234;n H&#236;nh &#7843;nh / Video / &#194;m thanh</p>
                                <span>H&#7895; tr&#7907;: JPG, PNG, MP4, MOV, MP3, WAV - T&#7889;i &#273;a 200 MB/t&#7879;p</span>
                                <input type="file" id="fileInput" style="display:none" multiple accept="image/*,video/*,audio/*">
                            </div>
                            </security:authorize>
                            <security:authorize access="hasRole('USER')">
                            <div class="media-upload-zone readonly">
                                <div class="upload-icon"><i class="fa-solid fa-lock"></i></div>
                                <p>T&#224;i kho&#7843;n User ch&#7881; &#273;&#432;&#7907;c xem n&#7897;i dung media</p>
                                <span>Upload ch&#7881; d&#224;nh cho Admin/Editor</span>
                            </div>
                            </security:authorize>

                            <div class="media-grid">
                                <c:forEach var="media" items="${mediaList}" varStatus="st">
                                    <div class="media-card ${st.index == 0 ? 'active' : ''}"
                                         data-id="${media.id}"
                                         data-name="${media.fileName}"
                                         data-type="${media.mediaType}"
                                         data-size="${media.fileSize}"
                                         data-date="${media.uploadDate}"
                                         data-duration="${media.duration}"
                                         data-url="${media.fileUrl}"
                                         data-person="${media.personId}"
                                         data-branch="${media.branchId}"
                                         data-uploader="${media.uploaderId}"
                                         data-scope="${media.accessScope}"
                                         onclick="selectMedia(this)">

                                        <c:choose>
                                            <c:when test="${media.mediaType == 'VIDEO'}">
                                                <video muted preload="metadata" style="width:100%;height:100%;object-fit:cover;background:#111827;">
                                                    <source src="${media.fileUrl}">
                                                </video>
                                            </c:when>
                                            <c:when test="${media.mediaType == 'AUDIO'}">
                                                <div class="audio-thumb">
                                                    <i class="fa-solid fa-music"></i>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <img src="${media.fileUrl}" alt="${media.fileName}">
                                            </c:otherwise>
                                        </c:choose>

                                        <c:if test="${media.mediaType == 'VIDEO' && not empty media.duration}">
                                            <div class="badge-type">
                                                <i class="fa-solid fa-play" style="font-size:0.55rem"></i>
                                                ${media.duration}
                                            </div>
                                        </c:if>
                                        <c:if test="${media.mediaType == 'AUDIO'}">
                                            <div class="badge-type">
                                                <i class="fa-solid fa-music" style="font-size:0.55rem"></i>
                                                AUDIO
                                            </div>
                                        </c:if>

                                        <div class="card-overlay">
                                            <div class="name" title="${media.fileName}">${media.fileName}</div>
                                            <div class="size">${media.fileSize}</div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>

                        <div class="media-sidebar" id="sidebarPanel">
                            <div class="sidebar-empty" id="sidebarEmpty">
                                <i class="fa-regular fa-image"></i>
                                <p>Ch&#7885;n m&#7897;t t&#7879;p &#273;&#7875; xem chi ti&#7871;t</p>
                            </div>

                            <div id="sidebarContent" style="display:none; flex-direction:column;">
                                <div class="sidebar-preview" id="previewArea"></div>
                                <div class="sidebar-body">
                                    <h3 id="detailName"></h3>
                                    <div class="sidebar-meta">
                                        <span id="detailSize"></span>
                                        <span>&bull;</span>
                                        <span id="detailDate"></span>
                                        <span id="detailDurationWrap" style="display:none">
                                            <span>&bull;</span>
                                            <span id="detailDuration" style="color:#047857; font-weight:600"></span>
                                        </span>
                                    </div>

                                    <div class="sidebar-section">
                                        <h4><i class="fa-solid fa-gear" style="color:#047857; margin-right:0.35rem"></i> H&#224;nh &#273;&#7897;ng</h4>
                                        <div style="display:flex; gap:0.5rem; flex-wrap:wrap; margin-bottom:0.5rem;">
                                            <button class="btn-media-outline" id="btnZoomOut"><i class="fa-solid fa-magnifying-glass-minus"></i> Thu nh&#7887;</button>
                                            <button class="btn-media-outline" id="btnZoomIn"><i class="fa-solid fa-magnifying-glass-plus"></i> Ph&#243;ng to</button>
                                            <button class="btn-media-outline" id="btnZoomReset"><i class="fa-solid fa-rotate-left"></i> 100%</button>
                                        </div>
                                        <div style="display:flex; gap:0.5rem; flex-wrap:wrap;">
                                            <button class="btn-media-outline" id="btnDownloadMedia" style="flex:1"><i class="fa-solid fa-download"></i> T&#7843;i xu&#7889;ng</button>
                                            <security:authorize access="hasAnyRole('MANAGER','EDITOR')">
                                            <button class="btn-media-outline" id="btnDeleteMedia" style="flex:1; color:#dc2626; border-color:#fecaca;"><i class="fa-solid fa-trash-can"></i> X&#243;a</button>
                                            </security:authorize>
                                        </div>
                                    </div>

                                    <div class="sidebar-section link-info-section">
                                        <h4><i class="fa-solid fa-tags" style="color:#047857; margin-right:0.35rem"></i> Th&#244;ng tin li&#234;n k&#7871;t</h4>
                                        <div class="sidebar-field">
                                            <span class="label">Lo&#7841;i t&#7879;p</span>
                                            <span class="value" id="detailType"></span>
                                        </div>
                                        <div class="sidebar-field">
                                            <span class="label">Chi nh&#225;nh</span>
                                            <span class="value" id="detailBranch"></span>
                                        </div>
                                        <div class="sidebar-field">
                                            <span class="label">Nh&#226;n kh&#7849;u</span>
                                            <span class="value" id="detailPerson"></span>
                                        </div>
                                        <div class="sidebar-field">
                                            <span class="label">Ng&#432;&#7901;i t&#7843;i l&#234;n</span>
                                            <span class="value" id="detailUploader"></span>
                                        </div>
                                        <div class="sidebar-field">
                                            <span class="label">M&#7913;c xem</span>
                                            <span class="value" id="detailScope"></span>
                                        </div>
                                    </div>

                                    <div class="sidebar-section">
                                        <h4><i class="fa-solid fa-user-shield" style="color:#047857; margin-right:0.35rem"></i> Quy&#7873;n truy c&#7853;p</h4>
                                        <security:authorize access="hasAnyRole('MANAGER','EDITOR')">
                                        <p class="permission-note can-edit">B&#7841;n &#273;ang l&#224; Admin/Editor: &#273;&#432;&#7907;c upload, t&#7843;i xu&#7889;ng, x&#243;a v&#224; xem file b&#237; m&#7853;t.</p>
                                        </security:authorize>
                                        <security:authorize access="hasRole('USER')">
                                        <p class="permission-note read-only">B&#7841;n &#273;ang l&#224; User: ch&#7881; xem/t&#7843;i xu&#7889;ng file c&#244;ng khai, kh&#244;ng th&#7845;y file b&#237; m&#7853;t.</p>
                                        </security:authorize>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>

                </div>
            </div>
        </div>
    </div>
</div>

<div id="appDialogBackdrop" class="app-dialog-backdrop">
    <div class="app-dialog" role="dialog" aria-modal="true" aria-labelledby="appDialogTitle">
        <div class="app-dialog-header">
            <h5 class="app-dialog-title" id="appDialogTitle">Xác nhận</h5>
        </div>
        <div class="app-dialog-body">
            <p class="app-dialog-message" id="appDialogMessage"></p>
            <div class="app-dialog-input-wrap" id="appDialogInputWrap">
                <label class="app-dialog-label" id="appDialogInputLabel" for="appDialogInput"></label>
                <input type="text" class="app-dialog-input" id="appDialogInput">
            </div>
            <div class="app-dialog-input-wrap" id="appDialogScopeWrap">
                <label class="app-dialog-label" for="appDialogScope">Quyền xem</label>
                <select class="app-dialog-input" id="appDialogScope">
                    <option value="PUBLIC">Cho tất cả xem</option>
                    <option value="PRIVATE">Bí mật - chỉ Admin/Editor xem</option>
                </select>
            </div>
            <ol class="app-dialog-list" id="appDialogList" style="display:none;"></ol>
        </div>
        <div class="app-dialog-actions">
            <button type="button" class="btn-dialog-cancel" id="appDialogCancel">Hủy</button>
            <button type="button" class="btn-dialog-ok" id="appDialogOk">Xác nhận</button>
        </div>
    </div>
</div>

            </div>
        </div>
    </div>
</div>

<script>
    var branchMap = {
        <c:forEach var="entry" items="${branchMap}">
            ${entry.key}: "${entry.value}",
        </c:forEach>
    };
    var userMap = {
        <c:forEach var="entry" items="${userMap}">
            ${entry.key}: "${entry.value}",
        </c:forEach>
    };
    var personMap = {
        <c:forEach var="entry" items="${personMap}">
            ${entry.key}: "${entry.value}",
        </c:forEach>
    };

    var currentMediaId = null;
    var currentZoom = 1;
    var currentMediaType = null;
    var dropZone = document.getElementById('dropZone');
    var fileInput = document.getElementById('fileInput');
    var mediaPage = document.querySelector('.media-page');
    var canUpload = false;
    <security:authorize access="hasAnyRole('MANAGER','EDITOR')">
    canUpload = true;
    </security:authorize>
    var dialogBackdrop = document.getElementById('appDialogBackdrop');
    var dialogTitle = document.getElementById('appDialogTitle');
    var dialogMessage = document.getElementById('appDialogMessage');
    var dialogInputWrap = document.getElementById('appDialogInputWrap');
    var dialogInputLabel = document.getElementById('appDialogInputLabel');
    var dialogInput = document.getElementById('appDialogInput');
    var dialogScopeWrap = document.getElementById('appDialogScopeWrap');
    var dialogScope = document.getElementById('appDialogScope');
    var dialogList = document.getElementById('appDialogList');
    var dialogCancel = document.getElementById('appDialogCancel');
    var dialogOk = document.getElementById('appDialogOk');
    var activeDialogResolver = null;

    function closeAppDialog(payload) {
        dialogBackdrop.style.display = 'none';
        dialogOk.classList.remove('btn-danger');
        if (activeDialogResolver) {
            var resolve = activeDialogResolver;
            activeDialogResolver = null;
            resolve(payload);
        }
    }

    function openAppDialog(options) {
        options = options || {};
        return new Promise(function(resolve) {
            activeDialogResolver = resolve;
            dialogTitle.textContent = options.title || 'Xác nhận';
            dialogMessage.textContent = options.message || '';

            if (options.list && options.list.length) {
                dialogList.style.display = '';
                dialogList.innerHTML = options.list.map(function(item) {
                    return '<li>' + item + '</li>';
                }).join('');
            } else {
                dialogList.style.display = 'none';
                dialogList.innerHTML = '';
            }

            if (options.input) {
                dialogInputWrap.style.display = 'block';
                dialogInputLabel.textContent = options.inputLabel || 'Nhập nội dung';
                dialogInput.value = options.inputValue || '';
            } else {
                dialogInputWrap.style.display = 'none';
                dialogInput.value = '';
            }
            if (options.scopeSelect) {
                dialogScopeWrap.style.display = 'block';
                dialogScope.value = options.scopeValue || 'PUBLIC';
            } else {
                dialogScopeWrap.style.display = 'none';
                dialogScope.value = 'PUBLIC';
            }

            dialogCancel.style.display = options.hideCancel ? 'none' : '';
            dialogCancel.textContent = options.cancelText || 'Hủy';
            dialogOk.textContent = options.okText || 'Xác nhận';
            if (options.danger) {
                dialogOk.classList.add('btn-danger');
            } else {
                dialogOk.classList.remove('btn-danger');
            }

            dialogBackdrop.style.display = 'flex';
            if (options.input) {
                setTimeout(function() {
                    dialogInput.focus();
                    dialogInput.select();
                }, 0);
            } else {
                setTimeout(function() {
                    dialogOk.focus();
                }, 0);
            }
        });
    }

    dialogCancel.addEventListener('click', function() {
        closeAppDialog({ confirmed: false, value: null });
    });
    dialogOk.addEventListener('click', function() {
        closeAppDialog({
            confirmed: true,
            value: dialogInputWrap.style.display === 'none' ? null : dialogInput.value,
            scope: dialogScopeWrap.style.display === 'none' ? 'PUBLIC' : dialogScope.value
        });
    });
    dialogBackdrop.addEventListener('click', function(e) {
        if (e.target === dialogBackdrop) {
            closeAppDialog({ confirmed: false, value: null });
        }
    });
    dialogInput.addEventListener('keydown', function(e) {
        if (e.key === 'Enter') {
            e.preventDefault();
            dialogOk.click();
        }
    });

    function clampZoom(v) {
        if (v < 1) return 1;
        if (v > 4) return 4;
        return v;
    }

    function updateZoomButtons() {
        var btnZoomOut = document.getElementById('btnZoomOut');
        var btnZoomReset = document.getElementById('btnZoomReset');
        if (btnZoomOut) {
            btnZoomOut.disabled = currentZoom <= 1;
            btnZoomOut.style.opacity = currentZoom <= 1 ? '0.6' : '1';
            btnZoomOut.style.cursor = currentZoom <= 1 ? 'not-allowed' : 'pointer';
        }
        if (btnZoomReset) {
            btnZoomReset.disabled = currentZoom === 1;
            btnZoomReset.style.opacity = currentZoom === 1 ? '0.6' : '1';
            btnZoomReset.style.cursor = currentZoom === 1 ? 'not-allowed' : 'pointer';
        }
    }

    function setMediaLayoutByRatio(ratio, mediaType) {
        if (!mediaPage) return;
        var leftFr = '1.05fr';
        var rightFr = '0.95fr';

        if (mediaType === 'AUDIO') {
            leftFr = '1.12fr';
            rightFr = '0.88fr';
        } else if (ratio >= 1.65) {
            leftFr = '0.92fr';
            rightFr = '1.08fr';
        } else if (ratio >= 1.25) {
            leftFr = '0.98fr';
            rightFr = '1.02fr';
        } else if (ratio <= 0.8) {
            leftFr = '1.12fr';
            rightFr = '0.88fr';
        }

        mediaPage.style.setProperty('--left-fr', leftFr);
        mediaPage.style.setProperty('--right-fr', rightFr);
    }

    function bindMediaFitSize(media) {
        if (!media) return;
        var fitWidth = Math.max(1, media.clientWidth || media.offsetWidth || 1);
        var fitHeight = Math.max(1, media.clientHeight || media.offsetHeight || 1);
        media.dataset.fitWidth = String(fitWidth);
        media.dataset.fitHeight = String(fitHeight);
    }

    function applyPreviewZoom() {
        var preview = document.getElementById('previewArea');
        var media = preview.querySelector('.preview-media');
        if (!media) {
            updateZoomButtons();
            return;
        }

        media.style.display = 'block';
        media.style.margin = 'auto';
        media.style.objectFit = 'contain';
        media.style.transition = 'width 0.15s ease, height 0.15s ease';

        // Default: always fit inside preview frame
        if (currentZoom <= 1) {
            media.style.width = 'auto';
            media.style.height = 'auto';
            media.style.maxWidth = '100%';
            media.style.maxHeight = '100%';
            bindMediaFitSize(media);
            updateZoomButtons();
            return;
        }

        // Zoom mode: scale from fitted size for smooth incremental zoom
        var baseW = parseFloat(media.dataset.fitWidth || '0');
        var baseH = parseFloat(media.dataset.fitHeight || '0');
        if (!(baseW > 0) || !(baseH > 0)) {
            bindMediaFitSize(media);
            baseW = parseFloat(media.dataset.fitWidth || '1');
            baseH = parseFloat(media.dataset.fitHeight || '1');
        }

        media.style.maxWidth = 'none';
        media.style.maxHeight = 'none';
        media.style.width = Math.max(120, Math.round(baseW * currentZoom)) + 'px';
        media.style.height = Math.max(90, Math.round(baseH * currentZoom)) + 'px';
        updateZoomButtons();
    }

    function selectMedia(el) {
        document.querySelectorAll('.media-card').forEach(function(c) { c.classList.remove('active'); });
        el.classList.add('active');
        currentMediaId = el.dataset.id;
        currentZoom = 1;
        currentMediaType = el.dataset.type || null;

        document.getElementById('sidebarEmpty').style.display = 'none';
        document.getElementById('sidebarContent').style.display = 'flex';

        var d = el.dataset;
        document.getElementById('detailName').textContent = d.name;
        document.getElementById('detailSize').textContent = d.size;
        document.getElementById('detailDate').textContent = d.date;
        var mediaTypeText = d.type === 'VIDEO' ? 'Video' : (d.type === 'AUDIO' ? 'Âm thanh' : 'Hình ảnh');
        document.getElementById('detailType').textContent = mediaTypeText;
        document.getElementById('detailScope').textContent = (d.scope === 'PRIVATE') ? 'Bí mật' : 'Công khai';

        var dw = document.getElementById('detailDurationWrap');
        if (d.duration && d.duration !== 'null') {
            dw.style.display = 'inline';
            document.getElementById('detailDuration').textContent = d.duration;
        } else {
            dw.style.display = 'none';
        }

        document.getElementById('detailBranch').textContent = branchMap[d.branch] || '-';
        document.getElementById('detailPerson').textContent =
            (d.person && d.person !== 'null') ? personMap[d.person] : 'Không gắn cá nhân';
        document.getElementById('detailUploader').textContent = userMap[d.uploader] || '-';

        var preview = document.getElementById('previewArea');
        if (d.type === 'VIDEO') {
            preview.innerHTML = '<video class="preview-media" controls preload="metadata" playsinline>' +
                '<source src="' + d.url + '">' +
                '</video>';
        } else if (d.type === 'AUDIO') {
            preview.innerHTML = '<div style="width:100%;display:flex;flex-direction:column;align-items:center;justify-content:center;gap:12px;padding:20px;">' +
                '<i class="fa-solid fa-music" style="font-size:42px;color:#fff;"></i>' +
                '<audio controls style="width:100%;max-width:520px;">' +
                '<source src="' + d.url + '">' +
                '</audio></div>';
        } else {
            preview.innerHTML = '<img class="preview-media" src="' + d.url + '" alt="preview">';
        }
        preview.scrollTop = 0;
        preview.scrollLeft = 0;
        var media = preview.querySelector('.preview-media');
        if (media) {
            if (media.tagName && media.tagName.toLowerCase() === 'video') {
                media.addEventListener('loadedmetadata', function() {
                    var ratio = (media.videoWidth && media.videoHeight) ? (media.videoWidth / media.videoHeight) : 1.3;
                    setMediaLayoutByRatio(ratio, 'VIDEO');
                    applyPreviewZoom();
                });
            } else if (media.tagName && media.tagName.toLowerCase() === 'img') {
                if (media.complete) {
                    var ratioReady = (media.naturalWidth && media.naturalHeight) ? (media.naturalWidth / media.naturalHeight) : 1;
                    setMediaLayoutByRatio(ratioReady, 'IMAGE');
                    applyPreviewZoom();
                } else {
                    media.onload = function() {
                        var ratio = (media.naturalWidth && media.naturalHeight) ? (media.naturalWidth / media.naturalHeight) : 1;
                        setMediaLayoutByRatio(ratio, 'IMAGE');
                        applyPreviewZoom();
                    };
                }
            }
        }
        if (d.type === 'AUDIO') {
            setMediaLayoutByRatio(1, 'AUDIO');
        }
        applyPreviewZoom();
    }

    function uploadFiles(files) {
        if (!canUpload) return;
        if (!files || !files.length) return;

        var rawFiles = Array.prototype.slice.call(files);
        var prepared = [];
        var chain = Promise.resolve();

        rawFiles.forEach(function(f) {
            chain = chain.then(function() {
                var baseName = f.name.replace(/\.[^/.]+$/, '');
                return openAppDialog({
                    title: 'Đặt tên tệp',
                    message: 'Nhập tên hiển thị cho tệp: ' + f.name,
                    input: true,
                    scopeSelect: true,
                    scopeValue: 'PUBLIC',
                    inputLabel: 'Tên hiển thị',
                    inputValue: baseName,
                    okText: 'Tải lên',
                    cancelText: 'Hủy'
                }).then(function(result) {
                    if (!result.confirmed) {
                        throw { cancelled: true };
                    }
                    var customName = (result.value || '').trim();
                    if (!customName) customName = baseName;
                    prepared.push({ file: f, displayName: customName, scope: result.scope || 'PUBLIC' });
                });
            });
        });

        chain.then(function() {
            var formData = new FormData();
            for (var j = 0; j < prepared.length; j++) {
                formData.append('files', prepared[j].file);
                formData.append('displayNames', prepared[j].displayName);
                formData.append('visibilityScopes', prepared[j].scope);
            }

            var activeCard = document.querySelector('.media-card.active');
            if (activeCard) {
                var d = activeCard.dataset;
                if (d.person && d.person !== 'null') {
                    formData.append('personId', d.person);
                }
                if (d.branch && d.branch !== 'null') {
                    formData.append('branchId', d.branch);
                }
            }

            return fetch('/api/media/upload', {
                method: 'POST',
                body: formData
            }).then(function(response) {
                if (!response.ok) {
                    return response.text().then(function(text) {
                        throw new Error(text || 'Upload failed');
                    });
                }
                return response.json();
            }).then(function() {
                window.location.reload();
            });
        }).catch(function(err) {
            if (err && err.cancelled) {
                return;
            }
            openAppDialog({
                title: 'Lỗi tải lên',
                message: 'Tải lên lỗi: ' + (err.message || 'Không xác định'),
                hideCancel: true,
                okText: 'Đóng'
            });
        });
    }

    if (dropZone && fileInput) {
        dropZone.addEventListener('click', function() { fileInput.click(); });
        dropZone.addEventListener('dragover', function(e) { e.preventDefault(); dropZone.style.borderColor = '#047857'; dropZone.style.background = '#f0fdf4'; });
        dropZone.addEventListener('dragleave', function() { dropZone.style.borderColor = '#d6d3d1'; dropZone.style.background = '#fafaf9'; });
        dropZone.addEventListener('drop', function(e) {
            e.preventDefault();
            dropZone.style.borderColor = '#d6d3d1';
            dropZone.style.background = '#fafaf9';
            uploadFiles(e.dataTransfer.files);
        });
        fileInput.addEventListener('change', function() {
            uploadFiles(fileInput.files);
            fileInput.value = '';
        });
    }
    var btnUpload = document.getElementById('btnUpload');
    if (btnUpload && fileInput) {
        btnUpload.addEventListener('click', function() { fileInput.click(); });
    }

    document.getElementById('btnZoomIn').addEventListener('click', function() {
        currentZoom = clampZoom(currentZoom + 0.05);
        applyPreviewZoom();
    });
    document.getElementById('btnZoomOut').addEventListener('click', function() {
        currentZoom = clampZoom(currentZoom - 0.05);
        applyPreviewZoom();
    });
    document.getElementById('btnZoomReset').addEventListener('click', function() {
        currentZoom = 1;
        applyPreviewZoom();
    });

    document.getElementById('btnDownloadMedia').addEventListener('click', function() {
        if (!currentMediaId) {
            openAppDialog({
                title: 'Thông báo',
                message: 'Vui lòng chọn media để tải xuống.',
                hideCancel: true,
                okText: 'Đóng'
            });
            return;
        }
        window.open('/api/media/' + encodeURIComponent(currentMediaId) + '/download', '_blank');
    });

    var btnDeleteMedia = document.getElementById('btnDeleteMedia');
    if (btnDeleteMedia) btnDeleteMedia.addEventListener('click', function() {
        if (!currentMediaId) {
            openAppDialog({
                title: 'Thông báo',
                message: 'Vui lòng chọn media để xóa.',
                hideCancel: true,
                okText: 'Đóng'
            });
            return;
        }

        openAppDialog({
            title: 'Xác nhận xóa',
            message: 'Bạn có chắc muốn xóa media này không?',
            okText: 'Xóa',
            cancelText: 'Hủy',
            danger: true
        }).then(function(result) {
            if (!result.confirmed) {
                return;
            }
            return fetch('/api/media/' + encodeURIComponent(currentMediaId), {
                method: 'DELETE'
            }).then(function(response) {
                if (!response.ok) {
                    return response.text().then(function(text) {
                        throw new Error(text || 'Delete failed');
                    });
                }
                var selected = document.querySelector('.media-card.active');
                if (selected) {
                    selected.remove();
                }
                currentMediaId = null;
                document.getElementById('sidebarContent').style.display = 'none';
                document.getElementById('sidebarEmpty').style.display = 'flex';
                var firstCard = document.querySelector('.media-card');
                if (firstCard) {
                    selectMedia(firstCard);
                }
            });
        }).catch(function(err) {
            openAppDialog({
                title: 'Lỗi xóa',
                message: 'Xóa lỗi: ' + (err.message || 'Không xác định'),
                hideCancel: true,
                okText: 'Đóng'
            });
        });
    });

    function applyMediaFilter() {
        var keyword = (document.getElementById('mediaSearch').value || '').toLowerCase().trim();
        var type = document.getElementById('mediaTypeFilter').value;
        document.querySelectorAll('.media-card').forEach(function(card) {
            var name = (card.dataset.name || '').toLowerCase();
            var cardType = (card.dataset.type || '').toUpperCase();
            var matchedKeyword = !keyword || name.indexOf(keyword) >= 0;
            var matchedType = (type === 'ALL') || (cardType === type);
            card.style.display = (matchedKeyword && matchedType) ? '' : 'none';
        });
    }

    function initTypeFilterLabels() {
        var counts = { ALL: 0, IMAGE: 0, VIDEO: 0, AUDIO: 0 };
        document.querySelectorAll('.media-card').forEach(function(card) {
            counts.ALL++;
            var t = (card.dataset.type || '').toUpperCase();
            if (counts[t] !== undefined) {
                counts[t]++;
            }
        });
        var filter = document.getElementById('mediaTypeFilter');
        var labels = {
            ALL: 'Tất cả loại tệp',
            IMAGE: 'Hình ảnh',
            VIDEO: 'Video',
            AUDIO: 'Âm thanh'
        };
        Array.prototype.forEach.call(filter.options, function(opt) {
            var key = opt.value;
            if (labels[key] !== undefined) {
                opt.textContent = labels[key] + ' (' + (counts[key] || 0) + ')';
            }
        });
    }

    document.getElementById('mediaSearch').addEventListener('input', applyMediaFilter);
    document.getElementById('mediaTypeFilter').addEventListener('change', applyMediaFilter);

    var firstCard = document.querySelector('.media-card');
    if (firstCard) selectMedia(firstCard);
    else setMediaLayoutByRatio(1.2, null);
    initTypeFilterLabels();
    applyMediaFilter();
</script>

</body>
</html>

