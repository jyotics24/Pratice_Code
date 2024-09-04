# wap take a list and sort the list in using Bubble sort.
# 09/04/2024

def bubbleSort(list):
    for index in range(len(list)-1, 0, -1): 
        for i in range(index):
            if list[i] > list[i+1]: 
                temp = list[i] # swap them
                list[i] = list[i+1]
                list[i+1] = temp

n = int(input("Enter Index Of List: "))
list = [] 
for i in range(n):
    element = int(input(f"Enter element {i+1}: "))
    list.append(element) # Add the value
print("Before List",list)
bubbleSort(list)
print("After Sorted List",list)
