<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@include file="/common/taglib.jsp"%>

<%
    Map<Integer, String> branchMap = new LinkedHashMap<>();
    branchMap.put(1, "Nhánh Trưởng");
    branchMap.put(2, "Nhánh Hai");
    request.setAttribute("branchMap", branchMap);

    Map<Integer, String> userMap = new LinkedHashMap<>();
    userMap.put(1, "nguyenvana");
    userMap.put(2, "tranthib");
    userMap.put(3, "levanc");
    request.setAttribute("userMap", userMap);

    Map<Integer, String> personMap = new LinkedHashMap<>();
    personMap.put(1, "Nguyễn Văn Tố");
    personMap.put(2, "Nguyễn Thị Lan");
    personMap.put(3, "Trần Văn Bình");
    request.setAttribute("personMap", personMap);

    List<Map<String, Object>> mediaList = new ArrayList<>();

    Map<String, Object> m1 = new HashMap<>();
    m1.put("id", 1);
    m1.put("file_url", "https://placehold.co/600x400/1a1a2e/FFF?text=Hop+mat+2023");
    m1.put("media_type", "VIDEO");
    m1.put("person_id", null);
    m1.put("branch_id", 1);
    m1.put("uploader_id", 1);
    m1.put("file_name", "Hop_mat_2023.mp4");
    m1.put("file_size", "1.2 GB");
    m1.put("upload_date", "20/11/2023");
    m1.put("duration", "45:30");
    mediaList.add(m1);

    Map<String, Object> m2 = new HashMap<>();
    m2.put("id", 2);
    m2.put("file_url", "https://placehold.co/600x400/2d6a4f/FFF?text=Anh+Gia+Dinh");
    m2.put("media_type", "IMAGE");
    m2.put("person_id", 1);
    m2.put("branch_id", 1);
    m2.put("uploader_id", 2);
    m2.put("file_name", "Anh_Gia_Dinh.jpg");
    m2.put("file_size", "4.5 MB");
    m2.put("upload_date", "20/11/2023");
    m2.put("duration", null);
    mediaList.add(m2);

    Map<String, Object> m3 = new HashMap<>();
    m3.put("id", 3);
    m3.put("file_url", "https://placehold.co/600x400/1a1a2e/FFF?text=Phat+bieu+ong+noi");
    m3.put("media_type", "VIDEO");
    m3.put("person_id", 1);
    m3.put("branch_id", 1);
    m3.put("uploader_id", 1);
    m3.put("file_name", "Phat_bieu_ong_noi.mp4");
    m3.put("file_size", "450 MB");
    m3.put("upload_date", "15/10/2023");
    m3.put("duration", "12:05");
    mediaList.add(m3);

    Map<String, Object> m4 = new HashMap<>();
    m4.put("id", 4);
    m4.put("file_url", "https://placehold.co/600x400/40916c/FFF?text=Nha+cu+1990");
    m4.put("media_type", "IMAGE");
    m4.put("person_id", null);
    m4.put("branch_id", 2);
    m4.put("uploader_id", 3);
    m4.put("file_name", "Nha_cu_1990.jpg");
    m4.put("file_size", "2.1 MB");
    m4.put("upload_date", "05/09/2023");
    m4.put("duration", null);
    mediaList.add(m4);

    Map<String, Object> m5 = new HashMap<>();
    m5.put("id", 5);
    m5.put("file_url", "https://placehold.co/600x400/52b788/FFF?text=Chan+dung+1985");
    m5.put("media_type", "IMAGE");
    m5.put("person_id", 2);
    m5.put("branch_id", 1);
    m5.put("uploader_id", 2);
    m5.put("file_name", "Chan_dung_1985.jpg");
    m5.put("file_size", "1.8 MB");
    m5.put("upload_date", "12/08/2023");
    m5.put("duration", null);
    mediaList.add(m5);

    Map<String, Object> m6 = new HashMap<>();
    m6.put("id", 6);
    m6.put("file_url", "https://placehold.co/600x400/1a1a2e/FFF?text=Tho+cung+to+tien");
    m6.put("media_type", "VIDEO");
    m6.put("person_id", null);
    m6.put("branch_id", 1);
    m6.put("uploader_id", 1);
    m6.put("file_name", "Tho_cung_to_tien.mp4");
    m6.put("file_size", "890 MB");
    m6.put("upload_date", "10/02/2023");
    m6.put("duration", "25:00");
    mediaList.add(m6);

    request.setAttribute("mediaList", mediaList);
%>

<!-- Icons (Bootstrap Icons) — giống family-tree -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet"/>

