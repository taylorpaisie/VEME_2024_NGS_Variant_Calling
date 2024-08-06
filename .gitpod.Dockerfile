FROM gitpod/workspace-full

USER gitpod

# Install Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/miniconda && \
    rm Miniconda3-latest-Linux-x86_64.sh

# Initialize Conda 
# install and use mamba as the dependency solver
# install packages for specifiedenvironment
RUN $HOME/miniconda/bin/conda init bash && \
    $HOME/miniconda/bin/conda install -n base conda-libmamba-solver && \
    $HOME/miniconda/bin/conda config --set solver libmamba && \
    $HOME/miniconda/bin/conda conda env create -f environment.yml


