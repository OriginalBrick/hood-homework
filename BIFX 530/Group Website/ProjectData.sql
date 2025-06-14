/* Use the following command to run the file. Make sure to change it to your directory and database. */
/* source /home/jjs14/public_html/Group_Project/ProjectData.sql; */

USE jjs14db;

DROP TABLE IF EXISTS saved;
DROP TABLE IF EXISTS find;
DROP TABLE IF EXISTS search;
DROP TABLE IF EXISTS account;
DROP TABLE IF EXISTS institution;
DROP TABLE IF EXISTS species;


CREATE TABLE species (
	Scientific_Name VARCHAR (50), 
	Common_Name VARCHAR (30),
	Vertebrate INTEGER, 
	Region VARCHAR (25),
	Reproduction VARCHAR(30),
	Ploidy INTEGER,
	MRCA_Name VARCHAR (30),
	MYA INTEGER,
	PRIMARY KEY (Scientific_Name)
);

INSERT INTO species(Scientific_Name, Common_Name, Vertebrate, Region, Reproduction, Ploidy, MRCA_NAME, MYA) VALUES 
	('Xenopus tropicalis', 'African Clawed Frog', 1, 'Africa', 'Ovoviviparous', 20, 'Tetrapoda', 390),
	('Danio rerio', 'Zebrafish', 1, 'Asia', 'Oviparous', 50, 'Gnathostomata', 419),
	('Drosophila melanogaster', 'Fruit Fly', 0, 'Asia', 'Oviparous', 4, 'Urbilateria', 580),
	('Hydra vulgaris', 'Freshwater Polyp', 0, 'S. America', 'Budding', 32, 'Eumetazoa', 630),
	('Caenorhabditis elegans', 'C. elegans', 0, 'N. America', 'Autogamy', 12, 'Nephrozoa', 558),
	('Macaca mulatta', 'Rhesus Macacque', 1, 'Asia', 'Viviparous', 42, 'Catarrhini', 25),
	('Mus musculus', 'Common Mouse', 1, 'Europe', 'Viviparous', 40, 'Euarchontoglires', 90),
	('Schmidtea mediterranea', 'Planaria Worm', 0, 'Europe', 'Binary Fission', 8, 'Xenacoelomorpha', 526),
	('Arbacia punctulata', 'Purple-Spined Sea Urchin', 0, 'Pacific', 'Allogamy', 44, 'Ambulacraria', 533),
	('Euprymna scolopes', 'Hawaiian Bobtail Squid', 0, 'Pacific', 'Iteroparous', 46, 'Lophotrochozoa', 600);


CREATE TABLE institution (
	Institute_ID VARCHAR(9) NOT NULL,
	Name VARCHAR(30),
	Expiration DATE,
	License_Amt INTEGER, 
	PRIMARY KEY (Institute_ID)
);

INSERT INTO institution(Institute_ID, Name, Expiration, License_Amt) VALUES 
	('000000001', 'Hood College', '2026-01-01', 200),
	('000000002', 'Shepherd University', '2024-05-22', 500),
	('000000003', 'Montgomery College', '2025-03-08', 300),
	('000000004', 'Shippensburg University', '2023-11-07', 1000),
	('000000005', 'Loma Linda University', '2029-08-01', 100),
	('000000006', 'University of Maryland', '2023-03-08', 700),
	('000000007', 'University of Virginia', '2028-01-09', 8000),
	('000000008', 'University of California', '2029-09-09', 9999),
	('000000009', 'Andrews University', '2024-05-02', 802),
	('000000010', 'Blueridge Community College', '2099-11-17', 1999);


/* When an institution ceases to pay for its license or is deleted, we do not want user data to be deleted. Accounts should be able to update though if their intuition changes. Hence ON CASCADE is only for update, not delete. */
CREATE TABLE account(
	Student_ID VARCHAR(9),
	Name VARCHAR(30),
	Major VARCHAR(20),
	Class VARCHAR(20),
	Institute_ID VARCHAR(9) NOT NULL,
	PRIMARY KEY (Student_ID),
	FOREIGN KEY (Institute_ID) REFERENCES institution(Institute_ID)
	ON UPDATE CASCADE
);

