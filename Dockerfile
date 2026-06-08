FROM python:3.11-slim

# Install gitleaks
RUN apt-get update && apt-get install -y wget git \
    && wget https://github.com/gitleaks/gitleaks/releases/download/v8.30.1/gitleaks_8.30.1_linux_x64.tar.gz\
    && tar -xvf gitleaks_8.30.1_linux_x64.tar.gz \
    && mv gitleaks /usr/local/bin/gitleaks \
    && chmod +x /usr/local/bin/gitleaks \
# Install jq
    && apt-get install -y jq \
    && apt-get install -y curl \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install pandas openpyxl

# Copy your scripts
WORKDIR /apps

COPY . .


RUN echo "Hello Srishty!"
RUN ls 
RUN chmod +x app.sh 

# Default command
ENTRYPOINT ["bash", "-c", "./app.sh && sleep 2m"]

# RUN ./app.sh
# CMD ["sleep", "20m"]