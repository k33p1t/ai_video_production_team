#!/usr/bin/env bash
# Video Production Team — Setup Helper
# Run with:  bash scripts/setup.sh   or   make setup

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}"
echo "=============================================="
echo "  Video Production Team — Setup Helper"
echo "=============================================="
echo -e "${NC}"

# ------------------------------------------------
# 1. Basic environment checks
# ------------------------------------------------
echo -e "${YELLOW}[1/6] Checking required tools...${NC}"

check_cmd() {
  if command -v "$1" >/dev/null 2>&1; then
    echo -e "  ${GREEN}✓${NC} $1 found"
  else
    echo -e "  ${RED}✗${NC} $1 not found"
    return 1
  fi
}

MISSING=0
check_cmd git      || MISSING=1
check_cmd python3  || MISSING=1
check_cmd zip      || MISSING=1

if [[ $MISSING -eq 1 ]]; then
  echo -e "${RED}Some required tools are missing. Please install them and re-run.${NC}"
  exit 1
fi

# Optional but useful
command -v tree >/dev/null 2>&1 && echo -e "  ${GREEN}✓${NC} tree found" || echo -e "  ${YELLOW}○${NC} tree not found (optional)"
command -v jq   >/dev/null 2>&1 && echo -e "  ${GREEN}✓${NC} jq found"   || echo -e "  ${YELLOW}○${NC} jq not found (optional)"

# ------------------------------------------------
# 2. GPU check (if available)
# ------------------------------------------------
echo ""
echo -e "${YELLOW}[2/6] Checking GPU (nvidia-smi)...${NC}"
if command -v nvidia-smi >/dev/null 2>&1; then
  nvidia-smi --query-gpu=name,memory.total,driver_version --format=csv,noheader
  echo -e "  ${GREEN}✓${NC} nvidia-smi available — record this output for model sizing"
else
  echo -e "  ${YELLOW}○${NC} nvidia-smi not found (normal if running on a non-GPU machine)"
fi

# ------------------------------------------------
# 3. Create recommended clean structure
# ------------------------------------------------
echo ""
echo -e "${YELLOW}[3/6] Creating recommended repository structure...${NC}"

mkdir -p agents/{01-supervisor,02-trend-strategist,03-trends-researcher,04-storyboard-creator,05-scriptwriter,06-voice-over,07-quality-assurance,08-publishing-monitor,workers/video-assembly}
mkdir -p architecture docs schemas templates/project-skeleton/{audio,logs,publishing,qa,script,storyboard,trends,video}
mkdir -p scripts .github/workflows

echo -e "  ${GREEN}✓${NC} Folders created"

# ------------------------------------------------
# 4. Copy soul.md files into the clean layout (if source exists)
# ------------------------------------------------
echo ""
echo -e "${YELLOW}[4/6] Organizing agent files...${NC}"

# Map old numbered folders → new clean names
declare -A AGENT_MAP=(
  ["01-supervisor-project-orchestrator"]="01-supervisor"
  ["02-trend-strategist-concept-generator"]="02-trend-strategist"
  ["03-trends-researcher-intelligence-analyst"]="03-trends-researcher"
  ["04-storyboard-creator-visual-planner"]="04-storyboard-creator"
  ["05-scriptwriter-audience-engagement"]="05-scriptwriter"
  ["06-voiceover-audio-production"]="06-voice-over"
  ["07-quality-assurance-final-review"]="07-quality-assurance"
  ["08-publishing-metadata-performance-monitor"]="08-publishing-monitor"
)

for old in "${!AGENT_MAP[@]}"; do
  new="${AGENT_MAP[$old]}"
  if [[ -f "$old/soul.md" ]]; then
    cp "$old/soul.md" "agents/$new/soul.md"
    echo -e "  ${GREEN}✓${NC} agents/$new/soul.md"
  fi
done

if [[ -f "workers/video-assembly-editor/soul.md" ]]; then
  cp "workers/video-assembly-editor/soul.md" "agents/workers/video-assembly/soul.md"
  echo -e "  ${GREEN}✓${NC} agents/workers/video-assembly/soul.md"
fi

# Architecture & docs
[[ -d "00-architecture" ]] && cp 00-architecture/* architecture/ 2>/dev/null || true
[[ -d "docs" ]] && cp docs/* docs/ 2>/dev/null || true
[[ -d "schemas" ]] && cp schemas/* schemas/ 2>/dev/null || true

echo -e "  ${GREEN}✓${NC} Documentation and schemas in place"

# ------------------------------------------------
# 5. Create .gitignore if missing
# ------------------------------------------------
echo ""
echo -e "${YELLOW}[5/6] Ensuring .gitignore exists...${NC}"

if [[ ! -f .gitignore ]]; then
  cat > .gitignore << 'EOF'
# Python
__pycache__/
*.py[cod]
*.egg-info/
.venv/
venv/
.env

# OS
.DS_Store
Thumbs.db

# IDE
.vscode/
.idea/
*.swp

# Runtime data — never commit real projects or media
projects/
*.sqlite
*.db
logs/*.jsonl
*.wav
*.mp3
*.mp4
*.mov
*.mkv

# Secrets
.env*
secrets/
credentials/
*.pem
*.key
*.token
EOF
  echo -e "  ${GREEN}✓${NC} .gitignore created"
else
  echo -e "  ${GREEN}✓${NC} .gitignore already exists"
fi

# ------------------------------------------------
# 6. Summary
# ------------------------------------------------
echo ""
echo -e "${YELLOW}[6/6] Summary${NC}"
echo ""
echo -e "${GREEN}Setup complete.${NC}"
echo ""
echo "Next steps:"
echo "  1. Review architecture/ and docs/STEP_BY_STEP_SETUP.md"
echo "  2. Run:  make agents          # verify all soul.md files"
echo "  3. Run:  make check-schemas   # validate JSON schemas"
echo "  4. Initialize git (if not already):"
echo "       git init"
echo "       git add ."
echo "       git commit -m \"Initial commit: AI video production team\""
echo "  5. Create the GitHub repository (see docs or previous instructions)"
echo ""
echo -e "${BLUE}Local-first tip:${NC} Keep the Supervisor on a low-power always-on machine."
echo "                 Use the gaming desktop only for LLM inference and rendering."
echo ""
