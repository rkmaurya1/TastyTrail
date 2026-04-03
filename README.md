# TastyTrail - Food Delivery Web Application

A food delivery web application for ordering food from restaurants online.

## Tech Stack

- **Frontend:** HTML, CSS, JavaScript, jQuery, Bootstrap 5
- **Backend:** JSP, Java Servlet
- **Database:** MySQL

## Project Structure

```
src/
├── main/
│   ├── java/com/tastytrail/
│   │   ├── dao/          # Database access (DBConnection, UserDAO, etc.)
│   │   ├── model/        # Data models (User, Restaurant, Order, etc.)
│   │   ├── servlet/      # Servlets (Login, Register, Cart, Order, etc.)
│   │   └── listener/     # App lifecycle listeners
│   ├── resources/
│   │   └── db.properties # Database config
│   └── webapp/
│       ├── css/          # Stylesheets
│       ├── js/           # JavaScript files
│       ├── WEB-INF/      # JSP pages & web.xml
│       └── *.jsp         # Public JSP pages
database.sql              # MySQL schema & sample data
pom.xml                   # Maven dependencies
```

## Setup

### Prerequisites
- Java JDK 11+
- Apache Tomcat 10+
- MySQL 8+
- Maven

### Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/rkmaurya1/TastyTrail.git
   cd TastyTrail
   ```

2. **Setup Database**
   ```bash
   mysql -u root -p < database.sql
   ```

3. **Configure DB credentials**

   Edit `src/main/resources/db.properties`:
   ```properties
   db.url=jdbc:mysql://localhost:3306/tastytrail?useSSL=false&serverTimezone=UTC
   db.username=root
   db.password=yourpassword
   ```

4. **Build & Deploy**
   ```bash
   mvn clean package
   ```
   Deploy the generated `target/TastyTrail.war` to Tomcat.

5. **Run**

   Open browser: `http://localhost:8080/TastyTrail`

## Features

- User registration & login
- Browse restaurants & menus
- Add to cart & place orders
- Order history & tracking
- Admin dashboard
- Driver dashboard
