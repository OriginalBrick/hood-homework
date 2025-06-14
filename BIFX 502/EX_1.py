# J. Jedediah Smith
# In-Class Exercise 1
# BIFX 502-1
# This program promts the user for a temperature in C, then converts it to F.

# Input
C = float(input("Enter temperature in Celsius: "))

# Processing
F = ((9/5)*C)+32

# Output
print(format(C, '.2f'), "C is", format(F, '.2f'), "F") #Format rounds to 2 decimal places.
