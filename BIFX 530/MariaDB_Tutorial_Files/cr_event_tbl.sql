# drop the event table if it exists, then recreate it

DROP TABLE IF EXISTS event;

CREATE TABLE event
(
  event_id MEDIUMINT NOT NULL AUTO_INCREMENT,
  name   VARCHAR(20),
  date   DATE,
  type   VARCHAR(15),
  remark VARCHAR(255),
  PRIMARY KEY (event_id),
  FOREIGN KEY (name) REFERENCES pet(name) 
)ENGINE = InnoDB;