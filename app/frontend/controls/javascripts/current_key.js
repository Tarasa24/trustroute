function getCookie(name) {
  const value = `; ${document.cookie}`;
  const parts = value.split(`; ${name}=`);
  if (parts.length === 2) return parts.pop().split(';').shift();

  return null;
}

function loadCurrentKey() {
  document.current_key = getCookie("key_uuid");
}

document.addEventListener('DOMContentLoaded', () => loadCurrentKey());
document.addEventListener('turbo:visit', () => loadCurrentKey());
