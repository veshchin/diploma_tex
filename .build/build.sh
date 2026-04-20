#!/bin/zsh
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SOURCE_DIR="$ROOT_DIR/source"
FULL_BUILD_DIR="$ROOT_DIR/.build/full"
RESULTS_DIR="$ROOT_DIR/results"

rm -rf "$FULL_BUILD_DIR"
mkdir -p "$FULL_BUILD_DIR" "$RESULTS_DIR/chapters"

cp "$SOURCE_DIR/main.tex" "$FULL_BUILD_DIR/main.tex"
cp "$SOURCE_DIR/preamble.tex" "$FULL_BUILD_DIR/preamble.tex"
cp "$SOURCE_DIR/references.bib" "$FULL_BUILD_DIR/references.bib"
cp -R "$SOURCE_DIR/chapters" "$FULL_BUILD_DIR/"

cd "$FULL_BUILD_DIR"

xelatex -interaction=nonstopmode -halt-on-error -file-line-error -jobname=main main.tex
biber main
xelatex -interaction=nonstopmode -halt-on-error -file-line-error -jobname=main main.tex
xelatex -interaction=nonstopmode -halt-on-error -file-line-error -jobname=main main.tex

cp "$FULL_BUILD_DIR/main.pdf" "$RESULTS_DIR/diploma.pdf"

"$ROOT_DIR/.build/chapters/build_chapters.sh"
