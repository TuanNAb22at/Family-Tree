package com.javaweb.websocket;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.javaweb.entity.LivestreamEntity;
import com.javaweb.entity.PersonEntity;
import com.javaweb.entity.UserEntity;
import com.javaweb.repository.LivestreamRepository;
import com.javaweb.repository.PersonRepository;
import com.javaweb.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import java.io.IOException;
import java.net.URI;
import java.security.Principal;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.Map;
import java.util.Optional;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class LiveWebSocketHandler extends TextWebSocketHandler {

    private static final Integer STATUS_LIVE = 1;
    private static final DateTimeFormatter TIME_FMT = DateTimeFormatter.ofPattern("HH:mm");

    private final ObjectMapper objectMapper = new ObjectMapper();

    @Autowired
    private LivestreamRepository livestreamRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PersonRepository personRepository;

    private final Map<Long, RoomState> rooms = new ConcurrentHashMap<>();
    private final Map<String, SessionMeta> sessionIndex = new ConcurrentHashMap<>();

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        Principal principal = session.getPrincipal();
        if (principal == null || principal.getName() == null) {
            session.close(CloseStatus.NOT_ACCEPTABLE.withReason("Unauthenticated"));
            return;
        }

        Long livestreamId = parseLivestreamId(session.getUri());
        if (livestreamId == null) {
            session.close(CloseStatus.BAD_DATA.withReason("livestreamId is required"));
            return;
        }

        UserEntity user = userRepository.findOneByUserName(principal.getName());
        if (user == null) {
            session.close(CloseStatus.NOT_ACCEPTABLE.withReason("User not found"));
            return;
        }

        Optional<PersonEntity> personOpt = personRepository.findByUserId(user.getId());
        if (!personOpt.isPresent() || personOpt.get().getBranch() == null) {
            session.close(CloseStatus.NOT_ACCEPTABLE.withReason("User has no branch mapping"));
            return;
        }
        Long viewerBranchId = personOpt.get().getBranch().getId();

        LivestreamEntity livestream = livestreamRepository.findByIdAndStatus(livestreamId, STATUS_LIVE).orElse(null);
        if (livestream == null || livestream.getBranch() == null) {
            session.close(CloseStatus.NOT_ACCEPTABLE.withReason("Livestream not found or not live"));
            return;
        }

        if (!viewerBranchId.equals(livestream.getBranch().getId())) {
            session.close(CloseStatus.NOT_ACCEPTABLE.withReason("Access denied by branch"));
            return;
        }

        boolean canHost = livestream.getHost() != null && livestream.getHost().getId().equals(user.getId());

        RoomState room = rooms.computeIfAbsent(livestreamId, id -> new RoomState());
        SessionMeta meta = new SessionMeta(livestreamId, user.getId(), user.getFullName(), canHost);
        sessionIndex.put(session.getId(), meta);
        room.sessions.put(session.getId(), session);
        room.members.put(session.getId(), meta);
        if (canHost) {
            room.hostSessionId = session.getId();
        }

        send(session, json()
                .put("type", "welcome")
                .put("sessionId", session.getId())
                .put("livestreamId", livestreamId)
                .put("canHost", canHost)
                .put("hostSessionId", room.hostSessionId)
                .put("displayName", safeName(meta.displayName))
                .toString());

        broadcast(room, json()
                .put("type", "participant-joined")
                .put("sessionId", session.getId())
                .put("displayName", safeName(meta.displayName))
                .put("totalParticipants", room.sessions.size())
                .toString(), session.getId());
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        SessionMeta senderMeta = sessionIndex.get(session.getId());
        if (senderMeta == null) {
            return;
        }
        RoomState room = rooms.get(senderMeta.livestreamId);
        if (room == null) {
            return;
        }

        JsonNode node = objectMapper.readTree(message.getPayload());
        String type = text(node, "type");

        if ("offer".equals(type) || "answer".equals(type) || "ice".equals(type)) {
            relaySignal(room, session, node, type);
            return;
        }

        if ("chat".equals(type)) {
            String content = text(node, "text");
            if (content == null || content.trim().isEmpty()) {
                return;
            }
            String now = LocalTime.now().format(TIME_FMT);
            broadcast(room, json()
                    .put("type", "chat")
                    .put("sessionId", session.getId())
                    .put("displayName", safeName(senderMeta.displayName))
                    .put("text", content.trim())
                    .put("time", now)
                    .toString(), null);
        }
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        SessionMeta meta = sessionIndex.remove(session.getId());
        if (meta == null) {
            return;
        }
        RoomState room = rooms.get(meta.livestreamId);
        if (room == null) {
            return;
        }

        room.sessions.remove(session.getId());
        room.members.remove(session.getId());
        if (session.getId().equals(room.hostSessionId)) {
            room.hostSessionId = null;
            broadcast(room, json().put("type", "host-left").toString(), null);
        }
        broadcast(room, json()
                .put("type", "participant-left")
                .put("sessionId", session.getId())
                .put("totalParticipants", room.sessions.size())
                .toString(), null);

        if (room.sessions.isEmpty()) {
            rooms.remove(meta.livestreamId);
        }
    }

    private void relaySignal(RoomState room, WebSocketSession sender, JsonNode node, String type) throws IOException {
        String target = text(node, "target");
        if (target == null || !room.sessions.containsKey(target)) {
            return;
        }
        WebSocketSession targetSession = room.sessions.get(target);
        if (targetSession == null || !targetSession.isOpen()) {
            return;
        }

        JsonNode payload = node.get("payload");
        com.fasterxml.jackson.databind.node.ObjectNode signal = json()
                .put("type", type)
                .put("from", sender.getId());
        signal.set("payload", payload == null ? objectMapper.createObjectNode() : payload);
        send(targetSession, signal.toString());
    }

    private Long parseLivestreamId(URI uri) {
        if (uri == null || uri.getQuery() == null) {
            return null;
        }
        String[] pairs = uri.getQuery().split("&");
        for (String pair : pairs) {
            String[] kv = pair.split("=", 2);
            if (kv.length == 2 && "livestreamId".equals(kv[0])) {
                try {
                    return Long.parseLong(kv[1]);
                } catch (NumberFormatException ignored) {
                    return null;
                }
            }
        }
        return null;
    }

    private com.fasterxml.jackson.databind.node.ObjectNode json() {
        return objectMapper.createObjectNode();
    }

    private String text(JsonNode node, String field) {
        JsonNode value = node.get(field);
        return value != null && !value.isNull() ? value.asText() : null;
    }

    private String safeName(String name) {
        if (name == null || name.trim().isEmpty()) {
            return "Unknown";
        }
        return name.trim();
    }

    private void send(WebSocketSession session, String payload) throws IOException {
        if (session != null && session.isOpen()) {
            session.sendMessage(new TextMessage(payload));
        }
    }

    private void broadcast(RoomState room, String payload, String exceptSessionId) throws IOException {
        for (Map.Entry<String, WebSocketSession> entry : room.sessions.entrySet()) {
            if (exceptSessionId != null && exceptSessionId.equals(entry.getKey())) {
                continue;
            }
            send(entry.getValue(), payload);
        }
    }

    private static class RoomState {
        private final Map<String, WebSocketSession> sessions = new ConcurrentHashMap<>();
        private final Map<String, SessionMeta> members = new ConcurrentHashMap<>();
        private volatile String hostSessionId;
    }

    private static class SessionMeta {
        private final Long livestreamId;
        private final Long userId;
        private final String displayName;
        private final boolean canHost;

        private SessionMeta(Long livestreamId, Long userId, String displayName, boolean canHost) {
            this.livestreamId = livestreamId;
            this.userId = userId;
            this.displayName = displayName;
            this.canHost = canHost;
        }
    }
}
