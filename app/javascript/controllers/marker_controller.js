import { Controller } from "@hotwired/stimulus"
import { MarkerArea } from "markerjs2"


export default class extends Controller {
  static values = {
    url: String,
    field: String, // "photo_before" или "photo_after"
    attachmentId: Number //For IR where has_many photos
  }

  connect() {
    this.img = this.element
    this.img.addEventListener("click", () => this.openMarker())
  }

  openMarker() {
    const markerArea = new MarkerArea(this.img)
    markerArea.settings.displayMode = 'popup'

    markerArea.addEventListener('render', async (event) => {
      const blob = await (await fetch(event.dataUrl)).blob()
      const formData = new FormData()
      const token = document.querySelector('meta[name="csrf-token"]').content;

      if (this.fieldValue === "photo_before" || this.fieldValue === "photo_after") {
        formData.append(`defect_list_item[${this.fieldValue}]`, blob, `${this.fieldValue}.png`)
      } else {
        formData.append(`photo`, blob, `marked.png`)
        formData.append("attachment_id", this.attachmentIdValue)
      }
      const response = await fetch(this.urlValue, {
        method: 'PATCH',
        headers: {
          'X-CSRF-Token': token,
          'Accept': 'text/vnd.turbo-stream.html'
        },
        body: formData
      })
      const html = await response.text()
      Turbo.renderStreamMessage(html)
    })
    markerArea.show()
  }
}
