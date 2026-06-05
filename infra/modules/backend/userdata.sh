#!/bin/bash
set -e
exec > /var/log/userdata.log 2>&1

# Install dependencies
yum update -y
yum install -y python3 python3-pip git postgresql15

# Clone app
cd /home/ec2-user
git clone ${repo_url} app
cd app/backend

# Install Python packages
pip3 install fastapi uvicorn sqlalchemy psycopg2-binary \
  python-jose passlib bcrypt python-multipart \
  pydantic-settings email-validator boto3

# Create .env file
cat > .env << ENVEOF
DATABASE_URL=${db_url}
SECRET_KEY=${secret_key}
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30
ENVIRONMENT=dev
ENVEOF

# Create systemd service
cat > /etc/systemd/system/hospital-app.service << SVCEOF
[Unit]
Description=Hospital Appointment API
After=network.target

[Service]
User=ec2-user
WorkingDirectory=/home/ec2-user/app/backend
ExecStart=/usr/local/bin/uvicorn app.main:app --host 0.0.0.0 --port 8080
Restart=always
EnvironmentFile=/home/ec2-user/app/backend/.env

[Install]
WantedBy=multi-user.target
SVCEOF

systemctl daemon-reload
systemctl enable hospital-app
systemctl start hospital-app
