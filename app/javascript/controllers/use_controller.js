import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    materialId: Number,
    materialName: String
  }

  open(event) {
    event.preventDefault()
    document.getElementById("use_modal_material_id").value = this.materialIdValue
    document.getElementById("use_modal_title").innerText = `Use material: ${this.materialNameValue}`
    document.getElementById("use_modal").showModal()
  }
}