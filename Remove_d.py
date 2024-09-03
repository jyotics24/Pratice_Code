# wap to remove Duplicate element in list
# 09/03/2024
def remove_dup(number):
    unique_no=[]
    for num in number:
        if num not in unique_no:
            unique_no.append(num)
    return unique_no
#test the function
nums=[101,102,101,103,104,102,105,106,107]
unique_num = remove_dup(nums)
print(unique_num)
