<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns="http://www.daisy.org/z3986/2005/ncx/"
    exclude-result-prefixes="xhtml xsl">

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

    <xsl:param name="dtb_uid">314159265359</xsl:param>
    <xsl:param name="xml_lang">en</xsl:param>
    <xsl:param name="docTitle">Book Title</xsl:param>
    <xsl:param name="docAuthor">Book Author</xsl:param>

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
                <xsl:apply-templates select="xhtml:div"/>
            </navMap>

        </ncx>
    </xsl:template>

    <xsl:template match="xhtml:div[@class='partToc']">
        <xsl:variable name="part" select="xhtml:a/@href"/>
        <navPoint>
            <xsl:attribute name = "id">
                <xsl:value-of select = "substring-after(xhtml:a/@href,'#')"/>
            </xsl:attribute>
            <navLabel>
                <text>
                    <xsl:value-of select="normalize-space(.)"/>
                </text>
            </navLabel>
            <content>
                <xsl:attribute name = "src">
                    <xsl:value-of select = "xhtml:a/@href"/>
                </xsl:attribute>
            </content>
            <xsl:for-each select="following-sibling::xhtml:div[@class='chapterToc' and preceding-sibling::xhtml:div[@class='partToc'][1]/xhtml:a/@href = $part]">
                <xsl:variable name="chapter" select="xhtml:a/@href"/>
                <navPoint>
                    <xsl:attribute name = "id">
                        <xsl:value-of select = "substring-after(xhtml:a/@href,'#')"/>
                    </xsl:attribute>
                    <navLabel>
                        <text>
                            <xsl:value-of select="normalize-space(.)"/>
                        </text>
                    </navLabel>
                    <content>
                        <xsl:attribute name = "src">
                            <xsl:value-of select = "xhtml:a/@href"/>
                        </xsl:attribute>
                    </content>
                    <xsl:for-each select="following-sibling::xhtml:div[@class='sectionToc' and preceding-sibling::xhtml:div[@class='chapterToc'][1]/xhtml:a/@href = $chapter]">
                        <navPoint>
                            <xsl:attribute name = "id">
                                <xsl:value-of select = "substring-after(xhtml:a/@href,'#')"/>
                            </xsl:attribute>
                            <navLabel>
                                <text>
                                    <xsl:value-of select="normalize-space(.)"/>
                                </text>
                            </navLabel>
                            <content>
                                <xsl:attribute name = "src">
                                    <xsl:value-of select = "xhtml:a/@href"/>
                                </xsl:attribute>
                            </content>
                        </navPoint>
                    </xsl:for-each>
                </navPoint>
            </xsl:for-each>
        </navPoint>
    </xsl:template>

</xsl:stylesheet>
