-- OptiSked AI migration 002
-- Adds class-specific leave/teacher attendance metadata and editable student attendance.
-- app.py also performs these compatibility changes automatically at startup for SQLite.

ALTER TABLE leaves ADD COLUMN schedule_id INTEGER;
ALTER TABLE leaves ADD COLUMN program TEXT DEFAULT '';
ALTER TABLE leaves ADD COLUMN year_level TEXT DEFAULT '';
ALTER TABLE leaves ADD COLUMN section TEXT DEFAULT '';

ALTER TABLE attendance ADD COLUMN schedule_id INTEGER;
ALTER TABLE attendance ADD COLUMN program TEXT DEFAULT '';
ALTER TABLE attendance ADD COLUMN year_level TEXT DEFAULT '';
ALTER TABLE attendance ADD COLUMN section TEXT DEFAULT '';

CREATE TABLE IF NOT EXISTS student_attendance (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    schedule_id INTEGER NOT NULL,
    student_user_id INTEGER NOT NULL,
    attendance_date TEXT NOT NULL,
    status TEXT NOT NULL CHECK(status IN ('Present','Absent','Excused')),
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(schedule_id, student_user_id, attendance_date)
);
