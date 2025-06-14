# J. Jedediah Smith
# In-Class Exercise 2
# BIFX 502
# This program will propt the user for a DNA sequence, then tally A, C, T, and G.

# Input
DNA = input("Enter DNA sequence: ")

# Process and Output

if "A" in DNA:
    # When A is found
    print("A Count = " + str(DNA.count("A")))
else:
    # When A is not found
    print("A not detected.") 

if "T" in DNA:
    # When T is found
    print("T Count = " + str(DNA.count("T")))
else:
    # When T is not found
    print("T not detected.") 

if "G" in DNA:
    # When G is found
    print("G Count = " + str(DNA.count("G")))
else:
    # When G is not found
    print("G not detected.")

if "C" in DNA:
    # When C is found
    print("C Count = " + str(DNA.count("C")))
else:
    # When C is not found
    print("C not detected.") 
