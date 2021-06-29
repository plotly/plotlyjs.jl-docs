
export PLOTLY_RENDERER_JULIA=docs
export JULIA_PROJECT=@.

MD_DIR ?= julia
IPYNB_DIR ?= build/ipynb
HTML_DIR ?= build/html
TEMP_HTML_DIR ?= build/temp_html
FAIL_DIR ?= build/failures


MD_FILES := $(shell ls $(MD_DIR)/*.md)

IPYNB_FILES := $(patsubst $(MD_DIR)/%.md,$(IPYNB_DIR)/%.ipynb,$(MD_FILES))
TEMP_HTML_FILES := $(patsubst $(MD_DIR)/%.md,$(TEMP_HTML_DIR)/%.html,$(MD_FILES))
HTML_FILES := $(patsubst $(MD_DIR)/%.md,$(HTML_DIR)/%.html,$(MD_FILES))


all: $(HTML_FILES)

.PRECIOUS: $(IPYNB_FILES)

# $(IPYNB_DIR)/.mapbox_token: $(MD_DIR)/.mapbox_token
# 	@mkdir -p $(IPYNB_DIR)
# 	@echo "[symlink]    .mapbox_token"
# 	@cd $(IPYNB_DIR) && ln -s ../../$<

# $(IPYNB_FILES): $(IPYNB_DIR)/.mapbox_token

$(IPYNB_DIR)/%.ipynb: $(MD_DIR)/%.md
	@mkdir -p $(IPYNB_DIR)
	@echo "[jupytext]   $< => $@"
	@jupytext  $< --to notebook --quiet --output $@

$(TEMP_HTML_DIR)/%.html: $(IPYNB_DIR)/%.ipynb
	@mkdir -p $(TEMP_HTML_DIR)
	@mkdir -p $(FAIL_DIR)
	@echo "[nbconvert]  $< => $@"
	@jupyter nbconvert $< --to html --template nb.tpl \
			--ExecutePreprocessor.timeout=600\
	  	--output-dir $(TEMP_HTML_DIR) --output $*.html \
	  	--execute > $(FAIL_DIR)/$* 2>&1  && rm -f $(FAIL_DIR)/$*


$(HTML_DIR)/%.html: $(TEMP_HTML_DIR)/%.html
	@mkdir -p $(HTML_DIR)
	@echo "[purge webio]  $< => $@"
	@python purge_webio.py $< $@

clean:
	@rm -rf $(IPYNB_DIR)
	@rm -rf $(HTML_DIR)
	@rm -rf $(TEMP_HTML_DIR)
