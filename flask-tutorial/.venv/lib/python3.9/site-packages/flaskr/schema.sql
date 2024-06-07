DROP TABLE IF EXISTS Person;

CREATE TABLE Person (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name_first TEXT NOT NULL,
  name_last TEXT NOT NULL,
  name_last_maiden TEXT,

  gender INT,

  birth_year INT CHECK (birth_year IS NULL OR (birth_year >= 1000 AND birth_year <= strftime('%Y', 'now'))), -- Allow null or valid year
  birth_month INT CHECK (birth_month IS NULL OR (birth_month >= 0 AND birth_month <= 12)), -- Allow null or valid month
  birth_day INT CHECK (birth_day IS NULL OR (birth_day >= 0 AND birth_day <= 31)), -- Allow null or valid day, 

  death_year INT CHECK (death_year IS NULL OR (death_year >= 1000 AND death_year <= strftime('%Y', 'now'))), -- Allow null or valid year
  death_month INT CHECK (death_month IS NULL OR (death_month >= 0 AND death_month <= 12)), -- Allow null or valid month
  death_day INT CHECK (death_day IS NULL OR (death_day >= 0 AND death_day <= 31)), -- Allow null or valid day, 


  mother_id INT,
  father_id INT,
  spouse_id INT, 

  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (mother_id) REFERENCES Person(id),
  FOREIGN KEY (father_id) REFERENCES Person(id),
  FOREIGN KEY (spouse_id) REFERENCES Person(id)
);

CREATE TABLE user (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL
);

CREATE TABLE post (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  author_id INTEGER NOT NULL,
  created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  FOREIGN KEY (author_id) REFERENCES user (id)
);

