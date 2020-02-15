# jupyter-lab-docker-rpi
A Docker image to run jupyterlab on your raspberry pi. Tested on rpi3b and rpi4 with raspian.

To run this docker image make sure you have Docker installed in your raspberry pi. You can find a tutorial [here](https://dev.to/rohansawant/installing-docker-and-docker-compose-on-the-raspberry-pi-in-5-simple-steps-3mgl)

----------
This is a Dockerfile for building __rpi-jupyter-lab__. The image is built on a Raspberry Pi 3B running raspian. 

The dockerfile starts a minimal notebook server with [resin/rpi-raspbian:jessie](https://hub.docker.com/r/resin/rpi-raspbian/) as base image without additional packages.  


### Installing
```python
docker pull jiwidi/jupyter-lab-rpi:latest
```

### Running the image
```python
docker run -dp 8888:8888 jiwidi/jupyter-lab-rpi:latesh 
```
The jupyter lab server should be accesible at  `http://<docker host IP address>:8888` and protected with a password `jns`

### Configuration
If you would like to change some config you can access bash in your container by:
```python
#Get your container id by running docker ps
docker exec -it <container id> /bin/bash 
```

And then execute:
```python
jupyter notebook password
```
You can also edit the config file `/root/.jupyter/jupyter_notebook_config.py` with any config you like!
