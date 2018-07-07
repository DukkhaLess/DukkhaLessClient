exports.removeLoader = function() {
  try {
    const loader = document.querySelector("#loading-widget");
    const loaderStyles = document.querySelector("style[title=loading-styles]");
    loader.remove();
    loaderStyles.remove();
  } catch (e) {
  }
   return;
};
