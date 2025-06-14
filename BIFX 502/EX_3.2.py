# J. Jedediah Smith
# In-Class Exercise 3.2
# BIFX 502
# This program will propt the user for a DNA sequence, then check whether it contains any of three restriction sites.

# Input
DNA = input("Enter a DNA sequence: ")

#Processing & Output
restriction_sites = [
    "GAATTC", # EcoRI
    "GGATCC", # BamHI
    "AAGCTT", # HindIII
    ]

for site in restriction_sites:
    result = site in DNA
    print(site, "is in the sequence:", result)
