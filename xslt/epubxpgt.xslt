<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:epub="http://www.idpf.org/2007/ops"
    exclude-result-prefixes="xhtml xsl">

    <xsl:strip-space  elements="*"/>
    <xsl:preserve-space elements="xhtml:p"/>

    <xsl:output method="xml" doctype-system="about:legacy-compat" indent="yes"/>

<!-- the identity template -->
<xsl:template match="@*|node()">
      <xsl:copy>
          <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
</xsl:template>

<!--
Template for the head section. Only needed if we want to change, delete or add nodes. In our case we need it to add a link element pointing to an external CSS stylesheet.
-->
<xsl:template match="xhtml:head">
    <xsl:copy>
        <meta charset="UTF-8" />
        <xsl:apply-templates select="@*|node()"/>
        <link rel="stylesheet" type="application/adobe-page-template+xml" href="page-template.xpgt" />
        <link rel="stylesheet" type="text/css" href="color.css" />
    </xsl:copy>
</xsl:template>

<!--
Remove some unused legacy metas from the header
-->
<xsl:template match="xhtml:meta[@http-equiv='Content-Type']" />
<xsl:template match="xhtml:meta[@name='generator']" />
<xsl:template match="xhtml:meta[@name='originator']" />
<xsl:template match="xhtml:meta[@name='src']" />
<xsl:template match="xhtml:meta[@name='date']" />

<!--
Assign class for images
-->
<xsl:template match="xhtml:img">
    <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
        <xsl:choose>
            <xsl:when test="contains(../@class, 'wrapfig')">
                <xsl:attribute name="class">
                    <xsl:text>icon</xsl:text>
                </xsl:attribute>
            </xsl:when>
            <xsl:when test="ancestor::xhtml:div[@class='centericon']">
                <xsl:attribute name="class">
                    <xsl:text>centered-icon</xsl:text>
                </xsl:attribute>
            </xsl:when>
        </xsl:choose>
    </xsl:copy>
</xsl:template>

<!--
Assign div class based on image shape, the shape of the image is determined
by its placement in a subdirectory, e. g. tall images go into tall/ and wide
images go under wide/, other images just go under images/
-->
<xsl:template match="xhtml:div[contains(@class, 'wrapfig')]">
    <xsl:copy>
        <xsl:choose>
            <xsl:when test="contains(xhtml:img/@src,'tall')">
                <xsl:attribute name="class">
                    <xsl:value-of select="concat(@class,'t')"/>
                </xsl:attribute>
                <xsl:apply-templates select="node()"/>
            </xsl:when>
            <xsl:when test="contains(xhtml:img/@src,'wide')">
                <xsl:attribute name="class">
                    <xsl:value-of select="concat(@class,'w')"/>
                </xsl:attribute>
                <xsl:apply-templates select="node()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="@*|node()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:copy>
</xsl:template>

<!--
Remove titlemark, e. g. "Part" wording
-->
<xsl:template match="xhtml:span[@class='titlemark']" />

<!--
Parts only in the main table of contents
-->
<xsl:template match="xhtml:div[@class='tableofcontents']">
    <div>
        <xsl:apply-templates select="@*"/>
        <xsl:apply-templates select="child::xhtml:div[@class='partToc']"/>
    </div>
</xsl:template>

<xsl:template match="xhtml:div[@class='partToc']">
    <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
</xsl:template>

<!--
Remove comments
-->
<xsl:template match="comment()"/>

<!--
Remove bukva sections from local part TOCs
-->
<xsl:template match="xhtml:div[@class='bukvaToc' and (../@class='partTOCS' or ../@class='tableofcontents')]"/>

<!--
Remove empty chapterTOCS divs
-->
<xsl:template match="xhtml:div[@class='chapterTOCS' and count(node()) = 0]"/>

<!--
This is to remove "clear" attribute from <br>
-->
<xsl:template match="xhtml:br">
    <br />
</xsl:template>

<!--
Remove "shape" attribute. Someday i will
learn how to fix that in tex4ht...
-->
<xsl:template match="@shape"/>

<!--
According to epubcheck, this is not allowed: <body><a></a></body>
Those a's are not used anyway, so it seems to be safe to remove them...
-->
<xsl:template match="xhtml:body/xhtml:a" />

