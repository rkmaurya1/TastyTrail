-- TastyTrail Database Schema (PostgreSQL)
-- Run: psql -U tryenor -f database.sql

CREATE DATABASE tastytrail;
\c tastytrail;

-- Users Table
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(15),
    address TEXT,
    city VARCHAR(50),
    profile_pic VARCHAR(255) DEFAULT 'default-avatar.png',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Restaurants Table
CREATE TABLE IF NOT EXISTS restaurants (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    cuisine VARCHAR(100),
    address TEXT,
    city VARCHAR(50),
    phone VARCHAR(15),
    image VARCHAR(255) DEFAULT 'default-restaurant.jpg',
    rating NUMERIC(2,1) DEFAULT 4.0,
    delivery_time INT DEFAULT 30,
    min_order INT DEFAULT 0,
    delivery_fee INT DEFAULT 0,
    is_veg BOOLEAN DEFAULT FALSE,
    is_open BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Menu Categories Table
CREATE TABLE IF NOT EXISTS menu_categories (
    id SERIAL PRIMARY KEY,
    restaurant_id INT NOT NULL REFERENCES restaurants(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    display_order INT DEFAULT 0
);

-- Menu Items Table
CREATE TABLE IF NOT EXISTS menu_items (
    id SERIAL PRIMARY KEY,
    restaurant_id INT NOT NULL REFERENCES restaurants(id) ON DELETE CASCADE,
    category_id INT REFERENCES menu_categories(id) ON DELETE SET NULL,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    price NUMERIC(8,2) NOT NULL,
    image VARCHAR(255) DEFAULT 'default-food.jpg',
    is_veg BOOLEAN DEFAULT TRUE,
    is_available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Orders Table
CREATE TYPE order_status AS ENUM ('PLACED','CONFIRMED','PREPARING','OUT_FOR_DELIVERY','DELIVERED','CANCELLED');

CREATE TABLE IF NOT EXISTS orders (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id),
    restaurant_id INT NOT NULL REFERENCES restaurants(id),
    total_amount NUMERIC(10,2) NOT NULL,
    delivery_address TEXT NOT NULL,
    status order_status DEFAULT 'PLACED',
    payment_method VARCHAR(50) DEFAULT 'COD',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Order Items Table
CREATE TABLE IF NOT EXISTS order_items (
    id SERIAL PRIMARY KEY,
    order_id INT NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    menu_item_id INT NOT NULL REFERENCES menu_items(id),
    quantity INT NOT NULL,
    price NUMERIC(8,2) NOT NULL
);

-- ==================== SAMPLE DATA ====================

INSERT INTO restaurants (name, description, cuisine, address, city, phone, image, rating, delivery_time, min_order, delivery_fee, is_veg) VALUES
('Spice Garden', 'Authentic Indian flavors with a modern twist. Family recipes passed down generations.', 'North Indian', '12 MG Road, Connaught Place', 'Delhi', '9876543210', 'spice-garden.jpg', 4.3, 35, 150, 30, FALSE),
('Pizza Planet', 'Wood-fired pizzas with fresh toppings and hand-tossed bases made daily.', 'Italian, Pizza', '45 Brigade Road, Indiranagar', 'Bangalore', '9876543211', 'pizza-planet.jpg', 4.5, 25, 200, 0, FALSE),
('Green Bowl', '100% Pure Vegetarian. Healthy salads, bowls and wraps for the health-conscious foodie.', 'Healthy, Salads', '78 Linking Road, Bandra', 'Mumbai', '9876543212', 'green-bowl.jpg', 4.1, 40, 100, 20, TRUE),
('Burger Barn', 'Juicy gourmet burgers stacked high with the freshest ingredients.', 'American, Burgers', '23 Park Street', 'Kolkata', '9876543213', 'burger-barn.jpg', 4.4, 20, 120, 0, FALSE),
('Wok Express', 'Fast & Fresh Pan-Asian cuisine. Noodles, rice, and more.', 'Chinese, Asian', '56 Anna Salai, T Nagar', 'Chennai', '9876543214', 'wok-express.jpg', 4.2, 30, 80, 15, FALSE),
('The Biryani House', 'Dum-cooked biryanis and kebabs straight from the tandoor.', 'Biryani, Mughlai', '90 Banjara Hills, Road No 2', 'Hyderabad', '9876543215', 'biryani-house.jpg', 4.6, 45, 200, 0, FALSE),
('South Spice', 'Traditional South Indian breakfast and meals. Dosas, idlis, uttapam.', 'South Indian', '34 Residency Road', 'Chennai', '9876543216', 'south-spice.jpg', 4.0, 25, 50, 10, TRUE),
('The Cake Studio', 'Artisan cakes, pastries, and desserts baked fresh every morning.', 'Desserts, Bakery', '11 Civil Lines', 'Delhi', '9876543217', 'cake-studio.jpg', 4.7, 50, 300, 50, TRUE);

-- Menu Categories
INSERT INTO menu_categories (restaurant_id, name, display_order) VALUES
(1, 'Starters', 1),(1, 'Main Course', 2),(1, 'Breads', 3),(1, 'Rice & Biryani', 4),(1, 'Desserts', 5),
(2, 'Pizzas', 1),(2, 'Pastas', 2),(2, 'Garlic Breads', 3),(2, 'Beverages', 4),
(4, 'Burgers', 1),(4, 'Sides', 2),(4, 'Beverages', 3);

-- Menu Items - Spice Garden
INSERT INTO menu_items (restaurant_id, category_id, name, description, price, is_veg) VALUES
(1,1,'Paneer Tikka','Marinated cottage cheese grilled in tandoor with spices',280,TRUE),
(1,1,'Chicken Seekh Kebab','Minced chicken with herbs & spices, skewer grilled',320,FALSE),
(1,2,'Dal Makhani','Slow-cooked black lentils in rich tomato-cream gravy',240,TRUE),
(1,2,'Butter Chicken','Tender chicken in velvety tomato-butter sauce',360,FALSE),
(1,2,'Palak Paneer','Cottage cheese in smooth spinach gravy',280,TRUE),
(1,2,'Mutton Rogan Josh','Kashmiri-style slow-cooked mutton curry',420,FALSE),
(1,3,'Butter Naan','Leavened bread baked in tandoor with butter',60,TRUE),
(1,3,'Garlic Naan','Naan with garlic and coriander topping',80,TRUE),
(1,4,'Veg Biryani','Fragrant basmati rice cooked with seasonal vegetables',280,TRUE),
(1,4,'Chicken Biryani','Dum-cooked biryani with tender chicken pieces',380,FALSE),
(1,5,'Gulab Jamun','Soft milk dumplings soaked in rose-flavored sugar syrup',120,TRUE);

-- Menu Items - Pizza Planet
INSERT INTO menu_items (restaurant_id, category_id, name, description, price, is_veg) VALUES
(2,6,'Margherita','Classic tomato sauce with mozzarella and fresh basil',299,TRUE),
(2,6,'Pepperoni','Loaded with pepperoni slices on tangy tomato base',399,FALSE),
(2,6,'BBQ Chicken','Grilled chicken, onions and peppers in smoky BBQ sauce',449,FALSE),
(2,6,'Veggie Supreme','Bell peppers, mushrooms, olives, and onions',349,TRUE),
(2,7,'Penne Arrabbiata','Penne in spicy tomato sauce with garlic',249,TRUE),
(2,7,'Chicken Alfredo','Creamy white sauce pasta with grilled chicken',329,FALSE),
(2,8,'Cheesy Garlic Bread','Toasted bread with garlic butter and cheese',149,TRUE),
(2,9,'Cold Coffee','Creamy blended iced coffee',119,TRUE);

-- Menu Items - Burger Barn
INSERT INTO menu_items (restaurant_id, category_id, name, description, price, is_veg) VALUES
(4,10,'Classic Chicken Burger','Crispy fried chicken with lettuce, tomato and mayo',199,FALSE),
(4,10,'Double Patty Smash','Two beef patties, double cheese, special sauce',349,FALSE),
(4,10,'Veggie Delight Burger','Grilled veggie patty with fresh veggies and pesto',179,TRUE),
(4,10,'Spicy Sriracha Burger','Chicken with sriracha mayo and jalapenos',249,FALSE),
(4,11,'Loaded Fries','Crispy fries with cheese sauce and jalapenos',149,TRUE),
(4,11,'Onion Rings','Beer-battered golden onion rings',129,TRUE),
(4,12,'Thick Milkshake','Vanilla / Chocolate / Strawberry',149,TRUE);
