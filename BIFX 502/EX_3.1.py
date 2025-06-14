# J. Jedediah Smith
# In-Class Exercise 3.1
# BIFX 502
# This program will propt the user for a DNA sequence, then print it 8 times with a respective number.

# Input
DNA = input("Enter a DNA sequence: ")

#Processing & Output

# Using While Loop
n = 1
while n<=8:
    print(n," ",DNA)
    n = n+1

# Using For Loop
for num in range(1,9):
    print(num, " ", DNA)
