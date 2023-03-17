#  morld set-up scripts

[morld](https://github.com/wsjeon92/morld) is a add-on for moldnq, its actully just one script which imply [moldqn](https://github.com/google-research/google-research/tree/master/mol_dqn) 



# usage 

1. use mgltools to get pdb and pdbqt for calc.

2. install morld in your env. or build a docker 

3. write config.txt and hparams.json which can use moldqn's settings jsons

4. transfer your init liand to smi 

    ```
    obabel -ixxx ligand.xxx -osmi 
    ```

5. run script

    ```
    python optimize_BE.py --model_dir=${OUTPUT_DIR} --start_molecule=${INIT_MOL} --hparams=hp.json
    ```
    or
    ```
    docker run --rm -v $PWD:/opt/workdir morld:cpu  python optimize_BE.py --model_dir=${OUTPUT_DIR} --start_molecule=${INIT_MOL} --hparams=hp.json
    ```