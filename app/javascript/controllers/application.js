import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = true
window.Stimulus   = application

export { application }
import LinkController from "./link_controller"
application.register("link", LinkController)        
