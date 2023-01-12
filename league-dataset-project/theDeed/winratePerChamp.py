import math
from turtle import color
import pandas as pd
import matplotlib.pyplot as plt
import itertools
import numpy as np

# -------------------------------------- DETERMINE IF THE MATCHUPS WHERE PUT OUT FAIRLY --------------------------------------
# Check if the Mastery Points of that Character for that user is above 50000
def main(x):
    return x > 50000

def firsTime(x):
    return x < 1000

def getChampionName(x, champsDF:pd.DataFrame):
    return str(champsDF.loc[champsDF['Key'] == x].values[0][0])

# sourcery skip: hoist-statement-from-loop
champPath = '../files/leagueChampions.csv'
gamesPath = '../files/leagueDataset.csv'

champsDF = pd.read_csv(champPath)
gamesDF = pd.read_csv(gamesPath)

result = champsDF[['Champion', 'Key', 'Role1']].copy()
result['AmountMatches'] = 0
result['AmountMatchesWon'] = 0
result['AmountMatchesLost'] = 0
result['Winrate'] = 0
result['PositionPercentage'] = 0
result['Position'] = ""
'''
xd = 0
for x in gamesDF.values:
    y = 875
    if x[3] == y or x[8] == y or x[13] == y or x[18] == y or x[23] == y or x[28] == y or  x[33] == y or x[38] == y or x[43] == y or x[48] == y:
        print("Sett!")
        xd = xd+1
print(xd)
'''

for y in result['Key']:
    champCounter, wonGames, lostGames = 0, 0, 0
    topRate, botRate, midRate, jngRate, supRate = 0, 0, 0, 0, 0
    for lmao, x in itertools.product(gamesDF.values, range(3, 49, 5)):
        if lmao[x] == y:
            if lmao[51] == 't1':
                wonGames = wonGames + 1
            else:
                lostGames = lostGames + 1
            champCounter = champCounter + 1
            if lmao[x-1] == 'TOP':
                topRate = topRate + 1
            elif lmao[x-1] == 'ADC':
                botRate = botRate + 1
            elif lmao[x-1] == 'SUPPORT':
                supRate = supRate + 1
            elif lmao[x-1] == 'JUNGLE':
                jngRate = jngRate + 1
            elif lmao[x-1] == 'MID':
                midRate = midRate + 1
            
    maxPlayRate = sorted([topRate, botRate, midRate, jngRate, supRate], reverse=True)
    if maxPlayRate[0] == topRate:
        result["Position"] = np.where(result['Key'] == y, "TOP", result["Position"])
    elif maxPlayRate[0] == botRate:
        result["Position"] = np.where(result['Key'] == y, "ADC", result["Position"])
    elif maxPlayRate[0] == supRate:
        result["Position"] = np.where(result['Key'] == y, "SUPPORT", result["Position"])
    elif maxPlayRate[0] == midRate:
        result["Position"] = np.where(result['Key'] == y, "MID", result["Position"])
    elif maxPlayRate[0] == jngRate:
        result["Position"] = np.where(result['Key'] == y, "JUNGLE", result["Position"])
        
    result["AmountMatches"] = np.where(result['Key'] == y, champCounter, result["AmountMatches"])
    result["AmountMatchesWon"] = np.where(result['Key'] == y, wonGames, result["AmountMatchesWon"])
    result["AmountMatchesLost"] = np.where(result['Key'] == y, lostGames, result["AmountMatchesLost"])
    result["PositionPercentage"] = np.where(result['Key'] == y, round((max([topRate, botRate, midRate, jngRate, supRate])/champCounter) * 100, 2)  , result["PositionPercentage"])
    result["Winrate"] = np.where(result['Key'] == y, round((wonGames / champCounter) * 100, 2), result["Winrate"])

print(result)

result.plot(kind="bar", x='Champion', y='PositionPercentage')
plt.show()





# -------------------------------------- DETERMINE IF THE MATCHUPS WHERE PUT OUT FAIRLY --------------------------------------