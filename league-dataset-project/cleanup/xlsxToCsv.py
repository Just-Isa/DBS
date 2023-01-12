import pandas as pd


champPath = '../files/leagueChampions.csv'
gamesPath = '../files/leagueDataset.csv'
# Making CSVS from Excel Datasheets
'''
read_league_xlsx = pd.read_excel('../files/GamesListPatch108.xlsx',)
read_league_champions_xlsx = pd.read_excel('../files/GamesListPatch108.xlsx', sheet_name='ChampionsList')

read_league_xlsx.to_csv('gamesPath', index=None, header=True)
read_league_champions_xlsx.to_csv('champPath', index=None, header=True)
'''

champsDF = pd.read_csv(champPath)
gamesDF = pd.read_csv(gamesPath)
print(gamesDF.head(20))