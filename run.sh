#!/bin/bash

# ============================================================
#  LoginApp - Start Script
#  Starts both Backend (FastAPI) and Frontend (React + Vite)
# ============================================================

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKEND_DIR="$ROOT_DIR/backend"
FRONTEND_DIR="$ROOT_DIR/frontend"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo ""
echo "============================================"
echo "         LoginApp - Starting Up"
echo "============================================"
echo ""

# ── Backend Setup ─────────────────────────────

echo -e "${YELLOW}[Backend] Setting up...${NC}"
cd "$BACKEND_DIR"

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
  echo -e "${YELLOW}[Backend] Creating virtual environment...${NC}"
  python -m venv venv
fi

# Activate virtual environment
if [ -f "venv/Scripts/activate" ]; then
  source venv/Scripts/activate       # Windows (Git Bash)
else
  source venv/bin/activate           # macOS / Linux
fi

# Install dependencies
echo -e "${YELLOW}[Backend] Installing dependencies...${NC}"
pip install -r requirements.txt -q

echo -e "${GREEN}[Backend] Starting FastAPI on http://localhost:8000${NC}"
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000 &
BACKEND_PID=$!

# ── Frontend Setup ────────────────────────────

echo ""
echo -e "${YELLOW}[Frontend] Setting up...${NC}"
cd "$FRONTEND_DIR"

# Install node modules if not already installed
if [ ! -d "node_modules" ]; then
  echo -e "${YELLOW}[Frontend] Installing dependencies...${NC}"
  npm install
fi

echo -e "${GREEN}[Frontend] Starting React on http://localhost:5173${NC}"
npm run dev &
FRONTEND_PID=$!

# ── Summary ───────────────────────────────────

echo ""
echo "============================================"
echo -e "  ${GREEN}Both servers are running!${NC}"
echo "  Backend  -> http://localhost:8000"
echo "  Frontend -> http://localhost:5173"
echo "  API Docs -> http://localhost:8000/docs"
echo ""
echo "  Press Ctrl+C to stop both servers."
echo "============================================"
echo ""

# ── Graceful Shutdown ─────────────────────────

cleanup() {
  echo ""
  echo -e "${RED}Shutting down servers...${NC}"
  kill $BACKEND_PID 2>/dev/null
  kill $FRONTEND_PID 2>/dev/null
  echo -e "${GREEN}All servers stopped. Goodbye!${NC}"
  exit 0
}

trap cleanup SIGINT SIGTERM

# Keep script alive until Ctrl+C
wait
