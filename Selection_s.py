# wap to sort the Array using selection sort.
# 09/05/2024
def selection(arr):
    n=len(arr)
    for i  in range(n):
        minn=i
        for j in range(i+1,n):
            if arr[j]<arr[minn]:
                minn=j
                arr[i],arr[minn]=arr[minn],arr[i]
arr=[21,41,33,42,31,17]
print("Before Array :",arr)
print()
selection(arr)
print("After sorted array using Selection sort :",arr)
