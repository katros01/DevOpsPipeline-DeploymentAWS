# Use an official Java runtime as the base image (JDK 21)
FROM eclipse-temurin:21-jdk

# Copy the Spring Boot app JAR
COPY target/my-spring-app.jar my-spring-app.jar

# Expose port 8080 to the outside world
EXPOSE 8080

# Run the JAR file
ENTRYPOINT ["java", "-jar", "/my-spring-app.jar"]
