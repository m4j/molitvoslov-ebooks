<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  exclude-result-prefixes="xhtml xsl">
  
  <xsl:strip-space  elements="*"/>
  <xsl:preserve-space elements="xhtml:p"/>

<xsl:output method="text"/>

<!-- the identity template -->
<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

<!-- template for the head section. Only needed if we want to change, delete or add nodes. In our case we need it to add a link element pointing to an external CSS stylesheet. -->
<xsl:template match="xhtml:table">
  <xsl:text>

\minicolumns</xsl:text>
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
  <xsl:if test="not(following-sibling::*[1][self::xhtml:p]/xhtml:a[@class = 'U'])">
    <xsl:text>}</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="xhtml:td">
  <xsl:text>{</xsl:text>
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
  <xsl:if test="@class='left'">
    <xsl:text>}</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="xhtml:p[./xhtml:a[1]/@class = 'U']">
  <xsl:text>

\hfill\footnotesize\myheadingcolor </xsl:text>
  <xsl:for-each select="./xhtml:a[@class = 'U']">
    <xsl:if test="position() > 1">
      <xsl:text>; </xsl:text>
    </xsl:if>
    <xsl:value-of select="normalize-space(text())"/>
  </xsl:for-each>
  <xsl:text>}</xsl:text>
</xsl:template>

<!--
pripev Pomiluj!
-->
<xsl:template 
    match="xhtml:p[normalize-space(text()) = 'Помилуй мя, Боже, помилуй мя.']" priority="2">
  <xsl:text>

\pripevpomiluj</xsl:text>

</xsl:template>

<!--
pripev
-->
<xsl:template 
    match="xhtml:p[
      normalize-space(text()) = 'Преподобне отче Андрее, моли Бога о нас.' or 
      normalize-space(text()) = 'Пресвятая Богородице, спаси нас.' or
      normalize-space(text()) = 'Святии апостоли, молите Бога о нас.' or
      normalize-space(text()) = 'Пресвятая Троице, Боже наш, слава Тебе.' or
      contains(., 'Припев:')]">

  <xsl:variable name="norm" select="normalize-space(.)"/>
  <xsl:variable name="text">
    <xsl:choose>
      <xsl:when test="starts-with($norm, 'Припев:')">
        <xsl:copy-of select="normalize-space(substring-after($norm, 'Припев:'))"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$norm"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:text>

\pripevmskipc{\firstletter{</xsl:text>
  <xsl:copy-of select="substring($text, 1, 1)"/>
  <xsl:text>}</xsl:text>
  <xsl:copy-of select="substring($text, 2)"/>
  <xsl:text>}</xsl:text>
</xsl:template>

<!--
Mark first letter of any paragraph
-->
<xsl:template 
    match="xhtml:p">

  <xsl:variable name="par" select="normalize-space(.)"/>

  <xsl:text>\firstletter{</xsl:text>
  <xsl:copy-of select="substring($par, 1, 1)"/>
  <xsl:text>}</xsl:text>
  <xsl:copy-of select="substring($par, 2)"/>
</xsl:template>

<!--
pripev
-->
<xsl:template 
    match="xhtml:p[
      contains(., 'Ирмос') or
      contains(., 'ирмос') or
      contains(., 'Икос') or
      contains(., 'икос')
      ]">

  <xsl:text>

\pripevc{\myemph{</xsl:text>
  <xsl:copy-of select="normalize-space(.)"/>
  <xsl:text>}}</xsl:text>
</xsl:template>

<!--
slava
-->
<xsl:template 
    match="xhtml:p[starts-with(normalize-space(.), 'Слава, Троичен:') or
      starts-with(normalize-space(.), 'Слава:')]">
  <xsl:text>

\slavac</xsl:text>
</xsl:template>

<!--
inyne
-->
<xsl:template 
    match="xhtml:p[starts-with(normalize-space(.), 'И ныне')]">
  <xsl:text>

\inynec</xsl:text>
</xsl:template>

<!--
sectioning
-->
<xsl:template 
    match="xhtml:h2|xhtml:h4|contains(., 'Кондак')">
  <xsl:text>

\mysubtitle{</xsl:text>
  <xsl:copy-of select="normalize-space(text())"/>
  <xsl:text>}</xsl:text>
      
</xsl:template>

</xsl:stylesheet>
