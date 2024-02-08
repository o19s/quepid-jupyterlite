# Quepid Jupyterlite Notebooks

This repository contains a Jupyterlite build and some example Jupyter notebooks to be used within [Quepid](https://quepid.com/).
The build is offline-optimized to be used in environments with no access to the public internet. It prepackages the
Pyodide kernel and all dependencies according Jupyterlite [manual](https://jupyterlite.readthedocs.io/en/latest/howto/configure/advanced/offline.html).

## How to

* The build is [Docker](./Dockerfile) based. For a local run try `docker run -it --rm -e TARGET_DIR=/dist -v "$(pwd)":/dist $(docker build -q .)`.
This will generate a `jupyter-lite-build.tgz` with the self-contained Jupyterlite web app in your current directory.
* On Github a [GH action](./action.yml) uses the Docker build and is embedded into the [build workflow](./.github/workflows/main.yml)
which also add the build artifact as a release asset.
* To create a new release push a new tag.

## Updates:
* Check [requirements.txt](./jupyterlite/requirements.txt) and [jupyter_lite_config.json](./jupyterlite/jupyter_lite_config.json) for library updates
* Check [Dockerfile](./Dockerfile) for Pyodide updates

## Development

Unzip the TGZ file which will then unpack into `./notebooks`.  

Run either `python -m http.server 8000 --directory ./notebooks` or `ruby -run -ehttpd ./notebooks -p 8000`

Browse to http://localhost:8000 and you should see the Jupyterlite interface.