INSERT INTO account(Student_ID, Name, Major, Class, Institute_ID) VALUES
	('123456789','John Doe','Biology','BIOL-156','000000001'),
	('987654321','Jane Snow','Chemistry','CHEM-262','000000002'),
	('789456123','Richard Roe','Biochemistry','CHEM-442','000000003'),
	('789123456','Jenny Crow','Biochemistry','BIOL-445','000000004'),
	('456123789','Reginald Loe','Ecology','BIOL-243','000000005'),
	('123123123','Bob Ross','Art','ARTL-123','000000006'),
	('789789789','Rowan Atkinson','Biology','BIOL-333','000000007'),
	('456456456','David Attenborough','Ecology','BIO-212','000000008'),
	('295739234','Billy Boe','Chemistry','CHEM-121','000000009'),
	('129549849','Major Major','Biochemistry','CHEM-455','000000010');


/* We set Student_ID to NOT NULL because every search must be made by an account, which in turn will have a student ID.*/
CREATE TABLE search(
	Search_ID VARCHAR (9),
	Search_Date DATE,
	Key_Words VARCHAR (75),
	Student_ID VARCHAR (9) NOT NULL,
	PRIMARY KEY (Search_ID),
	FOREIGN KEY (Student_ID) REFERENCES account(Student_ID)
	ON DELETE CASCADE
)ENGINE=InnoDB;

INSERT INTO search(Search_ID, Search_Date, Key_Words, Student_ID) VALUES
	('abcde1234', '2022-01-01', 'Mouse', '123456789'),
	('qwert0009', '2022-02-02', 'Urchin', '789123456'),
	('poikl9876', '2022-03-03', 'Fish', '789123456'),
	('fooba5555', '2022-04-04', 'Elegans', '456123789'), 
	('ytryx7539', '2022-05-05', 'Worm', '987654321'),
	('tmrwl6682', '2022-06-06', 'Fly', '123456789'),
	('rotfl9999', '2022-07/07', 'Squid', '789123456'),
	('fghij5678', '2022-08-08', 'Polyp', '789123456'), 
	('sqqab9876', '2022-09-09', 'Frog', '456123789'),
	('edcab4123', '2022-10-10', 'Macaca', '987654321'); 

/* When a search or species is deleted or updated, whatever results were produced should be affected the same way. Results will be misleading without the updates and will never be displayed if not associated with a search. Hence the ON CASCADE constraint. */
CREATE TABLE find(
	Search_ID VARCHAR(9), 
	Scientific_Name VARCHAR (50),
	PRIMARY KEY(Scientific_Name, Search_ID),
	FOREIGN KEY (Scientific_Name) REFERENCES species(Scientific_Name)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	FOREIGN KEY (Search_ID) REFERENCES search(Search_ID)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)ENGINE=InnoDB;

INSERT INTO find(Search_ID, Scientific_Name) VALUES
	('abcde1234', 'Mus musculus'),
	('qwert0009', 'Arbacia punctulata'),
	('poikl9876', 'Danio rerio'),
	('fooba5555', 'Caenorhabditis elegans'),
	('ytryx7539', 'Schmidtea mediterranea'),
	('tmrwl6682', 'Drosophila melanogaster'),
	('rotfl9999', 'Euprymna scolopes'),
	('fghij5678', 'Hydra vulgaris'),
	('sqqab9876', 'Xenopus tropicalis'),
	('edcab4123', 'Macaca mulatta');


/* When an account or search is deleted or updated, we want the saved searches to be affected the same way. No use in saved searches if they are no longer associated with an account or their account ID is not kept up to date. Hence the ON CASCADE constraint. */
CREATE TABLE saved(
	Student_ID VARCHAR(9) NOT NULL,
	Search_ID VARCHAR(9),
	PRIMARY KEY (Student_ID, Search_ID),
	FOREIGN KEY (Student_ID) REFERENCES account(Student_ID)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
)ENGINE=InnoDB;

INSERT INTO saved(Student_ID, Search_ID) VALUES
	('123456789', 'abcde1234'),
	('789123456', 'qwert0009'),
	('789123456', 'poikl9876'),
	('456123789', 'fooba5555'),
	('987654321', 'ytryx7539'),
	('789456123', 'tmrwl6682'),
	('987654321', 'rotfl9999'),
	('789456123', 'fghij5678'),
	('123456789', 'sqqab9876'),
	('456123789', 'edcab4123');