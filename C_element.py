# wap find common element in 2 list 
# 09/03/2024
def find_comn_e(list1,list2):
    common_element=[]
    for item in list1:
        if item in list2:
            common_element.append(item)
    return common_element
# test the function
list_a=[201,101,102,203,104]
list_b=[101,102,103,104,106]
common=find_comn_e(list_a,list_b)
print(common)
