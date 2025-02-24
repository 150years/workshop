import { Controller } from "@hotwired/stimulus"
import debounce from "https://esm.sh/lodash.debounce@4.0.8?standalone"

export default class extends Controller {
  static targets = [ "cancel", "searchInput" ]

  initialize() {
    this.search = debounce(this.search.bind(this), 500)
  }

  submit() {
    this.element.requestSubmit()
  }

  search() {
    this.element.requestSubmit()
  }

  cancel() {
    this.searchInputTarget.value = ''; // Clear the search input field
    this.cancelTarget?.click();
  }

  preventAttachment(event) {
    event.preventDefault()
  }
}
