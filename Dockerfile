FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libnss3 libatk1.0-0 libatk-bridge2.0-0 libxss1 libgtk-3-0 \
    libgbm1 libx11-xcb1 libxcomposite1 libxdamage1 libxrandr2 libasound2 \
    libpangocairo-1.0-0 libcups2 curl unzip wget fonts-liberation \
    && rm -rf /var/lib/apt/lists/*

# Set workdir
WORKDIR /app

# Copy files
COPY . .

# Install Python packages
RUN pip install --no-cache-dir -r requirements.txt

CMD ["python", "check_f1_selenium.py"]
