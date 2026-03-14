# LoginApp - Project Memory

## Overview
Full-stack authentication app built with React (Vite) + FastAPI + PostgreSQL.
Deployed on Render. JWT-based auth with bcrypt password hashing.

---

## Project Structure

```
LoginApp/
├── .gitignore
├── render.yaml              ← Render deployment config
├── run.sh                   ← Script to start both servers locally
├── Structure.sh             ← Full implementation plan (comments)
├── Memory.md                ← This file
├── Requirements.txt         ← Original project requirements
├── backend/
│   ├── .env                 ← DB URL, SECRET_KEY, ALGORITHM, token expiry
│   ├── requirements.txt     ← Python dependencies
│   └── app/
│       ├── __init__.py
│       ├── main.py          ← FastAPI app entry point + CORS middleware
│       ├── database.py      ← SQLAlchemy engine, SessionLocal, Base, get_db
│       ├── models.py        ← User ORM model (id, email, hashed_password)
│       ├── schemas.py       ← Pydantic schemas: UserCreate, UserLogin, Token
│       ├── auth.py          ← bcrypt hash/verify (direct) + JWT create_access_token
│       └── routers/
│           ├── __init__.py
│           └── auth.py      ← POST /auth/signup, POST /auth/login
└── frontend/
    ├── .env                 ← VITE_API_URL
    ├── package.json
    ├── vite.config.js
    ├── tailwind.config.js
    ├── postcss.config.js
    ├── index.html
    └── src/
        ├── index.css        ← Tailwind directives
        ├── main.jsx         ← React entry point
        ├── App.jsx          ← React Router routes (/, /login, /signup, /dashboard)
        ├── api/
        │   └── auth.js      ← axios: signup(), login() functions
        ├── components/
        │   └── InputField.jsx ← Reusable form input with error display
        └── pages/
            ├── Login.jsx    ← Login form with validation + JWT storage
            ├── Signup.jsx   ← Signup form with confirm password + validation
            └── Dashboard.jsx ← Protected page shown after login, has logout
```

---

## Tech Stack

| Layer      | Technology                                  |
|------------|---------------------------------------------|
| Frontend   | React 18, Vite, TailwindCSS, Axios          |
| Backend    | Python FastAPI, Uvicorn                     |
| Auth       | JWT (python-jose), bcrypt 4.0.1 (direct)   |
| ORM        | SQLAlchemy                                  |
| Database   | PostgreSQL (psycopg2-binary)               |
| Validation | Pydantic v2 (with EmailStr)                 |
| Deploy     | Render (Web Service + Static Site)          |

---

## Backend API Endpoints

| Method | Route        | Description                         |
|--------|--------------|-------------------------------------|
| GET    | /            | Health check — returns running status |
| POST   | /auth/signup | Register new user, returns JWT token |
| POST   | /auth/login  | Authenticate user, returns JWT token |

---

## Environment Variables

### backend/.env
```
DATABASE_URL=postgresql://postgres:1234@localhost:5432/loginapp
SECRET_KEY=change-this-to-a-long-random-secret-key-in-production
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30
```

### frontend/.env
```
VITE_API_URL=http://localhost:8000
```

---

## How to Run Locally

```bash
cd C:/Users/IQTech/Desktop/LoginApp
bash run.sh
```

### What run.sh does:
1. Creates Python virtual environment in `backend/venv/` (first time only)
2. Activates venv and installs pip dependencies
3. Starts FastAPI on http://localhost:8000
4. Installs npm packages in `frontend/node_modules/` (first time only)
5. Starts Vite dev server on http://localhost:5173
6. Press Ctrl+C to stop both servers cleanly

### Live URLs after startup:
- Frontend  → http://localhost:5173  (may shift to 5174/5175 if port is busy)
- Backend   → http://localhost:8000
- Swagger   → http://localhost:8000/docs

---

## PostgreSQL Setup (Local)

- Version installed: PostgreSQL 18
- Located at: `C:/Program Files/PostgreSQL/18/`
- psql binary: `C:/Program Files/PostgreSQL/18/bin/psql.exe`
- Username: `postgres` | Password: `1234` | Port: `5432`
- Database created: `loginapp`

