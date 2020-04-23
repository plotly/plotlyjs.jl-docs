### Time Series in Julia

#### Date Strings


```julia
using PlotlyJS
```


<script>
// Immediately-invoked-function-expression to avoid global variables.
(function() {
    var warning_div = document.getElementById("webio-warning-7969348531849103676");
    var hide = function () {
        var script = document.getElementById("webio-setup-15391577642230888377");
        var parent = script && script.parentElement;
        var grandparent = parent && parent.parentElement;
        if (grandparent) {
            grandparent.style.display = "none";
        }
        warning_div.style.display = "none";
    };
    if (typeof Jupyter !== "undefined") {
        console.log("WebIO detected Jupyter notebook environment.");
        // Jupyter notebook.
        var extensions = (
            Jupyter
            && Jupyter.notebook.config.data
            && Jupyter.notebook.config.data.load_extensions
        );
        if (extensions && extensions["webio-jupyter-notebook"]) {
            // Extension already loaded.
            console.log("Jupyter WebIO nbextension detected; not loading ad-hoc.");
            hide();
            return;
        }
    } else if (window.location.pathname.includes("/lab")) {
        // Guessing JupyterLa
        console.log("Jupyter Lab detected; make sure the @webio/jupyter-lab-provider labextension is installed.");
        hide();
        return;
    }
})();

</script>
<p
    id="webio-warning-7969348531849103676"
    class="output_text output_stderr"
    style="padding: 1em; font-weight: bold;"
>
    Unable to load WebIO. Please make sure WebIO works for your Jupyter client.
    For troubleshooting, please see <a href="https://juliagizmos.github.io/WebIO.jl/latest/providers/ijulia/">
    the WebIO/IJulia documentation</a>.
    <!-- TODO: link to installation docs. -->
</p>




```julia
function datetimestrings()
    x = ["2013-10-04 22:23:00", "2013-11-04 22:23:00", "2013-12-04 22:23:00"]
    plot(scatter(x=x, y=[1 ,3, 6]))
end
datetimestrings()
```




<div
    class="webio-mountpoint"
    data-webio-mountpoint="858760966554823716"
