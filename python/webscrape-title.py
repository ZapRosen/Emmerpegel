import re
from urllib.request import urlopen

url = "https://zaprosen.github.io/einfache.html"
page = urlopen(url)
html = page.read().decode("utf-8")

muster = "<title.*?>.*?</title.*?>"
match_results = re.search(muster, html, re.IGNORECASE)
title = match_results.group()
title = re.sub("<.*?>", "", title) # Remove HTML tags

print(title)

