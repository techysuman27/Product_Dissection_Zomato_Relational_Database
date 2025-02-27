CREATE DATABASE zomato_db;
USE zomato_db;

CREATE TABLE Users (
    UserID INT PRIMARY KEY AUTO_INCREMENT,
    Username VARCHAR(255) NOT NULL,
    Gender ENUM('Male', 'Female', 'Other'),
    Email VARCHAR(255) UNIQUE NOT NULL,
    Phone_Number VARCHAR(15) UNIQUE NOT NULL,
    Address TEXT,
    Password VARCHAR(255) NOT NULL
);

CREATE TABLE Restaurants (
    RestaurantID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(255) NOT NULL,
    Location TEXT NOT NULL,
    Cuisine_Type VARCHAR(255),
    Rating DECIMAL(2,1) CHECK (Rating BETWEEN 0 AND 5)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT NOT NULL,
    RestaurantID INT NOT NULL,
    Total_Amount DECIMAL(10,2) NOT NULL,
    Order_Status ENUM('Preparing', 'On Route', 'Delivered', 'Cancelled') NOT NULL,
    Order_Date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID) ON DELETE CASCADE
);

CREATE TABLE Delivery (
    DeliveryID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT NOT NULL,
    Delivery_ExecutiveID INT NOT NULL,
    Estimated_Delivery_Time TIME NOT NULL,
    Delivery_Status ENUM('Picked Up', 'On the Way', 'Delivered') NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE
);

CREATE TABLE Payment (
    PaymentID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    Payment_MethodID INT NOT NULL,
    Payment_Status ENUM('Successful', 'Pending', 'Failed') NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE
);

CREATE TABLE Payment_Method (
    Payment_MethodID INT PRIMARY KEY AUTO_INCREMENT,
    Method_Name ENUM('Credit Card', 'Debit Card', 'UPI', 'Net Banking', 'Wallet', 'Cash on Delivery') NOT NULL
);

CREATE TABLE Zomato_Money (
    Category_Name ENUM('Zomato Wallet', 'Gift Card', 'Zomato Credit') PRIMARY KEY,
    UserID INT NOT NULL,
    Balance DECIMAL(10,2) NOT NULL DEFAULT 0,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

CREATE TABLE Items (
    ItemID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT NOT NULL,
    Name VARCHAR(255) NOT NULL,
    Quantity INT CHECK (Quantity > 0),
    Price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE
);

-- Users place Orders: Users (1) → (M) Orders
-- Users have Zomato Money: Users (1) → (1) Zomato Money
-- Orders contain Items: Orders (1) → (M) Items
-- Restaurants fulfill Orders: Restaurants (1) → (M) Orders
-- Orders require Delivery: Orders (1) → (1) Delivery
-- Orders involve Payment: Orders (1) → (1) Payment
-- Payment uses Payment Method: Payment_Method (1) → (M) Payment
