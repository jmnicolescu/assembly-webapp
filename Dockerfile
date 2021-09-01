FROM centos:7

LABEL version="2.0"
LABEL description="Simple Assembly Lane WebApp"

RUN yum -y install python3 python3-pip
RUN pip3 install flask

COPY . /opt/assembly-webapp

ENV APP_COLOR blue
ENV LC_ALL en_US.UTF-8

ENTRYPOINT FLASK_APP=/opt/assembly-webapp/app.py flask run --host=0.0.0.0 --port=8080

EXPOSE 8080
