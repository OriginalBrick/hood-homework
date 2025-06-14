# J. Jedediah Smith
# Programming Assignment 9
# BIFX 502
# Converts user inputted DNA sequence to amino acid residue protein structure.

gencode = {
 'TTT':'F', 'TTC':'F', 'TTA':'L', 'TTG':'L', 'TCT':'S',
 'TCC':'S', 'TCA':'S', 'TCG':'S', 'TAT':'Y', 'TAC':'Y',
 'TGT':'C', 'TGC':'C', 'TGG':'W', 'CTT':'L', 'CTC':'L',
 'CTA':'L', 'CTG':'L', 'CCT':'P', 'CCC':'P', 'CCA':'P',
 'CCG':'P', 'CAT':'H', 'CAC':'H', 'CAA':'Q', 'CAG':'Q',
 'CGT':'R', 'CGC':'R', 'CGA':'R', 'CGG':'R', 'ATT':'I',
 'ATC':'I', 'ATA':'I', 'ATG':'M', 'ACT':'T', 'ACC':'T',
 'ACA':'T', 'ACG':'T', 'AAT':'N', 'AAC':'N', 'AAA':'K',
 'AAG':'K', 'AGT':'S', 'AGC':'S', 'AGA':'R', 'AGG':'R',
 'GTT':'V', 'GTC':'V', 'GTA':'V', 'GTG':'V', 'GCT':'A',
 'GCC':'A', 'GCA':'A', 'GCG':'A', 'GAT':'D', 'GAC':'D',
 'GAA':'E', 'GAG':'E', 'GGT':'G', 'GGC':'G', 'GGA':'G',
 'GGG':'G'}

stop_codons = ['TAA', 'TAG', 'TGA']

def main():
    UserSeq = input("Enter DNA Sequence: ")

    # Removes end base until sequence is divisible by 3.
    while len(UserSeq)%3 !=0:
        UserSeq = UserSeq[:-1]

    # Loop through sequence bases. Every 3 bases, check codon and print results.
    count = 0
    codon = ""
    for base in UserSeq:
        count += 1
        codon += base
        if count == 3:
            print(check(codon), end="")
            count = 0
            codon = ""

# Returns * for stop codons, X for unknown codons, and acid residue for known codons. 
def check(codon):
    if codon in stop_codons:
        return "*"
    test = gencode.get(codon,"Codon not found.")
    if test != "Codon not found.":
         return test
    else:
         return "X"
    
main()
