CREATE DATABASE bal_sample_db;

USE bal_sample_db;

CREATE TABLE person (
    id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    email VARCHAR(50),
    registered_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO `bal_sample_db`.`person` (`first_name`, `last_name`, `email`) VALUES ('Star', 'Load', 'star.load@gmail.com');
INSERT INTO `bal_sample_db`.`person` (`first_name`, `last_name`, `email`) VALUES ('Peter', 'Parker', 'p.parker@gmail.com');
INSERT INTO `bal_sample_db`.`person` (`first_name`, `last_name`, `email`) VALUES ('Tony', 'Stark', 'tony@gmail.com');
