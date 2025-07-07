// app/javascript/controllers/auto_resize_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.resize()
  }

  resize() {
    this.element.style.height = "auto"
    this.element.style.height = this.element.scrollHeight + "px"
  }

  adjust(event) {
    this.resize()
  }
}
