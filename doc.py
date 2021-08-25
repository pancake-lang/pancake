#!/usr/bin/env python3

OUTPUT_PATH = 'src/Help.elm'

TEMPLATE = '''module Help exposing (info)

import Markdown

info = 
    Markdown.toHtml Nothing """{}"""
'''

RENDERED = ''

with open('README.md') as README:
    RENDERED = TEMPLATE.format(README.read())

with open(OUTPUT_PATH, 'w') as output:
    output.write(RENDERED)
