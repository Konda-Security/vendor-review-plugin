#!/usr/bin/env bash
# Render a TPRM record (markdown) to PDF with a fixed set of pandoc options.
#
# Usage: make-pdf.sh <path/to/record>.md
#
# The path must be relative to the current directory. Writes the PDF next to
# the markdown file and prints its path. The skills pre-approve this script
# rather than pandoc itself, because pandoc flags such as --filter and
# --lua-filter run arbitrary programs. Raw TeX and HTML are disabled so text
# in a record can't pull local files into the PDF.
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: $(basename "$0") <path/to/record>.md" >&2
  exit 2
fi

input=$1

case "$input" in
  *..*)
    echo "error: path must not contain '..': $input" >&2
    exit 2
    ;;
  -* | /* | '~'*)
    echo "error: expected a path relative to the current directory, got: $input" >&2
    exit 2
    ;;
  *.md) ;;
  *)
    echo "error: expected a .md file, got: $input" >&2
    exit 2
    ;;
esac

if [[ ! -f "$input" ]]; then
  echo "error: no such file: $input" >&2
  exit 2
fi

if ! command -v pandoc >/dev/null 2>&1; then
  echo "error: pandoc is not installed (macOS: brew install pandoc)" >&2
  exit 3
fi

output="${input%.md}.pdf"

for engine in xelatex pdflatex wkhtmltopdf; do
  command -v "$engine" >/dev/null 2>&1 || continue
  pandoc "$input" \
    --from=markdown-raw_tex-raw_html-raw_attribute \
    --output="$output" \
    --pdf-engine="$engine" \
    -V geometry:margin=1in \
    -V fontsize=11pt \
    -V colorlinks=true
  echo "$output"
  exit 0
done

echo "error: no PDF engine found; install xelatex, pdflatex, or wkhtmltopdf" >&2
exit 3
