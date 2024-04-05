function registerListeners() {
  const search = document.querySelector(".search-bar");
  if (!search) return;

  // Autosubmit search form when typing
  let timeout;
  const searchInput = search.querySelector(".search-bar__input input");
  searchInput.addEventListener("input", () => {
    clearTimeout(timeout);
    timeout = setTimeout(() => {
      if (searchInput.value === "")
        document.querySelector(".search-bar__results").innerHTML = "";
      else
        searchInput.closest("form").requestSubmit();
    }, 100);
  });

  document.addEventListener("turbo:load", () => {
    document.removeEventListener("click", clickOutsideSearchBar);
  });
}

document.addEventListener("DOMContentLoaded", () => registerListeners());
document.addEventListener("turbolinks:load", () => registerListeners());