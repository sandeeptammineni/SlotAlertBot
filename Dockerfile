FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    wget unzip xvfb libxi6 libgconf-2-4 libnss3 libxss1 libasound2 \
    libatk1.0-0 libatk-bridge2.0-0 libgtk-3-0 libdrm-dev libgbm-dev \
    fonts-liberation libappindicator3-1 libxrandr2 lsb-release \
    && rm -rf /var/lib/apt/lists/*

# Install Google Chrome
RUN wget -qO- https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb > /tmp/chrome.deb \
    && apt install -y /tmp/chrome.deb

# Install Chromedriver
RUN CHROMEDRIVER_VERSION=$(curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE) && \
    wget -q -O /tmp/chromedriver.zip https://chromedriver.storage.googleapis.com/${CHROMEDRIVER_VERSION}/chromedriver_linux64.zip && \
    unzip /tmp/chromedriver.zip -d /usr/local/bin/ && \
    chmod +x /usr/local/bin/chromedriver

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

# Install Python packages
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Run your script
CMD ["python", "check_f1_selenium.py"]
