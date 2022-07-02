from turtle import color
import pandas as pd
import matplotlib.pyplot as plt
import itertools
# -------------------------------------- DETERMINE IF THE MATCHUPS WHERE PUT OUT FAIRLY --------------------------------------
# Check if the Mastery Points of that Character for that user is above 50000
def main(x):
    return x > 50000

def firsTime(x):
    return x < 1000

def getChampionName(x, champsDF:pd.DataFrame):
    return str(champsDF.loc[champsDF['Key'] == x].values[0][0])

champPath = '../files/leagueChampions.csv'
gamesPath = '../files/leagueDataset.csv'

champsDF = pd.read_csv(champPath)
gamesDF = pd.read_csv(gamesPath)

result = gamesDF[['GameID', 'winner']].copy()


for j, i in itertools.product(range(1,3), range(1,6)):
    result[f'team{str(j)}player{str(i)}_main'] = [1 if main(x) else 0 for x in gamesDF[f't{str(j)}_mast{str(i)}']]

for j, i in itertools.product(range(1,3), range(1,6)):
    result[f'team{str(j)}player{str(i)}_main'] = [1 if main(x) else 0 for x in gamesDF[f't{str(j)}_mast{str(i)}']]
    
for j, i in itertools.product(range(1,3), range(1,6)):
    result[f't{str(j)}_summoner{str(i)}_champion'] = [getChampionName(x, champsDF) for x in gamesDF[f't{str(j)}_champ{str(i)}']]


result['t1_main_amount'] = result['team1player1_main'] + result['team1player2_main'] + result['team1player3_main'] + result['team1player4_main'] + result['team1player5_main'] 
result['t2_main_amount'] = result['team2player1_main'] + result['team2player2_main'] + result['team2player3_main'] + result['team2player4_main'] + result['team2player5_main'] 

for j, i in itertools.product(range(1,3), range(1,6)):
    result = result.drop(f'team{str(j)}player{str(i)}_main', axis=1)

t1WinsWithMainAmount = pd.DataFrame({
    'team':["team1", "team2"],
    'wins':[len([x for x in gamesDF['winner'] if x == 't1']), len([x for x in gamesDF['winner'] if x == 't2'])],
    'mains':[sum([x for x in result['t1_main_amount']]), sum([x for x in result['t2_main_amount']])],
    'winrate':[(len([x for x in gamesDF['winner'] if x == 't1'])/len([x for x in gamesDF['winner']]))*100, (len([x for x in gamesDF['winner'] if x == 't2'])/len([x for x in gamesDF['winner']]))*100]
})

print(t1WinsWithMainAmount)
    
ax = plt.gca()
t1WinsWithMainAmount.plot(kind="bar", x='team', y='wins')
plt.show()
# -------------------------------------- DETERMINE IF THE MATCHUPS WHERE PUT OUT FAIRLY --------------------------------------