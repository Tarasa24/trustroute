import { registerFormatOptionListener } from "./shared";

function registerListeners() {
  const container = document.querySelector('.vouch');
  if (!container) return;

  registerFormatOptionListener();
}

document.addEventListener('DOMContentLoaded', registerListeners);
document.addEventListener('turbo:load', registerListeners);