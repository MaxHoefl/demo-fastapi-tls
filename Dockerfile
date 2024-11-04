FROM python:3.10.15-alpine3.20

COPY --from=ghcr.io/astral-sh/uv:0.4.29 /uv /uvx /bin/

WORKDIR /app
COPY pyproject.toml uv.lock /app/
ENV UV_PROJECT_ENVIRONMENT="/usr/local/"
RUN uv sync --frozen

COPY ./main.py /app/
ENV PYTHONPATH="."
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
EXPOSE 8080
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]
