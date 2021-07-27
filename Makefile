export PLOTLY_RENDERER_JULIA=docs
export JULIA_PROJECT=@.
export JULIA_DEBUG=Main

MD_DIR ?= julia
HTML_DIR ?= build/html
FAIL_DIR ?= build/failures

MD_FILES := $(shell ls $(MD_DIR)/*.md)
HTML_FILES := $(patsubst $(MD_DIR)/%.md,$(HTML_DIR)/%.html,$(MD_FILES))

all: $(HTML_FILES)

html:
	@julia --project=@. -L make.jl --threads 4 -e 'main()'

$(HTML_DIR)/%.html: $(MD_DIR)/%.md
	@mkdir -p $(FAIL_DIR)
	@mkdir -p $(HTML_DIR)
	@julia --project=@. -L make.jl -e 'process_file("$<")' && rm -f $(FAIL_DIR)/$*

clean:
	@rm -rf build
