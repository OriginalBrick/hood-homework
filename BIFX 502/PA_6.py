# J. Jedediah Smith
# Programming Assignment 6
# BIFX 502
# Processess a predefined DNA sequence in various ways.

def main():

    # Predefined sequence
    DNA_String = "ATCGATCGATCGATCGACTGACTAGTCATAGCTATGCATGTAGCTACTCGATCGATCGATCGATCGATCGATCGATCGATCGATCATGCTATCATCGATCGATATCGATGCATCGACTACTAT"

    # Determine exons and print.
    getExons(DNA_String)

    # Determine percent of exons and print.
    getPercent(DNA_String)

    # Convert intron to lowercase and print.
    getLower(DNA_String)

def getExons(string):
    Exon1 = string[:64]
    Exon2 = string[91:]
    print("The first exon is:", Exon1)
    print("The second exon is:", Exon2)

def getPercent(string):
    Exon1 = string[:64]
    Exon2 = string[91:]
    Total_Count = len(string)
    Exon_Count = len(Exon1+Exon2)
    Percent = Exon_Count/Total_Count*100
    print("Percent of coding DNA is: ", Percent, "%")

def getLower(string):
    Exon1 = string[:64]
    Exon2 = string[91:]
    Intron = string[64:91]
    NewDNA_String = Exon1 + Intron.lower() + Exon2
    print(NewDNA_String)

main()
