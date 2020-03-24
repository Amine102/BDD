<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/1999/xhtml"
	>
	<xsl:output method="html" encoding="UTF-8"/>
	
	<xsl:template match="/">
		<xsl:for-each-group select="dataset/ligne" group-by="date/@annee = '2016'">
			<h2><xsl:value-of select="current-grouping-key()" /></h2>
			<xsl:for-each-group select="current-group()" group-by="localisation/ville">
				<h3><xsl:value-of select="current-grouping-key()" /></h3>
				<xsl:for-each-group select="current-group()" group-by="categorie/@nom">
					<h4><xsl:value-of select="current-grouping-key()" /></h4>
					<xsl:variable name="homme_total" select="sum(current-group()[genre/@nom = 'Homme']/salaire)" />
					<xsl:variable name="femme_total" select="sum(current-group()[genre/@nom = 'Femme']/salaire)" />
					<xsl:variable name="total" select="$homme_total + $femme_total" />
					<h5>difference <xsl:value-of select="format-number(((abs($homme_total - $femme_total) div $total) * 100), '#.##')" />%</h5>
				</xsl:for-each-group>
			</xsl:for-each-group>
		</xsl:for-each-group>
	</xsl:template>
</xsl:stylesheet>

