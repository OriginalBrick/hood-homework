# J. Jedediah Smith
# Programming Assignment 8.2
# BIFX 502
# Reads in expense data, then makes a pie chart using matplotlib.

import matplotlib.pyplot as plt

def main():

  try:
    inputfile = open('expenses.txt','r')
    expenses = inputfile.readlines()

    for i in range(len(expenses)):
      expenses[i] = int(expenses[i].rstrip('\n'))

    titles = ["Rent","Gas","Food","Clothing","Car Payments","Misc"]

    plt.pie(expenses, labels=titles)
    plt.title("Monthly Expenses")
    plt.show()

  except IOError:
    print("File cannot be found.")

main()
