import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["field", "output"]

  connect() {
    this.convert()
  }

  convert() {
    const mmValue = parseFloat(this.fieldTarget.value)
    if (isNaN(mmValue)) {
      this.outputTarget.textContent = "-"
    } else {
      const meters = mmValue / 1000
      this.outputTarget.textContent = `${meters} m`
    }
  }
}
