import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="spin"
export default class extends Controller {
  static targets = ["buttonContainer"]
  originalButtonHTML = null
  connect() {
    console.log("connected to spin");
    this.element.addEventListener("submit", this.start)

    document.addEventListener("turbo:load", this.reset)
    document.addEventListener("turbo:before-cache", this.reset)
    this.originalButtonHTML = this.buttonContainerTarget.innerHTML
  }

  disconnect() {
    this.element.removeEventListener("submit", this.start)
    document.removeEventListener("turbo:load", this.reset)
    document.removeEventListener("turbo:before-cache", this.reset)
  }

  start = () => {
    const buttonContainer = this.buttonContainerTarget;

    const buttonElement = buttonContainer.querySelector('input[type="submit"], button[type="submit"]');
    const rect = buttonElement ? buttonElement.getBoundingClientRect() : {width: 200, height: 50};

    const spinnerHTML = `
      <div class="d-flex justify-content-center align-items-center btn btn-primary rounded-pill" style="width: ${rect.width}px; height: ${rect.height}px;">
        <i class="fa-solid fa-dharmachakra fa-spin"></i>
      </div>
    `;

    buttonContainer.innerHTML = spinnerHTML;

  }


    reset = () => {
      if (this.originalButtonHTML) {
        this.buttonContainerTarget.innerHTML = this.originalButtonHTML;
      }
    }
}
