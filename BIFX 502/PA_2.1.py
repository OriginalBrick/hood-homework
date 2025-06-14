# J. Jedediah Smith
# Programming Assignment 2.1
# BIFX 502-1
# This program prompts the user for rated bursting pressure and current pressure, then determines if the boiler is operating at a safe pressure.

# Input
rated_psi = int(input("Enter the rated burting pressure of your boiler (psi): "))
current_psi = int(input("Enter the current pressure of your boiler (psi): "))
safe_psi = rated_psi * 0.3333

# Processing & Output
print("Your maximum safe pressure is:", int(safe_psi), " psi")
if current_psi > safe_psi:
    print("WARINING! Current pressure exceedes max safe pressure.")
else:
    print("Safe. Current pressure does not exceed max safe pressure.")
