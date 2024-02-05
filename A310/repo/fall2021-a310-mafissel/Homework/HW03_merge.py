def merge(a,b):
    if a == [] and b == []:
        return a
    elif a == []:
        return b
    elif b == []:
        return a
    else:
        if (a[0] < b[0]):
            return [a[0]] + merge(a[1:], b)
        else:
            return [b[0]] + merge(a, b[1:])

def sort(numbers):
    if numbers == []:
        return numbers
    else:
        (a, b) = prefix(numbers)
        return merge(a, sort(b))

def prefix(numbers):
    a = []
    b = numbers
    if numbers == []:
        return (a, b)
    elif a == []:
        a = [numbers[0]]
        b = numbers[1:]
        (a, b) = ([numbers[0]], numbers[1:])
        if numbers == []:
            return (a, b)
    while (b != [] and a [-1] < b[0]):
        (a, b) = (a + [b[0]] , b[1:])
    return (a, b)


print(prefix([2, 4, 6, 1, 3, 5]))
print(sort([3, 2, 5, 4, 6, 1]))


