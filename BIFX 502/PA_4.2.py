# J. Jedediah Smith
# Programming Assignment 4.2
# BIFX 502
# Prompts user for a number and creates a multiplication table for it.

# Input
Stop = int(input("Enter a stopping number: "))

# Processing & Output
Count = 1
for Num1 in range(1, Stop+1):
    for Num2 in range(Count, Stop+1):
        print(Num1,"*",Num2,"=",Num1*Num2)
    Count = Count+1
    print()
