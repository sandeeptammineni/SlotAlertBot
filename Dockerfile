FROM seleniarm/standalone-chromium:latest

USER root

# Install python3-pip if not already present (some images have it pre-installed)
RUN apt-get update && apt-get install -y python3-pip

WORKDIR /app
COPY . .

# Upgrade pip and install requirements (with system override)
RUN pip3 install --upgrade pip --break-system-packages
RUN pip3 install --break-system-packages -r requirements.txt

CMD ["python3", "check_f1_selenium.py"]
