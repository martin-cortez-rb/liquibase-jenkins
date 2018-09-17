create table person (
  person_id INT NOT NULL,
  documentno VARCHAR(20) NOT NULL,
  birth_date DATETIME,
  name VARCHAR(20),
  surname VARCHAR(20),
  primary key(person_id)
);
