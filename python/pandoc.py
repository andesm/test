import pypandoc
import sys

md = sys.stdin.read()

# makedown -> html
html = pypandoc.convert(md, 'html', format='md')

print(md)

