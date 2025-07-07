FROM ghcr.io/browserless/chrome:latest

# Switch to root user so we can install packages
USER root

# Install Python and pip
RUN apt-get update && apt-get install -y python3 python3-pip

# Set work directory
WORKDIR /app

# Copy project files
COPY . .

# Install Python packages
RUN pip3 install --no-cache-dir -r requirements.txt

# Run the bot
CMD ["python3", "check_f1_selenium.py"]
