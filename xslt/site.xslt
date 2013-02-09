<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  exclude-result-prefixes="xhtml xsl">
  
<xsl:output method="xml" version="1.0" encoding="UTF-8" doctype-public="-//W3C//DTD XHTML 1.1//EN" doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd" indent="yes"/>

<!-- the identity template -->
<xsl:template match="@*|node()">
      <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
</xsl:template>

<!-- the identity template -->
<xsl:template match="xhtml:sup">
      <xsl:copy>
        <xsl:text>[</xsl:text><xsl:apply-templates select="node()"/><xsl:text>]</xsl:text>
      </xsl:copy>
</xsl:template>

<!--
Remove titlemark, e. g. "Part" wording
-->
<xsl:template match="xhtml:span[@class='titlemark']" />

<!--
Remove crosslinks at the bottom and at the top of the page
-->
<xsl:template match="xhtml:div[@class='crosslinks']" />

<!--
Remove comments
-->
<xsl:template match="comment()"/>

<!--
Remove paragraphs containing only whitespace or non-breaking space
match if only one node and that node is text and whitespace
-->
<xsl:template id="remove_empty_pars" 
    match="xhtml:p[count(node()) = 1 and child::node()[1][self::text() and (normalize-space(.) = '' or normalize-space(.) = '&#160;&#160;&#160;&#160;')]]" />

<xsl:template match="xhtml:a[count(node()) = 0]" />

<!--
Remove empty links
-->
<xsl:template match="text()">
    <xsl:if test="normalize-space(.) != '&#160;&#160;&#160;&#160;'">
      <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
    </xsl:if>
</xsl:template>

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

<!-- remove span elements, but not their contents -->
<xsl:template match="xhtml:span">
    <xsl:apply-templates select="node()"/>
</xsl:template>


</xsl:stylesheet>
