import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { shortcut: String }

  connect() {
    this.shortcut = this.shortcutValue || "Shift+n"
    this.handler = this.handleShortcut.bind(this)
    document.addEventListener("keydown", this.handler)
  }

  disconnect() {
    document.removeEventListener("keydown", this.handler)
  }

  handleShortcut(event) {
    const keys = this.shortcut.split("+")
    const keyPressed = keys.every(key => {
      if (key === "Shift") return event.shiftKey
      if (key === "Control") return event.ctrlKey
      if (key === "Alt") return event.altKey
      return event.key.toLowerCase() === key.toLowerCase()
    })

    if (keyPressed) {
      event.preventDefault()
      window.location.href = "/transactions/new"
    }
  }
}

