# J. Jedediah Smith
# Programming Assignment 1.1
# BIFX 502-1
# This program promts the user for a temperature in F, then converts it to C.

# Input
F = float(input("Enter temperature in Fahrenheit: "))

# Processing
C = (F-32)*(5/9)

# Output
print(format(F, '.2f'), "F is", format(C, '.2f'), "C") #Format rounds to 2 decimal places.
