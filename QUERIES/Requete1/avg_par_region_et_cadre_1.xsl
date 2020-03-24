<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/1999/xhtml"
	>
	<xsl:output method="html" encoding="UTF-8"/>
	
	<xsl:template match="/">
		<table border="1">
			<!-- group by region -->
			<xsl:for-each-group select="dataset/ligne[date/@annee = '2016']" group-by="localisation/region">
				<tr>
					<th>Region: <xsl:value-of select="current-grouping-key()" /></th>
				</tr>
				<!-- group by category -->
					<xsl:for-each-group select="current-group()" group-by="categorie/@nom">
						<tr>
							<td>Categorie: <xsl:value-of select="current-grouping-key()" /></td>
							<!-- sum up the salary in the grouped category -->
							<td>Total: <xsl:value-of select="avg(current-group()/salaire)" /></td>
						</tr>
					</xsl:for-each-group>
			</xsl:for-each-group>
		</table>
	</xsl:template>
</xsl:stylesheet>

