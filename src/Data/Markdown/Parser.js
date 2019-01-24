exports.parseImpl = function (text) {
  const converter = new showdown.Converter();
  return converter.makeHtml(text);
}