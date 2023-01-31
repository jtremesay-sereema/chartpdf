FROM python

# I hate modern development
RUN  curl -fsSL https://deb.nodesource.com/setup_18.x |  bash -
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs
RUN pip install -U pip setuptools wheel

WORKDIR /opt/chartpdf

COPY package.json package.json
COPY package-lock.json package-lock.json
RUN npm install

COPY requirements.txt requirements.txt
RUN pip install -Ur requirements.txt

COPY manage.py manage.py
COPY requirements.txt requirements.txt
COPY proj proj
COPY chartpdf chartpdf

RUN python3 manage.py collectstatic --no-input
RUN python3 manage.py compress
#CMD python3 manage.py runserver --noreload 0.0.0.0:8000
CMD gunicorn --bind 0.0.0.0:8000 proj.wsgi
