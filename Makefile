
# ---- Command ---- #

.PHONY : gen clean fclean re test

gen:
	tuist install
	tuist generate

clean:
	tuist clean

fclean: clean
	rm -rf **/**/**/*.xcodeproj
	rm -rf **/**/*.xcodeproj
	rm -rf **/*.xcodeproj
	rm -rf *.xcworkspace
	find . -name "DerivedData" -exec rm -rf {} +
	find . -name "Derived" -exec rm -rf {} +

re: fclean gen

# ---- test ---- #

test:
	tuist test

module:
	swift Scripts/GenerateModule.swift

# ---- Templates ---- #

TUIST_VERSION = $(shell tuist version)
TUIST_DIR = $(shell which tuist)
TEMPLATES_DIR = $(HOME)/.local/share/mise/installs/tuist/$(TUIST_VERSION)/bin/Templates

templates: copy_templates list_templates

copy_templates:
	@echo "Copying folders to Tuist Templates directory..."
	@cp -fR ./Templates/* $(TEMPLATES_DIR)/
	@echo "Folders copied to $(TEMPLATES_DIR)"

list_templates:
	@echo "Listing contents of Tuist Templates directory..."
	ls $(TEMPLATES_DIR)
