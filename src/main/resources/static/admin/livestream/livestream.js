﻿(function () {
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
  var PARTICIPANT_NAMES = {};
  var PERMISSION_STORAGE_KEY = "livestream.permission.settings";
  var PERMISSIONS = { chatMode: "all", scope: "branch", security: "high" };
  var RTC_CONFIG = { iceServers: [{ urls: "stun:stun.l.google.com:19302" }] };
  var AUDIO_CONSTRAINTS = { echoCancellation: true, noiseSuppression: true, autoGainControl: true };

  function $(id) { return document.getElementById(id); }
  function escapeHtml(str) {
    return String(str || "")
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/\"/g, "&quot;")
      .replace(/'/g, "&#39;");
  }

  function setStatusText(message, isError) {
    var el = $("lsStatusText");
    if (!el) return;
    el.textContent = message || "";
    el.style.color = isError ? "#dc2626" : "#475569";
  }

  function setStatusBadge(status) {
    var badge = $("lsStatusBadge");
    if (!badge) return;
    var normalized = (status || "ENDED").toUpperCase();
    badge.classList.remove("ls-status-live", "ls-status-ended");
    badge.classList.add(normalized === "LIVE" ? "ls-status-live" : "ls-status-ended");
    badge.innerHTML = '<i class="fa fa-circle"></i> ' + normalized;
  }

  function loadPermissions() {
    try {
      var raw = localStorage.getItem(PERMISSION_STORAGE_KEY);
      if (raw) {
        var parsed = JSON.parse(raw);
        PERMISSIONS.chatMode = parsed.chatMode || "all";
        PERMISSIONS.security = parsed.security || "high";
      }
    } catch (e) {}
    PERMISSIONS.scope = "branch";
  }

  function savePermissions() {
    try {
      localStorage.setItem(PERMISSION_STORAGE_KEY, JSON.stringify(PERMISSIONS));
    } catch (e) {}
    applyPermissionToUI();
  }

  function applyPermissionToUI() {
    PERMISSIONS.scope = "branch";
    if ($("lsAccessBadge")) $("lsAccessBadge").innerHTML = '<i class="fa fa-lock"></i> Quyền truy cập: Nội bộ dòng họ (branch_id)';
    if ($("lsSecurityBadge")) $("lsSecurityBadge").innerHTML = '<i class="fa fa-shield"></i> Chế độ bảo mật ' + (PERMISSIONS.security === "high" ? "cao" : "tiêu chuẩn");
  }

  function openPermissionModal() {
    $("permChatMode").value = PERMISSIONS.chatMode;
    $("permScope").value = "branch";
    $("permSecurity").value = PERMISSIONS.security;
    if (window.jQuery && window.jQuery.fn && window.jQuery.fn.modal) window.jQuery("#permissionModal").modal("show");
  }

  function closePermissionModal() {
    if (window.jQuery && window.jQuery.fn && window.jQuery.fn.modal) window.jQuery("#permissionModal").modal("hide");
  }

  function canCurrentUserChat() {
    if (PERMISSIONS.chatMode === "off") return false;
    return !(PERMISSIONS.chatMode === "host" && !CAN_HOST);
  }

  function setParticipantCount(count) {
    PARTICIPANTS = Math.max(1, Number(count || 1));
    if ($("participantCount")) $("participantCount").textContent = String(PARTICIPANTS);
  }

  function renderParticipants() {
    var listEl = $("participantsList");
    var emptyEl = $("participantsEmpty");
    if (!listEl || !emptyEl) return;
    var ids = Object.keys(PARTICIPANT_NAMES);
    if (!ids.length) {
      listEl.innerHTML = "";
      emptyEl.style.display = "block";
      return;
    }
    emptyEl.style.display = "none";
    listEl.innerHTML = ids.map(function (sid) {
      var name = escapeHtml(PARTICIPANT_NAMES[sid] || "Thành viên");
      var initials = name.split(" ").filter(Boolean).slice(-2).map(function (v) { return v.charAt(0); }).join("").toUpperCase();
      var isHost = HOST_SESSION_ID && sid === HOST_SESSION_ID;
      return '<div class="ls-participant-item"><div class="ls-participant-left"><span class="ls-participant-avatar">' +
        (initials || "TV") + '</span><span class="ls-participant-name">' + name +
        '</span></div><div class="ls-participant-meta"><span class="ls-online-dot"></span><span class="ls-role-tag ' +
        (isHost ? "host" : "member") + '">' + (isHost ? "Host" : "Member") + "</span></div></div>";
    }).join("");
  }

  function appendChatMessage(name, text, time, isHost) {
    var chatList = $("chatList");
    var emptyEl = $("chatEmpty");
    if (!chatList) return;
    if (emptyEl) emptyEl.style.display = "none";
    var safeName = escapeHtml(name || "Thành viên");
    var initials = safeName.split(" ").filter(Boolean).slice(-2).map(function (v) { return v.charAt(0); }).join("").toUpperCase();
    var role = isHost ? '<span class="ls-chat-role">ADMIN</span>' : '';
    var item = document.createElement("div");
    item.className = "ls-chat-item";
    item.innerHTML = '<div class="ls-chat-avatar">' + (initials || "TV") + '</div><div class="ls-chat-body"><div class="ls-chat-head"><span class="ls-chat-name ' +
      (isHost ? "host" : "") + '">' + safeName + '</span>' + role + '<span class="ls-chat-time">' + escapeHtml(time || "") +
      '</span></div><div class="ls-chat-bubble">' + escapeHtml(text || "") + "</div></div>";
    chatList.appendChild(item);
    chatList.scrollTop = chatList.scrollHeight;
  }

  async function readApiError(res, fallback) {
    if (res.status === 401) return "Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.";
    var text = "";
    try { text = await res.text(); } catch (e) {}
    if (!text) return fallback;
    if (text.indexOf("<html") !== -1 || text.indexOf("<!DOCTYPE") !== -1) return fallback;
    return text;
  }

  async function loadBranches() {
    try {
      var res = await fetch("/api/branch");
      if (!res.ok) return;
      var branches = await res.json();
      var select = $("lsBranchId");
      if (!select || !Array.isArray(branches)) return;
      select.innerHTML = branches.map(function (b) { return '<option value="' + b.id + '">' + (b.name || ("Chi nhánh " + b.id)) + "</option>"; }).join("");
    } catch (e) {}
  }

  function getQueryParam(name) { return new URLSearchParams(window.location.search).get(name); }

  function parseLivestreamIdFromUrl(rawUrl) {
    if (!rawUrl) return null;
    try {
      var u = new URL(rawUrl, window.location.origin);
      var id = u.searchParams.get("livestreamId");
      return id ? Number(id) : null;
    } catch (e) { return null; }
  }

  function applyLiveData(data) {
    if (!data) return;
    LIVE_ID = data.livestreamId || LIVE_ID;
    $("lsDisplayTitle").textContent = data.title || "Phòng livestream";
    $("lsTitle").value = data.title || "";
    if (data.branchId) $("lsBranchId").value = String(data.branchId);
    if (data.roomLink) {
      var fullLink = /^https?:\/\//i.test(data.roomLink) ? data.roomLink : (window.location.origin + data.roomLink);
      $("lsRoomLink").value = fullLink;
      $("lsJoinUrl").value = fullLink;
    }
    setStatusBadge(data.status);
  }

  async function startLiveRoom() {
    var payload = { title: ($("lsTitle").value || "").trim(), branchId: Number($("lsBranchId").value || 0) };
    if (!payload.branchId) { setStatusText("Vui lòng chọn chi nhánh.", true); return; }
    var res = await fetch("/api/livestream/start", { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify(payload) });
    if (!res.ok) throw new Error(await readApiError(res, "Bắt đầu livestream thất bại."));
    var data = await res.json();
    applyLiveData(data);
    return data;
  }

  async function watchLiveById(id) {
    var url = "/api/livestream/watch";
    if (id) url += "?livestreamId=" + encodeURIComponent(id);
    var res = await fetch(url);
    if (!res.ok) throw new Error(await readApiError(res, "Không thể xem phòng này."));
    return await res.json();
  }

  async function loadCurrentLive() {
    var res = await fetch("/api/livestream/live");
    if (!res.ok) throw new Error(await readApiError(res, "Không có livestream đang hoạt động."));
    return await res.json();
  }

  async function endLiveById(id) {
    var res = await fetch("/api/livestream/" + encodeURIComponent(id) + "/end", { method: "PUT" });
    if (!res.ok) throw new Error(await readApiError(res, "Kết thúc livestream thất bại."));
    return await res.json();
  }

  async function ensureLocalMedia() {
    if (LOCAL_STREAM) return LOCAL_STREAM;
    LOCAL_STREAM = await navigator.mediaDevices.getUserMedia({ video: true, audio: AUDIO_CONSTRAINTS });
    $("localVideo").srcObject = LOCAL_STREAM;
    applyLocalTrackStates();
    updateMediaButtons();
    return LOCAL_STREAM;
  }

  function applyLocalTrackStates() {
    if (!LOCAL_STREAM) return;
    LOCAL_STREAM.getVideoTracks().forEach(function (t) { t.enabled = CAM_ENABLED; });
    LOCAL_STREAM.getAudioTracks().forEach(function (t) { t.enabled = MIC_ENABLED; });
  }

  async function ensureCameraTrack() {
    if (!LOCAL_STREAM) await ensureLocalMedia();
    var current = LOCAL_STREAM.getVideoTracks().find(function (t) { return t.readyState === "live"; });
    if (current) return current;
    var camStream = await navigator.mediaDevices.getUserMedia({ video: true, audio: false });
    var camTrack = camStream.getVideoTracks()[0];
    if (!camTrack) return null;
    LOCAL_STREAM.addTrack(camTrack);
    return camTrack;
  }

  function stopCameraTrack() {
    if (!LOCAL_STREAM) return;
    LOCAL_STREAM.getVideoTracks().forEach(function (t) { t.stop(); LOCAL_STREAM.removeTrack(t); });
  }

  function updateMediaButtons() {
    if ($("btnToggleCamera")) $("btnToggleCamera").classList.toggle("active", CAM_ENABLED);
    if ($("btnToggleMic")) $("btnToggleMic").classList.toggle("active", MIC_ENABLED);
  }

  function stopLocalMedia() {
    if (!LOCAL_STREAM) return;
    LOCAL_STREAM.getTracks().forEach(function (t) { t.stop(); });
    LOCAL_STREAM = null;
    CAM_ENABLED = false;
    MIC_ENABLED = false;
    $("localVideo").srcObject = null;
    updateMediaButtons();
  }

  function replaceOutgoingVideoTrack(track) {
    Object.keys(PEERS).forEach(function (sid) {
      var pc = PEERS[sid];
      if (!pc) return;
      var sender = pc.getSenders().find(function (s) { return s.track && s.track.kind === "video"; });
      if (sender) sender.replaceTrack(track);
    });
  }

  async function stopScreenShare(internalStop) {
    if (!IS_SHARING_SCREEN) return;
    var camTrack = LOCAL_STREAM && LOCAL_STREAM.getVideoTracks()[0];
    if (camTrack) {
      replaceOutgoingVideoTrack(camTrack);
      $("localVideo").srcObject = LOCAL_STREAM;
    }
    if (SCREEN_STREAM) {
      SCREEN_STREAM.getTracks().forEach(function (t) { t.stop(); });
      SCREEN_STREAM = null;
    }
    IS_SHARING_SCREEN = false;
    $("btnShareScreen").classList.remove("active");
    if (!internalStop) setStatusText("Đã dừng chia sẻ màn hình.", false);
  }

  async function toggleScreenShare() {
    if (!CAN_HOST) { setStatusText("Chỉ chủ phòng mới có thể chia sẻ màn hình.", true); return; }
    await ensureLocalMedia();
    if (IS_SHARING_SCREEN) { await stopScreenShare(false); return; }
    SCREEN_STREAM = await navigator.mediaDevices.getDisplayMedia({ video: true, audio: false });
    var screenTrack = SCREEN_STREAM.getVideoTracks()[0];
    if (!screenTrack) { setStatusText("Không có track màn hình.", true); return; }
    replaceOutgoingVideoTrack(screenTrack);
    var previewStream = new MediaStream([screenTrack]);
    var micTrack = LOCAL_STREAM.getAudioTracks()[0];
    if (micTrack) previewStream.addTrack(micTrack);
    $("localVideo").srcObject = previewStream;
    IS_SHARING_SCREEN = true;
    $("btnShareScreen").classList.add("active");
    setStatusText("Đang chia sẻ màn hình.", false);
    screenTrack.onended = function () { stopScreenShare(true); };
  }

  function sendSignal(type, target, payload) {
    if (!SOCKET || SOCKET.readyState !== WebSocket.OPEN) return;
    SOCKET.send(JSON.stringify({ type: type, target: target, payload: payload || {} }));
  }

  async function createPeerConnection(peerId, asHostOfferer) {
    var pc = new RTCPeerConnection(RTC_CONFIG);
    PEERS[peerId] = pc;
    pc.onicecandidate = function (event) { if (event.candidate) sendSignal("ice", peerId, { candidate: event.candidate }); };
    pc.ontrack = function (event) { if (!CAN_HOST) $("remoteVideo").srcObject = event.streams[0]; };
    if (asHostOfferer) {
      var stream = await ensureLocalMedia();
      stream.getTracks().forEach(function (track) { pc.addTrack(track, stream); });
    }
    return pc;
  }

  async function createOfferFor(viewerSessionId) {
    var pc = PEERS[viewerSessionId] || await createPeerConnection(viewerSessionId, true);
    if (IS_SHARING_SCREEN && SCREEN_STREAM && SCREEN_STREAM.getVideoTracks().length > 0) replaceOutgoingVideoTrack(SCREEN_STREAM.getVideoTracks()[0]);
    var offer = await pc.createOffer();
    await pc.setLocalDescription(offer);
    sendSignal("offer", viewerSessionId, { sdp: offer });
  }

  async function handleOffer(fromSessionId, payload) {
    if (CAN_HOST) return;
    HOST_SESSION_ID = fromSessionId;
    if (!PARTICIPANT_NAMES[fromSessionId]) PARTICIPANT_NAMES[fromSessionId] = "Chủ phòng";
    renderParticipants();
    var pc = PEERS[fromSessionId] || await createPeerConnection(fromSessionId, false);
    await pc.setRemoteDescription(new RTCSessionDescription(payload.sdp));
    var answer = await pc.createAnswer();
    await pc.setLocalDescription(answer);
    sendSignal("answer", fromSessionId, { sdp: answer });
  }

  async function handleAnswer(fromSessionId, payload) {
    var pc = PEERS[fromSessionId];
    if (!pc) return;
    await pc.setRemoteDescription(new RTCSessionDescription(payload.sdp));
  }

  async function handleIce(fromSessionId, payload) {
    var pc = PEERS[fromSessionId] || PEERS[HOST_SESSION_ID];
    if (!pc || !payload || !payload.candidate) return;
    try { await pc.addIceCandidate(new RTCIceCandidate(payload.candidate)); } catch (e) {}
  }

  function connectSocket(livestreamId) {
    if (!livestreamId) { setStatusText("Không tìm thấy livestreamId.", true); return; }
    if (SOCKET && SOCKET.readyState === WebSocket.OPEN) return;
    var protocol = window.location.protocol === "https:" ? "wss://" : "ws://";
    SOCKET = new WebSocket(protocol + window.location.host + "/ws/live?livestreamId=" + encodeURIComponent(livestreamId));

    SOCKET.onopen = function () { setStatusText("Đã kết nối realtime.", false); };
    SOCKET.onmessage = async function (event) {
      var msg = JSON.parse(event.data || "{}");
      var type = msg.type;
      if (type === "welcome") {
        SELF_SESSION_ID = msg.sessionId;
        CAN_HOST = !!msg.canHost;
        HOST_SESSION_ID = msg.hostSessionId || null;
        if (CAN_HOST && !HOST_SESSION_ID) HOST_SESSION_ID = SELF_SESSION_ID;
        PARTICIPANT_NAMES[SELF_SESSION_ID] = msg.displayName || "Bạn";
        renderParticipants();
        setStatusText("Đã vào phòng. " + (CAN_HOST ? "Chế độ chủ phòng." : "Chế độ người xem."), false);
        return;
      }
      if (type === "participant-joined") {
        if (msg.sessionId) PARTICIPANT_NAMES[msg.sessionId] = msg.displayName || "Thành viên";
        setParticipantCount(msg.totalParticipants || (PARTICIPANTS + 1));
        renderParticipants();
        if (CAN_HOST && msg.sessionId && msg.sessionId !== SELF_SESSION_ID && LOCAL_STREAM) await createOfferFor(msg.sessionId);
        return;
      }
      if (type === "participant-left") {
        if (msg.sessionId && PARTICIPANT_NAMES[msg.sessionId]) delete PARTICIPANT_NAMES[msg.sessionId];
        setParticipantCount(msg.totalParticipants || Math.max(1, PARTICIPANTS - 1));
        renderParticipants();
        var sid = msg.sessionId;
        if (sid && PEERS[sid]) { PEERS[sid].close(); delete PEERS[sid]; }
        return;
      }
      if (type === "host-left") {
        HOST_SESSION_ID = null;
        renderParticipants();
        setStatusText("Chủ phòng đã rời.", true);
        $("remoteVideo").srcObject = null;
        return;
      }
      if (type === "offer") { await handleOffer(msg.from, msg.payload); return; }
      if (type === "answer") { await handleAnswer(msg.from, msg.payload); return; }
      if (type === "ice") { await handleIce(msg.from, msg.payload); return; }
      if (type === "chat") appendChatMessage(msg.displayName || "Thành viên", msg.text || "", msg.time || "", !!(HOST_SESSION_ID && msg.sessionId === HOST_SESSION_ID));
    };
    SOCKET.onclose = function () {
      if (IS_ENDING_LIVE) { setStatusText("Livestream đã kết thúc. Kết nối realtime đóng.", false); IS_ENDING_LIVE = false; }
      else if (IS_LEAVING_ROOM) { setStatusText("Đã rời phòng livestream.", false); IS_LEAVING_ROOM = false; }
      else setStatusText("Mất kết nối realtime.", true);
    };
    SOCKET.onerror = function () { setStatusText("Lỗi kết nối realtime.", true); };
  }

  function leaveRoom() {
    IS_LEAVING_ROOM = true;
    if (SOCKET) { SOCKET.close(); SOCKET = null; }
    Object.keys(PEERS).forEach(function (sid) { PEERS[sid].close(); delete PEERS[sid]; });
    if (IS_SHARING_SCREEN) stopScreenShare(true);
    stopLocalMedia();
    $("remoteVideo").srcObject = null;
    HOST_SESSION_ID = null;
    SELF_SESSION_ID = null;
    CAN_HOST = false;
    PARTICIPANT_NAMES = {};
    renderParticipants();
    updateMediaButtons();
  }

  function sendChat() {
    var input = $("chatInput");
    var text = (input.value || "").trim();
    if (!text) return;
    if (!canCurrentUserChat()) {
      if (PERMISSIONS.chatMode === "off") setStatusText("Chat đã bị tắt bởi cài đặt phân quyền.", true);
      else setStatusText("Chỉ chủ phòng mới được chat theo cài đặt hiện tại.", true);
      return;
    }
    if (!SOCKET || SOCKET.readyState !== WebSocket.OPEN) { setStatusText("Vui lòng vào phòng trước khi chat.", true); return; }
    SOCKET.send(JSON.stringify({ type: "chat", text: text }));
    input.value = "";
  }

  function initTabs() {
    $("tabChat").addEventListener("click", function () {
      $("tabChat").classList.add("active");
      $("tabParticipants").classList.remove("active");
      $("chatPanel").classList.remove("ls-hidden");
      $("participantsPanel").classList.add("ls-hidden");
    });
    $("tabParticipants").addEventListener("click", function () {
      $("tabParticipants").classList.add("active");
      $("tabChat").classList.remove("active");
      $("participantsPanel").classList.remove("ls-hidden");
      $("chatPanel").classList.add("ls-hidden");
    });
  }

  (async function init() {
    initTabs();
    loadPermissions();
    applyPermissionToUI();
    await loadBranches();
    updateMediaButtons();
    renderParticipants();

    $("btnOpenPermission").addEventListener("click", openPermissionModal);
    $("btnClosePermission").addEventListener("click", closePermissionModal);
    $("btnCancelPermission").addEventListener("click", closePermissionModal);
    $("btnSavePermission").addEventListener("click", function () {
      PERMISSIONS.chatMode = $("permChatMode").value;
      PERMISSIONS.scope = "branch";
      PERMISSIONS.security = $("permSecurity").value;
      savePermissions();
      closePermissionModal();
      setStatusText("Đã lưu cài đặt phân quyền.", false);
    });

    var roomIdFromQuery = getQueryParam("livestreamId");
    if (roomIdFromQuery) {
      try {
        var dataFromQuery = await watchLiveById(roomIdFromQuery);
        applyLiveData(dataFromQuery);
        connectSocket(dataFromQuery.livestreamId || roomIdFromQuery);
      } catch (e) {
        setStatusText(e.message || "Không thể mở phòng.", true);
      }
    }

    $("btnStartLive").addEventListener("click", async function () {
      try {
        var data = await startLiveRoom();
        connectSocket(data.livestreamId);
        setStatusText("Đã tạo livestream.", false);
      } catch (e) {
        setStatusText(e.message || "Bắt đầu livestream thất bại.", true);
      }
    });

    $("btnWatchLive").addEventListener("click", async function () {
      try {
        var data = await watchLiveById(LIVE_ID);
        applyLiveData(data);
        connectSocket(data.livestreamId || LIVE_ID);
      } catch (e) {
        setStatusText(e.message || "Không thể xem phòng này.", true);
      }
    });

    $("btnLoadCurrentLive").addEventListener("click", async function () {
      try {
        var current = await loadCurrentLive();
        applyLiveData(current);
        connectSocket(current.livestreamId);
      } catch (e) {
        setStatusText(e.message || "Không có livestream đang hoạt động.", true);
      }
    });

    $("btnJoinByUrl").addEventListener("click", async function () {
      var joinUrl = ($("lsJoinUrl").value || "").trim();
      var id = parseLivestreamIdFromUrl(joinUrl);
      if (!id) { setStatusText("URL livestream không hợp lệ.", true); return; }
      try {
        var data = await watchLiveById(id);
        applyLiveData(data);
        connectSocket(data.livestreamId || id);
      } catch (e) {
        setStatusText(e.message || "Không thể vào phòng theo URL.", true);
      }
    });

    $("btnToggleCamera").addEventListener("click", async function () {
      try {
        if (!CAN_HOST) { setStatusText("Chỉ chủ phòng có thể điều khiển camera/mic.", true); return; }
        if (CAM_ENABLED) {
          CAM_ENABLED = false;
          stopCameraTrack();
          if (!IS_SHARING_SCREEN) $("localVideo").srcObject = null;
          updateMediaButtons();
          return;
        }
        CAM_ENABLED = true;
        var camTrack = await ensureCameraTrack();
        if (!camTrack) { CAM_ENABLED = false; updateMediaButtons(); return; }
        replaceOutgoingVideoTrack(camTrack);
        applyLocalTrackStates();
        if (!IS_SHARING_SCREEN) $("localVideo").srcObject = LOCAL_STREAM;
        updateMediaButtons();
      } catch (e) { setStatusText("Không truy cập được camera.", true); }
    });

    $("btnToggleMic").addEventListener("click", async function () {
      try {
        if (!CAN_HOST) { setStatusText("Chỉ chủ phòng có thể điều khiển camera/mic.", true); return; }
        if (!LOCAL_STREAM) await ensureLocalMedia();
        MIC_ENABLED = !MIC_ENABLED;
        applyLocalTrackStates();
        updateMediaButtons();
      } catch (e) { setStatusText("Không truy cập được mic.", true); }
    });

    $("btnShareScreen").addEventListener("click", async function () {
      try { await toggleScreenShare(); } catch (e) { setStatusText("Chia sẻ màn hình thất bại.", true); }
    });

    $("btnEndLive").addEventListener("click", async function () {
      if (!LIVE_ID) { setStatusText("Chưa chọn phiên livestream.", true); return; }
      try {
        var endData = await endLiveById(LIVE_ID);
        applyLiveData(endData);
        IS_ENDING_LIVE = true;
        if (SOCKET) SOCKET.close();
        Object.keys(PEERS).forEach(function (sid) { PEERS[sid].close(); delete PEERS[sid]; });
        stopScreenShare(true);
        stopLocalMedia();
        $("remoteVideo").srcObject = null;
      } catch (e) { setStatusText(e.message || "Không thể kết thúc livestream.", true); }
    });

    $("btnLeaveLive").addEventListener("click", leaveRoom);

    $("btnCopyRoom").addEventListener("click", async function () {
      var roomLink = $("lsRoomLink").value || "";
      if (!roomLink) return;
      try { await navigator.clipboard.writeText(roomLink); setStatusText("Đã sao chép liên kết phòng.", false); }
      catch (e) { setStatusText("Không thể sao chép liên kết phòng.", true); }
    });

    $("btnSendChat").addEventListener("click", sendChat);
    $("chatInput").addEventListener("keydown", function (e) { if (e.key === "Enter") sendChat(); });
  })();
})();
