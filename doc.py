#!/usr/bin/env python3

OUTPUT_PATH = 'src/Help/Info.elm'

TEMPLATE = '''module Help.Info exposing (info)

import Markdown

info = 
    Markdown.toHtml Nothing """{}"""
'''

RENDERED = ''

with open('README.md') as README:
    RENDERED = TEMPLATE.format(README.read())

with open(OUTPUT_PATH, 'w') as output:
    output.write(RENDERED)
