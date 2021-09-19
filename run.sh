echo "Running Highest Profit..."
echo "Downloading requirements..."
pip3 install -q -q -r ./requirements.txt -t ./modules --exists-action i
python3 main/highest_profit.py "https://gist.githubusercontent.com/bobbae/b4eec5b5cb0263e7e3e63a6806d045f2/raw/279b794a834a62dc108fc843a72c94c49361b501/data.csv"
echo "DONE!"
