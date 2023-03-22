FROM rockylinux:9.1
WORKDIR  /opt/workdir 

RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-$(rpm -E '%{rhel}').noarch.rpm \ 
&& yum update -y \ 
&& yum install -y wget gcc gcc-c++ kernel-devel git \ 
&&  yum clean all

RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o miniconda.sh \
&& sh Miniconda3-latest-Linux-x86_64.sh -b -p /opt/miniconda

RUN /opt/miniconda/bin/conda create -n morld python=3.6 -y  \
&& /opt/miniconda/bin/conda install -n base conda-libmamba-solver

RUN /opt/miniconda/bin/conda install -y -n morld networkx=2.4 numpy=1.18.1 absl-py=0.9.0 pandas=1.0.1  cmake openmpi scipy matplotlib --solver=libmamba \
&& /opt/miniconda/bin/conda install -y -n morld openbabel=2.4.1 rdkit=2018.09.1  cudatoolkit=10 cudnn=7 -c conda-forge --solver=libmamba \
&& /opt/miniconda/envs/morld/bin/pip install tensorflow-gpu==1.14 six==1.14.0  gym==0.15.7 \
&& /opt/miniconda/envs/morld/bin/pip install torch==1.4.0 torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu \
&& /opt/miniconda/bin/conda clean --all -y

COPY mol_dqn/  ./mol_dqn/
COPY baselines/ ./baselines/
COPY gym-molecule ./gym-molecule/
COPY optimize_BE.py ./
COPY config.txt ./


RUN cd qvina/bin && chmod +x *
RUN cd baselines  && /opt/miniconda/envs/morld/bin/python setup.py install
RUN cd gym-molecule && /opt/miniconda/envs/morld/bin/python setup.py install
RUN cp ./gym-molecule/gym_molecule/envs/fpscores.pkl.gz /opt/miniconda/envs/morld/lib/python3.7/site-packages/gym_molecule-0.0.1-py3.7.egg/gym_molecule/envs/fpscores.pkl.gz

ENV PATH "/opt/conda-env/bin:/opt/miniconda/envs/morld/bin/:/var/lang/bin:/usr/local/bin:/usr/bin:/bin:/opt/bin:/opt/workdir/qvina/bin"
ENV OUTPUT_DIR "./save"
ENV PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION "python"

