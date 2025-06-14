# J. Jedediah Smith
# In-Class Exercise 4
# BIFX 502
# Function takes two inputs for protein sequence and amino acid residue code. Then uses subfunction to find percentage of the protein that amino acid makes up.  

#Main Function
def main():
    
    # 1. Get inputs
    ProSeq = input("Please enter Protein Sequence: ")
    AmiRed = input("Please enter Amino Acide Residue Code: ")
    
    # 2. Invoke Percentage function
    Result = percent(ProSeq, AmiRed)

    # 3. Print result from percent function
    print("The percentage is: ", Result, "%")

#Sub Function
def percent(protein, amino):

    #1. Count times amino acid residue code appears in the protein sequence.
    count = protein.count(amino)

    #2. Calculate the percentage.
    percent_similar = (count/len(protein))*100

    #3. Return the calculate percentage.
    return percent_similar

#Invoke Main Function
main()
