<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/common/taglib.jsp" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><dec:title default="Đăng nhập" /> | Gia Phả Online</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --gpo-primary: #047857;
            --gpo-primary-hover: #065f46;
            --gpo-primary-light: #d1fae5;
            --gpo-dark: #0f172a;
            --gpo-text: #1e293b;
            --gpo-text-muted: #64748b;
            --gpo-bg-light: #fafaf9;
            --gpo-border: #e7e5e4;
        }
        * { font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif; }
        body { background: var(--gpo-bg-light); min-height: 100vh; display: flex; flex-direction: column; }
        .gpo-auth-header { padding: 1.25rem 0; }
        .gpo-auth-header a { text-decoration: none; display: flex; align-items: center; gap: 0.5rem; }
        .gpo-auth-header svg { color: var(--gpo-primary); }
        .gpo-auth-header span { font-size: 1.15rem; font-weight: 700; color: var(--gpo-text); letter-spacing: -0.02em; }
        .gpo-auth-wrapper { flex: 1; display: flex; align-items: center; justify-content: center; padding: 2rem 1rem; }
        .gpo-auth-card { background: #fff; border: 1px solid var(--gpo-border); border-radius: 1rem; box-shadow: 0 4px 24px rgba(0,0,0,0.06); padding: 2.5rem; width: 100%; max-width: 440px; }
        .gpo-auth-card h2 { font-size: 1.5rem; font-weight: 700; color: var(--gpo-text); margin-bottom: 0.25rem; }
        .gpo-auth-card .subtitle { color: var(--gpo-text-muted); font-size: 0.9rem; margin-bottom: 1.75rem; }
        .gpo-form-label { font-size: 0.85rem; font-weight: 500; color: var(--gpo-text); margin-bottom: 0.35rem; }
        .gpo-form-control { border: 1px solid var(--gpo-border); border-radius: 0.5rem; padding: 0.625rem 0.875rem; font-size: 0.9rem; transition: border-color 0.2s, box-shadow 0.2s; }
        .gpo-form-control:focus { border-color: var(--gpo-primary); box-shadow: 0 0 0 3px rgba(4,120,87,0.12); outline: none; }
        .gpo-form-control::placeholder { color: #a8a29e; }
        .btn-gpo-primary { background: var(--gpo-primary); color: #fff; border: none; border-radius: 0.5rem; padding: 0.7rem; font-size: 0.95rem; font-weight: 600; width: 100%; transition: background 0.2s, box-shadow 0.2s; }
        .btn-gpo-primary:hover { background: var(--gpo-primary-hover); color: #fff; box-shadow: 0 4px 12px rgba(4,120,87,0.25); }
        .gpo-link { color: var(--gpo-primary); text-decoration: none; font-weight: 600; font-size: 0.85rem; }
        .gpo-link:hover { text-decoration: underline; color: var(--gpo-primary-hover); }
        .gpo-divider { display: flex; align-items: center; margin: 1.5rem 0; color: var(--gpo-text-muted); font-size: 0.8rem; }
        .gpo-divider::before, .gpo-divider::after { content: ''; flex: 1; border-top: 1px solid var(--gpo-border); }
        .gpo-divider span { padding: 0 0.75rem; }
        .gpo-alert { font-size: 0.85rem; border-radius: 0.5rem; padding: 0.75rem 1rem; margin-bottom: 1.25rem; border: none; }
        .gpo-auth-footer { text-align: center; padding: 1.5rem; color: var(--gpo-text-muted); font-size: 0.8rem; }
    </style>
</head>
<body>
    <div class="container gpo-auth-header">
        <a href="/trang-chu">
            <svg width="28" height="28" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                      d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"/>
            </svg>
            <span>Gia Phả Online</span>
        </a>
    </div>
    <div class="gpo-auth-wrapper">
        <dec:body/>
    </div>
    <div class="gpo-auth-footer">
        &copy; 2025 Gia Phả Online - Bài tập nhóm ATTT
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
