# J. Jedediah Smith
# In-Class Exercise 8
# BIFX 502
# User inputs team name, get how many times name appears on the list.

def main():

  try:
    inputfile = open('WorldSeriesWinners.txt','r')
    winners = inputfile.readlines()

    for i in range(len(winners)):
      winners[i] = winners[i].rstrip('\n')

    team = input("Enter team name: ")
    count = 0

    if team in winners:
      for item in winners:
        if item == team:
          count += 1
      print("Your team has won", count, "times between 1903 and 2009.")
    else:
      print("Your team has not won between 1903 and 2009.")

  except IOError:
    print("File cannot be found.")
  except:  
    print("An error has occured.")

main()
