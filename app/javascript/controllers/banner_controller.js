import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["banner", "tabStories", "tabCharacters"]
  static values = {
    storiesImage: String,
    charactersImage: String
  }

  connect() {
    this.applyInitialTab()
    this.switch()
  }

  applyInitialTab() {
    const params = new URLSearchParams(window.location.search)
    const tabParam = params.get("tab")

    if (tabParam === "characters") {
      this.tabCharactersTarget.checked = true
    } else {
      this.tabStoriesTarget.checked = true
    }
  }

  switch() {
    if (this.tabStoriesTarget.checked) {
      this.bannerTarget.style.backgroundImage = `url('${this.storiesImageValue}')`
      this.showTab("content-tab1")
      this.hideTab("content-tab2")
    } else {
      this.bannerTarget.style.backgroundImage = `url('${this.charactersImageValue}')`
      this.showTab("content-tab2")
      this.hideTab("content-tab1")
    }
  }

  showTab(id) {
    document.getElementById(id).style.display = "block"
  }

  hideTab(id) {
    document.getElementById(id).style.display = "none"
  }
}
