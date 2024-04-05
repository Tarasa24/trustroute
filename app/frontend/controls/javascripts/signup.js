import { registerAutoSubmitForm } from './shared';

function registerListeners() {
  const container = document.querySelector('.signup');
  if (!container) return;

  registerAutoSubmitForm();
}

document.addEventListener('DOMContentLoaded', registerListeners);
document.addEventListener('turbo:load', registerListeners);