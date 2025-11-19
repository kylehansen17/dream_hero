import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
  connect() {
    this.checkMessageCount()
  }
  checkMessageCount() {
    const messageCount = parseInt(this.element.dataset.messageCount)
    if (messageCount >= 5) {
      this.remove()
    }
  }
  remove() {
    this.element.remove()
  }
}
