USE mysql;
FLUSH PRIVILEGES;
CREATE DATABASE wordpress;
CREATE USER 'gna'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON wordpress.* TO 'gna'@'localhost';
FLUSH PRIVILEGES;
