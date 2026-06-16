function checkTimeConflict(timeSlot, scheduleId) {
    const rows = document.querySelectorAll('.schedule-row');
    for (let row of rows) {
        if (row.dataset.timeSlot === timeSlot && row.dataset.scheduleId !== scheduleId) {
            alert('时间冲突：该时段已有课程安排');
            return true;
        }
    }
    return false;
}

function renderScheduleTable(schedules, container) {
    const days = ['周一', '周二', '周三', '周四', '周五'];
    const periods = ['第1-2节', '第3-4节', '第5-6节', '第7-8节', '第9-10节'];
    let html = '<div class="schedule-grid">';
    html += '<div class="cell header">时间</div>';
    days.forEach(d => html += '<div class="cell header">' + d + '</div>');
    periods.forEach((p, pi) => {
        html += '<div class="cell time-header">' + p + '</div>';
        days.forEach((d, di) => {
            const slot = schedules.find(s => {
                const parts = s.timeSlot.split('-');
                return parseInt(parts[0]) === di + 1 && parseInt(parts[1]) === pi + 1;
            });
            html += '<div class="cell">' + (slot ? '<b>' + slot.courseName + '</b><br>' + slot.classroom : '') + '</div>';
        });
    });
    html += '</div>';
    container.innerHTML = html;
}