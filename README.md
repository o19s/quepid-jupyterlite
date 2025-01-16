# Quepid Jupyterlite Notebooks

This repository contains a Jupyterlite build and some example Jupyter notebooks to be used within [Quepid](https://quepid.com/).
The build is offline-optimized to be used in environments with no access to the public internet. It prepackages the
Pyodide kernel and all dependencies according Jupyterlite [manual](https://jupyterlite.readthedocs.io/en/latest/howto/configure/advanced/offline.html).

## How to

* The build is [Docker](./Dockerfile) based. For a local run try `docker run -it --rm -e TARGET_DIR=/dist -v "$(pwd)":/dist $(docker build -q .)`.
This will generate a `jupyter-lite-build.tgz` with the self-contained Jupyterlite web app in your current directory.
* On Github a [GH action](./action.yml) uses the Docker build and is embedded into the [build workflow](./.github/workflows/main.yml)
which also add the build artifact as a release asset.
* To create a new release push a new tag.   Then the job will fire.

## Updates:
* Check [requirements.txt](./jupyterlite/requirements.txt) and [jupyter_lite_config.json](./jupyterlite/jupyter_lite_config.json) for library updates
* Check [Dockerfile](./Dockerfile) for Pyodide updates

## Development

Unzip the TGZ file which will then unpack into `./notebooks`.  

Run either `python -m http.server 8000 --directory ./notebooks` or `ruby -run -ehttpd ./notebooks -p 8000`

Browse to http://localhost:8000 and you should see the Jupyterlite interface.


## Development 2

1. Run `docker run -it --rm -e TARGET_DIR=/dist -v "$(pwd)":/dist $(docker build -q .)` producing the jupyter-lite-build.tgz.
1. Unzip it into the ./notebooks
1. `rm -rf public/notebooks` in Quepid
1. Make sure Quepid's docker-compose.override.yml has a line similar to `- /Users/epugh/Documents/projects/quepid-jupyterlite/notebooks:/srv/app/public/notebooks`
1.`bin/docker s` for Quepid
1. In your Browser developer tools under network click "Disable Cache".
1. Now load the content: http://localhost:3000/notebooks
1. Make changes, 
1. Do a fresh kernal restart and rerun, the `>>` button.  
1. Update the footer date stamp.
1. then download and save the file in `./jupyterlite/files` tree.
1. Delete `jupyterlite.tar.gz` 
1. run `docker run -it --rm -e TARGET_DIR=/dist -v "$(pwd)":/dist $(docker build -q .)`

If you are debugging these notebooks, they all use the Haystack Party data.
1. Check out the dev version of Quepid.
1. Run `bin/docker r bundle exec thor sample_data:haystack_party` to load into Quepid the data that the notebooks references.
