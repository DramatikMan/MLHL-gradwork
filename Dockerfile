FROM python:3.11-slim
SHELL ["/bin/bash", "-c"]
WORKDIR /project
ENV PYTHONPATH "${PYTHONPATH}:/project"

RUN pip install "pdm==2.7.0" \
    && pdm config check_update false \
    && pdm config venv.in_project true

COPY pyproject.toml pdm.lock* ./
RUN pdm sync --no-self
COPY notebook notebook
CMD pdm run jupyter
