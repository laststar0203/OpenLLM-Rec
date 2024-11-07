#!/bin/sh

# 디렉토리 설정
DATA_DIR="./data"
BEAUTY_DIR="$DATA_DIR/beauty"
GAMES_DIR="$DATA_DIR/games"
ML100K_DIR="$DATA_DIR/ml-100k"

# 필요한 디렉토리 존재 여부 확인
if [ ! -d "$BEAUTY_DIR" ] || [ ! -d "$GAMES_DIR" ] || [ ! -d "$ML100K_DIR" ]; then
    echo "No directory required"
    exit 1
fi

# 다운로드할 URL 설정
BEAUTY_FILE1="http://snap.stanford.edu/data/amazon/productGraph/categoryFiles/ratings_Beauty.csv"
BEAUTY_FILE2="http://snap.stanford.edu/data/amazon/productGraph/categoryFiles/meta_Beauty.json.gz"

GAMES_FILE1="http://snap.stanford.edu/data/amazon/productGraph/categoryFiles/ratings_Video_Games.csv"
GAMES_FILE2="https://datarepo.eng.ucsd.edu/mcauley_group/data/amazon_v2/metaFiles2/meta_Video_Games.json.gz"

ML100K_FILE="https://files.grouplens.org/datasets/movielens/ml-latest-small.zip"

# 다운로드 실패 여부 플래그 초기화
DOWNLOAD_FAILED=0

# Beauty 파일 다운로드
wget -P "$BEAUTY_DIR" "$BEAUTY_FILE1" || DOWNLOAD_FAILED=1
wget -P "$BEAUTY_DIR" "$BEAUTY_FILE2" || DOWNLOAD_FAILED=1

# ml-100k 파일 다운로드
wget -P "$ML100K_DIR" "$ML100K_FILE" || DOWNLOAD_FAILED=1

# Games 파일 다운로드
wget -P "$GAMES_DIR" "$GAMES_FILE1" || DOWNLOAD_FAILED=1
wget -P "$GAMES_DIR" "$GAMES_FILE2" || DOWNLOAD_FAILED=1

unzip "$ML100K_DIR/ml-latest-small.zip"

# 다운로드 실패 시 파일 삭제
if [ $DOWNLOAD_FAILED -ne 0 ]; then
    echo "Download failed, deleting files..."
    rm -f "$BEAUTY_DIR/ratings_Beauty.csv"
    rm -f "$BEAUTY_DIR/meta_Beauty.json.gz"
    rm -f "$ML100K_DIR/ml-latest-small.zip"
    rm -f "$GAMES_DIR/ratings_Video_Games.csv"
    rm -f "$GAMES_DIR/meta_Video_Games.json.gz"
    exit 1
fi

echo "All files downloaded successfully."

