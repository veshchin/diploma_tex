#!/bin/zsh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
SOURCE_DIR="$ROOT_DIR/source"
RESULTS_DIR="$ROOT_DIR/results"
BUILD_DIR="$SCRIPT_DIR"

mkdir -p "$RESULTS_DIR/chapters"
find "$RESULTS_DIR/chapters" -maxdepth 1 -type f -name '*.pdf' -delete
cp "$SOURCE_DIR/references.bib" "$BUILD_DIR/references.bib"

# Chapters are now thin wrappers that `\input{chapters/...}` their parts.
# When compiling from `.build/chapters`, provide a `chapters/` entry point.
ln -sfn "$SOURCE_DIR/chapters" "$BUILD_DIR/chapters"

compile_chapter() {
  local job="$1"
  local file="$2"

  cd "$BUILD_DIR"
  xelatex -interaction=nonstopmode -halt-on-error -file-line-error -jobname="$job" "\\def\\ChapterFile{$file}\\input{chapter_wrapper.tex}" >/tmp/${job}_pass1.log
  biber "$job" >/tmp/${job}_biber.log
  xelatex -interaction=nonstopmode -halt-on-error -file-line-error -jobname="$job" "\\def\\ChapterFile{$file}\\input{chapter_wrapper.tex}" >/tmp/${job}_pass2.log
  xelatex -interaction=nonstopmode -halt-on-error -file-line-error -jobname="$job" "\\def\\ChapterFile{$file}\\input{chapter_wrapper.tex}" >/tmp/${job}_pass3.log
  cp "$BUILD_DIR/$job.pdf" "$RESULTS_DIR/chapters/"
}

compile_chapter "00_intro" "../../source/chapters/02_intro.tex"
compile_chapter "00_abstract" "../../source/chapters/01_abstract.tex"
compile_chapter "01_chapter01_domain_analysis_part01" "../../source/chapters/04_chapter01_domain_analysis_part01.tex"
compile_chapter "01_chapter01_domain_analysis_part02" "../../source/chapters/04_chapter01_domain_analysis_part02.tex"
compile_chapter "02_chapter02_math_part01" "../../source/chapters/05_chapter02_math_part01.tex"
compile_chapter "02_chapter02_math_part02" "../../source/chapters/05_chapter02_math_part02.tex"
compile_chapter "02_chapter02_math_part03" "../../source/chapters/05_chapter02_math_part03.tex"
compile_chapter "02_chapter02_math_part04" "../../source/chapters/05_chapter02_math_part04.tex"
compile_chapter "02_chapter02_math_part05" "../../source/chapters/05_chapter02_math_part05.tex"
compile_chapter "02_chapter02_math_part06" "../../source/chapters/05_chapter02_math_part06.tex"
compile_chapter "02_chapter02_math_part07" "../../source/chapters/05_chapter02_math_part07.tex"
compile_chapter "02_chapter02_math_part08" "../../source/chapters/05_chapter02_math_part08.tex"
compile_chapter "02_chapter02_math_part09" "../../source/chapters/05_chapter02_math_part09.tex"
compile_chapter "03_chapter03_core_part01" "../../source/chapters/06_chapter03_core_part01.tex"
compile_chapter "03_chapter03_core_part02" "../../source/chapters/06_chapter03_core_part02.tex"
compile_chapter "04_chapter04_ui" "../../source/chapters/07_chapter04_ui.tex"
compile_chapter "05_chapter05_service_part01" "../../source/chapters/08_chapter05_service_part01.tex"
compile_chapter "05_chapter05_service_part02" "../../source/chapters/08_chapter05_service_part02.tex"
compile_chapter "05_chapter05_service_part03" "../../source/chapters/08_chapter05_service_part03.tex"
compile_chapter "06_conclusion" "../../source/chapters/09_conclusion.tex"
compile_chapter "07_appendices" "../../source/chapters/10_appendices.tex"
