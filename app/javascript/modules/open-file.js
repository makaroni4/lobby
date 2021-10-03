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

const $autoOpenBlock = document.querySelector(".js-auto-open-file");

console.log($autoOpenBlock);

if($autoOpenBlock) {
  const projectPath = $autoOpenBlock.dataset.projectPath;
  const filePath = $autoOpenBlock.dataset.filePath;

  console.log(projectPath, filePath);

  openFileInVSCode(projectPath, filePath);
}
