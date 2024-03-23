function formatOptionListener(event) {
  const format = event.target.value;
  const formats = ['plain', 'curl', 'wget'];

  formats.forEach((f) => {
    const element = document.querySelector(`.signature-challenge__option--${f}`);
    element.style.display = f === format ? 'block' : 'none';
  });
}

function autoSubmitForm(event) {
  event.target.form.submit();
}


function registerListeners() {
  const formatSelector = document.getElementById('signature-challenge-format-selector');
  if (formatSelector) {
    formatSelector.addEventListener('change', formatOptionListener);
  }

  const signatureChallengeUploadForm = document.getElementById('signature-challenge-upload-form');
  if (signatureChallengeUploadForm) {
    signatureChallengeUploadForm.querySelectorAll('input[type="file"]')[0]
      .addEventListener('change', autoSubmitForm);
  }
}

document.addEventListener('turbo:before-stream-render', ((event) => {
  const fallbackToDefaultActions = event.detail.render;
  event.detail.render = function (streamElement) {
    fallbackToDefaultActions(streamElement);
    registerListeners();
  };
}));