FROM python:3.12.0b3-alpine3.18
WORKDIR /app
COPY ./requirements.txt /app
RUN pip install -r requirements.txt
COPY . .
EXPOSE 5005
ENV FLASK_APP=server.py
CMD [ "flask", "run","--host","0.0.0.0","--port","5005"]
