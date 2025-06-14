# J. Jedediah Smith
# Programming Assignment 5.1
# BIFX 502
# Asks for number of primes. Outputs that many primes, starting from 2.

# Returns True if n is prime, False if not.
def isprime(n):
    if n==0 or n==1:
        return False
    if n==2:
        return True
    for m in range(2,n):
        if n%m==0:
            return False
    return True

# Asks for number of primes. Outputs that many primes, starting from 2.
def main():
    Num = input("How many prime numbers do you want? ")
    Count = 1
    Iterator = 0
    while int(Num) < 1:
        print("Please enter a positive, non-zero number.")
        Num = input("How many prime numbers do you want? ")
    print("The first", Num, "prime numbers are:")
    while Count <= int(Num):
        Result = isprime(Iterator)
        if Result == True:
            print(Iterator)
            Count = Count + 1
        Iterator = Iterator +1

# Main function call
main()
