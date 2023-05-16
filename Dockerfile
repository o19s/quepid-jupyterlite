FROM python:3.11
RUN pip install --no-cache-dir --upgrade pip

COPY jupyterlite /build/

RUN pip install --no-cache-dir -r /build/requirements.txt && rm -f requirements.txt

# Use the target dir, i.e. a mounted path from where the built artifact can be retrieved from
# Use the github workspace as the default.
# For a local run use e.g. /dist with `docker run -it --rm -e TARGET_DIR=/dist -v "$(pwd)":/dist $(docker build -q .)`
ENV TARGET_DIR=${GITHUB_WORKSPACE:-/github/workspace}

# Build the Jupyter lite web app, the pyodide kernel option is passed for offline availability
# (see https://jupyterlite.readthedocs.io/en/latest/howto/configure/advanced/offline.html), the
# Kernel version is taken from https://github.com/jupyterlite/pyodide-kernel/blob/main/packages/pyodide-kernel/package.json
CMD jupyter lite build \
  --lite-dir /build \
  --pyodide https://github.com/pyodide/pyodide/releases/download/0.23.2/pyodide-0.23.2.tar.bz2 \
  --output-dir notebooks \
  && tar -czf ${TARGET_DIR}/jupyter-lite-build.tgz notebooks
