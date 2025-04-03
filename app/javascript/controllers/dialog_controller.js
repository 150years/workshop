import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "menu" ]

  connect() {
    this.shown = false
  }

  showModal() {
    if (this.shown) return

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
}
