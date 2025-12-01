#!/bin/bash
# RunPod Setup Script for NLP Joke Generator
# Run this on a fresh RunPod instance to set everything up

set -e  # Exit on any error

echo "=== NLP Joke Generator - RunPod Setup ==="

# 1. Install system dependencies
echo "[1/6] Installing system tools..."
apt-get update && apt-get install -y git-lfs zip magic-wormhole

# 2. Setup Git LFS
echo "[2/6] Setting up Git LFS..."
git lfs install

# 3. Clone the repository
echo "[3/6] Cloning repository..."
cd /workspace
if [ -d "project" ]; then
    echo "Project already exists, pulling latest..."
    cd project
    git fetch --all
    git reset --hard origin/main
else
    git clone https://github.com/sandeepsalwan1/nlp-joke-generator-1764511599.git project
    cd project
fi

# 4. Pull large files (the 300MB CSV)
echo "[4/6] Downloading large data files via Git LFS..."
git lfs pull

# 5. Install Python dependencies
echo "[5/6] Installing Python packages..."
pip install transformers accelerate gensim pandas nltk tensorflow tf-keras

# 6. Download NLTK data and move files
echo "[6/6] Setting up data files..."
python -c "import nltk; nltk.download('punkt_tab'); nltk.download('punkt')"

# Move TSV files if they're nested
if [ -d "compressed_data/rJokesData" ]; then
    mv compressed_data/rJokesData/*.tsv compressed_data/ 2>/dev/null || true
fi

echo ""
echo "=== Setup Complete! ==="
echo ""
echo "To train the model, run:"
echo "  python src/gpt2.py --train"
echo ""
echo "To generate jokes with existing model, run:"
echo "  python src/gpt2.py"
echo ""

