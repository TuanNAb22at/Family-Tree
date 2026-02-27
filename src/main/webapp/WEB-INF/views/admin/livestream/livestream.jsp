<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@include file="/common/taglib.jsp" %>
<c:url var="homeUrl" value="/admin/home"/>
<c:url var="livestreamCssUrl" value="/admin/livestream/livestream.css"/>
<c:url var="livestreamJsUrl" value="/admin/livestream/livestream.js"/>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Livestream</title>
    <link rel="stylesheet" href="${livestreamCssUrl}">
</head>
<body>
<div class="main-content">
    <div class="main-content-inner">
        <div class="breadcrumbs" id="breadcrumbs">
            <script type="text/javascript">
                try { ace.settings.check('breadcrumbs', 'fixed') } catch (e) {}
            </script>
            <ul class="breadcrumb">
                <li>
                    <i class="ace-icon fa-solid fa-house-chimney home-icon"></i>
                    <a href="${homeUrl}">Trang quản trị</a>
                </li>
                <li class="active">Livestream</li>
            </ul>
        </div>

        <div class="page-content">
            <div class="ls-layout">
                <div class="ls-left">
                    <div class="ls-card ls-player">
                        <video id="remoteVideo" autoplay playsinline controls poster="https://images.unsplash.com/photo-1511895426328-dc8714191300?auto=format&fit=crop&w=1600&q=80"></video>
                        <video id="localVideo" autoplay muted playsinline></video>

                        <div class="ls-player-overlay-top">
                            <div class="ls-overlay-left">
                                <span class="ls-live-badge"><span class="ls-dot"></span>TRỰC TIẾP</span>
                                <span class="ls-watch-badge"><i class="fa fa-eye"></i><span id="participantCount">256</span> Đang xem</span>
                            </div>
                        </div>

                        <div class="ls-player-controls">
                            <div class="ls-progress"></div>
                            <div class="ls-controls-row">
                                <div class="ls-controls-left">
                                    <button id="btnToggleCamera" type="button" class="ls-icon-btn" title="Camera"><i class="fa fa-video-camera"></i></button>
                                    <button id="btnToggleMic" type="button" class="ls-icon-btn" title="Micro"><i class="fa fa-microphone"></i></button>
                                    <button id="btnShareScreen" type="button" class="ls-icon-btn" title="Chia sẻ màn hình"><i class="fa fa-desktop"></i></button>
                                    <span class="ls-live-chip"><span class="ls-dot-red">●</span> LIVE</span>
                                </div>
                                <div class="ls-controls-right">
                                    <button id="btnEndLive" type="button" class="ls-icon-btn" title="Kết thúc"><i class="fa fa-stop"></i></button>
                                    <button id="btnLeaveLive" type="button" class="ls-icon-btn" title="Rời phòng"><i class="fa fa-sign-out"></i></button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="ls-card ls-info">
                        <div class="ls-info-head">
                            <div>
                                <h1 id="lsDisplayTitle" class="ls-title">Lễ Giỗ Tổ Dòng Họ Nguyễn - Năm 2026</h1>
                                <p class="ls-subtitle">Bắt đầu lúc 09:00 - Chủ Nhật, 22/02/2026</p>
                            </div>
                            <button id="btnOpenPermission" type="button" class="ls-permission-btn"><i class="fa fa-cog"></i> Cài đặt phân quyền</button>
                        </div>

                        <div class="ls-badges">
                            <span id="lsStatusBadge" class="ls-badge ls-badge-status ls-status-ended"><i class="fa fa-circle"></i> ENDED</span>
                            <span id="lsAccessBadge" class="ls-badge ls-badge-access"><i class="fa fa-lock"></i> Quyền truy cập: Nội bộ dòng họ</span>
                            <span id="lsSecurityBadge" class="ls-badge ls-badge-security"><i class="fa fa-shield"></i> Chế độ bảo mật cao</span>
                        </div>

                        <hr class="ls-divider"/>
                        <p class="ls-summary">Chào mừng quý bà con cô bác, anh chị em trong dòng họ đã tham gia buổi lễ trực tuyến. Đây là dịp để con cháu tề tựu, tưởng nhớ công ơn tổ tiên và gắn kết tình thân. Video sẽ được lưu lại trong thư viện Media sau khi kết thúc.</p>

                        <div class="ls-config-form">
                            <div class="ls-row">
                                <div>
                                    <label class="ls-label" for="lsTitle">Tiêu đề</label>
                                    <input id="lsTitle" class="ls-input" placeholder="Nhập tiêu đề livestream"/>
                                </div>
                                <div>
                                    <label class="ls-label" for="lsBranchId">Chi nhánh</label>
                                    <select id="lsBranchId" class="ls-select"></select>
                                </div>
                            </div>

                            <div>
                                <label class="ls-label" for="lsRoomLink">Liên kết phòng</label>
                                <div class="ls-inline-group">
                                    <input id="lsRoomLink" class="ls-input" readonly placeholder="Liên kết sẽ xuất hiện sau khi bắt đầu"/>
                                    <button id="btnCopyRoom" type="button" class="ls-btn ls-btn-light">Sao chép</button>
                                </div>
                            </div>

                            <div class="ls-actions">
                                <button id="btnStartLive" type="button" class="ls-btn ls-btn-success"><i class="fa fa-play"></i> Bắt đầu</button>
                                <button id="btnWatchLive" type="button" class="ls-btn ls-btn-primary"><i class="fa fa-eye"></i> Xem phòng</button>
                                <button id="btnLoadCurrentLive" type="button" class="ls-btn ls-btn-light"><i class="fa fa-rss"></i> Phòng đang live</button>
                            </div>

                            <div>
                                <label class="ls-label" for="lsJoinUrl">Vào phòng bằng URL</label>
                                <div class="ls-inline-group">
                                    <input id="lsJoinUrl" class="ls-input" placeholder="/admin/livestream?livestreamId=..."/>
                                    <button id="btnJoinByUrl" type="button" class="ls-btn ls-btn-warning"><i class="fa fa-sign-in"></i> Tham gia</button>
                                </div>
                            </div>

                            <div id="lsStatusText" class="ls-status"></div>
                        </div>
                    </div>
                </div>

                <div class="ls-right">
                    <div class="ls-card ls-sidebar">
                        <div class="ls-tabs">
                            <button id="tabChat" type="button" class="ls-tab active"><i class="fa fa-comment-o"></i> Trò chuyện</button>
                            <button id="tabParticipants" type="button" class="ls-tab"><i class="fa fa-users"></i> Người tham gia</button>
                        </div>

                        <div id="chatPanel" class="ls-chat-panel">
                            <div id="chatList" class="ls-chat-list"></div>
                            <div id="chatEmpty" class="ls-chat-empty">Chưa có tin nhắn. Hãy bắt đầu cuộc trò chuyện.</div>
                        </div>

                        <div id="participantsPanel" class="ls-participants-panel ls-hidden">
                            <div id="participantsEmpty" class="ls-chat-empty">Chưa có người tham gia.</div>
                            <div id="participantsList" class="ls-participants-list"></div>
                        </div>

                        <div class="ls-composer">
                            <div class="ls-composer-row">
                                <input id="chatInput" class="ls-composer-input" placeholder="Nhập tin nhắn..."/>
                                <button id="btnSendChat" type="button" class="ls-send-btn"><i class="fa fa-paper-plane"></i></button>
                            </div>
                            <div class="ls-composer-foot">
                                <div class="ls-composer-icons">
                                    <i class="fa fa-smile-o"></i>
                                    <i class="fa fa-heart-o"></i>
                                </div>
                                <span>Nhấn Enter để gửi</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div id="permissionModal" class="modal fade" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog modal-md" role="document">
        <div class="modal-content ls-modal-content">
            <div class="modal-header">
                <button id="btnClosePermission" type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">Cài đặt phân quyền livestream</h4>
            </div>
            <div class="modal-body">
                <div class="ls-modal-group">
                    <label class="ls-label" for="permChatMode">Quyền chat</label>
                    <select id="permChatMode" class="ls-select">
                        <option value="all">Tất cả người tham gia</option>
                        <option value="host">Chỉ chủ phòng</option>
                        <option value="off">Tắt chat</option>
                    </select>
                </div>
                <div class="ls-modal-group">
                    <label class="ls-label" for="permScope">Phạm vi truy cập</label>
                    <select id="permScope" class="ls-select" disabled>
                        <option value="branch">Nội bộ dòng họ (branch_id)</option>
                    </select>
                </div>
                <div class="ls-modal-group">
                    <label class="ls-label" for="permSecurity">Mức bảo mật</label>
                    <select id="permSecurity" class="ls-select">
                        <option value="high">Cao</option>
                        <option value="normal">Tiêu chuẩn</option>
                    </select>
                </div>
            </div>
            <div class="modal-footer">
                <button id="btnCancelPermission" type="button" class="btn btn-default" data-dismiss="modal">Hủy</button>
                <button id="btnSavePermission" type="button" class="btn btn-primary">Lưu cài đặt</button>
            </div>
        </div>
    </div>
</div>

<script src="${livestreamJsUrl}"></script>
</body>
</html>
