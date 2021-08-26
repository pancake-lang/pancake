var loader = setInterval(function () {
  if (document.readyState !== "complete") return;
  clearInterval(loader);
  const editorTextarea = document.querySelector(".editor-textarea");
  const editorLineNumbers = document.querySelector(".editor-line-numbers");
  editorTextarea.addEventListener("scroll", () => {
    editorLineNumbers.scrollTop = editorTextarea.scrollTop;
  });
}, 300);
