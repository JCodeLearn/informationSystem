CREATE DATABASE IF NOT EXISTS informationSystem;
USE informationSystem;

CREATE TABLE IF NOT EXISTS Users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(10) NOT NULL UNIQUE,
    password VARCHAR(10) NOT NULL
);

ALTER TABLE Users 
ADD COLUMN avatar LONGBLOB,
ADD COLUMN avatar_type VARCHAR(20);

create table Emails (
	id int AUTO_INCREMENT primary key,
	sender_id int not null,
	receiver_id int not null,
	subject varchar(100) not null,
	content text not null,
	send_time datetime default CURRENT_TIMESTAMP,
	is_read tinyint default 0,
	status ENUM('draft', 'sent', 'trash') default 'sent',
	foreign key (sender_id) references Users(id),
	foreign key (receiver_id) references Users(id)
);

ALTER TABLE Emails MODIFY receiver_id INT NULL;

create table Attachments (
	id int AUTO_INCREMENT primary key,
	email_id int not null, 
	file_name varchar(255) not null,
	file_type varchar(255) not null,
	file_data LONGBLOB not null,
	upload_time datetime default CURRENT_TIMESTAMP,
	foreign key (email_id) references Emails(id)
);





