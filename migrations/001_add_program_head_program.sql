-- OptiSked AI Sprint update: store the academic program managed by a Program Head.
-- The Flask application also performs an automatic compatibility migration
-- with ensure_column() for existing SQLite databases.
ALTER TABLE users ADD COLUMN program TEXT DEFAULT '';
