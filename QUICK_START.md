# TastyTrail - Quick Start

## Requirements
- Java JDK 11+
- Apache Tomcat 10+
- MySQL 8+
- Maven 3+

## Steps

1. **Database setup**
   ```bash
   mysql -u root -p < database.sql
   ```

2. **Set your MySQL password** in `src/main/resources/db.properties`
   ```properties
   db.password=yourpassword
   ```

3. **Build**
   ```bash
   mvn clean package
   ```

4. **Deploy** `target/TastyTrail.war` to Tomcat

5. **Open** `http://localhost:8080/TastyTrail`
