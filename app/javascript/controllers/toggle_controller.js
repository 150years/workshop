import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content"]


  toggle() {
    const el = this.contentTarget
    const isHidden = el.style.display === "none"
    el.style.display = isHidden ? "block" : "none"
  }
}
