# TastyTrail - Setup Guide

## 1. Install Prerequisites

- [Java JDK 11+](https://adoptium.net/)
- [Apache Tomcat 10+](https://tomcat.apache.org/)
- [MySQL 8+](https://dev.mysql.com/downloads/)
- [Maven 3+](https://maven.apache.org/)

## 2. Database Setup

```bash
mysql -u root -p < database.sql
```

This will create the `tastytrail` database with all tables and sample data.

## 3. Configure Database

Edit `src/main/resources/db.properties`:

```properties
db.driver=com.mysql.cj.jdbc.Driver
db.url=jdbc:mysql://localhost:3306/tastytrail?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
db.username=root
db.password=yourpassword
```

## 4. Build the Project

```bash
mvn clean package
```

WAR file will be created at `target/TastyTrail.war`.

## 5. Deploy to Tomcat

Copy the WAR file to Tomcat's webapps folder:

```bash
cp target/TastyTrail.war /path/to/tomcat/webapps/
```

Start Tomcat and open: `http://localhost:8080/TastyTrail`

## 6. Default Pages

| URL | Description |
|-----|-------------|
| `/TastyTrail/` | Home page |
| `/TastyTrail/login.jsp` | Login |
| `/TastyTrail/register.jsp` | Register |
| `/TastyTrail/restaurants` | All restaurants |
