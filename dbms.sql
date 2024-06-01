CREATE TABLE Hotel (
  Hotel_No VARCHAR(10) PRIMARY KEY,
  Name VARCHAR(100),
  City VARCHAR(50)
  );

INSERT INTO Hotel (Hotel_No, Name, City) VALUES 
('H111', 'Empire Hotel', 'New York'),
('H235', 'Park Place', 'New York'),
('H432', 'Brownstone Hotel', 'Toronto'),
('H498', 'James Plaza', 'Toronto'),
('H193', 'Devon Hotel', 'Boston'),
('H437', 'Clairmont Hotel', 'Boston');

CREATE TABLE Room (
  Room_No INT(10),
  Hotel_No VARCHAR(10),
  Type CHAR(1) CHECK (Type IN ('S', 'N')),
  Price DECIMAL(10, 2),
  FOREIGN KEY (Hotel_No) REFERENCES Hotel(Hotel_No),
  PRIMARY KEY (Room_No, Hotel_No)
  );

INSERT INTO Room (Room_No, Hotel_No, Type, Price) VALUES 
(313, 'H111', 'S', 145.00),
(412, 'H111', 'N', 145.00),
(1267, 'H235', 'N', 175.00),
(1289, 'H235', 'N', 195.00),
(876, 'H432', 'S', 124.00),
(898, 'H432', 'S', 124.00),
(345, 'H498', 'N', 160.00),
(467, 'H498', 'N', 180.00),
(1001, 'H193', 'S', 150.00),
(1201, 'H193', 'N', 175.00),
(257, 'H437', 'N', 140.00),
(223, 'H437', 'N', 155.00);

CREATE TABLE Guest (
  Guest_No VARCHAR(10),
  Name VARCHAR(100),
  City VARCHAR(50),
  PRIMARY KEY (Guest_No)
);

INSERT INTO Guest (Guest_No, Name, City) VALUES 
('G256', 'Adam Wayne', 'Pittsburgh'),
('G367', 'Tara Cummings', 'Baltimore'),
('G879', 'Vanessa Parry', 'Pittsburgh'),
('G230', 'Tom Hancock', 'Philadelphia'),
('G467', 'Robert Swift', 'Atlanta'),
('G190', 'Edward Cane', 'Baltimore');

CREATE TABLE Booking (
    Hotel_No VARCHAR(10),
    Guest_No VARCHAR(10),
    Date_From DATE,
    Date_To DATE,
    Room_No INT(10),
    FOREIGN KEY (Hotel_No) REFERENCES Hotel(Hotel_No),
    FOREIGN KEY (Guest_No) REFERENCES Guest(Guest_No),
    FOREIGN KEY (Room_No, Hotel_No) REFERENCES Room(Room_No, Hotel_No),
    PRIMARY KEY (Hotel_No, Guest_No, Date_From)
);

INSERT INTO Booking (Hotel_No, Guest_No, Date_From, Date_To, Room_No) VALUES
('H111', 'G256', '1999-08-10', '1999-08-15', 412),
('H111', 'G367', '1999-08-18', '1999-08-21', 412),
('H235', 'G879', '1999-09-05', '1999-09-12', 1267),
('H498', 'G230', '1999-09-15', '1999-09-18', 467),
('H498', 'G256', '1999-11-30', '1999-12-02', 345),
('H498', 'G467', '1999-11-03', '1999-11-05', 345),
('H193', 'G190', '1999-11-15', '1999-11-19', 1001),
('H193', 'G367', '1999-09-12', '1999-09-14', 1001),
('H193', 'G367', '1999-10-01', '1999-10-06', 1201),
('H437', 'G190', '1999-10-04', '1999-10-06', 223),
('H437', 'G879', '1999-09-14', '1999-09-17', 223);


-- 1.      List full details of all hotels.
SELECT * FROM Hotel;

-- 2.      List full details of all hotels in New York.
SELECT * FROM Hotel WHERE City = 'New York';

-- 3.      List the names and cities of all guests, ordered according to their cities.
SELECT Name, City FROM Guest ORDER BY City;
SELECT Name, City FROM Guest ORDER BY City DESC;

-- 4.      List all details for non-smoking rooms in ascending order of price.
SELECT * FROM Room WHERE Type = 'N' ORDER BY Price;

-- 5.      List the number of hotels there are.
SELECT COUNT(*) AS NumberOfHotels FROM Hotel;

-- 6.      List the cities in which guests live. Each city should be listed only once.
SELECT DISTINCT City FROM Guest;

-- 7.      List the average price of a room.
SELECT AVG(Price) AS AveragePrice FROM Room;

-- 8.      List hotel names, their room numbers, and the type of that room.
SELECT Hotel.Name AS Hotel_Name, Room.Room_No, Room.Type AS Room_Type
FROM Hotel INNER JOIN Room ON Hotel.Hotel_No = Room.Hotel_No;

-- 9.      List the hotel names, booking dates, and room numbers for all hotels in New York.
SELECT Hotel.Name AS Hotel_Name, Booking.Date_From, Booking.Date_To, Booking.Room_No 
FROM Hotel INNER JOIN Booking ON Hotel.Hotel_No = Booking.Hotel_No WHERE City = 'New York';

-- 10.  	What is the number of bookings that started in the month of September?
SELECT COUNT(*) AS September_Bookings FROM Booking 
WHERE STRFTIME('%m', Date_From) = '09';

-- 11.	List the names and cities of guests who began a stay in New York in August.
SELECT Guest.Name, Guest.City FROM Guest 
INNER JOIN Booking ON Guest.Guest_No = Booking.Guest_No
INNER JOIN Hotel ON Booking.Hotel_No = Hotel.Hotel_No
WHERE Hotel.City = 'New York' AND STRFTIME('%m', Booking.Date_From) = '08';

-- 12.  	List the hotel names and room numbers of any hotel rooms that have not been booked.
SELECT Hotel.Name, Room.Room_No FROM HOTEL
INNER JOIN Room ON Hotel.Hotel_No = Room.Hotel_No
WHERE NOT EXISTS (SELECT * FROM BOOKING WHERE Booking.Room_No = Room.Room_No);

-- 13.  	List the hotel name and city of the hotel with the highest priced room.
SELECT Hotel.Name, Hotel.City FROM Hotel
INNER JOIN Room ON Hotel.Hotel_No = Room.Hotel_No
WHERE Room.Price = (SELECT MAX(Price) FROM Room);

-- 14.  	List hotel names, room numbers, cities, and prices for hotels that have rooms
with prices lower than the lowest priced room in a Boston hotel.
SELECT Hotel.Name, Room.Room_No, Hotel.City, Room.Price
FROM Hotel INNER JOIN Room ON Hotel.Hotel_No = Room.Hotel_No
WHERE Room.Price < 
(SELECT MIN(Price) FROM Room 
 INNER JOIN Hotel ON Room.Hotel_No = Hotel.Hotel_No
 WHERE City = 'Boston');

-- 15.  	List the average price of a room grouped by city.
SELECT AVG(Room.Price) AS AvgPrice, Hotel.City FROM Room 
INNER JOIN Hotel ON Room.Hotel_No = Hotel.Hotel_No
GROUP BY Hotel.City;
