export function registerFormatOptionListener() {
  const formatSelector = document.querySelector('.format-selector');
  formatSelector.addEventListener('change', formatSelectorChange);

  document.addEventListener('turbo:load', () => {
    formatSelector.removeEventListener('change', formatSelectorChange);
  });
}

function formatSelectorChange(event) {
  const formatSelector = event.target;
  const selectedOption = formatSelector.options[formatSelector.selectedIndex];
  const format = selectedOption.value;

  document.querySelectorAll('.format-option').forEach(function (option) {
    if (option.dataset.format === format) {
      option.classList.remove('hidden');
    } else {
      option.classList.add('hidden');
    }
  });
}

export function registerAutoSubmitForm() {
  document.querySelector('input[type="file"]').addEventListener('change', function (event) {
    event.target.form.submit();
  });
}