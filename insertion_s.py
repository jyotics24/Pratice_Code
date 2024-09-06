# Program to take an array and sort it using Insertion Sort
# 09/06/2024

def insertion_s(arr):
    n = len(arr)
    for i in range(1, n):
        tmp = arr[i]
        j = i - 1                           
        while j >= 0 and tmp < arr[j]:      #logic
            arr[j + 1] = arr[j]
            j -= 1
        arr[j + 1] = tmp

n = int(input("Enter the number of elements: ")) # Input the no of element in array
arr = []

for i in range(n):
    element = int(input(f"Enter element {i+1}: ")) # Input elemennt into array
    arr.append(element)
print("Before sorting:", arr)
insertion_s(arr) # Call
print("After sorting:", arr)
