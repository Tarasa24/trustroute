function formatOptionListener(event) {
  const format = event.target.value;
  const formats = ['plain', 'curl', 'wget'];

  formats.forEach((f) => {
    const element = document.querySelector(`.signature-challenge__option--${f}`);
    element.style.display = f === format ? 'block' : 'none';
  });
}

function registerListeners() {
  const formatSelector = document.getElementById('signature-challenge-format-selector');
  if (!formatSelector) return;

  formatSelector.addEventListener('change', formatOptionListener);
}

document.addEventListener('turbo:before-stream-render', ((event) => {
  const fallbackToDefaultActions = event.detail.render;
  event.detail.render = function (streamElement) {
    fallbackToDefaultActions(streamElement);
    registerListeners();
  };
}));