# one-liners from chapter 5

# Listing 5-1: One-liner solution to search for specific phrases (nongreedy)
# result = re.findall('p.*?e.*?r', text)

# Listing 5-2: One-liner solution to find text snippets in the form crypto(some text)coin
# pattern = re.compile("crypto(.{1,30})coin") 

# Listing 5-3: One-liner solution to analyze web page links
# practice_tests = re.findall("(<a.*?finxter.*?(test|puzzle).*?>)", page)

# Listing 5-4: One-liner solution to find all dollar amounts in a text
# dollars = [x[0] for x in re.findall('(\$[0-9]+(\.[0-9]*)?)', report)]

# Listing 5-5: One-liner solution to find valid http:// URLs
# stale_links = re.findall('http://[a-z0-9_\-.]+\.[a-z0-9_\-/]+', article)

# Listing 5-6: One-liner solution to check whether a given user input matches the general
# time format XX:XX
# input_ok = lambda x: re.fullmatch('[0-9]{2}:[0-9]{2}', x) != None

# Listing 5-7: One-liner solution to check whether a given user input matches the general
# time format XX:XX and is valid in the 24-hour time
# input_ok = lambda x: re.fullmatch('([01][0-9]|2[0-3]):[0-5][0-9]', x) != None

# Listing 5-8: One-liner solution to find all duplicate characters
# duplicates = re.findall('([^\s]*(?P<x>[^\s])(?P=x)[^\s]*)', text)

# Listing 5-9: One-liner solution to find word repetitions
# style_problems = re.search('\s(?P<x>[a-z]+)\s+([a-z]+\s+){0,10}(?P=x)\s', ' ' + text + ' ')

# Listing 5-10: One-liner solution to replace patterns in a text
# updated_text = re.sub("Alice Wonderland(?!')", 'Alice Doe', text)