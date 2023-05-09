FROM python:3.10-slim
SHELL ["/bin/bash", "-c"]
WORKDIR /project
ENV PYTHONPATH "${PYTHONPATH}:/project"

RUN pip install "pdm==2.6.0" \
    && pdm config check_update false \
    && pdm config venv.in_project true

COPY pyproject.toml pdm.lock* ./
RUN pdm sync --no-self
COPY notebook notebook
CMD pdm run jupyter
