<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@include file="/common/taglib.jsp" %>
<c:url var="homeUrl" value="/admin/home"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Livestream</title>
    <style>
        :root {
            --ls-bg: #f5f5f4;
            --ls-card: #ffffff;
            --ls-border: #e7e5e4;
            --ls-text: #0f172a;
            --ls-muted: #64748b;
            --ls-emerald: #10b981;
            --ls-emerald-dark: #047857;
            --ls-red: #ef4444;
            --ls-black: #0b0b0b;
            --ls-shadow: 0 12px 30px rgba(15, 23, 42, 0.08);
        }

        .ls-page {
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        .ls-layout {
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        .ls-left {
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        .ls-right {
            width: 100%;
        }

        @media (min-width: 1200px) {
            .ls-layout {
                flex-direction: row;
                align-items: stretch;
            }
            .ls-left {
                width: 70%;
            }
            .ls-right {
                width: 30%;
            }
        }

        .ls-card {
            background: var(--ls-card);
            border: 1px solid var(--ls-border);
            border-radius: 16px;
            box-shadow: var(--ls-shadow);
        }

        .ls-player {
            position: relative;
            aspect-ratio: 16 / 9;
            background: var(--ls-black);
            border-radius: 16px;
            overflow: hidden;
            border: 1px solid #1f2937;
        }

        .ls-player video {
            width: 100%;
            height: 100%;
            object-fit: cover;
            background: #0f172a;
        }

        .ls-player-overlay-top {
            position: absolute;
            inset: 0 0 auto 0;
            padding: 14px;
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            background: linear-gradient(180deg, rgba(0,0,0,.7) 0%, transparent 100%);
            color: #fff;
        }

        .ls-live-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 6px 10px;
            font-size: 11px;
            font-weight: 800;
            border-radius: 8px;
            text-transform: uppercase;
            letter-spacing: .08em;
            background: var(--ls-red);
            box-shadow: 0 8px 16px rgba(239,68,68,.25);
        }

        .ls-watch-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 10px;
            font-size: 12px;
            font-weight: 600;
            border-radius: 8px;
            background: rgba(0,0,0,.5);
            border: 1px solid rgba(255,255,255,.2);
        }

        .ls-player-controls {
            position: absolute;
            inset: auto 0 0 0;
            padding: 10px 14px 14px;
            background: linear-gradient(0deg, rgba(0,0,0,.85) 0%, rgba(0,0,0,.35) 60%, transparent 100%);
            color: #fff;
        }

        .ls-progress {
            height: 6px;
            background: rgba(255,255,255,.2);
            border-radius: 999px;
            position: relative;
            margin-bottom: 10px;
        }

        .ls-progress::after {
            content: "";
            position: absolute;
            inset: 0 0 0 0;
            background: var(--ls-red);
            border-radius: 999px;
        }

        .ls-controls-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
        }

        .ls-controls-left,
        .ls-controls-right {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .ls-icon-btn {
            border: 0;
            background: transparent;
            color: #fff;
            cursor: pointer;
            padding: 4px;
        }

        .ls-live-chip {
            font-family: monospace;
            font-size: 12px;
            color: #e2e8f0;
        }

        .ls-info {
            padding: 16px;
        }

        .ls-title {
            font-size: 22px;
            font-weight: 800;
            color: var(--ls-text);
            margin: 0 0 4px 0;
        }

        .ls-subtitle {
            font-size: 13px;
            color: var(--ls-muted);
            margin: 0 0 10px 0;
        }

        .ls-badges {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
            margin-bottom: 12px;
        }

        .ls-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 10px;
            font-size: 11px;
            font-weight: 700;
            border-radius: 999px;
            border: 1px solid #e2e8f0;
            background: #f8fafc;
            color: #334155;
        }

        .ls-section {
            border-top: 1px solid #f1f5f9;
            padding-top: 12px;
        }

        .ls-form {
            display: grid;
            gap: 12px;
        }

        .ls-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 12px;
        }

        .ls-label {
            font-size: 12px;
            font-weight: 700;
            color: #475569;
            text-transform: uppercase;
            letter-spacing: .05em;
            margin-bottom: 6px;
            display: block;
        }

        .ls-input,
        .ls-select {
            width: 100%;
            height: 40px;
            border-radius: 10px;
            border: 1px solid #cbd5e1;
            padding: 0 12px;
            font-size: 14px;
        }

        .ls-actions {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
            gap: 10px;
        }

        .ls-btn {
            border: 1px solid transparent;
            border-radius: 10px;
            padding: 9px 12px;
            font-weight: 700;
            cursor: pointer;
        }

        .ls-btn-primary { background: #0f172a; color: #fff; }
        .ls-btn-success { background: var(--ls-emerald); color: #fff; }
        .ls-btn-warning { background: #f59e0b; color: #1f2937; }
        .ls-btn-danger { background: #ef4444; color: #fff; }
        .ls-btn-light { background: #fff; color: #0f172a; border-color: #d1d5db; }

        .ls-status {
            font-size: 12px;
            color: #475569;
            min-height: 18px;
        }

        .ls-sidebar {
            display: flex;
            flex-direction: column;
            height: 100%;
            min-height: 520px;
            overflow: hidden;
        }

        .ls-tabs {
            display: grid;
            grid-template-columns: 1fr 1fr;
            border-bottom: 1px solid var(--ls-border);
        }

        .ls-tab {
            padding: 12px;
            text-align: center;
            font-weight: 700;
            cursor: pointer;
            color: var(--ls-muted);
            background: #fff;
            border-bottom: 2px solid transparent;
        }

        .ls-tab.active {
            color: var(--ls-emerald-dark);
            border-bottom-color: var(--ls-emerald);
            background: #ecfdf5;
        }

        .ls-chat {
            flex: 1;
            overflow-y: auto;
            padding: 12px;
            background: #fcfdfd;
        }

        .ls-chat-empty,
        .ls-participants-empty {
            color: var(--ls-muted);
            font-size: 13px;
            padding: 20px 0;
            text-align: center;
        }

        .ls-chat-input {
            border-top: 1px solid var(--ls-border);
            padding: 10px;
            display: flex;
            gap: 8px;
            align-items: center;
        }

        .ls-chat-input input {
            flex: 1;
            border-radius: 999px;
            border: 1px solid #cbd5e1;
            height: 38px;
            padding: 0 14px;
        }

        .ls-send-btn {
            border-radius: 999px;
            background: var(--ls-emerald);
            color: #fff;
            border: 0;
            width: 40px;
            height: 40px;
            cursor: pointer;
        }

        .ls-participants {
            padding: 0 0 12px 0;
            overflow-y: auto;
        }

        .ls-hidden { display: none; }
    </style>
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
            <div class="ls-page">
                <div class="ls-layout">
                    <div class="ls-left">
                        <div class="ls-card ls-player">
                            <video id="remoteVideo" autoplay playsinline controls></video>
                            <video id="localVideo" autoplay muted playsinline style="position:absolute; right:16px; bottom:16px; width:220px; height:124px; border-radius:12px; border:2px solid #fff; object-fit:cover;"></video>

                            <div class="ls-player-overlay-top">
                                <div style="display:flex; gap:10px; align-items:center;">
                                    <span class="ls-live-badge"><span style="width:8px;height:8px;background:#fff;border-radius:50%;"></span>Trực tiếp</span>
                                    <span class="ls-watch-badge">Đang xem: <span id="participantCount">1</span></span>
                                </div>
                            </div>

                            <div class="ls-player-controls">
                                <div class="ls-progress"></div>
                                <div class="ls-controls-row">
                                    <div class="ls-controls-left">
                                        <button id="btnToggleCamera" type="button" class="ls-icon-btn"><i class="fa fa-video-camera"></i></button>
                                        <button id="btnToggleMic" type="button" class="ls-icon-btn"><i class="fa fa-microphone"></i></button>
                                        <button id="btnShareScreen" type="button" class="ls-icon-btn"><i class="fa fa-desktop"></i></button>
                                        <span class="ls-live-chip"><span style="color:#ef4444;">●</span> LIVE</span>
                                    </div>
                                    <div class="ls-controls-right">
                                        <button id="btnEndLive" type="button" class="ls-icon-btn" title="Kết thúc"><i class="fa fa-stop"></i></button>
                                        <button id="btnLeaveLive" type="button" class="ls-icon-btn" title="Rời phòng"><i class="fa fa-sign-out"></i></button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="ls-card ls-info">
                            <h1 class="ls-title" id="lsDisplayTitle">Phòng livestream dòng họ</h1>
                            <p class="ls-subtitle">Buổi lễ trực tuyến dành cho thành viên trong nhánh</p>

                            <div class="ls-badges">
                                <span id="lsStatusBadge" class="ls-badge"><i class="fa fa-circle" style="color:#ef4444"></i> ENDED</span>
                                <span class="ls-badge"><i class="fa fa-lock"></i> Chỉ nội bộ</span>
                                <span class="ls-badge"><i class="fa fa-shield"></i> Bảo mật cao</span>
                            </div>

                            <div class="ls-section">
                                <div class="ls-form">
                                    <div class="ls-row">
                                        <div>
                                            <label class="ls-label">Tiêu đề</label>
                                            <input id="lsTitle" class="ls-input" placeholder="Nhập tiêu đề buổi livestream" />
                                        </div>
                                        <div>
                                            <label class="ls-label">Chi nhánh</label>
                                            <select id="lsBranchId" class="ls-select"></select>
                                        </div>
                                    </div>

                                    <div>
                                        <label class="ls-label">Liên kết phòng</label>
                                        <div style="display:flex; gap:8px;">
                                            <input id="lsRoomLink" class="ls-input" readonly placeholder="Liên kết sẽ xuất hiện sau khi bắt đầu" />
                                            <button id="btnCopyRoom" type="button" class="ls-btn ls-btn-light">Sao chép</button>
                                        </div>
                                    </div>

                                    <div class="ls-actions">
                                        <button id="btnStartLive" type="button" class="ls-btn ls-btn-success"><i class="fa fa-play"></i> Bắt đầu</button>
                                        <button id="btnWatchLive" type="button" class="ls-btn ls-btn-primary"><i class="fa fa-eye"></i> Xem phòng</button>
                                    </div>

                                    <div>
                                        <label class="ls-label">Vào phòng bằng URL</label>
                                        <div style="display:flex; gap:8px;">
                                            <input id="lsJoinUrl" class="ls-input" placeholder="Dán URL /watch?livestreamId=..." />
                                            <button id="btnJoinByUrl" type="button" class="ls-btn ls-btn-warning"><i class="fa fa-sign-in"></i> Tham gia</button>
                                        </div>
                                    </div>

                                    <div id="lsStatusText" class="ls-status"></div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="ls-right">
                        <div class="ls-card ls-sidebar">
                            <div class="ls-tabs">
                                <div id="tabChat" class="ls-tab active">Trò chuyện</div>
                                <div id="tabParticipants" class="ls-tab">Người tham gia</div>
                            </div>

                            <div id="chatPanel" class="ls-chat">
                                <div id="chatList"></div>
                                <div class="ls-chat-empty" id="chatEmpty">Chưa có tin nhắn. Hãy bắt đầu cuộc trò chuyện.</div>
                            </div>

                            <div id="participantsPanel" class="ls-chat ls-hidden">
                                <div class="ls-participants-empty">Chưa có người tham gia được tải.</div>
                                <div class="ls-participants"></div>
                            </div>

                            <div class="ls-chat-input">
                                <input id="chatInput" placeholder="Nhập tin nhắn..." />
                                <button id="btnSendChat" class="ls-send-btn"><i class="fa fa-paper-plane"></i></button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
    (function () {
        var tabChat = document.getElementById('tabChat');
        var tabParticipants = document.getElementById('tabParticipants');
        var chatPanel = document.getElementById('chatPanel');
        var participantsPanel = document.getElementById('participantsPanel');

        function activate(tab) {
            if (tab === 'chat') {
                tabChat.classList.add('active');
                tabParticipants.classList.remove('active');
                chatPanel.classList.remove('ls-hidden');
                participantsPanel.classList.add('ls-hidden');
            } else {
                tabParticipants.classList.add('active');
                tabChat.classList.remove('active');
                participantsPanel.classList.remove('ls-hidden');
                chatPanel.classList.add('ls-hidden');
            }
        }

        tabChat.addEventListener('click', function () { activate('chat'); });
        tabParticipants.addEventListener('click', function () { activate('participants'); });
    })();
</script>
<script type="text/javascript">
    var LIVE_ID = null;
    var SOCKET = null;
    var SELF_SESSION_ID = null;
    var HOST_SESSION_ID = null;
    var CAN_HOST = false;
    var LOCAL_STREAM = null;
    var SCREEN_STREAM = null;
    var IS_SHARING_SCREEN = false;
    var IS_ENDING_LIVE = false;
    var IS_LEAVING_ROOM = false;
    var CAM_ENABLED = false;
    var MIC_ENABLED = false;
    var PEERS = {};
    var PARTICIPANTS = 1;

    var RTC_CONFIG = { iceServers: [{ urls: 'stun:stun.l.google.com:19302' }] };
    var AUDIO_CONSTRAINTS = {
        echoCancellation: true,
        noiseSuppression: true,
        autoGainControl: true
    };

    function setStatusText(message, isError) {
        var el = document.getElementById('lsStatusText');
        if (!el) return;
        el.textContent = message || '';
        el.style.color = isError ? '#d9534f' : '#475569';
    }

    function setStatusBadge(status) {
        var badge = document.getElementById('lsStatusBadge');
        if (!badge) return;
        var normalized = (status || 'ENDED').toUpperCase();
        badge.innerHTML = '<i class="fa fa-circle" style="color:' + (normalized === 'LIVE' ? '#ef4444' : '#64748b') + '"></i> ' + normalized;
    }

    async function readApiError(res, fallback) {
        if (res.status === 401) {
            return 'Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.';
        }
        var text = '';
        try { text = await res.text(); } catch (e) {}
        if (!text) return fallback;
        if (text.indexOf('<html') !== -1 || text.indexOf('<!DOCTYPE') !== -1) {
            return fallback;
        }
        return text;
    }

    function setParticipantCount(count) {
        PARTICIPANTS = Math.max(1, Number(count || 1));
        var el = document.getElementById('participantCount');
        if (el) el.textContent = String(PARTICIPANTS);
    }

    function appendChatMessage(name, text, time) {
        var chatList = document.getElementById('chatList');
        var empty = document.getElementById('chatEmpty');
        if (!chatList) return;
        if (empty) empty.style.display = 'none';

        var item = document.createElement('div');
        item.style.display = 'grid';
        item.style.gridTemplateColumns = '32px 1fr';
        item.style.gap = '10px';
        item.style.marginBottom = '12px';
        item.innerHTML = '' +
            '<div style="width:32px;height:32px;border-radius:50%;background:#e2e8f0;"></div>' +
            '<div>' +
            '<div style="display:flex;gap:8px;align-items:center;margin-bottom:4px;">' +
            '<strong style="font-size:12px;color:#0f172a;">' + (name || 'Thành viên') + '</strong>' +
            '<span style="font-size:10px;color:#94a3b8;">' + (time || '') + '</span>' +
            '</div>' +
            '<div style="background:#f8fafc;border:1px solid #e2e8f0;border-radius:10px;padding:8px 10px;font-size:13px;color:#0f172a;">' +
            (text || '') +
            '</div>' +
            '</div>';
        chatList.appendChild(item);
        chatList.scrollTop = chatList.scrollHeight;
    }

    async function loadBranches() {
        try {
            var res = await fetch('/api/branch');
            if (!res.ok) return;
            var branches = await res.json();
            var select = document.getElementById('lsBranchId');
            if (!select || !Array.isArray(branches)) return;
            select.innerHTML = branches.map(function (b) {
                return '<option value="' + b.id + '">' + (b.name || ('Chi nhánh ' + b.id)) + '</option>';
            }).join('');
        } catch (e) {
            console.error('load branches failed', e);
        }
    }

    function getQueryParam(name) {
        var url = new URL(window.location.href);
        return url.searchParams.get(name);
    }

    function parseLivestreamIdFromUrl(rawUrl) {
        if (!rawUrl) return null;
        try {
            var u = new URL(rawUrl, window.location.origin);
            var id = u.searchParams.get('livestreamId');
            return id ? Number(id) : null;
        } catch (e) {
            return null;
        }
    }

    function applyLiveData(data) {
        if (!data) return;
        LIVE_ID = data.livestreamId || LIVE_ID;
        var titleEl = document.getElementById('lsDisplayTitle');
        if (titleEl) titleEl.textContent = data.title || 'Phòng livestream dòng họ';
        var roomLink = document.getElementById('lsRoomLink');
        if (roomLink && data.roomLink) roomLink.value = data.roomLink;
        if (data.branchId) {
            var branchSelect = document.getElementById('lsBranchId');
            if (branchSelect) branchSelect.value = String(data.branchId);
        }
        setStatusBadge(data.status);
    }

    async function startLiveRoom() {
        var payload = {
            title: (document.getElementById('lsTitle').value || '').trim(),
            branchId: Number(document.getElementById('lsBranchId').value || 0)
        };
        if (!payload.branchId) {
            setStatusText('Vui lòng chọn chi nhánh.', true);
            return;
        }
        var res = await fetch('/api/livestream/start', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload)
        });
        if (!res.ok) {
            throw new Error(await readApiError(res, 'Bắt đầu livestream thất bại.'));
        }
        var data = await res.json();
        applyLiveData(data);
        return data;
    }

    async function watchLiveById(id) {
        var url = '/watch';
        if (id) url += '?livestreamId=' + encodeURIComponent(id);
        var res = await fetch(url);
        if (!res.ok) throw new Error(await readApiError(res, 'Không thể xem phòng này.'));
        return await res.json();
    }

    async function endLiveById(id) {
        var res = await fetch('/api/livestream/' + encodeURIComponent(id) + '/end', { method: 'PUT' });
        if (!res.ok) throw new Error(await readApiError(res, 'Kết thúc livestream thất bại.'));
        return await res.json();
    }

    async function ensureLocalMedia() {
        if (LOCAL_STREAM) return LOCAL_STREAM;
        LOCAL_STREAM = await navigator.mediaDevices.getUserMedia({ video: true, audio: AUDIO_CONSTRAINTS });
        document.getElementById('localVideo').srcObject = LOCAL_STREAM;
        applyLocalTrackStates();
        return LOCAL_STREAM;
    }

    function applyLocalTrackStates() {
        if (!LOCAL_STREAM) return;
        LOCAL_STREAM.getVideoTracks().forEach(function (t) { t.enabled = CAM_ENABLED; });
        LOCAL_STREAM.getAudioTracks().forEach(function (t) {
            t.enabled = MIC_ENABLED;
            if (typeof t.applyConstraints === 'function') {
                t.applyConstraints(AUDIO_CONSTRAINTS).catch(function () {});
            }
        });
    }

    async function ensureCameraTrack() {
        if (!LOCAL_STREAM) {
            await ensureLocalMedia();
        }
        var current = LOCAL_STREAM.getVideoTracks().find(function (t) { return t.readyState === 'live'; });
        if (current) return current;
        var camStream = await navigator.mediaDevices.getUserMedia({ video: true, audio: false });
        var camTrack = camStream.getVideoTracks()[0];
        if (!camTrack) return null;
        LOCAL_STREAM.addTrack(camTrack);
        return camTrack;
    }

    function stopCameraTrack() {
        if (!LOCAL_STREAM) return;
        LOCAL_STREAM.getVideoTracks().forEach(function (t) {
            t.stop();
            LOCAL_STREAM.removeTrack(t);
        });
    }

    function stopLocalMedia() {
        if (!LOCAL_STREAM) return;
        LOCAL_STREAM.getTracks().forEach(function (t) { t.stop(); });
        LOCAL_STREAM = null;
        CAM_ENABLED = false;
        MIC_ENABLED = false;
        document.getElementById('localVideo').srcObject = null;
    }

    function replaceOutgoingVideoTrack(track) {
        var ids = Object.keys(PEERS);
        ids.forEach(function (sid) {
            var pc = PEERS[sid];
            if (!pc) return;
            var sender = pc.getSenders().find(function (s) {
                return s.track && s.track.kind === 'video';
            });
            if (sender) {
                sender.replaceTrack(track);
            }
        });
    }

    async function stopScreenShare(internalStop) {
        if (!IS_SHARING_SCREEN) return;
        var camTrack = LOCAL_STREAM && LOCAL_STREAM.getVideoTracks()[0];
        if (camTrack) {
            replaceOutgoingVideoTrack(camTrack);
            document.getElementById('localVideo').srcObject = LOCAL_STREAM;
        }
        if (SCREEN_STREAM) {
            SCREEN_STREAM.getTracks().forEach(function (t) { t.stop(); });
            SCREEN_STREAM = null;
        }
        IS_SHARING_SCREEN = false;
        if (!internalStop) {
            setStatusText('Đã dừng chia sẻ màn hình.', false);
        }
    }

    async function toggleScreenShare() {
        if (!CAN_HOST) {
            setStatusText('Chỉ chủ phòng mới có thể chia sẻ màn hình.', true);
            return;
        }
        await ensureLocalMedia();

        if (IS_SHARING_SCREEN) {
            await stopScreenShare(false);
            return;
        }

        SCREEN_STREAM = await navigator.mediaDevices.getDisplayMedia({ video: true, audio: false });
        var screenTrack = SCREEN_STREAM.getVideoTracks()[0];
        if (!screenTrack) {
            setStatusText('Không có track màn hình.', true);
            return;
        }

        replaceOutgoingVideoTrack(screenTrack);
        var previewStream = new MediaStream([screenTrack]);
        var micTrack = LOCAL_STREAM.getAudioTracks()[0];
        if (micTrack) previewStream.addTrack(micTrack);
        document.getElementById('localVideo').srcObject = previewStream;
        IS_SHARING_SCREEN = true;
        setStatusText('Đang chia sẻ màn hình cho người xem.', false);

        screenTrack.onended = function () {
            stopScreenShare(true);
        };
    }

    function connectSocket(livestreamId) {
        if (!livestreamId) {
            setStatusText('Không tìm thấy livestreamId.', true);
            return;
        }
        if (SOCKET && SOCKET.readyState === WebSocket.OPEN) return;

        var protocol = window.location.protocol === 'https:' ? 'wss://' : 'ws://';
        SOCKET = new WebSocket(protocol + window.location.host + '/ws/live?livestreamId=' + encodeURIComponent(livestreamId));

        SOCKET.onopen = function () {
            setStatusText('Đã kết nối realtime.', false);
        };

        SOCKET.onmessage = async function (event) {
            var msg = JSON.parse(event.data || '{}');
            var type = msg.type;

            if (type === 'welcome') {
                SELF_SESSION_ID = msg.sessionId;
                CAN_HOST = !!msg.canHost;
                HOST_SESSION_ID = msg.hostSessionId || null;
                if (CAN_HOST && !HOST_SESSION_ID) HOST_SESSION_ID = SELF_SESSION_ID;
                setStatusText('Đã vào phòng. ' + (CAN_HOST ? 'Chế độ chủ phòng.' : 'Chế độ người xem.'), false);
                return;
            }

            if (type === 'participant-joined') {
                setParticipantCount(msg.totalParticipants || (PARTICIPANTS + 1));
                if (CAN_HOST && msg.sessionId && msg.sessionId !== SELF_SESSION_ID && LOCAL_STREAM) {
                    await createOfferFor(msg.sessionId);
                }
                return;
            }

            if (type === 'participant-left') {
                setParticipantCount(msg.totalParticipants || Math.max(1, PARTICIPANTS - 1));
                var sid = msg.sessionId;
                if (sid && PEERS[sid]) {
                    PEERS[sid].close();
                    delete PEERS[sid];
                }
                return;
            }

            if (type === 'host-left') {
                HOST_SESSION_ID = null;
                setStatusText('Chủ phòng đã rời.', true);
                document.getElementById('remoteVideo').srcObject = null;
                return;
            }

            if (type === 'offer') {
                await handleOffer(msg.from, msg.payload);
                return;
            }

            if (type === 'answer') {
                await handleAnswer(msg.from, msg.payload);
                return;
            }

            if (type === 'ice') {
                await handleIce(msg.from, msg.payload);
                return;
            }

            if (type === 'chat') {
                appendChatMessage(msg.displayName || 'Thành viên', msg.text || '', msg.time || '');
            }
        };

        SOCKET.onclose = function () {
            if (IS_ENDING_LIVE) {
                setStatusText('Livestream đã kết thúc. Kết nối đóng.', false);
                IS_ENDING_LIVE = false;
            } else if (IS_LEAVING_ROOM) {
                setStatusText('Đã rời phòng.', false);
                IS_LEAVING_ROOM = false;
            } else {
                setStatusText('Mất kết nối realtime.', true);
            }
        };

        SOCKET.onerror = function () {
            setStatusText('Lỗi kết nối realtime.', true);
        };
    }

    function sendSignal(type, target, payload) {
        if (!SOCKET || SOCKET.readyState !== WebSocket.OPEN) return;
        SOCKET.send(JSON.stringify({ type: type, target: target, payload: payload || {} }));
    }

    async function createPeerConnection(peerId, asHostOfferer) {
        var pc = new RTCPeerConnection(RTC_CONFIG);
        PEERS[peerId] = pc;

        pc.onicecandidate = function (event) {
            if (event.candidate) {
                sendSignal('ice', peerId, { candidate: event.candidate });
            }
        };

        pc.ontrack = function (event) {
            if (!CAN_HOST) {
                document.getElementById('remoteVideo').srcObject = event.streams[0];
            }
        };

        if (asHostOfferer) {
            var stream = await ensureLocalMedia();
            stream.getTracks().forEach(function (track) { pc.addTrack(track, stream); });
        }

        return pc;
    }

    async function createOfferFor(viewerSessionId) {
        var pc = PEERS[viewerSessionId] || await createPeerConnection(viewerSessionId, true);
        if (IS_SHARING_SCREEN && SCREEN_STREAM && SCREEN_STREAM.getVideoTracks().length > 0) {
            replaceOutgoingVideoTrack(SCREEN_STREAM.getVideoTracks()[0]);
        }
        var offer = await pc.createOffer();
        await pc.setLocalDescription(offer);
        sendSignal('offer', viewerSessionId, { sdp: offer });
    }

    async function handleOffer(fromSessionId, payload) {
        if (CAN_HOST) return;
        HOST_SESSION_ID = fromSessionId;
        var pc = PEERS[fromSessionId] || await createPeerConnection(fromSessionId, false);
        await pc.setRemoteDescription(new RTCSessionDescription(payload.sdp));
        var answer = await pc.createAnswer();
        await pc.setLocalDescription(answer);
        sendSignal('answer', fromSessionId, { sdp: answer });
    }

    async function handleAnswer(fromSessionId, payload) {
        var pc = PEERS[fromSessionId];
        if (!pc) return;
        await pc.setRemoteDescription(new RTCSessionDescription(payload.sdp));
    }

    async function handleIce(fromSessionId, payload) {
        var pc = PEERS[fromSessionId] || PEERS[HOST_SESSION_ID];
        if (!pc || !payload || !payload.candidate) return;
        try {
            await pc.addIceCandidate(new RTCIceCandidate(payload.candidate));
        } catch (e) {
            console.error('addIceCandidate error', e);
        }
    }

    function leaveRoom() {
        IS_LEAVING_ROOM = true;
        if (SOCKET) {
            SOCKET.close();
            SOCKET = null;
        }
        Object.keys(PEERS).forEach(function (sid) {
            PEERS[sid].close();
            delete PEERS[sid];
        });
        if (IS_SHARING_SCREEN) {
            stopScreenShare(true);
        }
        stopLocalMedia();
        document.getElementById('remoteVideo').srcObject = null;
        HOST_SESSION_ID = null;
        SELF_SESSION_ID = null;
        CAN_HOST = false;
    }

    function sendChat() {
        var input = document.getElementById('chatInput');
        var text = (input.value || '').trim();
        if (!text) return;
        if (!SOCKET || SOCKET.readyState !== WebSocket.OPEN) {
            setStatusText('Vui lòng vào phòng trước khi chat.', true);
            return;
        }
        SOCKET.send(JSON.stringify({ type: 'chat', text: text }));
        input.value = '';
    }

    (function init() {
        var btnStart = document.getElementById('btnStartLive');
        var btnToggleCamera = document.getElementById('btnToggleCamera');
        var btnToggleMic = document.getElementById('btnToggleMic');
        var btnShareScreen = document.getElementById('btnShareScreen');
        var btnWatch = document.getElementById('btnWatchLive');
        var btnLeave = document.getElementById('btnLeaveLive');
        var btnJoinByUrl = document.getElementById('btnJoinByUrl');
        var btnEnd = document.getElementById('btnEndLive');
        var btnCopy = document.getElementById('btnCopyRoom');
        var btnSendChat = document.getElementById('btnSendChat');
        var chatInput = document.getElementById('chatInput');

        loadBranches();

        var roomIdFromQuery = getQueryParam('livestreamId');
        if (roomIdFromQuery) {
            watchLiveById(roomIdFromQuery)
                .then(function (data) {
                    applyLiveData(data);
                    connectSocket(data.livestreamId || roomIdFromQuery);
                    setStatusText('Đã mở phòng từ liên kết.', false);
                })
                .catch(function (e) {
                    setStatusText(e.message || 'Không thể mở phòng.', true);
                });
        }

        btnStart.addEventListener('click', async function () {
            try {
                var data = await startLiveRoom();
                connectSocket(data.livestreamId);
                setStatusText('Đã tạo livestream. Bật camera/mic để phát.', false);
            } catch (e) {
                setStatusText(e.message || 'Bắt đầu thất bại.', true);
            }
        });

        btnToggleCamera.addEventListener('click', async function () {
            try {
                if (!CAN_HOST) {
                    setStatusText('Chỉ chủ phòng có thể bật/tắt camera.', true);
                    return;
                }
                if (CAM_ENABLED) {
                    CAM_ENABLED = false;
                    stopCameraTrack();
                    if (!IS_SHARING_SCREEN) {
                        document.getElementById('localVideo').srcObject = null;
                    }
                    setStatusText('Đã tắt camera.', false);
                    return;
                }

                CAM_ENABLED = true;
                var camTrack = await ensureCameraTrack();
                if (!camTrack) {
                    CAM_ENABLED = false;
                    setStatusText('Không truy cập được camera.', true);
                    return;
                }
                replaceOutgoingVideoTrack(camTrack);
                applyLocalTrackStates();
                if (!IS_SHARING_SCREEN) {
                    document.getElementById('localVideo').srcObject = LOCAL_STREAM;
                }
                setStatusText('Đã bật camera.', false);
            } catch (e) {
                setStatusText('Không truy cập được camera.', true);
            }
        });

        btnToggleMic.addEventListener('click', async function () {
            try {
                if (!CAN_HOST) {
                    setStatusText('Chỉ chủ phòng có thể bật/tắt mic.', true);
                    return;
                }
                if (!LOCAL_STREAM) {
                    await ensureLocalMedia();
                }
                MIC_ENABLED = !MIC_ENABLED;
                applyLocalTrackStates();
                setStatusText(MIC_ENABLED ? 'Đã bật mic.' : 'Đã tắt mic.', false);
            } catch (e) {
                setStatusText('Không truy cập được mic.', true);
            }
        });

        btnWatch.addEventListener('click', async function () {
            try {
                var data = await watchLiveById(LIVE_ID);
                applyLiveData(data);
                connectSocket(data.livestreamId || LIVE_ID);
                setStatusText('Đã vào phòng.', false);
            } catch (e) {
                setStatusText(e.message || 'Không thể xem phòng này.', true);
            }
        });

        btnJoinByUrl.addEventListener('click', async function () {
            var joinUrl = (document.getElementById('lsJoinUrl').value || '').trim();
            var id = parseLivestreamIdFromUrl(joinUrl);
            if (!id) {
                setStatusText('URL livestream không hợp lệ.', true);
                return;
            }
            try {
                var data = await watchLiveById(id);
                applyLiveData(data);
                connectSocket(data.livestreamId || id);
                setStatusText('Đã vào phòng từ URL.', false);
                if (window.history && window.history.replaceState) {
                    var nextUrl = window.location.pathname + '?livestreamId=' + encodeURIComponent(id);
                    window.history.replaceState({}, '', nextUrl);
                }
            } catch (e) {
                setStatusText(e.message || 'Không thể vào phòng này.', true);
            }
        });

        btnEnd.addEventListener('click', async function () {
            if (!LIVE_ID) {
                setStatusText('Chưa chọn phiên livestream.', true);
                return;
            }
            try {
                var data = await endLiveById(LIVE_ID);
                applyLiveData(data);
                IS_ENDING_LIVE = true;
                if (SOCKET) SOCKET.close();
                Object.keys(PEERS).forEach(function (sid) { PEERS[sid].close(); delete PEERS[sid]; });
                stopScreenShare(true);
                stopLocalMedia();
                document.getElementById('remoteVideo').srcObject = null;
                setStatusText('Đã kết thúc livestream.', false);
            } catch (e) {
                setStatusText(e.message || 'Không thể kết thúc.', true);
            }
        });

        btnLeave.addEventListener('click', function () {
            leaveRoom();
        });

        btnShareScreen.addEventListener('click', async function () {
            try {
                await toggleScreenShare();
            } catch (e) {
                setStatusText('Chia sẻ màn hình thất bại.', true);
            }
        });

        btnCopy.addEventListener('click', async function () {
            var roomLink = document.getElementById('lsRoomLink').value || '';
            if (!roomLink) return;
            try {
                await navigator.clipboard.writeText(roomLink);
                setStatusText('Đã sao chép liên kết.', false);
            } catch (e) {
                setStatusText('Không thể sao chép.', true);
            }
        });

        btnSendChat.addEventListener('click', sendChat);
        chatInput.addEventListener('keydown', function (e) {
            if (e.key === 'Enter') sendChat();
        });
    })();
</script>
</body>
</html>
