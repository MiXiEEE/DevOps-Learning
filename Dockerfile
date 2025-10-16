FROM ubuntu:latest

# Install bash and common utilities
RUN apt-get update && apt-get install -y bash coreutils grep gawk tar

# Copy your script into the image
COPY bash-scripting/scripting/monitor-disk-usage.sh /app/monitor-disk-usage.sh

# Set the working directory inside the container
WORKDIR /app

# Make sure the script is executable
RUN chmod +x monitor-disk-usage.sh

# This command will run your script when the container starts
CMD ["bash", "monitor-disk-usage.sh"]