<!--
Assign div class based on image shape, the shape of the image is determined
by its placement in a subdirectory, e. g. tall images go into tall/ and wide
images go under wide/, other images just go under images/
-->
<xsl:template match="xhtml:p[@class='noindent' and preceding-sibling::*[@class='subsubsectionHead' or @class='sectionHead']]">
    <xsl:copy>
        <xsl:attribute name="class">
            <xsl:text>indent</xsl:text>
        </xsl:attribute>
        <xsl:apply-templates select="node()"/>
    </xsl:copy>
</xsl:template>

<xsl:template match="xhtml:p[xhtml:span/@class='lettrine']">
    <xsl:copy>
        <xsl:attribute name="class">
            <xsl:text>noindent</xsl:text>
        </xsl:attribute>
        <xsl:apply-templates select="node()"/>
    </xsl:copy>
</xsl:template>

<!--
Remove paragraphs containing only whitespace or non-breaking space
match if only one node and that node is text and whitespace

<xsl:template id="remove_empty_pars" 
    match="xhtml:p[count(node()) = 1 and child::node()[1][self::text() and (normalize-space(.) = '' or normalize-space(.) = '&#160;&#160;&#160;&#160;')]]" />
-->
<xsl:template match="xhtml:p[normalize-space() = '' or normalize-space() = '&#160;&#160;&#160;&#160;']" />
<!--
Remove empty links
<xsl:template match="text()">
    <xsl:if test="normalize-space(.) != '&#160;&#160;&#160;&#160;'">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:if>
</xsl:template>
-->

<!--
Move h2 anchor into preceding div and wrap it around image to improve navigation on
Kindle device
-->
<xsl:template match="xhtml:div[@class='ornamentHead' or @class='partOrnamentHead']">
    <xsl:variable name="chapterId" select="following-sibling::xhtml:h2[1]/xhtml:a/@id"/>
    <xsl:copy>
        <xsl:apply-templates select="@*"/>
        <a>
            <xsl:attribute name="id">
                <xsl:value-of select="$chapterId"/>
            </xsl:attribute>
            <xsl:apply-templates select="node()"/>
        </a>
    </xsl:copy>
</xsl:template>

<xsl:template match="xhtml:a[../@class='chapterHead' or ../@class='partHead']" />

<!--
Inline text-decoration style in <a>, because Kindle doesn't honor external CSS in that regard
-->
<xsl:template match="xhtml:a">
    <xsl:copy>
        <xsl:if test="@href">
            <xsl:attribute name="style">
                <xsl:text>text-decoration: none;</xsl:text>
            </xsl:attribute>
        </xsl:if>
        <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
</xsl:template>

<!--
======================================================================
<xsl:template match="text()">
    <xsl:value-of select="normalize-space(.)" />
</xsl:template>
-->

<!--
Remove empty links
-->
<!--
<xsl:template match="xhtml:a[count(node()) = 0 or normalize-space(.) = '' or normalize-space(.) = '&#160;&#160;&#160;&#160;']" />
-->

<!--
Remove empty links
-->
<!--
<xsl:template match="xhtml:a[count(node()) = 0]" />
-->

<!-- template for the body section. Only needed if we want to change, delete or add nodes. In our case we need it to add a div element containing a menu of navigation. -->
<!--
<xsl:template match="xhtml:body">
  <xsl:copy>
    <div class="menu">
      <p><a href="home">Homepage</a> &gt; <strong>Test document</strong></p>
    </div>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>
-->

<!--
Assign class for the div with chapter ending ornament
-->
<!--
<xsl:template match="xhtml:div[@class='center']">
 <xsl:copy>
    <xsl:choose>
        <xsl:when test="contains(xhtml:p/xhtml:img/@src,'uzor_end')">
            <xsl:attribute name="class">
                <xsl:text>mychapterending</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates select="node()"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:otherwise>
    </xsl:choose>
 </xsl:copy>
</xsl:template>
-->

<!--
Remove footer ornament from chapter TOCs
<xsl:template match="xhtml:img[@class='ornamentlast' and (preceding-sibling::xhtml:div[@class='tableofcontents'] or preceding-sibling::xhtml:div[@class='chapterTOCS'])]"/>
-->

</xsl:stylesheet>
