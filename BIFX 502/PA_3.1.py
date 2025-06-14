# J. Jedediah Smith
# Programming Assignment 3.1
# BIFX 502-1
# This program prints 1 - 20 degress Celsius and then the respective temperature in Fahrenheit.

# Processing
print("Celsius\t\tFahrenheit")

for n in range(0,21):
    f = (n*(9/5))+32
    print(n, "\t\t", f)