<style>
    /* ==== CRITICAL: tránh vỡ layout do box model ==== */
    #mediaApp, #mediaApp * { box-sizing: border-box; }

    #mediaApp .container-fluid{width:100%;padding-left:12px;padding-right:12px;margin:0 auto}
                        .media-page { display: flex; gap: 1rem; }
                        .media-main { flex: 1; min-width: 0; display: flex; flex-direction: column; background: #fff; border-radius: 0.75rem; border: 1px solid #e7e5e4; overflow: hidden; }
                        .media-sidebar { width: 320px; min-width: 320px; background: #fff; border-radius: 0.75rem; border: 1px solid #e7e5e4; display: flex; flex-direction: column; overflow: hidden; }

                        .media-toolbar { padding: 0.75rem 1rem; border-bottom: 1px solid #e7e5e4; display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 0.5rem; }
                        .media-toolbar h2 { font-size: 1.1rem; font-weight: 700; color: #1e293b; margin: 0 1rem 0 0; }
                        .media-search { position: relative; }
                        .media-search input { padding: 0.45rem 0.75rem 0.45rem 2.25rem; border: 1px solid #e7e5e4; border-radius: 0.5rem; font-size: 0.85rem; width: 220px; background: #fafaf9; }
                        .media-search input:focus { outline: none; border-color: #047857; box-shadow: 0 0 0 3px rgba(4,120,87,0.1); }
                        .media-search i { position: absolute; left: 0.75rem; top: 50%; transform: translateY(-50%); color: #94a3b8; font-size: 0.8rem; }
                        .media-toolbar .btn-group { display: flex; gap: 0.5rem; }

                        .btn-media-outline { display: flex; align-items: center; gap: 0.4rem; padding: 0.45rem 0.75rem; border: 1px solid #e7e5e4; border-radius: 0.5rem; background: #fff; color: #64748b; font-size: 0.8rem; font-weight: 500; cursor: pointer; transition: all 0.15s; }
                        .btn-media-outline:hover { border-color: #047857; color: #047857; background: #f0fdf4; }
                        .btn-media-primary { display: flex; align-items: center; gap: 0.4rem; padding: 0.45rem 1rem; border: none; border-radius: 0.5rem; background: #047857; color: #fff; font-size: 0.8rem; font-weight: 600; cursor: pointer; transition: all 0.15s; }
                        .btn-media-primary:hover { background: #065f46; box-shadow: 0 2px 8px rgba(4,120,87,0.25); }

                        .media-upload-zone { margin: 0.75rem 1rem; border: 2px dashed #d6d3d1; border-radius: 0.75rem; padding: 1.25rem; text-align: center; background: #fafaf9; transition: all 0.2s; cursor: pointer; }
                        .media-upload-zone:hover { border-color: #047857; background: #f0fdf4; }
                        .media-upload-zone .upload-icon { width: 36px; height: 36px; border-radius: 50%; background: #d1fae5; color: #047857; display: inline-flex; align-items: center; justify-content: center; margin-bottom: 0.4rem; font-size: 1rem; }
                        .media-upload-zone p { font-size: 0.85rem; font-weight: 500; color: #1e293b; margin: 0; }
                        .media-upload-zone span { font-size: 0.75rem; color: #94a3b8; }

                        .media-grid { overflow-y: auto; max-height: 400px; padding: 0.75rem 1rem 1rem; display: grid; grid-template-columns: repeat(auto-fill, minmax(160px, 1fr)); gap: 0.75rem; align-content: start; }
                        .media-card { position: relative; aspect-ratio: 1; border-radius: 0.75rem; overflow: hidden; border: 2px solid transparent; cursor: pointer; transition: all 0.2s; background: #f5f5f4; }
                        .media-card:hover { border-color: #a7f3d0; box-shadow: 0 4px 12px rgba(0,0,0,0.08); }
                        .media-card.active { border-color: #047857; box-shadow: 0 0 0 3px rgba(4,120,87,0.15); }
                        .media-card img { width: 100%; height: 100%; object-fit: cover; }
                        .media-card .card-overlay { position: absolute; bottom: 0; left: 0; right: 0; background: rgba(255,255,255,0.92); backdrop-filter: blur(4px); padding: 0.5rem 0.65rem; border-top: 1px solid #f5f5f4; }
                        .media-card .card-overlay .name { font-size: 0.75rem; font-weight: 600; color: #1e293b; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
                        .media-card .card-overlay .size { font-size: 0.68rem; color: #94a3b8; }
                        .media-card .badge-type { position: absolute; top: 0.5rem; right: 0.5rem; background: rgba(0,0,0,0.6); color: #fff; font-size: 0.65rem; font-weight: 600; padding: 0.15rem 0.4rem; border-radius: 0.25rem; display: flex; align-items: center; gap: 0.25rem; }

                        .sidebar-preview { background: #0f172a; display: flex; align-items: center; justify-content: center; min-height: 180px; }
                        .sidebar-preview img { width: 100%; height: auto; max-height: 200px; object-fit: contain; }
                        .sidebar-body { overflow-y: auto; padding: 1rem; }
                        .sidebar-body h3 { font-size: 0.95rem; font-weight: 700; color: #1e293b; margin-bottom: 0.25rem; word-break: break-all; }
                        .sidebar-meta { display: flex; gap: 0.5rem; font-size: 0.75rem; color: #94a3b8; margin-bottom: 1rem; flex-wrap: wrap; }
                        .sidebar-section { padding-top: 0.75rem; border-top: 1px solid #f5f5f4; margin-top: 0.75rem; }
                        .sidebar-section h4 { font-size: 0.7rem; font-weight: 700; color: #1e293b; text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 0.6rem; }
                        .sidebar-field { display: flex; justify-content: space-between; padding: 0.35rem 0; font-size: 0.8rem; }
                        .sidebar-field .label { color: #94a3b8; }
                        .sidebar-field .value { color: #1e293b; font-weight: 500; }
                        .tag { display: inline-flex; align-items: center; gap: 0.25rem; padding: 0.2rem 0.6rem; border-radius: 1rem; font-size: 0.72rem; font-weight: 500; }
                        .tag-green { background: #d1fae5; color: #047857; }
                        .tag-blue { background: #dbeafe; color: #1d4ed8; }

                        .sidebar-empty { display: flex; flex-direction: column; align-items: center; justify-content: center; min-height: 300px; color: #94a3b8; text-align: center; padding: 2rem; }
                        .sidebar-empty i { font-size: 2.5rem; margin-bottom: 0.75rem; color: #d6d3d1; }
                    </style>

                    <!-- ========== MEDIA PAGE ========== -->
                    <div class="media-page">

                        <div class="media-main">
                            <div class="media-toolbar">
                                <div style="display:flex; align-items:center;">
                                    <h2>Thư viện Media</h2>
                                    <div class="media-search">
                                        <i class="fa-solid fa-magnifying-glass"></i>
                                        <input type="text" id="mediaSearch" placeholder="Tìm kiếm tập tin...">
                                    </div>
                                </div>
                                <div class="btn-group">
                                    <button class="btn-media-outline"><i class="fa-solid fa-filter"></i> Bộ lọc</button>
                                    <button class="btn-media-primary" id="btnUpload"><i class="fa-solid fa-cloud-arrow-up"></i> Tải lên</button>
                                </div>
                            </div>

                            <div class="media-upload-zone" id="dropZone">
                                <div class="upload-icon"><i class="fa-solid fa-cloud-arrow-up"></i></div>
                                <p>Kéo thả hoặc nhấn để tải lên Hình ảnh / Video</p>
                                <span>Hỗ trợ: JPG, PNG, MP4, MOV — Tối đa 2 GB</span>
                                <input type="file" id="fileInput" style="display:none" multiple accept="image/*,video/*">
                            </div>

                            <div class="media-grid">
                                <c:forEach var="media" items="${mediaList}" varStatus="st">
                                    <div class="media-card ${st.index == 0 ? 'active' : ''}"
                                         data-id="${media.id}"
                                         data-name="${media.file_name}"
                                         data-type="${media.media_type}"
                                         data-size="${media.file_size}"
                                         data-date="${media.upload_date}"
                                         data-duration="${media.duration}"
                                         data-url="${media.file_url}"
                                         data-person="${media.person_id}"
                                         data-branch="${media.branch_id}"
                                         data-uploader="${media.uploader_id}"
                                         onclick="selectMedia(this)">

                                        <img src="${media.file_url}" alt="${media.file_name}">

                                        <c:if test="${media.media_type == 'VIDEO'}">
                                            <div class="badge-type">
                                                <i class="fa-solid fa-play" style="font-size:0.55rem"></i>
                                                ${media.duration}
                                            </div>
                                        </c:if>

                                        <div class="card-overlay">
                                            <div class="name" title="${media.file_name}">${media.file_name}</div>
                                            <div class="size">${media.file_size}</div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>

                        <div class="media-sidebar" id="sidebarPanel">
                            <div class="sidebar-empty" id="sidebarEmpty">
                                <i class="fa-regular fa-image"></i>
                                <p>Chọn một tập tin để xem chi tiết</p>
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
                                        <h4><i class="fa-solid fa-tags" style="color:#047857; margin-right:0.35rem"></i> Thông tin liên kết</h4>
                                        <div class="sidebar-field">
                                            <span class="label">Loại tệp</span>
                                            <span class="value" id="detailType"></span>
                                        </div>
                                        <div class="sidebar-field">
                                            <span class="label">Chi nhánh</span>
                                            <span class="value" id="detailBranch"></span>
                                        </div>
                                        <div class="sidebar-field">
                                            <span class="label">Nhân khẩu</span>
                                            <span class="value" id="detailPerson"></span>
                                        </div>
                                        <div class="sidebar-field">
                                            <span class="label">Người tải lên</span>
                                            <span class="value" id="detailUploader"></span>
                                        </div>
                                    </div>

                                    <div class="sidebar-section">
                                        <h4><i class="fa-solid fa-gear" style="color:#047857; margin-right:0.35rem"></i> Hành động</h4>
                                        <div style="display:flex; gap:0.5rem; flex-wrap:wrap;">
                                            <button class="btn-media-outline" style="flex:1"><i class="fa-solid fa-download"></i> Tải xuống</button>
                                            <button class="btn-media-outline" style="flex:1; color:#dc2626; border-color:#fecaca;"><i class="fa-solid fa-trash-can"></i> Xóa</button>
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

    function selectMedia(el) {
        document.querySelectorAll('.media-card').forEach(function(c) { c.classList.remove('active'); });
        el.classList.add('active');

        document.getElementById('sidebarEmpty').style.display = 'none';
        document.getElementById('sidebarContent').style.display = 'flex';

        var d = el.dataset;
        document.getElementById('detailName').textContent = d.name;
        document.getElementById('detailSize').textContent = d.size;
        document.getElementById('detailDate').textContent = d.date;
        document.getElementById('detailType').innerHTML =
            d.type === 'VIDEO'
                ? '<span class="tag tag-blue"><i class="fa-solid fa-film"></i> Video</span>'
                : '<span class="tag tag-green"><i class="fa-solid fa-image"></i> Hình ảnh</span>';

        var dw = document.getElementById('detailDurationWrap');
        if (d.duration && d.duration !== 'null') {
            dw.style.display = 'inline';
            document.getElementById('detailDuration').textContent = d.duration;
        } else {
            dw.style.display = 'none';
        }

        document.getElementById('detailBranch').textContent = branchMap[d.branch] || '—';
        document.getElementById('detailPerson').textContent =
            (d.person && d.person !== 'null') ? personMap[d.person] : 'Không gắn cá nhân';
        document.getElementById('detailUploader').textContent = userMap[d.uploader] || '—';

        var preview = document.getElementById('previewArea');
        if (d.type === 'VIDEO') {
            preview.innerHTML = '<div style="text-align:center;padding:2rem;color:#94a3b8;">' +
                '<i class="fa-solid fa-circle-play" style="font-size:3rem;margin-bottom:0.5rem;color:#047857"></i>' +
                '<p style="font-size:0.8rem;margin:0;">Video Player Placeholder</p></div>';
        } else {
            preview.innerHTML = '<img src="' + d.url + '" alt="preview">';
        }
    }

    var dropZone = document.getElementById('dropZone');
    var fileInput = document.getElementById('fileInput');

    dropZone.addEventListener('click', function() { fileInput.click(); });
    document.getElementById('btnUpload').addEventListener('click', function() { fileInput.click(); });

    dropZone.addEventListener('dragover', function(e) { e.preventDefault(); dropZone.style.borderColor = '#047857'; dropZone.style.background = '#f0fdf4'; });
    dropZone.addEventListener('dragleave', function() { dropZone.style.borderColor = '#d6d3d1'; dropZone.style.background = '#fafaf9'; });
    dropZone.addEventListener('drop', function(e) { e.preventDefault(); dropZone.style.borderColor = '#d6d3d1'; dropZone.style.background = '#fafaf9'; alert('Đã chọn ' + e.dataTransfer.files.length + ' tập tin (placeholder)'); });
    fileInput.addEventListener('change', function() { alert('Đã chọn ' + fileInput.files.length + ' tập tin (placeholder)'); });

    document.getElementById('mediaSearch').addEventListener('input', function() {
        var keyword = this.value.toLowerCase();
        document.querySelectorAll('.media-card').forEach(function(card) {
            var name = card.dataset.name.toLowerCase();
            card.style.display = name.includes(keyword) ? '' : 'none';
        });
    });

    var firstCard = document.querySelector('.media-card');
    if (firstCard) selectMedia(firstCard);
</script>

</body>
</html>