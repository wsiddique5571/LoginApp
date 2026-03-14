# ============================================================
# Implementation Plan: Full-Stack Auth App (React + FastAPI)
# ============================================================

# -----------------------------------------------
# Phase 1 — Project Scaffolding
# -----------------------------------------------
# - Initialize frontend/ with Vite + React
# - Create backend/ as a Python package
# - Set up .gitignore, root README.md

# -----------------------------------------------
# Phase 2 — Backend (FastAPI)
# -----------------------------------------------

# Folder Structure:
# backend/
# ├── app/
# │   ├── main.py          # FastAPI app, CORS config
# │   ├── database.py      # SQLAlchemy engine + session
# │   ├── models.py        # User ORM model
# │   ├── schemas.py       # Pydantic schemas (signup/login/token)
# │   ├── auth.py          # JWT creation, password hashing (bcrypt)
# │   └── routers/
# │       └── auth.py      # /signup, /login endpoints
# ├── .env                 # DATABASE_URL, SECRET_KEY, ALGORITHM
# └── requirements.txt     # fastapi, uvicorn, sqlalchemy, psycopg2, etc.

# Key Implementation Steps:
# 1. database.py  — create SQLAlchemy engine from DATABASE_URL, SessionLocal, Base
# 2. models.py    — User model with id, email, hashed_password
# 3. schemas.py   — UserCreate, UserLogin, Token Pydantic models with email/password validation
# 4. auth.py      — hash_password, verify_password (bcrypt), create_access_token (PyJWT)
# 5. routers/auth.py — POST /signup (check duplicate email -> hash -> save)
#                      POST /login (verify credentials -> return JWT)
# 6. main.py      — mount router, enable CORS for frontend origin

# -----------------------------------------------
# Phase 3 — Frontend (React + Vite)
# -----------------------------------------------

# Folder Structure:
# frontend/
# ├── src/
# │   ├── pages/
# │   │   ├── Login.jsx
# │   │   └── Signup.jsx
# │   ├── components/
# │   │   └── InputField.jsx
# │   ├── api/
# │   │   └── auth.js      # axios calls to backend
# │   ├── App.jsx           # React Router routes
# │   └── main.jsx
# ├── .env                  # VITE_API_URL
# ├── tailwind.config.js
# └── package.json

# Key Implementation Steps:
# 1. Install dependencies: react-router-dom, axios, tailwindcss
# 2. api/auth.js   — signup(data) and login(data) axios functions
# 3. Login.jsx     — controlled form, validation, error display, store JWT in localStorage
# 4. Signup.jsx    — controlled form, validation, error display, redirect after success
# 5. Responsive + mobile-first Tailwind styling
# 6. React Router v6 with redirect to dashboard after login

# -----------------------------------------------
# Phase 4 — Environment Variables
# -----------------------------------------------

# backend/.env:
#   DATABASE_URL=postgresql://user:password@host:port/dbname
#   SECRET_KEY=your_super_secret_key
#   ALGORITHM=HS256
#   ACCESS_TOKEN_EXPIRE_MINUTES=30

# frontend/.env:
#   VITE_API_URL=http://localhost:8000

# -----------------------------------------------
# Phase 5 — Render Deployment
# -----------------------------------------------

# Backend (Web Service on Render):
#   - Build command : pip install -r requirements.txt
#   - Start command : uvicorn app.main:app --host 0.0.0.0 --port $PORT
#   - Add PostgreSQL add-on via Render dashboard
#   - Set DATABASE_URL env var from Render PostgreSQL connection string
#   - Set SECRET_KEY and other env vars in Render dashboard

# Frontend (Static Site on Render):
#   - Build command     : npm run build
#   - Publish directory : dist
#   - Set VITE_API_URL to the deployed backend URL in Render dashboard

# -----------------------------------------------
# Implementation Order
# -----------------------------------------------
# Step 1 — Backend scaffolding + DB models
# Step 2 — Auth logic (password hashing + JWT)
# Step 3 — API endpoints + test with curl / Postman
# Step 4 — Frontend scaffold + Tailwind setup
# Step 5 — Login & Signup pages with API integration
# Step 6 — End-to-end local test
# Step 7 — Deploy backend and frontend to Render
