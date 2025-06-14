# J. Jedediah Smith
# Programming Assignment 1.2
# BIFX 502-1
# This program promts the user for number of male and female students, then determines what percentage they are of the class.

# Input
Male = int(input("Enter number of male students: "))
Female = int(input("Enter number of female students: "))

# Processing
Total = Male + Female
P_Male = (Male/Total)
P_Female = (Female/Total)

# Output
print(Total, "was your class size:\n", format(P_Male,'.2%'), "of the class is male.\n", format(P_Female,'.2%'), "of the class is female.")
