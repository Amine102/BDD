<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/1999/xhtml"
	>
	<xsl:output method="html" encoding="UTF-8"/>
	
	<xsl:template match="/">
		<table border="1">
			<xsl:for-each-group select="dataset/ligne" group-by="date/@annee">
				<xsl:sort select="current-grouping-key()" />
				<tr>
					<th>Annee: <xsl:value-of select="current-grouping-key()" /></th>
				</tr>
				<!-- group by region -->
				<xsl:for-each-group select="current-group()" group-by="localisation/region">
					<tr>
						<th>Region: <xsl:value-of select="current-grouping-key()" /></th>
					</tr>
					<!-- group by category -->
						<xsl:for-each-group select="current-group()" group-by="categorie/@nom">
							<tr>
								<td>Categorie: <xsl:value-of select="current-grouping-key()" /></td>
								<!-- sum up the salary in the grouped category -->
								<td>Moyen: <xsl:value-of select="format-number(avg(current-group()/salaire), '##.###')" /></td>
							</tr>
						</xsl:for-each-group>
				</xsl:for-each-group>
			</xsl:for-each-group>
		</table>
	</xsl:template>
</xsl:stylesheet>

