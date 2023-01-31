FROM python
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs
RUN pip install -U pip setuptools wheel

WORKDIR /opt/chartpdf
COPY requirements.txt requirements.txt
RUN pip install -Ur requirements.txt

COPY manage.py manage.py
COPY package.json package.json
COPY package-lock.json package-lock.json
COPY requirements.txt requirements.txt
COPY proj proj
COPY chartpdf chartpdf

RUN SECRET_KEY=temporary python3 manage.py collectstatic --no-input
RUN SECRET_KEY=temporary python3 manage.py compress
CMD gunicorn proj.wsgi
