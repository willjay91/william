import json, os, sys
sys.path.append(os.path.abspath(os.curdir))
sys.path.append(os.path.join(os.path.dirname(__file__)))
import modules.pandas as pd
import modules.requests as requests
from io import StringIO

class data_processor:
    def __init__(self,url: str, refrence_col: str='Profit (in millions)',
    json_path: str='./data/data2.json', top_num: int=20):
        """
        This class processes a csv data file and generates the highest profits.
        Parameters:
            url:
                required: True
                default: N/A
                datatupe: string
                description: the url containing the datafile
            refrence_col:
                required: False
                default: 'Profit (in millions)'
                datatupe: string
                description: the column used to clean and check highest profit
            json_path:
                required: False
                default: './data/data2.json'
                datatupe: string
                description: the location to store the csv datafile
            top_num:
                required: False
                default: 20
                datatupe: integer
                description: the top number of columns to display
        """
        self.url = url
        self.column = refrence_col
        self.json_path = json_path
        self.top_num = top_num

    def run(self):
        self.load_data()
        self.clean_data()
        self.convert_to_json()
        self.top_performing()

    def load_data(self):
        raw = StringIO(requests.get(self.url, allow_redirects=True).text) #read data into string buffer
        self.df = pd.read_csv(raw)
        print(f"Number of rows in the data: {len(self.df)}")

    def clean_data(self):
        self.df[self.column] = pd.to_numeric( self.df[self.column], errors='coerce') #cast column to numeric
        self.df = self.df[self.df[self.column].notnull()] #remove non-numeric values
        print(f"Number of clean rows in the data: {len(self.df)}")

    def convert_to_json(self):
        self.df.to_json(path_or_buf=self.json_path,orient="table", index=False) #save data as jsin

    def top_performing(self):
        top_profit = self.df.sort_values(by=self.column, ascending=False) #sort by decending values of column
        print(f"The Top {self.top_num} {self.column} are:"); print(top_profit[:self.top_num])

if __name__ == "__main__":
    print("\n\n\n================ RUNNING HIGHEST PROFIT DATA PROCESSOR ================\n")

    try: url = sys.argv[1]
    except: print("You need to pass the URL of the csv file!")
    data_processor(url).run()

    print("\n\n=============================== FINISHED ===============================\n\n\n")
