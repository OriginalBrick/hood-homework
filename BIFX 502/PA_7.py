# J. Jedediah Smith
# Programming Assignment 7
# BIFX 502
# Read in DNA sequences and perform various analyses.

def main():
    
    # Open file with read. No changes need to be made.
    filename = input("Please enter file name and extention: ")
    
    # Determine number of sequences and print.
    getCount(filename)

    # Determine number of sequences with CTATA pattern and print.
    getPattern(filename)

    # Determine number of sequences with more than 1000 bases and print.
    getLength(filename)

    # Determine number of sequences with over 50% GC composition and print.
    getContentGC(filename)

    # Determine number of sequences with more than 50% GC composition and over 2000 bases.
    getContentLength(filename)

def getCount(name):
    source = open(name,'r')
    count = 0
    for line in source:
        count += 1
    print("There are", count, "DNA sequences.")
    source.close()

def getPattern(name):
    source = open(name,'r')
    count = 0
    for line in source:
        if "CTATA" in line:
            count += 1
    print("There are", count, "DNA sequences with the CTATA pattern.")
    source.close()

def getLength(name):
    source = open(name,'r')
    count = 0
    for line in source:
        basecount = 0
        for base in line:
            basecount += 1
        if basecount > 1000:
            count += 1
    print("There are", count, "DNA sequences with more than 1000 bases.")    
    source.close()

def getContentGC(name):
    source = open(name,'r')
    count = 0
    for line in source:
        GCcount = 0
        totalcount = 0
        for base in line:
            totalcount += 1
            if base == "G" or base == "C":
                GCcount += 1
        if GCcount / totalcount > 0.50:
            count += 1
    print("There are", count, "DNA sequences with over 50% GC composition.") 
    source.close()

def getContentLength(name):
    source = open(name,'r')
    count = 0
    for line in source:
        GCcount = 0
        totalcount = 0
        for base in line:
            totalcount += 1
            if base == "G" or base == "C":
                GCcount += 1
        if (GCcount / totalcount > 0.50) and (totalcount > 2000):
            count += 1
    print("There are", count, "DNA sequences with more than 2000 bases and over 50% GC composition.") 
    source.close()

# Call the main function
main()
