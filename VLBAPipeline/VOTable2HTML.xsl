<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="html" indent="yes"/>
<xsl:strip-space elements="*"/>
  
<!-- TEMPLATE: votable -->
<xsl:template match="votable">
<html>
<head>
<style type="text/css">
table
{ border-collapse:collapse; }
table, td, th
{ border:1px solid black; }
</style>
</head>
<body>
  <!-- first resource block contains multi-source data -->
  <xsl:for-each select="resource[1]">
    <h1>Multi-source</h1>
    <xsl:call-template name="dataSummary"/>
  </xsl:for-each>
  <!-- all subsequent resource blocks contain single-source data -->
  <xsl:for-each select="resource[2]">
    <h1>Single source</h1>
    <xsl:call-template name="dataSummary"/>
  </xsl:for-each>
</body>
</html>
</xsl:template>

<!-- TEMPLATE: data summary -->
<xsl:template name="dataSummary">
  <h2>Metadata</h2>
  <table>
    <col/>
    <col style="width:50%"/>
    <tr> <th> Name </th> <th> Description </th> <th> Example value </th> </tr>
    <xsl:call-template name="metadataTable"/>
  </table>

  <h2>File data</h2>
  <xsl:for-each select="table[@name='files']">
    <table>
      <tr> <th> Example file name </th> <th> Description </th> </tr>
        <xsl:call-template name="fileTable"/>
    </table>
  </xsl:for-each>
</xsl:template>

<!-- TEMPLATE: meta data table -->
<xsl:template name="metadataTable">
  <xsl:for-each select="param">
    <tr>
      <td> <xsl:value-of select="@name"/> </td>
      <td> <xsl:value-of select="description"/> </td>
      <td> <xsl:value-of select="@value"/> </td>
    </tr>
  </xsl:for-each>
</xsl:template>

<!-- TEMPLATE: file table -->
<xsl:template name="fileTable">
  <xsl:for-each select="data/tabledata/tr">
    <tr>
      <td> <xsl:value-of select="td[position()=1]/text()"/> </td>
      <td> <xsl:value-of select="td[position()=2]/text()"/> </td>
    </tr>
  </xsl:for-each>
</xsl:template>

<!-- TEMPLATE: text node -->
<xsl:template match="text()"/> <!-- Override default rule for text nodes -->

</xsl:stylesheet>
