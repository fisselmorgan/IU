def h1(word): # we hashing
    result = 0
    letters = sorted(word)
    for letter in letters:
        result += ord(letter)
    return result %  25
for i in ["cat", "act", "coast", "alpha", "beta", "english"]:
    print(h1(i))

import re

text = '''one two three four five six seven eleven twenty'''

print(re.findall('....', text)) 