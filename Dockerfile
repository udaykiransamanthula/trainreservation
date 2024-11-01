# Use the official Maven image to build the application
FROM maven:3.8.5-openjdk-17 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the project files to the container
COPY . .

# Build the WAR file
RUN mvn clean package

# Use the Tomcat image for runtime
FROM tomcat:9.0-jdk17

# Remove default Tomcat webapps to avoid conflicts
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the generated WAR file to the Tomcat webapps directory
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/app.war

# Expose the Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
