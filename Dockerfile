FROM ghcr.io/browserless/chrome:latest

# Install Python & pip
RUN apt-get update && apt-get install -y python3 python3-pip

# Set work directory
WORKDIR /app

# Copy your files
COPY . .

# Install dependencies
RUN pip3 install --no-cache-dir -r requirements.txt

# Run your script
CMD ["python3", "check_f1_selenium.py"]
