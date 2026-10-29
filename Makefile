# Video Production Team — Makefile
# Usage: make <target>

.PHONY: help setup structure check-schemas clean zip tree agents

# Default target
help:
	@echo ""
	@echo "Video Production Team"
	@echo "====================="
	@echo ""
	@echo "Available targets:"
	@echo "  make setup          - Run the setup script (creates folders, checks tools)"
	@echo "  make structure      - Create the recommended clean repository layout"
	@echo "  make check-schemas  - Validate all JSON schemas"
	@echo "  make tree           - Show the current folder tree"
	@echo "  make agents         - List all agent soul.md files"
	@echo "  make zip            - Rebuild the distribution zip"
	@echo "  make clean          - Remove temporary files and zip"
	@echo ""

# Run the interactive setup helper
setup:
	@bash scripts/setup.sh

# Create the cleaner GitHub-oriented structure (agents/, architecture/, etc.)
structure:
	@echo "Creating clean repository structure..."
	@mkdir -p agents/{01-supervisor,02-trend-strategist,03-trends-researcher,04-storyboard-creator,05-scriptwriter,06-voice-over,07-quality-assurance,08-publishing-monitor,workers/video-assembly}
	@mkdir -p architecture docs schemas templates/project-skeleton/{audio,logs,publishing,qa,script,storyboard,trends,video} scripts .github/workflows
	@echo "Done. You can now copy the soul.md and documentation files into the new folders."

# Basic JSON schema syntax check
check-schemas:
	@echo "Checking schemas..."
	@python3 -c "import json,sys,glob; \
	[json.load(open(f)) for f in glob.glob('schemas/*.json')]; \
	print('All schemas are valid JSON.')"

# Show folder tree (requires tree command)
tree:
	@command -v tree >/dev/null 2>&1 && tree -L 3 --dirsfirst || find . -maxdepth 3 -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'

# List all agent definition files
agents:
	@echo "Agent soul.md files:"
	@find . -name "soul.md" | sort

# Rebuild the distribution package
zip:
	@cd .. && rm -f video_production_team_complete.zip && \
	zip -r video_production_team_complete.zip video_production_team/ -x "*.git*" && \
	echo "Created ../video_production_team_complete.zip"

# Clean temporary artifacts
clean:
	@rm -f ../video_production_team_complete.zip
	@find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true
	@echo "Cleaned."
