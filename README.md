# plotlyjs.jl-docs

Documentation for the Plotly Julia graphing library.

## Developer Setup


**Julia setup**

1. Download and install latest Julia from official source: https://julialang.org/downloads/ (at least version 1.6)
2. Start Julia in this repo
3. At Julia prompt press `]` to move REPL into package mode. Prompt should be `(@v1.6) pkg>`
4. At package prompt use command `activate .`. Prompt should now read `(plotlyjs.jl-docs) pkg>`
5. Install necessary Julia packages by entering `instantiate` command at package prompt

**Python Setup**

1. Download and install your preferred Python distribution
2. Create a virtual environment using something like pyenv, venv, or conda
3. Install dependnencies in `requirements.txt`


## Building docs

After completing installation steps above, you should be able to build the docs by running `make` or `make all`
