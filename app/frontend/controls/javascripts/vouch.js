import { registerFormatOptionListener, registerAutoSubmitForm } from './shared';

function registerListeners() {
  const container = document.querySelector('.vouch');
  if (!container) return;

  registerFormatOptionListener();
  registerAutoSubmitForm();
}

function beforeRedirectListener() {
  if (!document.querySelector('.vouch')) return;

  localStorage.removeItem('graph_data');
}

document.addEventListener('DOMContentLoaded', registerListeners);
document.addEventListener('turbo:load', registerListeners);
document.addEventListener('turbo:before-visit', beforeRedirectListener);