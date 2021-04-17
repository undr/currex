import { getAttributeOrThrow } from "../lib";

const DATA_ELEMENT_TOGGLE = '[data-element="toggle"]';
const DATA_ELEMENT_SUGGESTIOS = '[data-element="suggestions"]';
const DATA_ELEMENT_INPUT = '[data-element="input"]';
const DATA_JS_HIDDEN = "data-js-hidden";
const DATA_SELECTED = "data-selected";
const DATA_PHX_COMPONENT = "data-phx-component";

const Selector = {
  mounted() {
    this.props = getProps(this);

    this.state = {
      isOpen: false,
    };

    this.toggleButton = this.el.querySelector(DATA_ELEMENT_TOGGLE);
    this.suggestionsList = this.el.querySelector(DATA_ELEMENT_SUGGESTIOS);
    this.inputField = this.el.querySelector(DATA_ELEMENT_INPUT);

    this.updateInputField();
    this.updateSuggestionsList();

    this.handleDocumentClick = (event) => handleDocumentClick(this, event);
    document.addEventListener("click", this.handleDocumentClick);

    this.handleToggleButtonClick = (event) => handleToggleButtonClick(this, event);
    this.toggleButton.addEventListener("click", this.handleToggleButtonClick);

    this.handleInputFieldFocus = (event) => handleInputFieldFocus(this, event);
    this.inputField.addEventListener("focus", this.handleInputFieldFocus);
  },

  updated() {
    this.props = getProps(this);

    if (!this.state.isOpen) this.updateInputField();
    this.updateSuggestionsList();
  },

  destroyed() {
    document.removeEventListener("click", this.handleDocumentClick);
    this.toggleButton.removeEventListener("click", this.handleToggleButtonClick);
    this.inputField.removeEventListener("focus", this.handleInputFieldFocus);
  },

  updateInputField(value) {
    value = typeof value !== 'undefined' ?  value : this.props.selected;
    this.inputField.value = value;
  },

  updateSuggestionsList() {
    if (this.state.isOpen) {
      this.suggestionsList.removeAttribute(DATA_JS_HIDDEN);
    } else {
      this.suggestionsList.setAttribute(DATA_JS_HIDDEN, "true")
    }
  }
};

function handleToggleButtonClick(hook, event) {
  if (hook.state.isOpen) {
    closeSuggestionsList(hook);
  } else {
    hook.inputField.focus();
  }
}

function handleDocumentClick(hook, event) {
  if (hook.el.children[0].contains(event.target)) return;
  if (hook.state.isOpen) closeSuggestionsList(hook);
}

function handleInputFieldFocus(hook, event) {
  openSuggestionsList(hook);
}

function closeSuggestionsList(hook) {
  hook.state.isOpen = false
  hook.updateSuggestionsList();
  hook.updateInputField();
  hook.pushEventTo(hook.props.component, "close");
}

function openSuggestionsList(hook) {
  hook.state.isOpen = true;
  hook.updateSuggestionsList();
  hook.updateInputField("");
}

function getProps(hook) {
  return {
    selected: getAttributeOrThrow(hook.el, DATA_SELECTED),
    component: getAttributeOrThrow(hook.el, DATA_PHX_COMPONENT),
  };
}

export default Selector;
