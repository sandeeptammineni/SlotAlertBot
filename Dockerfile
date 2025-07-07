FROM seleniarm/standalone-chromium:latest

USER root

# Install Python and pip
RUN apt-get update && apt-get install -y python3 python3-pip && \
    rm -rf /var/lib/apt/lists/*

# Create app folder
WORKDIR /app

# Copy project files
COPY . .

# Install Python dependencies
RUN pip3 install --upgrade pip
RUN pip3 install -r requirements.txt

# Run the script
CMD ["python3", "check_f1_selenium.py"]
