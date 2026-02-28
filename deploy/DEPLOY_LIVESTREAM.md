# Deploy Livestream For Internet Access

## 1) Backend
- Deploy Spring Boot app on a public server.
- Keep app running on `127.0.0.1:8080`.
- Set profile: `spring.profiles.active=pro`.

## 2) ICE Servers (Production)
Set environment variable before starting app:

```bash
LIVESTREAM_ICE_SERVERS_JSON=[{"urls":"stun:stun.l.google.com:19302"},{"urls":"turn:turn.your-domain.com:3478","username":"turnuser","credential":"strong_turn_password"},{"urls":"turns:turn.your-domain.com:5349?transport=tcp","username":"turnuser","credential":"strong_turn_password"}]
```

## 3) Nginx
- Use `deploy/nginx/family-tree.conf`.
- Replace `your-domain.com`.
- Enable site and reload Nginx.

## 4) TURN (coturn)
- Use `deploy/coturn/turnserver.conf`.
- Replace:
  - `YOUR_SERVER_PUBLIC_IP`
  - `turn.your-domain.com`
  - `turnuser` / `strong_turn_password`
- Open firewall:
  - `3478/tcp`, `3478/udp`
  - `5349/tcp`
  - `49160-49200/udp`

## 5) Verify
- Open livestream with host on network A.
- Open viewer from 4G/network B.
- Confirm:
  - Viewer can join room.
  - Viewer can see host screen share.
  - Chat and participant list still work.
