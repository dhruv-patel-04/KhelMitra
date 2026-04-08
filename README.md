# KhelMitra

KhelMitra is a multi-app sports scoring platform with:

- A Django REST backend for auth, sports, teams, matches, and scoring
- A Flutter fan app for browsing live, upcoming, and completed matches
- A Flutter referee app for posting live score updates (referee-only)

The current implementation is optimized for local development and testing.

## Project Structure

```text
KhelMitra/
|- khelmitra_backend/      # Django + DRF API server
|- khelmitra_frontend/     # Flutter app for fans/users
|- khelmitra_referee/      # Flutter app for referees
`- README.md
```

## Core Features

- User registration and login with token authentication
- User profile view/update
- Sports and teams listing
- Match listing by status: live, upcoming, completed
- Match details with score history
- Live Match Scores
- Referee-only endpoint to post score updates
- Admin panel for managing sports, teams, matches, and profiles

## Architecture Overview

1. Backend serves REST APIs under `/api/`.
2. Frontend app consumes APIs for user and match experiences.
3. Referee app authenticates with the same backend and posts score updates.
4. When a score is posted, backend auto-switches match status to `live` (if not already live).

## Tech Stack

- Backend: Python, Django, Django REST Framework, Token Auth
- Database: PostgreSQL (currently configured in settings)
- Mobile Apps: Flutter + Provider (frontend), Flutter (referee)
- Media: Django media storage for profile pictures, team logos, sport icons

## Prerequisites

Install these before setup:

- Python 3.10+
- PostgreSQL 14+ (or adjust backend settings to SQLite)
- Flutter SDK (stable)
- Android Studio or VS Code Flutter toolchain

## 1) Backend Setup (Django)

From `khelmitra_backend`:

```bash
python -m venv venv
```

Activate venv:

- Windows (PowerShell):

```powershell
venv\Scripts\Activate.ps1
```

- macOS/Linux:

```bash
source venv/bin/activate
```

Install dependencies:

```bash
pip install -r requirements.txt
```

### Database Configuration

Current `khelmitra_backend/khelmitra/settings.py` is configured for PostgreSQL:

- DB name: `khelmitra_db`
- User: `YOUR_POSTGRESQL_USERNAME`
- Password: `YOUR_POSTGRESQL_PASSWORD`
- Host: `localhost`
- Port: `5432`

Update these values before running in your environment.

Run migrations and create admin:

```bash
python manage.py migrate
python manage.py createsuperuser
```

Start backend:

```bash
python manage.py runserver
```

Backend URLs:

- API root prefix: `http://127.0.0.1:8000/api/`
- Admin: `http://127.0.0.1:8000/admin/`

## 2) Frontend Setup (Flutter user app)

From `khelmitra_frontend`:

```bash
flutter pub get
flutter run
```

The current frontend API base URL in code:

- `http://127.0.0.1:8000/api`

If running on Android emulator, use `http://10.0.2.2:8000/api`.
If running on a physical device, use your machine LAN IP.

## 3) Referee App Setup (Flutter referee app)

From `khelmitra_referee`:

```bash
flutter pub get
flutter run
```

Referee app supports configurable server URL from login screen.

Default base URLs seen in code:

- App state default: `http://10.0.2.2:8000`
- Login field default: `http://localhost:8000`

Use a user account with `is_referee = true` in backend profile to post scores.

## API Endpoints

### Auth and Profile

- `POST /api/register/`
- `POST /api/login/`
- `POST /api/token-auth/`
- `GET /api/profile/`
- `PUT /api/profile/`

### Sports and Teams

- `GET /api/sports/`
- `GET /api/teams/`
- `GET /api/teams/?sport_id=<id>`

### Matches and Scoring

- `GET /api/matches/live/`
- `GET /api/matches/upcoming/`
- `GET /api/matches/completed/`
- `GET /api/matches/<id>/`
- `POST /api/matches/<id>/update_score/` (authenticated referee only)

### Example: Update Score

Headers:

- `Authorization: Token <token>`
- `Content-Type: application/json`

Body:

```json
{
	"team_a_score": 21,
	"team_b_score": 18,
	"period": "2nd Half"
}
```

## Referee Workflow (Current Behavior)

- Referee logs in from referee app
- Referee sees live Kabaddi matches (default sport filter in app)
- Referee opens match and posts score events
- App polls match detail every 5 seconds and displays server latest score
- Each submit writes a new `Score` record for match history

## Seeding Data for Local Testing

Use Django admin to create initial data in this order:

1. Sports
2. Teams (linked to sports)
3. Matches (team A, team B, status, start time)
4. Optional initial scores
5. Users and profiles

To enable a referee account:

1. Create user (register API or admin)
2. Open related `UserProfile` in admin
3. Set `is_referee = true`

## Known Notes

- CORS is currently wide open (`CORS_ALLOW_ALL_ORIGINS = True`) for development.
- Backend default permission is authenticated, but many list/detail endpoints explicitly allow public read access.
- Media upload paths are configured; ensure media URLs are reachable in development.
- `db.sqlite3` exists in repository, but active settings currently point to PostgreSQL.

## Useful Development Commands

Backend:

```bash
python manage.py makemigrations
python manage.py migrate
python manage.py runserver
```

Flutter apps:

```bash
flutter pub get
flutter run
flutter test
```

## Suggested Next Improvements

- Add environment-based configuration (`.env`) for backend DB and CORS
- Add API docs (Swagger/OpenAPI)
- Add CI checks for backend and both Flutter apps
- Add role-based admin tooling for referee management
- Add docker-compose for one-command local startup