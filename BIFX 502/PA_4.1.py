# J. Jedediah Smith
# Programming Assignment 4.1
# BIFX 502
# Prompts user for number of exams. Asks for that number of scores. Gets score average and higest.

# Input
ExamCount = int(input("Please enter the number of exams: "))
Count = 1
Sum = 0
Highest = 0
Score = 0

while Count <= ExamCount:
    Score = float(input("Please enter exam score: "))
    Sum = Sum+Score
    if Score > Highest:
        Highest = Score
    Count = Count+1

# Processing
Avg = Sum/ExamCount

# Output
print("The average is " + str(Avg) + ", the highest score is " + str(Highest) + ".")
