import { registerFormatOptionListener, registerAutoSubmitForm } from './shared';
import * as channel from "./channels/async_redirect";

function registerListeners() {
  const container = document.querySelector('.vouch');
  if (!container) return;

  registerFormatOptionListener();
  registerAutoSubmitForm();
  connect();
}

function connect() {
  const container = document.querySelector('.vouch');
  if (!container) return;

  const keyId = container.dataset.keyId;
  if (keyId) channel.connect(`vouch:${document.current_key}:${keyId}`);
}

document.addEventListener('DOMContentLoaded', registerListeners);
document.addEventListener('turbo:load', registerListeners);