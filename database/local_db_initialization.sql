DROP DATABASE IF EXISTS scheduling_app;
CREATE DATABASE scheduling_app 
    DEFAULT CHARACTER SET utf8mb4 
    DEFAULT COLLATE utf8mb4_unicode_ci;
USE scheduling_app;

CREATE TABLE IF NOT EXISTS users (
	id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(80) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE COLLATE utf8mb4_bin,
    password VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS tasks (
	id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    description VARCHAR(1000) DEFAULT '',
    date_created DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    due_date DATETIME DEFAULT NULL,
    date_completed DATETIME DEFAULT NULL,
    task_status ENUM('Not Started', 'In Progress', 'Completed') DEFAULT ('Not Started'),
    user_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

INSERT INTO users (full_name, email, password) VALUES
	('John Doe', 'jdoe@example.com', 'password1'),
	('Bob Tester', 'bobt@example.com', 'password2'),
	('Alice Johnson', 'alicej123@example.com', 'password3');

INSERT INTO tasks (title, description, date_created, due_date, date_completed, task_status, user_id) VALUES
	(
		'Prepare Meeting Deck',
		'Prepare the meeting deck for new hires of the PMO team to give them a background of the project.',
		'2025-02-07 13:30:00',
		'2025-02-14 17:00:00',
		'2025-02-12 14:05:00',
		'Completed',
		1
    ),
    (
		'Complete Onboarding Training',
		'Complete the onboarding training that was assigned to you for the start of the new project.',
		'2025-02-03 10:15:00',
		'2025-02-07 17:00:00',
		NULL,
		'In Progress',
		2
    ),
    (
		'Take Dog For Walk',
		'Remember to take the dog for a 20 minute walk.',
        '2025-02-07 09:30:00',
        '2025-02-07 19:00:00',
        NULL,
        'Not Started',
        3
    );