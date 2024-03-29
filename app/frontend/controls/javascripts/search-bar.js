function registerListeners() {
  const search = document.querySelector(".search-bar");
  if (!search) return;

  // Autosubmit search form when typing
  let timeout;
  const searchInput = search.querySelector(".search-bar__input input");
  searchInput.addEventListener("input", () => {
    clearTimeout(timeout);
    timeout = setTimeout(() => {
      searchInput.closest("form").requestSubmit();
    }, 100);
  });

  // When clicking outside of .search-bar, clear the input and results
  document.addEventListener("click", clickOutsideSearchBar);

  document.addEventListener("turbo:load", () => {
    document.removeEventListener("click", clickOutsideSearchBar);
  });
}

function clickOutsideSearchBar(event) {
  if (!search) return;

  if (!event.target.closest(".search-bar")) {
    searchInput.value = "";
    document.querySelector(".search-bar .search-bar__results").outerHTML = "";
  }
}

document.addEventListener("DOMContentLoaded", () => registerListeners());
document.addEventListener("turbolinks:load", () => registerListeners());