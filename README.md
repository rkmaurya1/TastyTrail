<div align="center">

# 🍽️ TastyTrail

### A Full-Stack Food Ordering Web Application

[![Java](https://img.shields.io/badge/Java-11-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)](https://www.java.com)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-4479A1?style=for-the-badge&logo=mysql&logoColor=white)](https://www.mysql.com)
[![Bootstrap](https://img.shields.io/badge/Bootstrap-5.3-7952B3?style=for-the-badge&logo=bootstrap&logoColor=white)](https://getbootstrap.com)
[![Tomcat](https://img.shields.io/badge/Tomcat-10.1-F8DC75?style=for-the-badge&logo=apache-tomcat&logoColor=black)](https://tomcat.apache.org)
[![Maven](https://img.shields.io/badge/Maven-3.9-C71A36?style=for-the-badge&logo=apache-maven&logoColor=white)](https://maven.apache.org)

> **TastyTrail** is a single-restaurant food ordering platform where customers can browse the full menu — North Indian, Pizza, Burgers, Biryani, Chinese, Desserts & more — and order online with real-time order tracking.

</div>

---

## ✨ Features

<table>
<tr>
<td valign="top" width="33%">

### 👤 Customer
- Browse 26+ menu items across 10 categories
- Add / remove items from cart (live update)
- Place orders (Cash on Delivery)
- Real-time order status tracking
- Order history with itemized view
- User profile management

</td>
<td valign="top" width="33%">

### 🛠️ Admin Panel
- Dashboard — orders, revenue & user stats
- Update order status & assign drivers
- Manage restaurant menu items
- View all registered users

</td>
<td valign="top" width="33%">

### 🚴 Driver Panel
- View assigned deliveries
- Update delivery status live
- Pickup & drop-off flow

</td>
</tr>
</table>

---

## 🏗️ Tech Stack

| Layer | Technology |
|-------|-----------|
| **Frontend** | HTML5, CSS3, JavaScript, jQuery 3.7, Bootstrap 5.3 |
| **Animations** | AOS (Animate On Scroll) |
| **Backend** | Java 11, Jakarta Servlet 6.0, JSP 3.1 |
| **Database** | MySQL 8.0 |
| **Build** | Apache Maven 3.9 |
| **Server** | Apache Tomcat 10.1 |
| **Security** | BCrypt password hashing (jBCrypt) |
| **JSON** | Google Gson |

---

## 📁 Project Structure

```
TastyTrail/
├── src/main/
│   ├── java/com/tastytrail/
│   │   ├── dao/              # Data Access Layer
│   │   │   ├── DBConnection.java
│   │   │   ├── UserDAO.java
│   │   │   ├── OrderDAO.java
│   │   │   ├── MenuDAO.java
│   │   │   └── RestaurantDAO.java
│   │   ├── model/            # Data Models
│   │   │   ├── User.java
│   │   │   ├── Order.java
│   │   │   ├── MenuItem.java
│   │   │   ├── Restaurant.java
│   │   │   └── CartItem.java
│   │   ├── servlet/          # Controller Servlets
│   │   │   ├── LoginServlet.java
│   │   │   ├── RegisterServlet.java
│   │   │   ├── MenuServlet.java
│   │   │   ├── CartServlet.java
│   │   │   ├── OrderServlet.java
│   │   │   └── AdminServlet.java
│   │   └── listener/
│   │       └── AppInitListener.java
│   ├── resources/
│   │   └── db.properties     # DB config
│   └── webapp/
│       ├── css/style.css     # Global styles
│       ├── js/main.js        # Cart, toast & UI logic
│       ├── WEB-INF/
│       │   ├── includes/     # Navbar & footer partials
│       │   └── admin/        # Admin JSP views
│       ├── index.jsp         # Home page
│       ├── menu.jsp          # Menu & ordering
│       ├── cart.jsp          # Cart
│       ├── orders.jsp        # Order history
│       ├── login.jsp
│       └── register.jsp
├── database.sql              # Full schema + seed data
└── pom.xml
```

---

## 🚀 Getting Started

### Prerequisites

- Java JDK 11+
- Apache Maven 3.6+
- MySQL 8.0+
- Apache Tomcat 10.1+

---

### 1. Clone the Repository

```bash
git clone https://github.com/rkmaurya1/TastyTrail.git
cd TastyTrail
```

### 2. Setup Database

```bash
mysql -u root -p
```

```sql
CREATE DATABASE tastytrail;
USE tastytrail;
SOURCE database.sql;
```

### 3. Configure Database Connection

Edit `src/main/resources/db.properties`:

```properties
db.driver=com.mysql.cj.jdbc.Driver
db.url=jdbc:mysql://localhost:3306/tastytrail?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
db.username=root
db.password=your_password_here
```

### 4. Run the App (One Command)

```bash
mvn clean package cargo:run
```

This single command will:
- Compile the source code
- Build the WAR file
- Start embedded Tomcat 10 on port 8080
- Deploy the app automatically

### 5. Open in Browser

```
http://localhost:8080/TastyTrail
```

> Keep the terminal open while using the app. Press `Ctrl+C` to stop the server.

---

## 🔐 Default Login Credentials

| Role | Email | Password |
|------|-------|----------|
| **Admin** | `admin@tastytrail.com` | `admin123` |
| **Driver** | `driver@tastytrail.com` | `driver123` |
| **Customer** | Register a new account | — |

---

## 🗺️ Application Routes

| URL | Description | Access |
|-----|-------------|--------|
| `/` | Home page | Public |
| `/menu` | Full menu with categories | Public |
| `/cart` | Shopping cart | Login required |
| `/orders` | My order history | Login required |
| `/login` | Login page | Public |
| `/register` | Sign up | Public |
| `/admin/dashboard` | Admin panel | Admin only |
| `/admin/orders` | Manage orders | Admin only |
| `/driver/dashboard` | Driver panel | Driver only |

---

## 🗃️ Database Overview

| Table | Description |
|-------|-------------|
| `users` | Customers, admins and drivers (role-based) |
| `restaurants` | Single restaurant — TastyTrail |
| `menu_categories` | 10 categories (Starters, Pizza, Burgers, etc.) |
| `menu_items` | 26+ food items with price, description, veg flag |
| `orders` | Order records with status & payment info |
| `order_items` | Line items for each order |

---

## 📦 Key Dependencies (`pom.xml`)

```xml
jakarta.servlet-api        6.0.0   <!-- Servlet API for Tomcat 10 -->
jakarta.servlet.jsp-api    3.1.0   <!-- JSP support -->
jakarta.servlet.jsp.jstl   3.0.0   <!-- JSTL tag library -->
mysql-connector-j          8.3.0   <!-- MySQL JDBC driver -->
jbcrypt                    0.4     <!-- BCrypt password hashing -->
gson                       2.10.1  <!-- JSON responses -->
```

---

## 📸 UI Highlights

- **Hero Section** — Animated gradient background with floating food image & info chips
- **Menu Page** — Category sidebar + real food images from Unsplash
- **Order Tracking** — Step-by-step visual progress bar
- **Admin Dashboard** — Live stats, order management table
- **Responsive Design** — Works on mobile, tablet & desktop

---

## 🤝 Contributing

Contributions are welcome!

1. Fork the repo
2. Create your branch: `git checkout -b feature/YourFeature`
3. Commit: `git commit -m 'Add YourFeature'`
4. Push: `git push origin feature/YourFeature`
5. Open a Pull Request

---

## 📄 License

This project is licensed under the **MIT License** — free to use, modify and distribute.

---

<div align="center">

Built with ❤️ by **Ravikant Maurya**

If you found this project useful, please consider giving it a ⭐

</div>
