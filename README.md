# plotlyjs.jl-docs

Documentation for the Plotly Julia graphing library.

<div align="center">
  <a href="https://dash.plotly.com/project-maintenance">
    <img src="https://dash.plotly.com/assets/images/maintained-by-community.png" width="600px" alt="Maintained by the Plotly Community">
  </a>
</div>

## Developer Setup

**Julia setup**

1. Download and install latest Julia from official source: https://julialang.org/downloads/ (at least version 1.6).
2. Start Julia in this repo.
3. At Julia prompt press `]` to move REPL into package mode.
   Prompt should be `(@v1.6) pkg>`.
4. At package prompt use command `activate .`.
   Prompt should now read `(plotlyjs.jl-docs) pkg>`.
5. Install necessary Julia packages by entering `instantiate` command at package prompt.

## Building docs

After completing installation steps above, you should be able to build the docs by running `make` or `make html`.

Note that `make` will process only modified markdown files from the `julia` directory.
This will be done in a separate Julia process for each file.

The `make html` will process ALL markdown files in the `julia` directory (even those that have not been modified) in a single Julia process with multiple threads.
If you need to do a clean build of the docs the `make html` rule will be more efficient.

### Building from Julia

When working on many doc pages, it can greatly reduce Julia compiler times and overall latency to keep a Julia session running while building.

One common workflow would be to iteratively test if a single file can be build.

To do this, open your julia REPL, activate the project and then run:

```julia
# only do this once
include("make.jl")

# do this each time you want to test a rebuild.
process_file("my-file.md")
```

This will cause just the only file `julia/my-file.md` to be built.
If, after making some changes, you want to build again run the `process_file("my-file.md")` command again.
