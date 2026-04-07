FROM python:3.11-alpine

WORKDIR /app

COPY simple_time_service.py .

RUN adduser -D appuser

USER appuser

EXPOSE 8080

CMD ["python", "simple_time_service.py"]