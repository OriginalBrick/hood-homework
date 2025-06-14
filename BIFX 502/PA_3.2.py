# J. Jedediah Smith
# Programming Assignment 3.2
# BIFX 502-1
# This program prompts the user for data to predict approximate size of a population over time.

# Input
Start = int(input("Enter starting number of organisms: "))
Increase = int(input("Enter average daily increase (%): "))
Length = int(input("Enter number of days to multiply: "))

while Start < 1 or Increase < 1 or Length < 1:
    print("Error. Numbers must be positive.")
    Start = int(input("Enter starting number of organisms: "))
    Increase = int(input("Enter average daily increase (%): "))
    Length = int(input("Enter number of days to multiply: "))

# Processing & Output
for day in range(1, 11):
    print(day, "\t\t", Start)
    Start = Start + (Start*(.01*Increase))
