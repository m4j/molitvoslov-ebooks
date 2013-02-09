<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns="http://www.gribuser.ru/xml/fictionbook/2.0"
  xmlns:pre="http://www.gribuser.ru/xml/fictionbook/2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  exclude-result-prefixes="pre xsl">

<xsl:strip-space elements="pre:*"/>
<xsl:preserve-space elements="pre:p pre:v pre:emphasis pre:strong pre:a"/>
  
<xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<xsl:param name="title-info-author-fn">www.molitvoslov.org</xsl:param>
<xsl:param name="title-info-author-mn"></xsl:param>
<xsl:param name="title-info-author-ln"></xsl:param>
<xsl:param name="title-info-title">Полный православный молитвослов</xsl:param>
<xsl:param name="document-info-id">AF0BDE17-0E06-48C1-9449-EEF622B3740B</xsl:param>
<xsl:param name="document-info-version">123456789</xsl:param>
<xsl:param name="document-info-date">2006-03-30</xsl:param>
<xsl:param name="document-info-date-value">2006-03-30</xsl:param>
<xsl:param name="cover-image-id">cover</xsl:param>

<!-- the identity template -->
<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

<!--
Populate the description
-->
<xsl:template match="pre:description">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
    <title-info>
      <genre>religion_rel</genre>
      <author>
        <first-name>
          <xsl:value-of select = "$title-info-author-fn" />
        </first-name>
        <middle-name>
          <xsl:value-of select = "$title-info-author-mn" />
        </middle-name>
        <last-name>
          <xsl:value-of select = "$title-info-author-ln" />
        </last-name>
      </author>
      <book-title>
        <xsl:value-of select = "$title-info-title" />
      </book-title>
      <annotation>
        <xsl:copy-of select="//pre:section[@id='announce']/*" />
      </annotation>
    <keywords>Православие,церковь,молитва,молитвослов,канон,акафист,правило,святой,вера,исцеление</keywords>
      <coverpage>
      	<image>
       	  <xsl:attribute name = "xlink:href">
      	    <xsl:value-of select = "concat('#', $cover-image-id)" />
          </xsl:attribute>
        </image>
      </coverpage>
      <lang>ru</lang>
      <src-lang>ru</src-lang>
    </title-info>
    <document-info>
      <author>
        <nickname/>
      </author>
      <program-used>TeX4ht (http://www.tug.org/tex4ht/) | xsltproc, xmllint (http://xmlsoft.org/)</program-used>
      <date>
        <xsl:attribute name = "value">
            <xsl:value-of select = "$document-info-date-value"/>
        </xsl:attribute>
        <xsl:value-of select = "$document-info-date" />
      </date>
      <src-url>https://github.com/m4j/molitvoslov.org</src-url>
      <id>
        <xsl:value-of select = "$document-info-id" />
      </id>
      <version>
        <xsl:value-of select = "$document-info-version" />
      </version>
    </document-info>
    <publish-info/>
  </xsl:copy>
</xsl:template>

<!-- Copy <image> element into the preceding <title> -->
<xsl:template match="pre:title">
    <xsl:copy>
        <xsl:apply-templates select="@*" />
        <xsl:apply-templates select="node()" />
        <xsl:copy-of select="following-sibling::pre:p[1][./pre:image]" />
    </xsl:copy>
</xsl:template>

<!-- Remove <image> element that was copied in the previous template -->
<xsl:template match="pre:p[preceding-sibling::pre:title[1] and ./pre:image]" />

<!-- Remove meta elements -->
<xsl:template match="pre:meta" />

<!-- Delete "announce" section -->
<xsl:template match="pre:section[@id='announce']" />

<!--
Remove paragraphs containing only whitespace or non-breaking space
match if only one node and that node is text and whitespace
-->
<xsl:template 
    match="pre:p[count(node()) = 1 and child::node()[1][self::text() and normalize-space(.) = '']]" />

<!--
Remove empty links
-->
<xsl:template 
    match="pre:a[count(node()) = 0]" />

<!--
Remove paragraphs containing only whitespace or non-breaking space
match if only one node and that node is text and whitespace
-->
<xsl:template 
    match="pre:v[count(node()) = 1 and child::node()[1][self::text() and normalize-space(.) = '']]" />

<!--
Remove comments
-->
<xsl:template match="comment()"/>

<!--
Remove comments
-->
<xsl:template match="pre:br"/>

<!-- remove span elements, but not their contents -->
<xsl:template match="pre:span">
    <xsl:apply-templates select="node()"/>
</xsl:template>

</xsl:stylesheet>
