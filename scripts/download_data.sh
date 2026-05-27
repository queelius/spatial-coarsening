#!/usr/bin/env bash
# Download the 10x Genomics V1 adult mouse coronal brain Visium dataset.
# Idempotent: skips files already present.
#
# Layout after running:
#   data/filtered_feature_bc_matrix/{matrix.mtx.gz, barcodes.tsv.gz, features.tsv.gz}
#   data/spatial/...
#   data/analysis/clustering/{graphclust, kmeans_*_clusters}/clusters.csv
#
# Total download: ~100 MB.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DATA_DIR="${REPO_ROOT}/data"
URL_BASE="https://cf.10xgenomics.com/samples/spatial-exp/1.1.0/V1_Adult_Mouse_Brain"

mkdir -p "${DATA_DIR}"
cd "${DATA_DIR}"

fetch_and_extract() {
    local file="$1"
    local extract_dir="$2"
    if [ -d "${extract_dir}" ] && [ -n "$(ls -A "${extract_dir}" 2>/dev/null)" ]; then
        echo "  ${extract_dir}/ already present, skipping."
        return 0
    fi
    if [ ! -f "${file}" ]; then
        echo "  downloading ${file}..."
        curl -sL --max-time 600 -o "${file}" "${URL_BASE}/V1_Adult_Mouse_Brain_${file}"
    else
        echo "  ${file} already present, skipping download."
    fi
    echo "  extracting ${file}..."
    tar xzf "${file}"
}

echo "[1/3] filtered feature-barcode matrix..."
fetch_and_extract "filtered_feature_bc_matrix.tar.gz" "filtered_feature_bc_matrix"

echo "[2/3] spatial metadata..."
fetch_and_extract "spatial.tar.gz" "spatial"

echo "[3/3] CellRanger analysis tarball (clusters, PCA, UMAP)..."
fetch_and_extract "analysis.tar.gz" "analysis"

echo ""
echo "Done. Files under ${DATA_DIR}/:"
du -sh filtered_feature_bc_matrix spatial analysis 2>/dev/null | sed 's/^/  /'
