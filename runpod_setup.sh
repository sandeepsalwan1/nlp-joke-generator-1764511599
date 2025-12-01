#!/bin/bash
# RunPod Setup Script for NLP Joke Generator
# Run this on a fresh RunPod instance to set everything up

set -e  # Exit on any error

echo "=== NLP Joke Generator - RunPod Setup ==="

# 1. Install system dependencies
echo "[1/7] Installing system tools..."
apt-get update && apt-get install -y git-lfs zip magic-wormhole

# 2. Setup Git LFS
echo "[2/7] Setting up Git LFS..."
git lfs install

# 3. Clone the repository
echo "[3/7] Cloning repository..."
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
echo "[4/7] Downloading large data files via Git LFS..."
git lfs pull

# 5. Create virtual environment with system site-packages
# This inherits PyTorch/CUDA from RunPod's base image (saves time & disk)
echo "[5/7] Creating virtual environment with --system-site-packages..."
python -m venv --system-site-packages venv
source venv/bin/activate

# 6. Install Python dependencies (only what's not in system)
echo "[6/7] Installing Python packages..."
pip install --upgrade pip
pip install transformers accelerate gensim pandas nltk tensorflow tf-keras

# 7. Download NLTK data and move files
echo "[7/7] Setting up data files..."
python -c "import nltk; nltk.download('punkt_tab'); nltk.download('punkt')"

# Move TSV files if they're nested
if [ -d "compressed_data/rJokesData" ]; then
    mv compressed_data/rJokesData/*.tsv compressed_data/ 2>/dev/null || true
fi

echo ""
echo "=== Setup Complete! ==="
echo ""
echo "Virtual environment created at: /workspace/project/venv"
echo ""
echo "IMPORTANT: Activate venv before running (already active in this session):"
echo "  source /workspace/project/venv/bin/activate"
echo ""
echo "To train the model, run:"
echo "  python src/gpt2.py --train"
echo ""
echo "To generate jokes with existing model, run:"
echo "  python src/gpt2.py"
echo ""
echo "To download your trained model:"
echo "  cd models && zip -r model.zip distilgpt2-jokes && wormhole send model.zip"
echo ""
