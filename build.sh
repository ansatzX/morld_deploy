# centos7 cuda10.1
conda install -y -n base conda-libmamba-solver
conda config --set solver libmamba
conda create -n morld python=3.6 -y 
conda activate morld
conda install -y networkx=2.4 numpy=1.18.1 absl-py=0.9.0 pandas=1.0.1  cmake openmpi scipy matplotlib
conda install -y openbabel rdkit=2018.09.1 cudatoolkit=10 cudnn=7 -c conda-forge
pip install tensorflow-gpu==1.14 six==1.14.0  gym==0.15.7
# for cu10.1
pip install torch==1.4.1 torchvision==0.5.0 tqdm joblib cloudpickle click opencv-python scipy




git clone https://github.com/bowenliu16/rl_graph_generation --depth=1
git clone https://github.com/google-research/google-research.git --depth=1
git clone https://github.com/openai/baselines.git --depth=1
git clone https://github.com/rdkit/rdkit/ --depth=1
git clone https://github.com/QVina/qvina.git --depth=1

cd qvina/bin
chmod +x *
export PATH=$(pwd):$PATH
cd ../..

cp -r google-research/mol_dqn  . 
rm -rf google-research
cd mol_dqn 
cp -R ../rdkit/Contrib/SA_Score ./chemgraph/dqn/py
# do handly fix to 
# according to this
# https://github.com/rdkit/rdkit/issues/2279
cd ..

cp -r rl_graph_generation/gym-molecule/ .
rm -rf rl_graph_generation


cd baselines 
python setup.py install
cd ..

# conda install -y mgltools -c bioconda

cd gym-molecule 
python setup.py install
cd ..
# cp ./gym-molecule/gym_molecule/envs/fpscores.pkl.gz ${CONDA_PREFIX//base/envs}/morld-gpu/lib/python3.7/site-packages/gym_molecule-0.0.1-py3.7.egg/gym_molecule/envs/fpscores.pkl.gz

cp ./gym-molecule/gym_molecule/envs/fpscores.pkl.gz /export/home/gongcx/soft/miniconda3/envs/morld-gpu/lib/python3.7/site-packages/gym_molecule-0.0.1-py3.7.egg/gym_molecule/envs/fpscores.pkl.gz

# when run
export OUTPUT_DIR="./save"
export PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION=python
#export INIT_MOL="C1CC2=CC=CC=C2N(C1)C(=O)CN3CCC(CC3)NC4=NC(=CC(=O)N4)C(F)(F)F"
obabel -ipdb ligand.pdb -osmi  |awk '{print $1}' > ligand.smi

# json example ./mol_dqn/chemgraph/configs/bootstrap_dqn_step1.json
python optimize_BE.py --model_dir=${OUTPUT_DIR} --start_molecule=$(cat ligand.smi) --hparams="./run.json"