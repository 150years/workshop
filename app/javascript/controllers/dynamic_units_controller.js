import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["unitSelect", "unitText"];

  connect() {
    this.updateUnitText();
  }

  updateUnitText() {
    const selectedUnit = this.unitSelectTarget.value;
    this.unitTextTarget.textContent = selectedUnit || "Units";
  }
}
