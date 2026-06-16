function saveScores(scheduleId) {
    var rows = document.querySelectorAll('.score-row');
    var scores = [];
    rows.forEach(function(row) {
        var studentId = row.dataset.studentId;
        var regular = row.querySelector('.regular-score').value;
        var exam = row.querySelector('.exam-score').value;
        if (studentId && (regular || exam)) {
            scores.push({studentId: studentId, scheduleId: scheduleId, regularScore: regular, examScore: exam});
        }
    });
    if (scores.length === 0) {
        showMessage('请输入成绩', 'error');
        return;
    }
    var basePath = document.querySelector('meta[name="basePath"]');
    var ctx = basePath ? basePath.content : '';
    post(ctx + '/score?method=batchSave', {scores: JSON.stringify(scores), scheduleId: scheduleId}, function(res) {
        if (res && res.success) {
            showMessage(res.message || '成绩保存成功');
        } else {
            showMessage((res && res.message) || '保存失败', 'error');
        }
    }, function(err) {
        showMessage('网络错误', 'error');
    });
}

function filterBySemester(semester) {
    var rows = document.querySelectorAll('.score-row');
    rows.forEach(function(row) {
        row.style.display = (!semester || row.dataset.semester === semester) ? '' : 'none';
    });
}