FROM python:3.10

# System dependencies
# I hate modern development
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs

WORKDIR /opt/chartpdf

# Node dependencies
COPY package.json package.json
COPY package-lock.json package-lock.json
RUN npm install

# Python dependencies
RUN python -m venv venv
RUN venv/bin/pip install -U pip setuptools wheel
COPY requirements.txt requirements.txt
RUN venv/bin/pip install -Ur requirements.txt

# Copy project files
COPY manage.py manage.py
COPY proj proj
COPY chartpdf chartpdf

# Handle static files
RUN venv/bin/python manage.py collectstatic --no-input
RUN venv/bin/python manage.py compress

# Gunicorn
#CMD python3 manage.py runserver --noreload 0.0.0.0:8000
CMD venv/bin/gunicorn --bind 0.0.0.0:8000 proj.wsgi
