#!/usr/bin/env bash

PROJECT="/projects/rabh7066/repos/fairseq"
PREFIX="$PROJECT/examples/translation/korean-parallel.ko-en/korean-english-news-v1"
DATASET="$PREFIX/tmp/korean-english-park"
src="ko"
tgt="en"
BPE_TOKENS=2000
BPE_CODE="$PREFIX/bpe_code_$BPE_TOKENS"

BPE_ROOT="$PROJECT/examples/translation/subword-nmt"

LEARN_TRAIN_COMBINED="$PREFIX/learn_train.$src-$tgt"
if [ -f $BPE_CODE ]; then
  echo "bpe already learnt successfully"
else
  for L in $src $tgt; do
      cat $DATASET.train.$L >> $LEARN_TRAIN_COMBINED
  done
  echo "learn_bpe.py on $BPE_ROOT/learn_bpe.py"
  subword-nmt learn-bpe -s $BPE_TOKENS < $LEARN_TRAIN_COMBINED > $BPE_CODE
  rm -r $LEARN_TRAIN_COMBINED
  for L in $src $tgt; do
      for f in train.$L dev.$L test.$L; do
        echo "apply_bpe.py to ${f} ..."
        subword-nmt apply-bpe -c $BPE_CODE < $DATASET.$f > $PREFIX/$f
      done
  done
fi


echo "applying bpe"
 

fairseq-preprocess --source-lang $src --target-lang $tgt \
    --trainpref $PREFIX/train --validpref $PREFIX/dev --testpref $PREFIX/test \
    --destdir $PROJECT/data-bin/korean.tokenized.$src-$tgt

