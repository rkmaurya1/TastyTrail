# TastyTrail — Login Credentials & Access Links

## Quick Start
> Make sure Tomcat & PostgreSQL are running before opening any link.

---

## 👤 Admin

| Field    | Value                        |
|----------|------------------------------|
| URL      | http://localhost:8080/TastyTrail/login |
| Email    | admin@tastytrail.com         |
| Password | admin123                     |

### Admin Panel Pages
| Page           | Link |
|----------------|------|
| Dashboard      | http://localhost:8080/TastyTrail/admin/dashboard |
| Manage Orders  | http://localhost:8080/TastyTrail/admin/orders |
| Manage Restaurants | http://localhost:8080/TastyTrail/admin/restaurants |
| All Users      | http://localhost:8080/TastyTrail/admin/users |

---

## 🛵 Driver

| Field    | Value                        |
|----------|------------------------------|
| URL      | http://localhost:8080/TastyTrail/login |
| Email    | driver@tastytrail.com        |
| Password | driver123                    |

### Driver Panel Pages
| Page              | Link |
|-------------------|------|
| Driver Dashboard  | http://localhost:8080/TastyTrail/driver/dashboard |

---

## 🛍️ Customer (User)

| Field    | Value                        |
|----------|------------------------------|
| URL      | http://localhost:8080/TastyTrail/register |
| Email    | Register karke banao         |
| Password | Apni choice ka               |

### Customer Pages
| Page          | Link |
|---------------|------|
| Home          | http://localhost:8080/TastyTrail/ |
| Restaurants   | http://localhost:8080/TastyTrail/restaurants |
| Cart          | http://localhost:8080/TastyTrail/cart |
| My Orders     | http://localhost:8080/TastyTrail/orders |
| Profile       | http://localhost:8080/TastyTrail/profile |
| Login         | http://localhost:8080/TastyTrail/login |
| Register      | http://localhost:8080/TastyTrail/register |

---

## 🗄️ Database

| Field     | Value       |
|-----------|-------------|
| Type      | PostgreSQL  |
| Host      | localhost   |
| Port      | 5432        |
| Database  | tastytrail  |
| Username  | postgres    |
| Password  | (blank)     |

```bash
# Database me directly dekhne ke liye:
psql -U postgres -d tastytrail

# Users dekhne ke liye:
psql -U postgres -d tastytrail -c "SELECT id, name, email, role FROM users;"

# Orders dekhne ke liye:
psql -U postgres -d tastytrail -c "SELECT id, status, total_amount FROM orders ORDER BY id DESC;"
```

---

## 🚀 Server Start/Stop Commands

```bash
# PostgreSQL start
brew services start postgresql@15

# Tomcat start
JAVA_HOME=/opt/homebrew/opt/openjdk@11 /opt/homebrew/opt/tomcat@10/libexec/bin/startup.sh

# Tomcat stop
/opt/homebrew/opt/tomcat@10/libexec/bin/shutdown.sh

# Project rebuild karo (code change karne ke baad)
cd /Users/tryenor/Documents/GitHub/TastyTrail
mvn clean package
cp target/TastyTrail.war /opt/homebrew/opt/tomcat@10/libexec/webapps/
# Phir Tomcat restart karo
```

---

## 🔁 Role Flow

```
Login → Role check → Redirect
─────────────────────────────
ADMIN   → /admin/dashboard
DRIVER  → /driver/dashboard
CUSTOMER → / (Home page)
```

---

## 📁 Project Location

```
/Users/tryenor/Documents/GitHub/TastyTrail/
├── src/main/java/com/tastytrail/
│   ├── servlet/     → LoginServlet, AdminServlet, DriverServlet...
│   ├── dao/         → UserDAO, RestaurantDAO, OrderDAO...
│   ├── model/       → User, Restaurant, MenuItem, Order...
│   └── listener/    → AppInitListener (creates admin/driver on startup)
├── src/main/webapp/
│   ├── WEB-INF/
│   │   ├── admin/   → dashboard.jsp, orders.jsp, restaurants.jsp, users.jsp
│   │   ├── driver/  → dashboard.jsp
│   │   └── includes/→ navbar.jsp, footer.jsp
│   ├── index.jsp    → Homepage
│   ├── login.jsp    → Login page
│   ├── register.jsp → Register page
│   ├── restaurants.jsp
│   ├── menu.jsp
│   ├── cart.jsp
│   ├── orders.jsp
│   └── profile.jsp
├── database.sql     → PostgreSQL schema + sample data
├── pom.xml          → Maven dependencies
└── CREDENTIALS.md   → Ye file
```
