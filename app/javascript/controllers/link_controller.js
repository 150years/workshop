import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { href: String }

  connect() {
    this.element.addEventListener("click", this.navigate.bind(this))
  }

  navigate(event) {
    const target = event.target
    if (target.closest("a, button")) return // игнорируем клики по ссылкам и кнопкам
    if (this.hasHrefValue) {
      Turbo.visit(this.hrefValue)
    }
  }
}
