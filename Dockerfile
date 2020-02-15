# This file creates a container that runs a jupyter lab server on Raspberry Pi
#
# Author: Jaime Ferrando Huertas
# Date 15/02/2020
#
# Originally from: https://github.com/mkjiang/rpi-jupyter/blob/master/Dockerfile and https://github.com/kidig/rpi-jupyter-lab/blob/master/Dockerfile
#

FROM resin/raspberrypi3-python:3.6
MAINTAINER Jaime Ferrando Huertas <fhjaime96@gmail.com>

WORKDIR /root

# Update pip and install jupyter
RUN apt-get update && apt-get install -y libncurses5-dev libzmq-dev libfreetype6-dev libpng-dev
RUN apt-get install python-dev --fix-missing 

RUN pip3 install --upgrade pip
RUN pip3 install cython
RUN pip3 install readline ipywidgets jupyter jupyterlab


# Configure jupyter
RUN jupyter nbextension enable --py widgetsnbextension
RUN jupyter serverextension enable --py jupyterlab
RUN jupyter notebook --generate-config
RUN mkdir notebooks
RUN sed -i "/c.NotebookApp.open_browser/c c.NotebookApp.open_browser = False" /root/.jupyter/jupyter_notebook_config.py \
        && sed -i "/c.NotebookApp.ip/c c.NotebookApp.ip = '*'" /root/.jupyter/jupyter_notebook_config.py \
        && sed -i "/c.NotebookApp.notebook_dir/c c.NotebookApp.notebook_dir = '/root'" /root/.jupyter/jupyter_notebook_config.py \ 
        && sed -i "/c.NotebookApp.password/c c.NotebookApp.password = 'sha1:5815fb7ca805:f09ed218dfcc908acb3e29c3b697079fea37486a'" /root/.jupyter/jupyter_notebook_config.py

VOLUME /root/notebooks

# Add Tini. Tini operates as a process subreaper for jupyter. This prevents kernel crashes.
ENV TINI_VERSION 0.18.0
ENV CFLAGS="-DPR_SET_CHILD_SUBREAPER=36 -DPR_GET_CHILD_SUBREAPER=37"

ADD https://github.com/krallin/tini/archive/v${TINI_VERSION}.tar.gz /root/v${TINI_VERSION}.tar.gz
RUN apt-get install -y cmake
RUN tar zxvf v${TINI_VERSION}.tar.gz \
        && cd tini-${TINI_VERSION} \
        && cmake . \
        && make \
        && cp tini /usr/bin/. \
        && cd .. \
        && rm -rf "./tini-${TINI_VERSION}" \
        && rm "./v${TINI_VERSION}.tar.gz"

ENTRYPOINT ["/usr/bin/tini", "--"]

EXPOSE 8888

CMD ["jupyter", "lab", "--allow-root"]

