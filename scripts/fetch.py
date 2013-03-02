#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#       fetch.py -- screen scraping script
#
#       Fetches the contents of the site www.molitvoslov.org and converts
#       html to tex representation, also saves images under img/ directory
#       
#       Copyright 2011-13 Max Agapov <m4j@swissmail.org>
#       
#       This program is free software; you can redistribute it and/or modify
#       it under the terms of the GNU General Public License as published by
#       the Free Software Foundation; either version 2 of the License, or
#       (at your option) any later version.
#       
#       This program is distributed in the hope that it will be useful,
#       but WITHOUT ANY WARRANTY; without even the implied warranty of
#       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#       GNU General Public License for more details.
#       
#       You should have received a copy of the GNU General Public License
#       along with this program; if not, write to the Free Software
#       Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#       MA 02110-1301, USA.

import sys, codecs, locale, urllib2

# This is to ensure compatibility with python 2.5 and 2.6
try:
    # standard 2.6 lib
    import json
except ImportError:
    # case for python 2.5
    import simplejson as json

from BeautifulSoup import BeautifulSoup, NavigableString, Tag
from urlparse import urlparse
from datetime import datetime
from urllib2 import urlopen, URLError, HTTPError

# enable utf-8 output
sys.stdout = codecs.getwriter(locale.getpreferredencoding())(sys.stdout)

sections = [u'', u'mypart', u'mychapter', u'section', u'subsection', u'subsubsection',
    u'paragraph']

chapterSection = u'mychapter'

