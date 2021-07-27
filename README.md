# plotlyjs.jl-docs

Documentation for the Plotly Julia graphing library.

## Developer Setup


**Julia setup**

1. Download and install latest Julia from official source: https://julialang.org/downloads/ (at least version 1.6)
2. Start Julia in this repo
3. At Julia prompt press `]` to move REPL into package mode. Prompt should be `(@v1.6) pkg>`
4. At package prompt use command `activate .`. Prompt should now read `(plotlyjs.jl-docs) pkg>`
5. Install necessary Julia packages by entering `instantiate` command at package prompt

## Building docs

After completing installation steps above, you should be able to build the docs by running `make` or `make html`

Note that `make` will process only modified markdown files from the `julia` directory. This will be done in a separate Julia process for each file

The `make html` will process ALL markdown files in the `julia` directory (even those that have not been modified) in a single Julia process with multiple threads. If you need to do a clean build of the docs the `make html` rule will be more efficient
