import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "frame"]

  connect() {
    this.shown = false
  }

  showModal(event) {
    if (this.shown) return
    if (event.target.closest('#dropdown')) return

    this.menuTarget.showModal()
    this.shown = true
  }

  show(event) {
    event.stopPropagation();
    this.menuTarget.showModal()
    this.shown = true
  }

  close(event) {
    event?.stopPropagation();
    this.menuTarget.close()
    this.shown = false
  }

  closeOnClickOutside(event) {
    if (event.target.nodeName === "DIALOG") {
      event.stopPropagation();
      this.close();
    }
  }

  openFromLink(event) {
    event.preventDefault()
    event.stopPropagation()

    const url = event.currentTarget.getAttribute("href")

    this.frameTarget.src = url
    this.menuTarget.showModal()
    this.shown = true
  }
}
