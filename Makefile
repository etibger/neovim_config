UV ?= uv
DOCS_RUN = $(UV) run --no-project --with-requirements requirements-docs.txt

.PHONY: docs-build docs-serve cheat-sheet

docs-build: cheat-sheet
	$(DOCS_RUN) python -m mkdocs build --strict

docs-serve: cheat-sheet
	$(DOCS_RUN) python -m mkdocs serve

cheat-sheet:
	$(DOCS_RUN) python scripts/build-cheat-sheet.py
