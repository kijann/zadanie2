FROM openjdk:21-alpine
WORKDIR /app
COPY zadanie2/target/zadanie2.jar /app/zadanie2.jar
EXPOSE 9090
CMD ["java", "-jar", "zadanie2.jar"] 
