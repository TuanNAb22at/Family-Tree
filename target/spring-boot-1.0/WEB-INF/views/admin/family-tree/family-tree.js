(function () {
    const btn = document.getElementById('btnCreateFirst');
    if (!btn) return;

    btn.addEventListener('click', function () {
        // Mở modal
        if (window.ftUi && typeof window.ftUi.openModal === 'function') {
            window.ftUi.openModal('memberModal');
        }

        // Set tiêu đề (đúng id là modalTitle)
        const title = document.getElementById('modalTitle');
        if (title) title.textContent = 'Tạo thành viên đầu tiên';

        // Reset fields
        const setVal = (id, v) => {
            const el = document.getElementById(id);
            if (el) el.value = v;
        };

        setVal('mFullname', '');
        setVal('mDob', '');
        setVal('mDod', '');
        setVal('mGeneration', '1');

        // Default giới tính
        const gMale = document.getElementById('gMale');
        if (gMale) gMale.checked = true;

        // Focus
        const fullname = document.getElementById('mFullname');
        if (fullname) fullname.focus();
    });
})();