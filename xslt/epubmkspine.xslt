<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns="http://www.daisy.org/z3986/2005/ncx/"
  exclude-result-prefixes="xhtml xsl">
 
  <xsl:output method="text" indent="yes"/>
 
  <!-- the identity template -->
  <xsl:template match="@*|node()">
      <xsl:apply-templates select="@*|node()"/>
  </xsl:template>

  <xsl:template match="xhtml:div[@class='partToc' or @class='chapterToc' or @class='bukvaToc']">
    <xsl:text disable-output-escaping="yes">
    &lt;itemref idref="</xsl:text>
    <xsl:value-of select = "substring-before(xhtml:a/@href,'#')"/><xsl:text disable-output-escaping="yes">" /&gt;</xsl:text>
  </xsl:template>
 
</xsl:stylesheet>
