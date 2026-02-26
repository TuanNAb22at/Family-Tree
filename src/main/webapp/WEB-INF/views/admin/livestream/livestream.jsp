<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@include file="/common/taglib.jsp" %>
<c:url var="homeUrl" value="/admin/home"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Live Stream Realtime</title>
    <style>
        :root {
            --live-bg: #f8fafc;
            --live-card: #ffffff;
            --live-line: #e2e8f0;
            --live-text: #0f172a;
            --live-muted: #64748b;
            --live-primary: #0f172a;
            --live-info: #0369a1;
            --live-red: #dc2626;
            --live-red-soft: #fee2e2;
            --live-shadow: 0 12px 34px rgba(15, 23, 42, 0.08);
        }

        .page-content {
            background: linear-gradient(180deg, #f8fafc 0%, #f1f5f9 100%);
            border-radius: 14px;
            padding: 14px;
        }

        .live-layout {
            display: grid;
            grid-template-columns: minmax(0, 1fr) 360px;
            gap: 14px;
            align-items: start;
        }

        .live-main-card,
        .live-side-card {
            border: 1px solid var(--live-line);
            border-radius: 14px;
            background: var(--live-card);
            box-shadow: var(--live-shadow);
        }

        .live-main-card {
            padding: 14px;
        }

        .live-player-wrap {
            width: 100%;
            aspect-ratio: 16 / 9;
            border-radius: 12px;
            overflow: hidden;
            border: 1px solid #0f172a;
            background: #020617;
            margin-bottom: 12px;
            position: relative;
        }

        .live-player-wrap::before {
            content: "LIVE";
            position: absolute;
            top: 14px;
            left: 14px;
            border-radius: 999px;
            padding: 6px 12px;
            font-size: 11px;
            font-weight: 800;
            color: #fff;
            background: rgba(220, 38, 38, 0.9);
            z-index: 3;
            letter-spacing: .08em;
        }

        .live-player-wrap video {
            width: 100%;
            height: 100%;
            object-fit: cover;
            background: #020617;
        }

        .player-controls {
            position: absolute;
            left: 12px;
            right: 12px;
            bottom: 12px;
            z-index: 5;
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            align-items: center;
            padding: 8px;
            border-radius: 10px;
            background: rgba(15, 23, 42, 0.72);
            backdrop-filter: blur(2px);
        }

        .player-controls .btn {
            border-radius: 999px;
            padding: 6px 12px;
            font-weight: 700;
        }

        .local-preview {
            position: absolute;
            right: 12px;
            bottom: 12px;
            width: 220px;
            height: 124px;
            border: 2px solid #fff;
            border-radius: 10px;
            overflow: hidden;
            background: #0f172a;
            box-shadow: 0 16px 40px rgba(0, 0, 0, .35);
            z-index: 4;
        }

        .local-preview video {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .live-title {
            margin: 2px 0 0;
            font-size: 28px;
            font-weight: 800;
            color: var(--live-text);
            line-height: 1.2;
            letter-spacing: -0.015em;
        }

        .live-meta-row {
            display: flex;
            justify-content: space-between;
            gap: 10px;
            flex-wrap: wrap;
            margin-top: 4px;
        }

        .live-subtitle {
            color: var(--live-muted);
            font-size: 13px;
        }

        .live-badges {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
            margin: 10px 0 2px;
        }

        .live-badge {
            border-radius: 999px;
            padding: 6px 11px;
            font-size: 12px;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            border: 1px solid transparent;
        }

        .live-badge.live {
            background: var(--live-red-soft);
            border-color: #fecaca;
            color: #991b1b;
        }

        .live-badge.ended {
            background: #f1f5f9;
            border-color: #dbe4ee;
            color: #334155;
        }

        .live-badge.scope {
            background: #fff;
            border-color: #d1d5db;
            color: #334155;
        }

        .live-form {
            margin-top: 12px;
            border-top: 1px solid #edf2f7;
            padding-top: 12px;
        }

        .control-block {
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 12px;
            background: #ffffff;
            margin-bottom: 10px;
        }

        .control-title {
            font-size: 12px;
            font-weight: 800;
            color: #334155;
            text-transform: uppercase;
            letter-spacing: .05em;
            margin-bottom: 8px;
        }

        .live-form .form-group {
            margin-bottom: 11px;
        }

        .live-form label {
            font-size: 12px;
            letter-spacing: .04em;
            text-transform: uppercase;
            font-weight: 700;
            color: #475569;
            margin-bottom: 6px;
            display: block;
        }

        .form-control {
            border-radius: 10px;
            border: 1px solid #cbd5e1;
            height: 40px;
        }

        .form-control:focus {
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, .15);
        }

        .live-actions {
            margin: 7px 0 10px;
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 8px;
        }

        .live-actions .btn {
            border-radius: 10px;
            font-weight: 700;
            border: 1px solid transparent;
            box-shadow: 0 1px 1px rgba(0, 0, 0, .05);
            padding: 8px 10px;
            text-align: left;
        }

        .btn-success { background: #16a34a; border-color: #16a34a; }
        .btn-warning { background: #f59e0b; border-color: #f59e0b; color: #1f2937; }
        .btn-primary { background: var(--live-primary); border-color: var(--live-primary); }
        .btn-danger { background: #dc2626; border-color: #dc2626; }
        .btn-default, .btn-white { border-color: #d1d5db; background: #fff; color: #1f2937; }
        .btn-info { background: #0284c7; border-color: #0284c7; }

        .room-link-wrap,
        .join-url-wrap {
            display: flex;
            gap: 8px;
        }

        .muted-note {
            font-size: 12px;
            color: var(--live-muted);
            margin-top: 6px;
        }

        .live-status {
            min-height: 20px;
            margin-top: 6px;
            color: var(--live-info);
            font-weight: 700;
        }

        .live-side-card {
            padding: 0;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            min-height: 680px;
            position: sticky;
            top: 12px;
        }

        .live-side-head {
            padding: 12px;
            border-bottom: 1px solid var(--live-line);
            background: linear-gradient(180deg, #ffffff 0%, #f8fafc 100%);
            font-weight: 800;
            color: #0f172a;
        }

        .live-side-tabs {
            display: grid;
            grid-template-columns: 1fr 1fr;
            border-bottom: 1px solid var(--live-line);
        }

        .live-side-tabs div {
            padding: 12px;
            text-align: center;
            font-weight: 800;
            color: #64748b;
            border-bottom: 2px solid transparent;
            cursor: default;
        }

        .live-side-tabs .active {
            color: #0f172a;
            border-bottom-color: #0f172a;
            background: #fff;
        }

        .chat-list {
            padding: 12px;
            overflow: auto;
            flex: 1;
            background: #fcfdff;
        }

        .chat-item {
            display: grid;
            grid-template-columns: 34px 1fr;
            gap: 10px;
            margin-bottom: 12px;
        }

        .chat-avatar {
            width: 34px;
            height: 34px;
            border-radius: 50%;
            background: linear-gradient(135deg, #94a3b8, #cbd5e1);
            flex-shrink: 0;
        }

        .chat-bubble {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 10px;
        }

        .chat-name {
            font-weight: 800;
            color: #0f172a;
            margin-bottom: 4px;
            font-size: 13px;
        }

        .chat-time {
            color: #64748b;
            font-size: 12px;
            margin-left: 6px;
        }

        .chat-input-wrap {
            border-top: 1px solid var(--live-line);
            padding: 10px;
            display: flex;
            gap: 8px;
            background: #fff;
        }

        .chat-input-wrap input {
            flex: 1;
            border-radius: 999px;
            border: 1px solid #cbd5e1;
            height: 40px;
            padding: 0 14px;
        }

        .chat-input-wrap .btn {
            border-radius: 999px;
            min-width: 82px;
        }

        @media (max-width: 1300px) {
            .live-layout {
                grid-template-columns: minmax(0, 1fr);
            }

            .live-side-card {
                position: static;
                min-height: 430px;
            }
        }

        @media (max-width: 768px) {
            .page-content {
                padding: 10px;
            }

            .live-title {
                font-size: 24px;
            }

            .local-preview {
                width: 150px;
                height: 84px;
            }

            .player-controls {
                left: 8px;
                right: 8px;
                bottom: 8px;
                padding: 6px;
                gap: 6px;
            }

            .room-link-wrap,
            .join-url-wrap {
                flex-direction: column;
            }

            .room-link-wrap .btn,
            .join-url-wrap .btn {
                width: 100%;
            }

            .live-actions {
                grid-template-columns: 1fr;
            }
        }
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
                    <i class="ace-icon fa fa-home home-icon"></i>
                    <a href="${homeUrl}">Trang ch&#7911;</a>
                </li>
                <li class="active">Live Stream</li>
            </ul>
        </div>

        <div class="page-content">
            <div class="row">
                <div class="col-xs-12">
                    <div class="live-layout">
                        <div class="live-main-card">
                            <div class="live-player-wrap">
                                <video id="remoteVideo" autoplay playsinline controls></video>
                                <div class="local-preview">
                                    <video id="localVideo" autoplay muted playsinline></video>
                                </div>
                                <div class="player-controls">
                                    <button id="btnToggleCamera" type="button" class="btn btn-warning"><i class="fa fa-video-camera"></i> Turn on camera</button>
                                    <button id="btnToggleMic" type="button" class="btn btn-default"><i class="fa fa-microphone"></i> Turn on mic</button>
                                    <button id="btnShareScreen" type="button" class="btn btn-default"><i class="fa fa-desktop"></i> Share screen</button>
                                    <button id="btnEndLive" type="button" class="btn btn-danger"><i class="fa fa-stop"></i> End live</button>
                                    <button id="btnLeaveLive" type="button" class="btn btn-white"><i class="fa fa-sign-out"></i> Leave live</button>
                                </div>
                            </div>

                            <h3 class="live-title" id="lsDisplayTitle">Family Live Room</h3>
                            <div class="live-meta-row">
                                <div class="live-subtitle">Realtime livestream and chat for branch members</div>
                            </div>

                            <div class="live-badges">
                                <span id="lsStatusBadge" class="live-badge ended"><i class="fa fa-circle"></i> ENDED</span>
                                <span class="live-badge scope"><i class="fa fa-lock"></i> Branch-based access</span>
                                <span class="live-badge scope"><i class="fa fa-users"></i> <span id="participantCount">1</span> participants</span>
                            </div>

                            <div class="live-form">
                                <div class="control-block">
                                    <div class="control-title">Room Information</div>
                                    <div class="row">
                                        <div class="col-sm-6">
                                            <div class="form-group">
                                                <label>Title</label>
                                                <input id="lsTitle" class="form-control" placeholder="Live title"/>
                                            </div>
                                        </div>
                                        <div class="col-sm-6">
                                            <div class="form-group">
                                                <label>Branch</label>
                                                <select id="lsBranchId" class="form-control"></select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label>Room link</label>
                                        <div class="room-link-wrap">
                                            <input id="lsRoomLink" class="form-control" readonly placeholder="Room link will appear after Start live"/>
                                            <button id="btnCopyRoom" type="button" class="btn btn-white">Copy</button>
                                        </div>
                                        <div class="muted-note">Host creates room, then shares this link for viewers to join.</div>
                                    </div>
                                </div>

                                <div class="control-block">
                                    <div class="control-title">Host Controls</div>
                                    <div class="live-actions">
                                        <button id="btnStartLive" type="button" class="btn btn-success"><i class="fa fa-play"></i> Start live</button>
                                    </div>
                                </div>

                                <div class="control-block">
                                    <div class="control-title">Join Room</div>
                                    <div class="form-group">
                                        <label>Join by livestream URL</label>
                                        <div class="join-url-wrap">
                                            <input id="lsJoinUrl" class="form-control" placeholder="Paste /watch?livestreamId=... URL"/>
                                            <button id="btnJoinByUrl" type="button" class="btn btn-info"><i class="fa fa-sign-in"></i> Join URL</button>
                                        </div>
                                    </div>
                                    <div class="live-actions" style="margin-bottom:0;">
                                        <button id="btnWatchLive" type="button" class="btn btn-primary"><i class="fa fa-eye"></i> Join/watch</button>
                                    </div>
                                </div>
                                <div id="lsStatusText" class="live-status"></div>
                            </div>
                        </div>

                        <div class="live-side-card">
                            <div class="live-side-head">Live Interaction</div>
                            <div class="live-side-tabs">
                                <div class="active">Chat</div>
                                <div>Participants</div>
                            </div>
                            <div id="chatList" class="chat-list"></div>
                            <div class="chat-input-wrap">
                                <input id="chatInput" class="form-control" placeholder="Type message..."/>
                                <button id="btnSendChat" type="button" class="btn btn-primary">Send</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

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
        badge.className = 'live-badge ' + (normalized === 'LIVE' ? 'live' : 'ended');
        badge.innerHTML = '<i class="fa fa-circle"></i> ' + normalized;
    }

    async function readApiError(res, fallback) {
        if (res.status === 401) {
            return 'Session expired. Please login again.';
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
        document.getElementById('participantCount').textContent = String(PARTICIPANTS);
    }

    function appendChatMessage(name, text, time) {
        var chatList = document.getElementById('chatList');
        if (!chatList) return;
        var item = document.createElement('div');
        item.className = 'chat-item';
        item.innerHTML = '' +
            '<div class="chat-avatar"></div>' +
            '<div class="chat-bubble">' +
                '<div class="chat-name">' + escapeHtml(name || 'User') + ' <span class="chat-time">' + escapeHtml(time || '') + '</span></div>' +
                '<div>' + escapeHtml(text || '') + '</div>' +
            '</div>';
        chatList.appendChild(item);
        chatList.scrollTop = chatList.scrollHeight;
    }

    function escapeHtml(str) {
        return String(str || '')
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#39;');
    }

    async function loadBranches() {
        try {
            var res = await fetch('/api/branch');
            if (!res.ok) return;
            var branches = await res.json();
            var select = document.getElementById('lsBranchId');
            if (!select || !Array.isArray(branches)) return;
            select.innerHTML = branches.map(function (b) {
                return '<option value="' + b.id + '">' + (b.name || ('Branch ' + b.id)) + '</option>';
            }).join('');
        } catch (e) {
            console.error('load branches failed', e);
        }
    }

    function getQueryParam(name) {
        var params = new URLSearchParams(window.location.search);
        return params.get(name);
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
        document.getElementById('lsDisplayTitle').textContent = data.title || 'Family Live Room';
        document.getElementById('lsTitle').value = data.title || '';
        if (data.branchId) document.getElementById('lsBranchId').value = String(data.branchId);
        if (data.roomLink) {
            var fullLink = window.location.origin + data.roomLink;
            document.getElementById('lsRoomLink').value = fullLink;
            document.getElementById('lsJoinUrl').value = fullLink;
        }
        setStatusBadge(data.status);
    }

    async function startLiveRoom() {
        var payload = {
            title: (document.getElementById('lsTitle').value || '').trim(),
            branchId: Number(document.getElementById('lsBranchId').value || 0)
        };
        if (!payload.branchId) {
            setStatusText('Please choose branch.', true);
            return;
        }
        var res = await fetch('/api/livestream/start', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload)
        });
        if (!res.ok) {
            throw new Error(await readApiError(res, 'Start live failed.'));
        }
        var data = await res.json();
        applyLiveData(data);
        return data;
    }

    async function watchLiveById(id) {
        var url = '/watch';
        if (id) url += '?livestreamId=' + encodeURIComponent(id);
        var res = await fetch(url);
        if (!res.ok) throw new Error(await readApiError(res, 'Cannot watch this room.'));
        return await res.json();
    }

    async function endLiveById(id) {
        var res = await fetch('/api/livestream/' + encodeURIComponent(id) + '/end', { method: 'PUT' });
        if (!res.ok) throw new Error(await readApiError(res, 'End live failed.'));
        return await res.json();
    }

    async function ensureLocalMedia() {
        if (LOCAL_STREAM) return LOCAL_STREAM;
        LOCAL_STREAM = await navigator.mediaDevices.getUserMedia({ video: true, audio: AUDIO_CONSTRAINTS });
        document.getElementById('localVideo').srcObject = LOCAL_STREAM;
        applyLocalTrackStates();
        updateMediaButtons();
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

    function updateMediaButtons() {
        var camBtn = document.getElementById('btnToggleCamera');
        var micBtn = document.getElementById('btnToggleMic');
        if (camBtn) {
            camBtn.innerHTML = CAM_ENABLED
                ? '<i class="fa fa-video-camera"></i> Turn off camera'
                : '<i class="fa fa-video-camera"></i> Turn on camera';
        }
        if (micBtn) {
            micBtn.innerHTML = MIC_ENABLED
                ? '<i class="fa fa-microphone"></i> Turn off mic'
                : '<i class="fa fa-microphone"></i> Turn on mic';
        }
    }

    function stopLocalMedia() {
        if (!LOCAL_STREAM) return;
        LOCAL_STREAM.getTracks().forEach(function (t) { t.stop(); });
        LOCAL_STREAM = null;
        CAM_ENABLED = false;
        MIC_ENABLED = false;
        document.getElementById('localVideo').srcObject = null;
        updateMediaButtons();
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
        var btn = document.getElementById('btnShareScreen');
        if (btn) btn.innerHTML = '<i class="fa fa-desktop"></i> Share screen';
        if (!internalStop) {
            setStatusText('Stopped sharing screen.', false);
        }
    }

    async function toggleScreenShare() {
        if (!CAN_HOST) {
            setStatusText('Only host can share screen.', true);
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
            setStatusText('No screen track available.', true);
            return;
        }

        replaceOutgoingVideoTrack(screenTrack);
        var previewStream = new MediaStream([screenTrack]);
        var micTrack = LOCAL_STREAM.getAudioTracks()[0];
        if (micTrack) previewStream.addTrack(micTrack);
        document.getElementById('localVideo').srcObject = previewStream;
        IS_SHARING_SCREEN = true;
        var btn = document.getElementById('btnShareScreen');
        if (btn) btn.innerHTML = '<i class="fa fa-times"></i> Stop share';
        setStatusText('Sharing screen to all viewers.', false);

        screenTrack.onended = function () {
            stopScreenShare(true);
        };
    }

    function connectSocket(livestreamId) {
        if (!livestreamId) {
            setStatusText('No livestreamId found.', true);
            return;
        }
        if (SOCKET && SOCKET.readyState === WebSocket.OPEN) return;

        var protocol = window.location.protocol === 'https:' ? 'wss://' : 'ws://';
        SOCKET = new WebSocket(protocol + window.location.host + '/ws/live?livestreamId=' + encodeURIComponent(livestreamId));

        SOCKET.onopen = function () {
            setStatusText('Realtime socket connected.', false);
        };

        SOCKET.onmessage = async function (event) {
            var msg = JSON.parse(event.data || '{}');
            var type = msg.type;

            if (type === 'welcome') {
                SELF_SESSION_ID = msg.sessionId;
                CAN_HOST = !!msg.canHost;
                HOST_SESSION_ID = msg.hostSessionId || null;
                if (CAN_HOST && !HOST_SESSION_ID) HOST_SESSION_ID = SELF_SESSION_ID;
                setStatusText('Joined room. ' + (CAN_HOST ? 'Host' : 'Viewer') + ' mode.', false);
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
                setStatusText('Host left room.', true);
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
                appendChatMessage(msg.displayName || 'User', msg.text || '', msg.time || '');
            }
        };

        SOCKET.onclose = function () {
            if (IS_ENDING_LIVE) {
                setStatusText('Live ended. Realtime socket closed.', false);
                IS_ENDING_LIVE = false;
            } else if (IS_LEAVING_ROOM) {
                setStatusText('Left livestream room.', false);
                IS_LEAVING_ROOM = false;
            } else {
                setStatusText('Realtime socket disconnected.', true);
            }
        };

        SOCKET.onerror = function () {
            setStatusText('Socket error.', true);
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
        updateMediaButtons();
    }

    function sendChat() {
        var input = document.getElementById('chatInput');
        var text = (input.value || '').trim();
        if (!text) return;
        if (!SOCKET || SOCKET.readyState !== WebSocket.OPEN) {
            setStatusText('Join room before chatting.', true);
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
        updateMediaButtons();
        appendChatMessage('System', 'Realtime chat initialized.', '');

        var roomIdFromQuery = getQueryParam('livestreamId');
        if (roomIdFromQuery) {
            watchLiveById(roomIdFromQuery)
                .then(function (data) {
                    applyLiveData(data);
                    connectSocket(data.livestreamId || roomIdFromQuery);
                    setStatusText('Room opened from link.', false);
                })
                .catch(function (e) {
                    setStatusText(e.message || 'Cannot open room.', true);
                });
        }

        btnStart.addEventListener('click', async function () {
            try {
                var data = await startLiveRoom();
                connectSocket(data.livestreamId);
                setStatusText('Livestream created. Now enable camera/mic to publish.', false);
            } catch (e) {
                setStatusText(e.message || 'Start live failed.', true);
            }
        });

        btnToggleCamera.addEventListener('click', async function () {
            try {
                if (!CAN_HOST) {
                    setStatusText('Only host can control camera/mic.', true);
                    return;
                }
                if (CAM_ENABLED) {
                    CAM_ENABLED = false;
                    stopCameraTrack();
                    if (!IS_SHARING_SCREEN) {
                        document.getElementById('localVideo').srcObject = null;
                    }
                    updateMediaButtons();
                    setStatusText('Camera turned off.', false);
                    return;
                }

                CAM_ENABLED = true;
                var camTrack = await ensureCameraTrack();
                if (!camTrack) {
                    CAM_ENABLED = false;
                    updateMediaButtons();
                    setStatusText('Cannot access camera track.', true);
                    return;
                }
                replaceOutgoingVideoTrack(camTrack);
                applyLocalTrackStates();
                if (!IS_SHARING_SCREEN) {
                    document.getElementById('localVideo').srcObject = LOCAL_STREAM;
                }
                updateMediaButtons();
                setStatusText('Camera turned on.', false);
            } catch (e) {
                setStatusText('Cannot access camera: ' + (e.message || ''), true);
            }
        });

        btnToggleMic.addEventListener('click', async function () {
            try {
                if (!CAN_HOST) {
                    setStatusText('Only host can control camera/mic.', true);
                    return;
                }
                if (!LOCAL_STREAM) {
                    await ensureLocalMedia();
                }
                MIC_ENABLED = !MIC_ENABLED;
                applyLocalTrackStates();
                updateMediaButtons();
                setStatusText(MIC_ENABLED ? 'Mic turned on.' : 'Mic turned off.', false);
            } catch (e) {
                setStatusText('Cannot access mic: ' + (e.message || ''), true);
            }
        });

        btnWatch.addEventListener('click', async function () {
            try {
                var data = await watchLiveById(LIVE_ID);
                applyLiveData(data);
                connectSocket(data.livestreamId || LIVE_ID);
                setStatusText('Joined live room.', false);
            } catch (e) {
                setStatusText(e.message || 'Not allowed to watch this room.', true);
            }
        });

        btnJoinByUrl.addEventListener('click', async function () {
            var joinUrl = (document.getElementById('lsJoinUrl').value || '').trim();
            var id = parseLivestreamIdFromUrl(joinUrl);
            if (!id) {
                setStatusText('Invalid livestream URL.', true);
                return;
            }
            try {
                var data = await watchLiveById(id);
                applyLiveData(data);
                connectSocket(data.livestreamId || id);
                setStatusText('Joined room from URL.', false);
                if (window.history && window.history.replaceState) {
                    var nextUrl = window.location.pathname + '?livestreamId=' + encodeURIComponent(id);
                    window.history.replaceState({}, '', nextUrl);
                }
            } catch (e) {
                setStatusText(e.message || 'Cannot join this room URL.', true);
            }
        });

        btnEnd.addEventListener('click', async function () {
            if (!LIVE_ID) {
                setStatusText('No live session selected.', true);
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
                updateMediaButtons();
                setStatusText('Live ended.', false);
            } catch (e) {
                setStatusText(e.message || 'End live failed.', true);
            }
        });

        btnLeave.addEventListener('click', function () {
            leaveRoom();
        });

        btnShareScreen.addEventListener('click', async function () {
            try {
                await toggleScreenShare();
            } catch (e) {
                setStatusText('Share screen failed: ' + (e.message || ''), true);
            }
        });

        btnCopy.addEventListener('click', async function () {
            var roomLink = document.getElementById('lsRoomLink').value || '';
            if (!roomLink) return;
            try {
                await navigator.clipboard.writeText(roomLink);
                setStatusText('Room link copied.', false);
            } catch (e) {
                setStatusText('Cannot copy room link.', true);
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

