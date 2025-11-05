# IIA Labs Claude File

This file specifies how LLMs (particularly claude) should behave when working with coursework projects

## Repository Structure

Labs and coursework are equivalent.

- Each folder should be labelled with their coursework title name (e.g. `3F3/`)
- Each coursework folder should contain pdf lab handouts, source code files or jupyter notebooks, and latex reports
- Coursework comes in 2 versions (each lab report will indicate short report questions and long report questions)
  - In short coursework mode, you should ignore all long report questions
    - Certain tasks may look like long report tasks, but are actually short. Be careful of this. Note that these tasks are not in italic and most importantly do not have the starting tag `Long report:`
  - In long coursework mode, you should consider both short and long reports
    - Long report tasks will be in italic, and have its own paragraph, and contain the starting tag `Long report:`

Our usual workflow is to use the ipynb as a scratchpad, to store all the core code, core math, and answers to the lab report questions. Then, we'll write a latex report using a provided template and the lab handout/ipynb.

## Short/Long Cousrework Mode

You are in this mode:

```md
SHORT_COURSEWORK
```

## Rules

- Always refer to the relevant lab handouts and readings specified when modifying code or writing the report
- Always try to put core math and core answers in the markdown blocks rather than directly in the code blocks
- Include core comments/inline documentation within the source code, but do not overdo this
- NEVER use emojis, or these tick/cross symbols `✗` ,`✓`
- No need to print unneccessary statements in the code unless core
- When I reference notebooks and pdfs, start by looking locally in the repository first
- Usually there will be a latex template provided, which contains all the core questions, math and figures that I need to produce. Always refer to this when completing tasks and guiding your working
- You will be completing tasks from the lab handout. Each task should be labelled with `>` in markdown inside the `ipynb` file. There should be a one-to-one correspondence between tasks in the lab handout, tasks specified in the latex document, and tasks specified with `>` in the `ipynb` file
