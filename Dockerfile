FROM maven:3.8.1-adoptopenjdk-11

COPY version /app/
COPY scripts/*.sh /app/scripts/
COPY scripts/git/*.sh /app/scripts/git/
WORKDIR /app
RUN ls -ls /home/