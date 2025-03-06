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
# 
# We need to trim the size of our package down, so we are explicitly deleting some default wheels
# from the resulting output.  Hacky!
CMD jupyter lite build \
  --config /build/jupyter_lite_config.json \
  --lite-dir /build \
  --no-sourcemaps \
  --output-dir notebooks \
  --pyodide https://github.com/pyodide/pyodide/releases/download/0.23.2/pyodide-0.23.2.tar.bz2 \
  && rm notebooks/static/pyodide/astropy-5.2* \
  && rm notebooks/static/pyodide/biopython-1.81* \
  && rm notebooks/static/pyodide/bokeh-3.1* \
  && rm notebooks/static/pyodide/Fiona-1.8* \
  && rm notebooks/static/pyodide/gdal-3.5* \
  && rm notebooks/static/pyodide/gensim* \
  && rm notebooks/static/pyodide/mne* \
  && rm notebooks/static/pyodide/mypy-1.1* \
  && rm notebooks/static/pyodide/opencv_python-4.7* \
  && rm notebooks/static/pyodide/*-tests.tar \
  && rm notebooks/static/pyodide/RobotRaconteur-0.15* \
  && rm notebooks/static/pyodide/scipy* \
  && rm notebooks/static/pyodide/sympy* \
  && rm notebooks/static/pyodide/test-1.0.* \
  && rm notebooks/static/pyodide/tomli* \
  && rm notebooks/static/pyodide/yt-4.1* \
  && tar -czf ${TARGET_DIR}/jupyter-lite-build.tgz notebooks
