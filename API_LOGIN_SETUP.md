# Asset Management System - API Setup Instructions

## Step 1: Install Backend Dependencies

Open PowerShell/Terminal and navigate to the database folder:

```bash
cd lib/database
npm install
```

This will install: express, mysql2, cors, @node-rs/argon2

## Step 2: Start the Backend Server

```bash
node app.js
```

You should see: "Server is running at 3000"

## Step 3: Create Test Users

**Option A: Create users directly in database**

First, get hashed passwords by visiting:
- http://localhost:3000/api/password/student123
- http://localhost:3000/api/password/lecturer123  
- http://localhost:3000/api/password/staff123

Then insert users in MySQL:
```sql
INSERT INTO users (username, password, role) VALUES 
('student1', 'YOUR_HASHED_PASSWORD_HERE', 'Student'),
('lecturer1', 'YOUR_HASHED_PASSWORD_HERE', 'Lecturer'),
('staff1', 'YOUR_HASHED_PASSWORD_HERE', 'Staff');
```

**Option B: Use the register API**

Using curl or Postman:
```bash
curl -X POST http://localhost:3000/api/register \
  -H "Content-Type: application/json" \
  -d '{"username": "student1", "password": "student123", "role": "Student"}'

curl -X POST http://localhost:3000/api/register \
  -H "Content-Type: application/json" \
  -d '{"username": "lecturer1", "password": "lecturer123", "role": "Lecturer"}'

curl -X POST http://localhost:3000/api/register \
  -H "Content-Type: application/json" \
  -d '{"username": "staff1", "password": "staff123", "role": "Staff"}'
```

## Step 4: Test the Login

1. Run your Flutter app: `flutter run`
2. Use the login page with these credentials:
   - Username: `student1`, Password: `student123`
   - Username: `lecturer1`, Password: `lecturer123`
   - Username: `staff1`, Password: `staff123`

## Step 5: Verify API is Working

Test the login API directly:
```bash
curl -X POST http://localhost:3000/api/login \
  -H "Content-Type: application/json" \
  -d '{"username": "student1", "password": "student123"}'
```

Expected response:
```json
{
  "token": "simple_token_1_1699077600000",
  "user": {
    "user_id": 1,
    "username": "student1",
    "role": "Student",
    "profile_image": null
  }
}
```

## Troubleshooting

1. **Server won't start**: Make sure port 3000 is not in use
2. **Database connection error**: Check MySQL is running and credentials in db.js
3. **CORS errors**: Make sure cors package is installed
4. **Login fails**: Verify users exist and passwords are hashed correctly

## What Changed in Your Login

Your login.dart now:
- Sends username/password to API instead of hardcoded values
- Shows loading spinner during API call
- Displays proper error messages from API
- Routes based on user role from database
- Maintains your original UI design