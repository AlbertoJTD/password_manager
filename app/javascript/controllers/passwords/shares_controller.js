import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="passwords--shares"
export default class extends Controller {
  static targets = ['userSelect', 'userEmail'];
  static classes = ['disabledField', 'activeField'];

  updateState() {
    debugger
    this.userSelectTarget.disabled = false;
    this.userEmailTarget.disabled = false;
    if (this.hasUserSelectTarget && this.userSelectTarget.value) {
      this.addDisabledFieldClass(this.userEmailTarget);
      this.removeActiveFieldClass(this.userEmailTarget);

      this.userEmailTarget.disabled = true;
    } else if (this.hasUserEmailTarget && this.userEmailTarget.value) {
      this.addDisabledFieldClass(this.userSelectTarget);
      this.removeActiveFieldClass(this.userSelectTarget);

      this.userSelectTarget.disabled = true;
    } else {
      this.removeDisabledFieldClass(this.userSelectTarget);
      this.removeDisabledFieldClass(this.userEmailTarget);

      this.addActiveFieldClass(this.userSelectTarget);
      this.addActiveFieldClass(this.userEmailTarget);
    }
  }

  addDisabledFieldClass(element) {
    this.disabledFieldClasses.forEach(className => {
      element.classList.add(className);
    });
  }

  removeDisabledFieldClass(element) {
    this.disabledFieldClasses.forEach(className => {
      element.classList.remove(className);
    });
  }

  addActiveFieldClass(element) {
    this.activeFieldClasses.forEach(className => {
      element.classList.add(className);
    });
  }

  removeActiveFieldClass(element) {
    this.activeFieldClasses.forEach(className => {
      element.classList.remove(className);
    });
  }
}
