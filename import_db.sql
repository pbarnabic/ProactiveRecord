PRAGMA foreign_keys = ON;

CREATE TABLE posts (
  id INTEGER PRIMARY KEY,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL,

  FOREIGN KEY(author_id) REFERENCES users(id)
);

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
  channel_id INTEGER NOT NULL,

  FOREIGN KEY(channel_id) REFERENCES users(id)
);

CREATE TABLE channels (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL
);

INSERT INTO
  channels (id, name)
VALUES
  (1, "App Academy"), (2, "Job Seekers");

INSERT INTO
  users (id, fname, lname, channel_id)
VALUES
  (1, "Paul", "Barnabic", 2),
  (2, "Danny", "Catalano", 1),
  (3, "Joey", "Fehrman", 1),
  (4, "Andrew", "Gregory", 1);

INSERT INTO
  posts (id, body, author_id)
VALUES
  (1, "Hire Me. Call me at 201-783-0234 or visit ptbarnabic.github.io", 1),
  (2, "Grad Night is tonight", 2),
  (3, "Make sure to complete your tasks", 3),
  (4, "Paul, make sure to complete your tasks", 3);