### To create the DB manually (if needed):
```bash
PGPASSWORD=1234 "C:/Program Files/PostgreSQL/18/bin/psql.exe" -U postgres -h localhost -c "CREATE DATABASE loginapp;"
```

### Tables:
- Auto-created on first backend startup via `Base.metadata.create_all()`
- Table: `users` (id, email, hashed_password)

---

## Render Deployment

Configured via `render.yaml` at project root.

### Backend (Web Service)
- Root dir  : `backend/`
- Build cmd : `pip install -r requirements.txt`
- Start cmd : `uvicorn app.main:app --host 0.0.0.0 --port $PORT`
- Env vars  : `SECRET_KEY` (auto-generated), `DATABASE_URL` (from Render PostgreSQL add-on)

### Frontend (Static Site)
- Root dir       : `frontend/`
- Build cmd      : `npm install && npm run build`
- Publish dir    : `dist`
- Env var        : `VITE_API_URL` → set to deployed backend URL

### Steps to deploy:
1. Push code to GitHub
2. Go to Render dashboard → New → Blueprint
3. Connect the GitHub repo
4. Render reads `render.yaml` and sets up all services automatically
5. Update `VITE_API_URL` in frontend service to the actual backend URL (e.g. https://loginapp-backend.onrender.com)

---

## Issues Encountered & Resolutions

### Issue 1 — Backend crash on startup (PostgreSQL not running)
- **Error:** `psycopg2.OperationalError: connection refused at localhost:5432`
- **Cause:** PostgreSQL was not installed on local machine
- **Resolution:** Installed PostgreSQL 18 locally, created `loginapp` database, updated `backend/.env`
- **Status:** Resolved

### Issue 2 — Database did not exist
- **Error:** `FATAL: database "loginapp" does not exist`
- **Cause:** PostgreSQL was installed but the `loginapp` database had not been created
- **Resolution:** Created the database via psql:
  ```bash
  PGPASSWORD=1234 "C:/Program Files/PostgreSQL/18/bin/psql.exe" -U postgres -h localhost -c "CREATE DATABASE loginapp;"
  ```
- **Status:** Resolved

### Issue 3 — bcrypt/passlib incompatibility (500 on /auth/signup)
- **Error:** `AttributeError: module 'bcrypt' has no attribute '__about__'` + `ValueError: password cannot be longer than 72 bytes`
- **Cause:** `passlib` is incompatible with `bcrypt 4.x` — passlib's internal wrap-bug detection fails on the newer bcrypt API
- **Resolution:** Replaced `passlib` with direct `bcrypt` calls in `backend/app/auth.py`. Removed `passlib[bcrypt]` from `requirements.txt`
- **Files changed:**
  - `backend/app/auth.py` — removed passlib, now uses `bcrypt.hashpw()` and `bcrypt.checkpw()` directly
  - `backend/requirements.txt` — removed `passlib[bcrypt]`, pinned `bcrypt==4.0.1`
- **Status:** Resolved

---

## Test Results (All Passing)

| Test                              | Expected                        | Result |
|-----------------------------------|---------------------------------|--------|
| GET /                             | 200 + running message           | ✅     |
| POST /auth/signup (valid)         | 201 + JWT token                 | ✅     |
| POST /auth/login (correct creds)  | 200 + JWT token                 | ✅     |
| POST /auth/signup (duplicate email) | 400 Email already registered  | ✅     |
| POST /auth/login (wrong password) | 401 Invalid email or password   | ✅     |
| POST /auth/signup (invalid email) | 422 Validation error            | ✅     |
| POST /auth/signup (short password)| 422 Password min 6 chars        | ✅     |
| Frontend (http://localhost:5175)  | 200 OK                          | ✅     |

---

## Key Notes

- JWT token is stored in `localStorage` under the key `token`
- CORS allows `http://localhost:5173` (dev) and the Render frontend URL (prod)
- Password minimum length is 6 characters — validated on both frontend (JS) and backend (Pydantic)
- `Base.metadata.create_all()` in `main.py` auto-creates DB tables on every startup
- Frontend redirects `/` → `/login` automatically
- After login or signup, user is redirected to `/dashboard`
- Logout removes token from `localStorage` and redirects to `/login`
- Do NOT use `passlib` with `bcrypt 4.x` — use `bcrypt` directly
