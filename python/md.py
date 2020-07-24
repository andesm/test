import markdown

sample_makedown = '''
An h1 header
============

Paragraphs are separated by a blank line.

2nd paragraph. *Italic*, **bold**, `monospace`. Itemized lists
look like:

  * this one
  * that one
  * the other one

term
: description

'''

# makedown -> html
html = markdown.markdown(sample_makedown)
print(html)
