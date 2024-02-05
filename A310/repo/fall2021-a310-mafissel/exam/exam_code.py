# Question 3 Quicksort
# q = lambda l: q([x for x in l[1:] if x <= l[0]] + \ # forgot the closing parenthesis after x <= l[0]])
#     [l[0]] +  q([x for x  in l  if x > l[0]]) \
#     if l else []

# corrected syntax so we can run
q = lambda l: q([x for x in l[1:] if x <= l[0]]) + [l[0]] +  q([x for x  in l  if x > l[0]]) if l else []
# test cases
print(q([1,15,14,20,4,6,5])) # prints 1,4,5,6,14,15,20
print(q([1,2,3,6,9,0,999])) # prints 0,1,2,3,6,9,999
print(q([4,3,7,4,9,3,1,2,8])) # prints 1,2,3,3,4,4,7,8,9
# seems to run great, except for syntax error missing the parentheses

# Question 4 Permuation
# def perm(word, step=0):
#     if step  == len(word):
#         print("".join(word))
#     for i in range(step,len(word)) # forgot a colon here
#         wordcopy = [x for x in  word]
#         wordcopy[i], wordcopy[step] = wordcopy[step], wordcopy[i]
#         perm(wordcopy,(step+1))

#corrected syntax so we can run
def perm(word, step=0):
    if step  == len(word):
        print("".join(word))
    for i in range(step,len(word)): # added the colon
        wordcopy = [x for x in  word]
        wordcopy[i], wordcopy[step] = wordcopy[step], wordcopy[i]
        perm(wordcopy,(step+1))

perm('cat')
perm('race')
# perm('morgan')

# with added colon runs perfectly 