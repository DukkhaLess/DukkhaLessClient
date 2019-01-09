exports.parseImpl = function (text) {
  const converter = new showdown.Converter();
  const text = '# hello, markdown!';
  return converter.makeHtml(text);
}