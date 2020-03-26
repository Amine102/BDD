<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/1999/xhtml"
	>
	<xsl:output method="html" encoding="UTF-8"/>
	
	<xsl:template match="/">
		<table border="1">
			<thead>
		        <tr>
		            <th> Ville</th>
		            <th> Categorie</th>
		            <th> Difference de salaire (%)</th>
		        </tr>
		    </thead>
		   	<tbody>
				<xsl:for-each-group select="dataset/ligne[date/@annee = '2016']" group-by="localisation/ville">					
						<xsl:variable name="ville" select="current-grouping-key()" />
						<xsl:for-each-group select="current-group()" group-by="categorie/@nom">
							<tr>
								<td><xsl:value-of select="$ville" /></td>
								<td><xsl:value-of select="current-grouping-key()" /></td>
								<xsl:variable name="homme_total" select="sum(current-group()[genre/@nom = 'Homme']/salaire)" />
								<xsl:variable name="femme_total" select="sum(current-group()[genre/@nom = 'Femme']/salaire)" />
								<xsl:variable name="total" select="$homme_total + $femme_total" />
								<td><xsl:value-of select="format-number(((($homme_total - $femme_total) div $total) * 100), '#.##')" /></td>
							</tr>
						</xsl:for-each-group>					
				</xsl:for-each-group>
			</tbody>
		</table>
	</xsl:template>
</xsl:stylesheet>

