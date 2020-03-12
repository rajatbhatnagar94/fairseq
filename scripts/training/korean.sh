#!/usr/bin/env bash
project="/projects/rabh7066/repos/fairseq"
cd $project

exp_name="korean.tokenized.ko-en"
seed=$1
epochs=5

save_dir=checkpoints/${exp_name}_$seed

mkdir -p $save_dir

fairseq-train data-bin/$exp_name \
  --encoder-hidden-size 1024 --decoder-hidden-size 1024 \
  --encoder-embed-dim 512 --decoder-embed-dim 512 \
  --encoder-layers 1 --decoder-layers 1 \
  --dropout 0.5 --encoder-dropout-out 0.2 --decoder-dropout-out 0.2 \
  --max-tokens 1000 --lr 0.0005 \
  --optimizer adam \
  --arch lstm_wiseman_iwslt_de_en \
   --save-dir $save_dir \
  --max-epoch $epochs \
  --batch-size 20 \
  --encoder-bidirectional \
  --seed $seed

