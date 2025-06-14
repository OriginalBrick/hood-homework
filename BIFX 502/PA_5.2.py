# J. Jedediah Smith
# Programming Assignment 5.2
# BIFX 502
# Asks for DNA and subset, then counts subset, counts number of G's and C's, and outputs the complement.

# Count occurences of substring in dna.
def count_substring(dna, substring):
    count = dna.count(substring)
    return count

# Count G's and C's in dna.
def get_gc_content(dna):
    g_count = dna.count("G")
    c_count = dna.count("C")
    return g_count, c_count

# Outputs complement of dna.
def complement(dna):
    comp = ""
    for n in dna:
        if n == "A":
            comp = comp+"T"
        elif n == "T":
            comp = comp+"A"
        elif n == "C":
            comp = comp+"G"
        elif n == "G":
            comp = comp+"C"
        else:
            comp = comp+n
    return comp

# Asks for DNA and subset, then counts subset, counts number of G's and C's, and outputs the complement.
def main():
    user_dna = input("Please enter a DNA sequence: ")
    user_subset = input("Please enter a DNA subset: ")
    
    sub_count = count_substring(user_dna, user_subset)
    print("Subset", user_subset, "appears in your DNA sequence", sub_count, "time(s).")

    user_gcon, user_ccon = get_gc_content(user_dna)
    print("Your sequence contains", user_gcon, "G's and", user_ccon, "C's.")

    user_comp = complement(user_dna)
    print("The complement to your sequence reads as followed:", user_comp)

# Main function call
main()
