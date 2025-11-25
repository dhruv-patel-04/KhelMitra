# KhelMitra Backend

This is the backend for the KhelMitra multi-sports scoring app. It provides APIs for user authentication, sports data, teams, and live match scores.

## Setup Instructions

### Prerequisites

- Python 3.8 or higher
- pip (Python package manager)
- PostgreSQL (optional, SQLite is configured by default for development)

### Installation

1. Clone the repository

2. Create a virtual environment:
   ```
   python -m venv venv
   ```

3. Activate the virtual environment:
   - Windows: `venv\Scripts\activate`
   - macOS/Linux: `source venv/bin/activate`

4. Install dependencies:
   ```
   pip install -r requirements.txt
   ```

5. Apply migrations:
   ```
   python manage.py migrate
   ```

6. Create a superuser (admin):
   ```
   python manage.py createsuperuser
   ```

7. Run the development server:
   ```
   python manage.py runserver
   ```

8. Access the admin panel at http://127.0.0.1:8000/admin/

## API Endpoints

### Authentication
- `POST /api/register/` - Register a new user
- `POST /api/login/` - Login and get authentication token
- `GET /api/profile/` - Get user profile
- `PUT /api/profile/` - Update user profile

### Sports & Teams
- `GET /api/sports/` - List all sports
- `GET /api/teams/` - List all teams (can filter by sport_id)

### Matches
- `GET /api/matches/live/` - List all live matches
- `GET /api/matches/upcoming/` - List all upcoming matches
- `GET /api/matches/completed/` - List all completed matches
- `GET /api/matches/{id}/` - Get match details

## Database Configuration

By default, the app uses SQLite for development. To use PostgreSQL:

1. Uncomment the PostgreSQL configuration in `settings.py`
2. Create a PostgreSQL database named `khelmitra_db`
3. Update the database credentials in `settings.py` if needed

## Admin Usage

Use the Django admin panel to:
- Create and manage sports
- Add teams
- Schedule matches
- Update match scores in real-time