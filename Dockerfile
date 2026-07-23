# ══════════════════════════════════════════════════════════════════════
# STAGE 1: "builder" — the kitchen where cooking happens
# This stage exists only to compile. It gets thrown away after.
# ══════════════════════════════════════════════════════════════════════
FROM maven:3.9-eclipse-temurin-21 AS builder
WORKDIR /app

# Cache deps layer separately from source (cache trick from Topic 2)
COPY pom.xml .
RUN mvn dependency:go-offline -B

COPY src ./src
RUN mvn clean package -DskipTests
# Result: /app/target/GHA-Phase1-1.0.0-SNAPSHOT.jar


# ══════════════════════════════════════════════════════════════════════
# STAGE 2: "runtime" — the delivery tiffin box. This is what ships.
# ══════════════════════════════════════════════════════════════════════
FROM eclipse-temurin:21-jre-alpine
# ↑ JRE only — no compiler, no Maven, no source code

WORKDIR /app

# COPY --from=builder pulls the JAR out of stage 1 into this clean image
# Nothing else from the builder stage comes along
COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]

# Final image contains: Alpine Linux + JRE + your JAR. That's it.
# Size: ~180MB instead of ~500MB+