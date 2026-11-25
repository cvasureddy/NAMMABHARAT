# Namma Bhavishy V4 Frontend

A separate React + Vite frontend for the Namma Bhavishy citizen-services project. It does **not** modify your existing `nammabhavishy-v4-frontend` folder.

## Included screens

- Home page and service overview
- Complaint submission form
- Complaint tracking by reference number
- Leaflet / OpenStreetMap issue map with sample markers
- Admin sign-in and complaint status management
- English / Telugu language toggle
- Demo mode so you can explore the interface without a backend

## Requirements

- Node.js 18 or newer
- npm

## Run on Windows

1. Extract `namma-bhavishy-v4-frontend.zip`.
2. Open the extracted folder.
3. Click the folder address bar in File Explorer, type `cmd`, and press Enter.
4. Run:

   ```bash
   npm install
   npm run dev
   ```

5. Open the local URL printed by Vite, usually `http://localhost:5173`.

## Demo mode

The project defaults to demo mode. You can submit a sample complaint, track `NBV-2026-1042`, view sample map markers, and open the admin dashboard.

For demo admin login, enter any email address and any password.

## Connect your Spring Boot backend

1. Copy `.env.example` to `.env`.
2. Set your API URL:

   ```env
   VITE_API_BASE_URL=http://localhost:8080/api
   VITE_DEMO_MODE=false
   ```

3. Restart the Vite server after changing `.env`.

The API helper in `src/api.js` currently expects these endpoints:

| Method | Endpoint | Purpose |
|---|---|---|
| POST | `/auth/send-otp` | Send registration OTP |
| POST | `/auth/verify-otp` | Verify registration OTP |
| POST | `/auth/login` | Admin/user login |
| POST | `/complaints` | Submit a complaint |
| GET | `/complaints/track/{reference}` | Track complaint |
| GET | `/admin/complaints` | List complaints |
| PATCH | `/admin/complaints/{id}` | Update complaint status |

**Important:** These are frontend integration contracts, not proof that your backend already implements them. If your Spring Boot endpoint paths or JSON field names differ, update `src/api.js` and the form payloads to match your backend. Configure CORS on the backend to allow the Vite origin (`http://localhost:5173`).

## Before production

- Replace demo login with real authentication and role-based authorization.
- Implement OTP send/verify screens and server-side OTP expiry / rate limits.
- Upload evidence files through a protected backend endpoint (the current upload control is visual only).
- Load map markers from the backend and validate coordinates.
- Add server-side validation, audit logs, secure token handling, privacy notice, and accessibility testing.
- Never put secrets or email/SMS provider keys in frontend environment variables.
