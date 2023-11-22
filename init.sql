CREATE TABLE IF NOT EXISTS User (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    age INT NOT NULL
);

INSERT INTO User (username, age) VALUES ('JohnDoe', 30);
INSERT INTO User (username, age) VALUES ('AliceSmith', 25);