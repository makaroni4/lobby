const openFileInVSCode = (projectPath, filePath) => {
  window.location = `vscode://file${projectPath}`;

  setTimeout(() => {
    window.location = `vscode://file${filePath}`;
  }, 1000);
};

document.addEventListener("click", e => {
  if(e.target.matches(".js-open-file")) {
    const projectPath = e.target.dataset.projectPath;
    const filePath = e.target.dataset.filePath;

    openFileInVSCode(projectPath, filePath);
  }
});
