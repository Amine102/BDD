<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/1999/xhtml"
	>
	<xsl:output method="html" encoding="UTF-8"/>
	
	<xsl:template match="/">
		<table border="1">
			<tr>
				<th>Ville</th>
				<th>Total salaire (homme et femme)</th>
			</tr>
			<xsl:for-each-group select="dataset/ligne/localisation/ville" group-by=".">
				<tr>
					<td><xsl:value-of select="current-grouping-key()" /></td>
					<td><xsl:value-of select="format-number(avg(current-group()/../../salaire), '##.###')" /></td>
				</tr>
			</xsl:for-each-group>
		</table>
	</xsl:template>
</xsl:stylesheet>