class Fetcher:
    
    baseUrl = ''

    "output to this file"
    myFile = None
    
    "ordered list counter"
    olCounter = None

    def __init__(self, baseUrl, file=None):
        "Basic constructor."
        self.baseUrl = baseUrl
        self.myFile = file

    def fetch(self, level, path):
        try:
            subtitles = path
            if not isinstance(path, list):
                sys.stdout.write('\n')
                sys.stdout.write('  ' * (level + 1) + self.baseUrl + path + ' --> ' + self.getMyFile().name + '...')
                soup = self.getSoup(path)
                my_td = self.getMyTd(soup)
                if level != 0:
                    heading = self.getHeading(my_td)
                    self.myprint('\n\n\\' + sections[level] + '{' + heading + '}')
                sys.stdout.write('done.')
                self.myprint('\n%' + self.baseUrl + path)
                node = self.getNode(my_td)
                self.outputElement(self.getContents(node))
                subtitles = self.getSubtitles(node)
            for href in subtitles:
                if level == 0:
                    fname = href.replace('/', '_') + '.tex'
                    try:
                        file = self.openFile(fname)
                        fetcher = Fetcher(self.baseUrl, file)
                        fetcher.fetch(level + 1, href)
                        self.myprint('\n\n\\input{' + fname + '}')
                    finally:
                        if file:
                            file.close()
                else:
                    self.fetch(level + 1, href)
            if self.isChapter(level):
                self.myprint('\n\n\\mychapterending')
        finally:
            if level == 0 and self.myFile:
                self.myFile.close()
                self.myFile = None
        return 0
        
    def openFile(self, fname, mode='w'):
        return codecs.open(fname, mode, 'utf-8')

    def getHeading(self, td):
        return td.h1.next

    def isChapter(self, level):
        return sections[level] == chapterSection
        
    def gethref(self, item):
        return item.a['href']
        
    def getSubtitles(self, node):
        subs = node.find('ul', { 'class' : 'nodehierarchy_title_list' })
        if subs:
            return map(self.gethref, subs)
        else:
            return []

    def getNode(self, td):
        return td.find('div', { 'class' : 'node' })
        
    def getContents(self, node):
        return node.div.contents

    def myprint(self, str):
        self.getMyFile().write(str)

    def outputElement(self, root):
        for el in root:
            if isinstance(el, NavigableString):
                self.writeText(el)
            elif el.name == 'br':
                self.myprint('\n\n')
            elif el.name == 'p':
                self.myprint('\n\n')
                if el.next == '&nbsp;':
                    self.myprint('\\medskip')
                else:
                    self.outputElement(el)
            elif el.name == 'i' or el.name == 'em':
                self.myprint('\\itshape ')
                self.outputElement(el)
                self.myprint('\\normalfont{}')
            elif el.name == 'b' or el.name == 'strong':
                self.myprint('\\bfseries ')
                self.outputElement(el)
                self.myprint('\\normalfont{}')
            elif el.name == 'a':
                if el.get('class') == 'icona':
                    file_name = self.findAndSaveBigIcon(el)
                    if file_name != None:
                        self.myprint('\\myfig{' + file_name + '}')
                        sys.stdout.write(', ' + file_name)
                else:
                    self.outputElement(el)
            elif el.name == 'font':
                self.outputElement(el)
            elif el.name == 'span':
                self.outputElement(el)
            elif el.name == 'sup':
                self.outputElement(el)
            elif el.name == 'table' and el.get('class') == 'description':
                self.outputElement(el)
            elif el.name == 'tbody':
                self.outputElement(el)
            elif el.name == 'tr':
                self.myprint('\n\n')
                self.outputElement(el)
            elif el.name == 'td' or el.name == 'th':
                self.outputElement(el)
            elif el.name == 'ol':
                self.olCounter = 1
                self.outputElement(el)
            elif el.name == 'ul' and el.get('class') != 'nodehierarchy_title_list':
                self.olCounter = None
                self.outputElement(el)
            elif el.name == 'li':
                self.myprint('\n\n')
                if self.olCounter:
                    listItem = '%d. ' % self.olCounter
                    self.olCounter = self.olCounter + 1
                    self.myprint(listItem)
                self.outputElement(el)
                
    def findAndSaveBigIcon(self, el_a):
        bi_soup = self.getSoup(el_a['href'])
        bi_div = bi_soup.find('div', { 'class' : 'big-icon' })
        img_src = bi_div.img['src']
        file_name = None
        try:
            img = urlopen(img_src)
            file_name = 'img/' + img_src.split('/')[-1]
            out = open(file_name, 'wb')
            out.write(img.read())
            out.close()
        except HTTPError, e:
            sys.stdout.write('\nThe server couldn\'t fulfill the request for ' + img_src)
            sys.stdout.write('\nError code: ' + str(e.code))
        return file_name

    def writeText(self, el_str):
        s = el_str.replace('<', '$<$')
        s = s.replace('&lt;', '$<$')
        s = s.replace('>', '$>$')
        s = s.replace('&gt;', '$>$')
        s = s.replace('&#8212;', '"---')
        s = s.replace(' - ', ' "--- ')
        s = s.replace(u'—', '"---')
        s = s.replace('&mdash;', '"---') 
        s = s.replace('&quot;', '"')
        s = s.replace('&nbsp;', ' ')
        self.myprint(s)

    def getMyTd(self, soup):
        return soup.find('div', id='center').table.tr.td.findNextSibling('td')
        
    def getSoup(self, path = '/'):
        page = urlopen(self.baseUrl + path)
        return BeautifulSoup(page)

    def getMyFile(self):
        if self.myFile == None:
            "Lazy init root file"
            self.myFile = self.openFile('root.tex', 'a')
            #self.myprint('% Autogenerated on ' + datetime.now().isoformat())
        return self.myFile

if __name__ == '__main__':
    "the first argument is the chapter level (0 is part, 1 is chapter, etc...)"
    level = int(sys.argv[1])
    sys.stdout.write('\nlevel=' + str(level))
    "the second argument is the base url of the site"
    baseUrl = sys.argv[2]
    sys.stdout.write('\nbaseUrl=' + baseUrl)
    fetcher = Fetcher(baseUrl)
    "the third argument is a JSon array with paths or sublists of paths, relative to the base url"
    sys.stdout.write('\npath=' + sys.argv[3])
    paths = json.loads(sys.argv[3])
    for path in paths:
        fetcher.fetch(level, path)

