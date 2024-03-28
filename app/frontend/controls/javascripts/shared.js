export function registerFormatOptionListener() {
  const formatSelector = document.querySelector('.format-selector');

  const options = formatSelector.querySelectorAll('option');

  formatSelector.addEventListener('change', function (event) {
    const selectedOption = options[formatSelector.selectedIndex];
    const format = selectedOption.value;

    document.querySelectorAll('.format-option').forEach(function (option) {
      if (option.dataset.format === format) {
        option.classList.remove('hidden');
      } else {
        option.classList.add('hidden');
      }
    });
  });
}

export function registerAutoSubmitForm() {
  document.querySelector('input[type="file"]').addEventListener('change', function (event) {
    event.target.form.submit();
  });
}