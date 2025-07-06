import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["commentThai", "comment"]

  translate(event) {
    const thaiText = this.commentThaiTarget.value

    fetch(`https://translate.googleapis.com/translate_a/single?client=gtx&sl=th&tl=en&dt=t&q=${encodeURIComponent(thaiText)}`)
      .then(response => response.json())
      .then(data => {
        const translated = data[0].map(item => item[0]).join(" ")
        this.commentTarget.value = translated
      })
      .catch(error => {
        console.error("Translation failed", error)
        alert("Translation failed")
      })
  }
}
