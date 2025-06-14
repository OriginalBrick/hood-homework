# J. Jedediah Smith
# Programming Assignment 2.2
# BIFX 502-1
# This program prompts the user for the amount packages they purchased, determines the relevant discount, and then applies it to their total cost.

# Input
quantity = int(input("Enter the number of packages you have purchased: "))
discount = 0

# Processing
if quantity < 10:
    discount = 0
elif quantity >= 10 and quantity <= 19:
    discount = 0.10
elif quantity >= 20 and quantity <= 49:
    discount = 0.20
elif quantity >= 50 and quantity <= 99:
    discount = 0.30
elif quantity >= 100:
    discount = 0.40

total_without = 99*quantity
total_with = 99*quantity - (99*quantity*discount)

# Output
print("Total without discount: $" + str(total_without))
print("Discount: ", format(discount, '.2%'))
print("Total with discount: $" + str(total_with))
