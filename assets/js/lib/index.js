export function getAttributeOrThrow(element, attr, transform = null) {
  if (!element.hasAttribute(attr)) {
    throw new Error(
      `Missing attribute '${attr}' on element <${element.tagName}:${element.id}>`
    );
  }

  const value = element.getAttribute(attr);

  return transform ? transform(value) : value;
}
