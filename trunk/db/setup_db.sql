CREATE USER hhac@'localhost' IDENTIFIED BY 'iamharmless';
CREATE DATABASE IF NOT EXISTS hhac2 CHARACTER SET utf8;
GRANT ALL PRIVILEGES ON hhac2.* TO hhac;