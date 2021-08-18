using Markdown, PlotlyBase, PlotlyJS, YAML

# also load packages used in examples to avoid world collision issues when
# evaluating code
using Dates, LaTeXStrings, CSV, JSON, DataFrames, Distributions, HTTP, VegaDatasets

transform(::Module, x) = x
function transform(mm::Module, x::Markdown.Code)
    if x.language == "julia"
        code = "begin $(x.code) end"
        expr = Meta.parse(code)
        try
            return [x, Core.eval(mm, macroexpand(Main, expr))]
        catch err
            error("Could not run code block: $(x.code)\n\n\nError was:\n\n\n$(err)\n")
        end
    end
    return x
end

Markdown.html(io::IO, p::PlotlyJS.SyncPlot) = Markdown.html(io, p.plot)
function Markdown.html(io::IO, p::PlotlyBase.Plot)
    return show(io, MIME"text/html"(), p, full_html=false, include_plotlyjs="require-loaded")
end


struct DocPage
    fn::String
    frontmatter::Dict
    html_content::String
end


function prep_file(fn::String)
    content = String(open(read, joinpath("julia", fn)))
    # strip out metadata
    meta_block = match(r"^---\n(.+)\n---\n"sm, content)
    if isnothing(meta_block)
        error("Could not parse yaml frontmatter. Make sure it is separated by ---")
    end
    frontmatter = YAML.load(meta_block[1])

    # parse markdown
    md_content = content[length(meta_block.match) + 1:end]
    parsed = Markdown.parse(md_content)
    # make module to isolate execution environments for each file
    mod = eval(:(module $(gensym()) end))

    # transform parsed markdown. Keep everything same, except eval code
    transformed = transform.(Ref(mod), parsed.content)

    # convert all to html
    htmls = Markdown.html.(transformed)

    # join as string
    html_content = join(htmls, "\n")

    return DocPage(fn, frontmatter, html_content)
end

function output_path(x::DocPage)
    base_name = rsplit(x.fn, ".", limit=2)[1]
    joinpath("build", "html", string("2021-08-17-", base_name, ".html"))
end

# writing output
function write_yaml_header(io::IO, x::DocPage)
    fm = x.frontmatter
    if haskey(fm, "jupyter") && haskey(fm["jupyter"], "plotly")
        println(io, "---")
        YAML.write(io, fm["jupyter"]["plotly"])
        println(io, "---")
    end
end

write_html_content(io::IO, x::DocPage) = println(io, x.html_content)

function write_output(x::DocPage)
    output_fn = output_path(x)
    # ensure path exists
    mkpath(dirname(output_fn))

    # write the document
    open(output_fn, "w") do f
        write_yaml_header(f, x)

        println(f, "\n\n{% raw %}")

        write_html_content(f, x)

        println(f, "\n\n{% endraw %}")
    end
    @info "Wrote to $(output_fn)"
end

function process_file(fn::String)
    bn = basename(fn)
    try
        @info "processing file $fn on thread $(Base.Threads.threadid())"
        content = prep_file(bn)
        write_output(content)
    catch err
        file_root = rsplit(bn, ".", limit=2)[1]
        open(joinpath("build", "failures", file_root), "w") do f
            println(f, err)
            for (exc, bt) in Base.catch_stack()
                println(f, "\n\n")
                showerror(f, exc, bt)
                println(f, "\n\n")
            end
        end
        @warn "failed when running $fn\nError is:\n$err"
        exit(1)
    end
end

function main()
    files = filter(endswith(".md"), readdir("julia"))
    Base.Threads.@threads for file in files
        process_file(file)
    end
end
