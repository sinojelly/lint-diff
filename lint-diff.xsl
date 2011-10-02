<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
  <html>
  <body>
    <h2>PC-Lint warnings on new/modified lines</h2>
    <table border="1">
      <tr bgcolor="#9acd32">
        <th>File</th>
        <th>Line</th>
		<th>Type</th>
		<th>Code</th>
		<th>Description</th>
      </tr>
      <xsl:for-each select="doc/message[===line-filter===]">
      <tr>
		<td><xsl:value-of select="file"/></td>
		<td><xsl:value-of select="line"/></td>
		<td><xsl:value-of select="type"/></td>
		<td><xsl:value-of select="code"/></td>
		<td><xsl:value-of select="desc"/></td>
      </tr>
      </xsl:for-each>
    </table>
  </body>
  </html>
</xsl:template>

</xsl:stylesheet>
