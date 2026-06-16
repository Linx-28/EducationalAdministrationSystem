function ajax({url, method = 'GET', data, onSuccess, onError}) {
    const xhr = new XMLHttpRequest();
    xhr.open(method, url, true);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4) {
            if (xhr.status === 200) {
                try {
                    const result = JSON.parse(xhr.responseText);
                    if (onSuccess) onSuccess(result);
                } catch(e) {
                    if (onSuccess) onSuccess(xhr.responseText);
                }
            } else {
                if (onError) onError(xhr.statusText);
            }
        }
    };
    if (data) {
        const params = Object.keys(data).map(k => encodeURIComponent(k) + '=' + encodeURIComponent(data[k])).join('&');
        xhr.send(params);
    } else {
        xhr.send();
    }
}

function post(url, data, onSuccess, onError) {
    ajax({url, method: 'POST', data, onSuccess, onError});
}

function get(url, onSuccess, onError) {
    ajax({url, method: 'GET', onSuccess, onError});
}

function validateForm(formId) {
    const form = document.getElementById(formId);
    if (!form) return true;
    const inputs = form.querySelectorAll('[required]');
    for (let input of inputs) {
        if (!input.value.trim()) {
            alert('请填写: ' + (input.previousElementSibling ? input.previousElementSibling.textContent : input.name));
            input.focus();
            return false;
        }
    }
    return true;
}

function showModal(id) {
    const modal = document.getElementById(id);
    if (modal) modal.style.display = 'flex';
}

function hideModal(id) {
    const modal = document.getElementById(id);
    if (modal) modal.style.display = 'none';
}

function confirmDelete(callback) {
    if (confirm('确定要删除吗？此操作不可恢复。')) {
        callback();
    }
}

function showMessage(msg, type) {
    const div = document.createElement('div');
    div.className = 'alert alert-' + (type || 'success');
    div.textContent = msg;
    document.querySelector('.container') ? document.querySelector('.container').prepend(div) : document.body.prepend(div);
    setTimeout(() => div.remove(), 3000);
}