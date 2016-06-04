<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:epub="http://www.idpf.org/2007/ops"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xhtml xsl">

    <xsl:output method="xml" doctype-system="about:legacy-compat" encoding="UTF-8" indent="yes"/>

    <xsl:param name="dtb_uid">314159265359</xsl:param>
    <xsl:param name="xml_lang">en</xsl:param>
    <xsl:param name="stylesheet"></xsl:param>
    <xsl:param name="docTitle">Book Title</xsl:param>
    <xsl:param name="docAuthor">Book Author</xsl:param>
    <xsl:param name="docTOCLabel">Contents</xsl:param>
    <xsl:param name="docLandmarksLabel">Contents</xsl:param>
    <xsl:param name="docCoverLabel"></xsl:param>
    <xsl:param name="docCoverPage"></xsl:param>
    <xsl:param name="docPrefaceLabel"></xsl:param>
    <xsl:param name="docPrefacePage"></xsl:param>

    <!-- the identity template -->
    <xsl:template match="@*|node()">
        <xsl:apply-templates select="@*|node()"/>
    </xsl:template>

    <xsl:template match="xhtml:div[@class='tableofcontents']">
        <html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops">
            <xsl:attribute name = "xml:lang">
                <xsl:value-of select = "$xml_lang"/>
            </xsl:attribute>
            <head>
                <meta content="text/html; charset=utf-8" http-equiv="content-type"/>
                <xsl:if test="$stylesheet != ''">
                    <link rel="stylesheet" type="text/css">
                        <xsl:attribute name="href">
                            <xsl:value-of select="$stylesheet"/>
                        </xsl:attribute>
                    </link>
                </xsl:if>
            </head>
            <body>
                <section>
                    <nav epub:type="toc">
                        <h1>
                            <xsl:value-of select = "$docTOCLabel"/>
                        </h1>
                        <ol>
                            <xsl:apply-templates select="xhtml:div"/>
                        </ol>
                    </nav>
                </section>
                <section>
                    <nav epub:type="landmarks">
                        <h1>
                            <xsl:value-of select = "$docLandmarksLabel"/>
                        </h1>
                        <ol>
                            <xsl:if test="$docCoverPage != ''">
                                <li>
                                    <a epub:type="cover">
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="$docCoverPage"/>
                                        </xsl:attribute>
                                        <xsl:value-of select="$docCoverLabel"/>
                                    </a>
                                </li>
                            </xsl:if>
                            <xsl:if test="$docPrefacePage != ''">
                                <li>
                                    <a epub:type="preface">
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="$docPrefacePage"/>
                                        </xsl:attribute>
                                        <xsl:value-of select="$docPrefaceLabel"/>
                                    </a>
                                </li>
                            </xsl:if>
                        </ol>
                    </nav>
                </section>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="xhtml:div[@class='partToc']">
        <xsl:variable name="part" select="xhtml:a/@href"/>
        <li>
            <a>
                <xsl:attribute name="href">
                    <xsl:value-of select="xhtml:a/@href"/>
                </xsl:attribute>
                <xsl:value-of select="normalize-space(.)"/>
            </a>
            <xsl:if test="following-sibling::xhtml:div[1]/@class = 'chapterToc'">
                <ol>
                    <xsl:for-each select="following-sibling::xhtml:div[@class='chapterToc' and preceding-sibling::xhtml:div[@class='partToc'][1]/xhtml:a/@href = $part]">
                        <xsl:variable name="chapter" select="xhtml:a/@href"/>
                        <li>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="xhtml:a/@href"/>
                                </xsl:attribute>
                                <xsl:value-of select="normalize-space(.)"/>
                            </a>
                            <xsl:if test="following-sibling::xhtml:div[1]/@class = 'sectionToc'">
                                <ol>
                                    <xsl:for-each select="following-sibling::xhtml:div[@class='sectionToc' and preceding-sibling::xhtml:div[@class='chapterToc'][1]/xhtml:a/@href = $chapter]">
                                        <li>
                                            <a>
                                                <xsl:attribute name="href">
                                                    <xsl:value-of select="xhtml:a/@href"/>
                                                </xsl:attribute>
                                                <xsl:value-of select="normalize-space(.)"/>
                                            </a>
                                        </li>
                                    </xsl:for-each>
                                </ol>
                            </xsl:if>
                        </li>
                    </xsl:for-each>
                </ol>
            </xsl:if>
        </li>
    </xsl:template>

</xsl:stylesheet>