>
    <script>
    if (window.require && require.defined && require.defined("nbextensions/webio-jupyter-notebook")) {
        console.log("Jupyter WebIO extension detected, not mounting.");
    } else if (window.WebIO) {
        WebIO.mount(
            document.querySelector('[data-webio-mountpoint="858760966554823716"]'),
            {"props":{},"nodeType":"Scope","type":"node","instanceArgs":{"imports":{"data":[{"name":"Plotly","type":"js","url":"\/assetserver\/7ba837e5fce6ce699adbb93c41e90439399caaa5-plotly-latest.min.js"},{"name":null,"type":"js","url":"\/assetserver\/c2e992e1f1686472ac3b73ed835d603e9bfc3968-plotly_webio.bundle.js"}],"type":"async_block"},"id":"9620817063818237952","handlers":{"_toImage":["(function (options){return this.Plotly.toImage(this.plotElem,options).then((function (data){return WebIO.setval({\"name\":\"image\",\"scope\":\"9620817063818237952\",\"id\":\"868178600978029896\",\"type\":\"observable\"},data)}))})"],"__get_gd_contents":["(function (prop){prop==\"data\" ? (WebIO.setval({\"name\":\"__gd_contents\",\"scope\":\"9620817063818237952\",\"id\":\"289598939174628482\",\"type\":\"observable\"},this.plotElem.data)) : undefined; return prop==\"layout\" ? (WebIO.setval({\"name\":\"__gd_contents\",\"scope\":\"9620817063818237952\",\"id\":\"289598939174628482\",\"type\":\"observable\"},this.plotElem.layout)) : undefined})"],"_downloadImage":["(function (options){return this.Plotly.downloadImage(this.plotElem,options)})"],"_commands":["(function (args){var fn=args.shift(); var elem=this.plotElem; var Plotly=this.Plotly; args.unshift(elem); return Plotly[fn].apply(this,args)})"]},"systemjs_options":null,"mount_callbacks":["function () {\n    var handler = ((function (Plotly,PlotlyWebIO){PlotlyWebIO.init(WebIO); var gd=this.dom.querySelector(\"#plot-f888e7be-b8fc-4f12-961f-3c61ab1c2c88\"); this.plotElem=gd; this.Plotly=Plotly; (window.Blink!==undefined) ? (gd.style.width=\"100%\", gd.style.height=\"100vh\", gd.style.marginLeft=\"0%\", gd.style.marginTop=\"0vh\") : undefined; window.onresize=(function (){return Plotly.Plots.resize(gd)}); Plotly.newPlot(gd,[{\"y\":[1,3,6],\"type\":\"scatter\",\"x\":[\"2013-10-04 22:23:00\",\"2013-11-04 22:23:00\",\"2013-12-04 22:23:00\"]}],{\"margin\":{\"l\":50,\"b\":50,\"r\":50,\"t\":60}},{}); gd.on(\"plotly_hover\",(function (data){var filtered_data=WebIO.PlotlyCommands.filterEventData(gd,data,\"hover\"); return !(filtered_data.isnil) ? (WebIO.setval({\"name\":\"hover\",\"scope\":\"9620817063818237952\",\"id\":\"7680119752059742864\",\"type\":\"observable\"},filtered_data.out)) : undefined})); gd.on(\"plotly_unhover\",(function (){return WebIO.setval({\"name\":\"hover\",\"scope\":\"9620817063818237952\",\"id\":\"7680119752059742864\",\"type\":\"observable\"},{})})); gd.on(\"plotly_selected\",(function (data){var filtered_data=WebIO.PlotlyCommands.filterEventData(gd,data,\"selected\"); return !(filtered_data.isnil) ? (WebIO.setval({\"name\":\"selected\",\"scope\":\"9620817063818237952\",\"id\":\"11233552089837475088\",\"type\":\"observable\"},filtered_data.out)) : undefined})); gd.on(\"plotly_deselect\",(function (){return WebIO.setval({\"name\":\"selected\",\"scope\":\"9620817063818237952\",\"id\":\"11233552089837475088\",\"type\":\"observable\"},{})})); gd.on(\"plotly_relayout\",(function (data){var filtered_data=WebIO.PlotlyCommands.filterEventData(gd,data,\"relayout\"); return !(filtered_data.isnil) ? (WebIO.setval({\"name\":\"relayout\",\"scope\":\"9620817063818237952\",\"id\":\"8604742727891926189\",\"type\":\"observable\"},filtered_data.out)) : undefined})); return gd.on(\"plotly_click\",(function (data){var filtered_data=WebIO.PlotlyCommands.filterEventData(gd,data,\"click\"); return !(filtered_data.isnil) ? (WebIO.setval({\"name\":\"click\",\"scope\":\"9620817063818237952\",\"id\":\"3995170247839861699\",\"type\":\"observable\"},filtered_data.out)) : undefined}))}));\n    (WebIO.importBlock({\"data\":[{\"name\":\"Plotly\",\"type\":\"js\",\"url\":\"\/assetserver\/7ba837e5fce6ce699adbb93c41e90439399caaa5-plotly-latest.min.js\"},{\"name\":null,\"type\":\"js\",\"url\":\"\/assetserver\/c2e992e1f1686472ac3b73ed835d603e9bfc3968-plotly_webio.bundle.js\"}],\"type\":\"async_block\"})).then((imports) => handler.apply(this, imports));\n}\n"],"observables":{"_toImage":{"sync":false,"id":"12505838084877500130","value":{}},"hover":{"sync":false,"id":"7680119752059742864","value":{}},"selected":{"sync":false,"id":"11233552089837475088","value":{}},"__gd_contents":{"sync":false,"id":"289598939174628482","value":{}},"click":{"sync":false,"id":"3995170247839861699","value":{}},"image":{"sync":true,"id":"868178600978029896","value":""},"__get_gd_contents":{"sync":false,"id":"17972867137054332931","value":""},"_downloadImage":{"sync":false,"id":"17552882909415877211","value":{}},"relayout":{"sync":false,"id":"8604742727891926189","value":{}},"_commands":{"sync":false,"id":"15685934784028110488","value":[]}}},"children":[{"props":{"id":"plot-f888e7be-b8fc-4f12-961f-3c61ab1c2c88"},"nodeType":"DOM","type":"node","instanceArgs":{"namespace":"html","tag":"div"},"children":[]}]},
            window,
        );
    } else {
        document
            .querySelector('[data-webio-mountpoint="858760966554823716"]')
            .innerHTML = (
                '<strong>WebIO not detected. Please read ' +
                '<a href="https://juliagizmos.github.io/WebIO.jl/latest/troubleshooting/not-detected/">the troubleshooting guide</a> ' +
                'for more information on how to resolve this issue.' +
                '</strong>'
            );
    }
    </script>
</div>



