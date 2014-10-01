# Makefile to create PDF documents from LaTeX-Files
# Needed software packages: pdflatex, rubber
# License: No copyright, just do what the heck you want with it

PDFLATEX		?= pdflatex -shell-escape -interaction=nonstopmode -file-line-error
BIBTEX			?= bibtex
GHOSTSCRIPT		?= gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite

WORK_DIR		= tmp
PDF_DIR			= pdf
MAIN_FILE   	= tables.tex
NEED_FILES		= settings.tex $(MAIN_FILE)

FINAL_EXT		= .pdf
GEN_EXT			= .generate.tex
GEN_PATTERN		= %$(GEN_EXT)

BUILD_DIR		= ../../tests
BUILD_FILE		= USTest.jar
BUILD_PARA  	= --clearpage
BUILD_EXEC		= $(BUILD_DIR)/$(BUILD_FILE)
MATRIX_DIR		= matrix
MATRIX_PATH		= $(MATRIX_DIR)/feld_*/*.normal.txt

GEN_FILES		= $(wildcard *$(GEN_EXT))
EXCLUDE_FILES	= $(wildcard matrix_col_*$(GEN_EXT))
FILTER_FILES	= $(filter-out $(EXCLUDE_FILES), $(GEN_FILES))

NORMAL_FILES	= $(FILTER_FILES:$(GEN_EXT)=$(FINAL_EXT))
MATRIX_FILES	= $(EXCLUDE_FILES:$(GEN_EXT)=$(FINAL_EXT))
REBUILD_FILES	= $(GEN_FILES:$(GEN_EXT)=$(FINAL_EXT))

all				: pdf

echo			:
				@echo $(REBUILD_FILES)
				@echo
				@echo $(NORMAL_FILES)
				@echo				
				@echo $(MATRIX_FILES)

pdf				: $(REBUILD_FILES)
normal			: $(NORMAL_FILES)
MATRIX			: $(MATRIX_FILES)

build_all		: $(GEN_FILES) 
build_normal	: $(FILTER_FILES)
build_MATRIX	: $(EXCLUDE_FILES)

run_MATRIX_jar	: $(BUILD_EXEC) $(BUILD_DIR)/$(MATRIX_DIR)
				java -jar $(BUILD_EXEC) $(BUILD_PARA) --sOut=./ --mode=filter $(BUILD_DIR)/$(MATRIX_PATH)

MATRIX_col_%$(GEN_EXT): $(BUILD_EXEC) $(BUILD_DIR)/$(MATRIX_DIR)
				make run_MATRIX_jar

%$(GEN_EXT)		: $(BUILD_EXEC) $(BUILD_DIR)/$*
				if [ -d $(abspath $(BUILD_DIR)/$*) ]; then \
					java -jar $(BUILD_EXEC) $(BUILD_PARA) --oL=$* $(BUILD_DIR)/$*/*.txt; \
				else \
					echo "No Dir found"; \
				fi			

%$(FINAL_EXT)	: %$(GEN_EXT) $(NEED_FILES)
				$(PDFLATEX)	-jobname=$* -output-directory=$(WORK_DIR) $(MAIN_FILE);
				$(GHOSTSCRIPT) -sOutputFile=$(PDF_DIR)/$@ $(WORK_DIR)/$@
				
clean			:
				rm -f $(WORK_DIR)/*

cleanall		:
				rm -f $(WORK_DIR)/* $(PDF_DIR)/*

.PHONY			: .FORCE all clean cleanall pdf normal MATRIX build_all build_normal build_MATRIX run_MATRIX_jar
.SILENT			: all

