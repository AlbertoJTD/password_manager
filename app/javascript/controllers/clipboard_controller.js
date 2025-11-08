import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="clipboard"
export default class extends Controller {
  static values = {
    content: String,
    copiedMessage: String
  }

  connect() {
    this.originalText = this.element.innerHTML;
  }

  copy() {
    navigator.clipboard.writeText(this.contentValue).then(
      () => {
        this.element.textContent = this.copiedMessageValue;
        setTimeout(() => {
          this.element.innerHTML = this.originalText;
        }, 1500);
      },
      () => {
        alert('Failed to copy to clipboard');
      }
    );
    
  }
}
