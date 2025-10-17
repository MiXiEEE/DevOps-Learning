FROM ubuntu:latest

# Install bash and common utilities
RUN apt-get update && apt-get install -y \
    bash \
    coreutils \
    grep \
    gawk \
    tar \
    curl \
    netcat-openbsd

# Copy your script into the image
COPY bash-scripting/scripting/monitor-disk-usage.sh /app/monitor-disk-usage.sh
COPY bash-scripting/scripting/check_website_status.sh /app/check_website_status.sh
COPY bash-scripting/scripting/run_all.sh /app/run_all.sh

# Set the working directory inside the container
WORKDIR /app

# Make sure the script is executable
RUN chmod +x monitor-disk-usage.sh
RUN chmod +x check_website_status.sh
RUN chmod +x run_all.sh
RUN ls -l /app

# This command will run your script when the container starts
ENTRYPOINT ["bash", "run_all.sh"]