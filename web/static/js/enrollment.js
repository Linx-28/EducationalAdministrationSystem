function addToCart(scheduleId) {
    var basePath = document.querySelector('meta[name="basePath"]');
    var ctx = basePath ? basePath.content : '';
    post(ctx + '/enrollment?method=enroll&scheduleId=' + scheduleId, null, function(res) {
        if (res && res.success) {
            showMessage('选课成功');
            setTimeout(function() { location.reload(); }, 1000);
        } else {
            showMessage((res && res.message) || '选课失败', 'error');
        }
    }, function(err) {
        showMessage('网络错误', 'error');
    });
}

function cancelEnroll(scheduleId) {
    if (!confirm('确定要退选此课程吗？')) return;
    var basePath = document.querySelector('meta[name="basePath"]');
    var ctx = basePath ? basePath.content : '';
    post(ctx + '/enrollment?method=cancelEnroll&scheduleId=' + scheduleId, null, function(res) {
        if (res && res.success) {
            showMessage('退选成功');
            setTimeout(function() { location.reload(); }, 1000);
        } else {
            showMessage((res && res.message) || '退选失败', 'error');
        }
    }, function(err) {
        showMessage('网络错误', 'error');
    });
}

function cancelEnrollCourse(courseId) {
    if (!confirm('确定要退选该课程的所有时间段吗？')) return;
    var basePath = document.querySelector('meta[name="basePath"]');
    var ctx = basePath ? basePath.content : '';
    post(ctx + '/enrollment?method=cancelEnrollCourse&courseId=' + courseId, null, function(res) {
        if (res && res.success) {
            showMessage('退选成功');
            setTimeout(function() { location.reload(); }, 1000);
        } else {
            showMessage((res && res.message) || '退选失败', 'error');
        }
    }, function(err) {
        showMessage('网络错误', 'error');
    });
}