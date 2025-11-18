// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"

document.addEventListener("turbo:load", () => {
  const banner = document.querySelector(".banner");
  const tab1 = document.getElementById("tab2-1");
  const tab2 = document.getElementById("tab2-2");

  if (!banner || !tab1 || !tab2) return;

  // Read from data- attributes
  const storiesImage = banner.dataset.storiesImage;
  const charactersImage = banner.dataset.charactersImage;

  tab1.addEventListener("change", () => {
    if (tab1.checked) {
      banner.style.backgroundImage = `url('${storiesImage}')`;
    }
  });

  tab2.addEventListener("change", () => {
    if (tab2.checked) {
      banner.style.backgroundImage = `url('${charactersImage}')`;
    }
  });
});
