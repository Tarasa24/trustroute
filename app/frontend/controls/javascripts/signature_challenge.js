import { registerFormatOptionListener, registerAutoSubmitForm } from './shared';

function registerListeners() {
  registerFormatOptionListener();
  registerAutoSubmitForm();
}

document.addEventListener('turbo:before-stream-render', ((event) => {
  const fallbackToDefaultActions = event.detail.render;
  event.detail.render = function (streamElement) {
    fallbackToDefaultActions(streamElement);
    registerListeners();
  };
}));