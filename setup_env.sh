#!/bin/bash
set -e

apt-get update && apt-get install -y zip magic-wormhole python3-pip python3-venv

ln -sf /usr/bin/python3.10 /usr/bin/python3

if [ ! -d "venv" ]; then
    python3 -m venv --system-site-packages venv
fi

. venv/bin/activate

pip install --upgrade pip
pip install transformers accelerate gensim pandas nltk tensorflow tf-keras

python3 -c "import nltk; nltk.download('punkt_tab'); nltk.download('punkt')"

if [ -d "compressed_data/rJokesData" ]; then
    mv compressed_data/rJokesData/*.tsv compressed_data/ 2>/dev/null || true
fi




cd /workspace/project
deactivate 2>/dev/null || true
rm -rf venv
python3 -m venv venv
source venv/bin/activate


pip install --upgrade pip
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124


pip install transformers accelerate gensim pandas nltk tensorflow tf-keras
python -c "import nltk; nltk.download('punkt_tab'); nltk.download('punkt')"
python -c "import torch; print('CUDA Available:', torch.cuda.is_available())"

python src/gpt2.py --train

