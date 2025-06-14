# J. Jedediah Smith
# Programming Assignment 8.1
# BIFX 502
# Reads in population data, then plots it against year using matplotlib.

import matplotlib.pyplot as plt

def main():

  try:
    inputfile = open('USPopulation.txt','r')
    population = inputfile.readlines()

    for i in range(len(population)):
      population[i] = int(population[i].rstrip('\n'))

    year = []
    year += range(1950, 1991)

    plt.plot(year, population)

    plt.title("US Population by Year")
    plt.xlabel("Year")
    plt.ylabel("Population in Thousands")

    plt.show()

  except IOError:
    print("File cannot be found.")

main()
