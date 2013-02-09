<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns="http://www.daisy.org/z3986/2005/ncx/"
  exclude-result-prefixes="xhtml xsl">
 
  <xsl:output method="xml" version="1.0" encoding="UTF-8" doctype-public="-//NISO//DTD ncx 2005-1//EN" doctype-system="http://www.daisy.org/z3986/2005/ncx-2005-1.dtd" indent="yes"/>
  
    <xsl:param name="dtb_uid">314159265359</xsl:param>
    <xsl:param name="xml_lang">en</xsl:param>
    <xsl:param name="docTitle">Book Title</xsl:param>
    <xsl:param name="docAuthor">Book Author</xsl:param>
    <xsl:param name="docFirstPage">Title Page</xsl:param>
    <xsl:param name="docFirstPageLabel">Title Page</xsl:param>
 
  <!-- the identity template -->
  <xsl:template match="@*|node()">
      <xsl:apply-templates select="@*|node()"/>
  </xsl:template>

  <xsl:template match="xhtml:div[@class='tableofcontents']">
    <ncx version="2005-1">

        <xsl:attribute name = "xml:lang">
            <xsl:value-of select = "$xml_lang"/>
        </xsl:attribute>

        <head xmlns="http://www.daisy.org/z3986/2005/ncx/">
            <meta name="dtb:uid">
                <xsl:attribute name = "content">
                    <xsl:value-of select = "$dtb_uid"/>
                </xsl:attribute>
            </meta>
            <meta name="dtb:depth" content="1"/> <!-- 1 or higher -->
            <meta name="dtb:totalPageCount" content="0"/> <!-- must be 0 -->
            <meta name="dtb:maxPageNumber" content="0"/> <!-- must be 0 -->
        </head>
        
        <docTitle>
            <text>
                <xsl:value-of select = "$docTitle" /> 
            </text>
        </docTitle>

        <docAuthor>
            <text>
                <xsl:value-of select = "$docAuthor" /> 
            </text>
        </docAuthor>

        <navMap>
            <navPoint>
                <xsl:attribute name = "id">
                    <xsl:value-of select = "$docFirstPage"/> 
                </xsl:attribute>
                <xsl:attribute name = "playOrder">
                    <xsl:value-of select = "1"/>
                </xsl:attribute>
                <navLabel>
                    <text><xsl:value-of select = "$docFirstPageLabel"/></text>
                </navLabel>
                <content>
                    <xsl:attribute name = "src">
                        <xsl:value-of select = "$docFirstPage"/> 
                    </xsl:attribute>
                </content>
            </navPoint>
            <xsl:apply-templates select="xhtml:div"/>
        </navMap>

    </ncx>
  </xsl:template>

  <xsl:template match="xhtml:div[@class='partToc']">
    <navPoint>
        <xsl:attribute name = "id">
            <xsl:value-of select = "substring-before(xhtml:a/@href,'#')"/>
        </xsl:attribute>
        <xsl:attribute name = "playOrder">
<!--
            The following expression with count is taken from here
            http://stackoverflow.com/questions/833118/in-xslt-how-do-i-increment-a-global-variable-from-a-different-scope
-->
            <xsl:value-of select = "count(preceding-sibling::xhtml:div[@class='partToc']) + 2"/>
        </xsl:attribute>
        <navLabel>
            <text>
                <xsl:value-of select="normalize-space(.)"/>
            </text>
        </navLabel>
        <content>
            <xsl:attribute name = "src">
                <xsl:value-of select = "substring-before(xhtml:a/@href,'#')"/>
            </xsl:attribute>
        </content>
    </navPoint>
  </xsl:template>
 
</xsl:stylesheet>
