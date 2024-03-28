import * as channel from './channels/async_redirect';
import { registerFormatOptionListener, registerAutoSubmitForm } from './shared';

function registerListeners() {
  registerFormatOptionListener();
  registerAutoSubmitForm();
}

function connect() {
  const container = document.querySelector('.signature-challenge');
  if (!container) return;

  const keyId = container.dataset.keyId;
  if (keyId) channel.connect(`signature_challenge:${keyId}`);
}

document.addEventListener('turbo:before-stream-render', ((event) => {
  const fallbackToDefaultActions = event.detail.render;
  event.detail.render = function (streamElement) {
    fallbackToDefaultActions(streamElement);
    registerListeners();
    connect();
  };
}));