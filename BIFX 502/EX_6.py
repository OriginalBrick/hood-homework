# J. Jedediah Smith
# In-Class Exercise 6
# BIFX 502
# Prompt user for a string, then count the number of lower case, upper case, digits, spaces. Also display reverse.

def main():
    # Get user input
    InputString = str(input("Please enter a string: "))

    #Process and print the message

    print("Number of upper case:", upperCaseCounter(InputString))
    print("Number of lower case:", lowerCaseCounter(InputString))
    print("Number of digits:", digitCounter(InputString))
    print("Number of spaces:", spaceCounter(InputString))
    print("Reverse:", backwards(InputString))

    
def upperCaseCounter(string):
    count = 0
    for character in string:
        if character.isupper():
            count += 1
    return count

def lowerCaseCounter(string):
    count = 0
    for character in string:
        if character.islower():
            count += 1
    return count

def digitCounter(string):
    count = 0
    for character in string:
        if character.isdigit():
            count += 1
    return count

def spaceCounter(string):
    count = 0
    for character in string:
        if character.isspace():
            count += 1
    return count

def backwards(string):
    reverse = string[-1::-1]
    return reverse

main()
