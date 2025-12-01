#!/bin/bash
set -e

# 1. System setup
apt-get update && apt-get install -y git-lfs zip magic-wormhole
ln -sf /usr/bin/python3.10 /usr/bin/python3

# 2. Install pip manually (to fix system pip issues)
curl -sS https://bootstrap.pypa.io/get-pip.py | python3

# 3. Setup workspace
cd /workspace
if [ ! -d "project" ]; then
    git clone https://github.com/sandeepsalwan1/nlp-joke-generator-1764511599.git project
fi
cd project

# 4. Git LFS & Update
git lfs install
git fetch --all
git reset --hard origin/main
git lfs pull

# 5. Virtual Environment
if [ ! -d "venv" ]; then
    python3 -m venv --system-site-packages venv
fi
. venv/bin/activate

# 6. Python Dependencies
python3 -m pip install --upgrade pip
python3 -m pip install transformers accelerate gensim pandas nltk tensorflow tf-keras

# 7. NLTK Data
python3 -c "import nltk; nltk.download('punkt_tab'); nltk.download('punkt')"

# 8. Move Data Files (if needed)
if [ -d "compressed_data/rJokesData" ]; then
    mv compressed_data/rJokesData/*.tsv compressed_data/ 2>/dev/null || true
fi

echo "Setup Complete."
echo "Run: source venv/bin/activate && python3 src/gpt2.py --train"
