DROP DATABASE IF EXISTS bal_sample_db;

CREATE DATABASE bal_sample_db;

USE bal_sample_db;

CREATE TABLE person (
    id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    department VARCHAR(50) NOT NULL,
    email VARCHAR(50),
    registered_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO `bal_sample_db`.`person` (`first_name`, `last_name`, `department`, `email`) VALUES ('Tony', 'Stark', 'Avengers', 'tony@starkindustries.com');
INSERT INTO `bal_sample_db`.`person` (`first_name`, `last_name`, `department`, `email`) VALUES ('Star', 'Lord', 'Avengers', 's.lord@avengers.com');
INSERT INTO `bal_sample_db`.`person` (`first_name`, `last_name`, `department`, `email`) VALUES ('Peter', 'Parker', 'Avengers', 'p.parker@gmail.com');
INSERT INTO `bal_sample_db`.`person` (`first_name`, `last_name`, `department`, `email`) VALUES ('Chandler', 'Bing', 'Friends', 'c.bing@friends.com');
INSERT INTO `bal_sample_db`.`person` (`first_name`, `last_name`, `department`, `email`) VALUES ('Monica', 'Geller', 'Friends', 'monica@friends.com');
INSERT INTO `bal_sample_db`.`person` (`first_name`, `last_name`, `department`, `email`) VALUES ('Joey', 'Tribbiani', 'Friends', 'joey@friends.com');
