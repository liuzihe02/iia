# Engineering Tripos Part IIA

Repository for labs and coursework for Engineering Tripos Part IIA

## Latex Workshop

We use [VSCode Latex Workshop](https://github.com/James-Yu/LaTeX-Workshop/wiki) to edit our latex documents. Please install this in VSCode as a drop-in local replacement for Overleaf.

Please keep the `.vscode/settings.json` file as this lays out how to build and clean latex properly.

- To build, simply *save* the latex file
- All build artefacts should be cleaned automatically, keeping only the pdf file in the relevant directory
- It may takes 2/3 seconds to compile and clean, so please be patient

## Templates

We use some templates for styling our FTRs. The `cls` file is available in the top level `templates` folder for reustability. We use a `latexmkrc` file to access these shared templates by passing in variables (see [here](https://docs.overleaf.com/managing-projects-and-files/the-latexmkrc-file)) for details on how this works

- Latex Templates [Journal Article](https://www.latextemplates.com/template/journal-article)

## References

Consider these repositories for samples of lab reports and formatting.

- [Tom Lu](https://github.com/xl402/IIA-Lab-Report/)
- [Qianshuo](https://github.com/harryeqs/Part-IIA-Notes)
