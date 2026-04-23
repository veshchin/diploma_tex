# Сборка и раскладка файлов (канон)

## Назначение

Этот файл описывает, как собирать проект и куда должны попадать артефакты.
Параллельно держать в голове `AGENTS/AGENTS.md` и карту `AGENTS/PROJECT_SUMMARY.md`.

## Структура

- `source/` — все редактируемые `.tex` и `references.bib`.
- `data/theory/` — теоретические материалы (не участвуют в сборке LaTeX).
- `results/` — готовые PDF-результаты.
- `.build/` — временная зона (промежуточные PDF, логи, скрипты).

## Выходы сборки

- `results/diploma.pdf` — итоговый полный файл работы.
- `results/chapters/*.pdf` — отдельные PDF по фрагментам документа (включая `*_partNN.pdf`).
- В корне проекта не должно оставаться новых PDF-артефактов.

Текущее ожидание по `results/chapters/` (под актуальное разбиение `*_part*.tex`):

- `00_abstract.pdf`, `00_intro.pdf`;
- `01_chapter01_domain_analysis_part01.pdf`, `01_chapter01_domain_analysis_part02.pdf`;
- `02_chapter02_math_part01.pdf` ... `02_chapter02_math_part09.pdf`;
- `03_chapter03_core_part01.pdf`, `03_chapter03_core_part02.pdf`;
- `04_chapter04_ui.pdf`;
- `05_chapter05_service_part01.pdf` ... `05_chapter05_service_part03.pdf`;
- `06_conclusion.pdf`, `07_appendices.pdf`.

## Как собирать (локально)

- Полная сборка (XeLaTeX + Biber): `.build/build.sh`.
- Сборка PDF-фрагментов: `.build/chapters/build_chapters.sh`.
- Техническая проверка без PDF: `xelatex -no-pdf` с `-output-directory` в `.build/check_*`.

## Промежуточные каталоги

- Полная сборка держит временные файлы в `.build/full/`.
- Сборка фрагментов держит временные файлы в `.build/chapters/`.

## Важные нюансы

- `.build/build.sh` копирует `source/` в `.build/full/` и собирает там, чтобы не засорять `source/`.
- `.build/chapters/build_chapters.sh` компилирует набор фрагментов, заданный явно; при добавлении/переименовании `*_part*.tex` список нужно обновлять.

## Запрещённые вещи

- Нельзя возвращать `Taskfile.yml` как основную точку входа.
- Нельзя оставлять `main.pdf` или `Diploma.pdf` в корне проекта.
- Нельзя складывать промежуточные файлы в `results/`.
- Нельзя смешивать исходники и собранные PDF в одном каталоге.
