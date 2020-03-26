<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/1999/xhtml"
	>
	<xsl:output method="html" encoding="UTF-8"/>
	
	<xsl:template match="/">
		<table border="1">
			<thead>
		        <tr>
		            <th> Region</th>
		            <th> Catégorie</th>
		            <th> Année</th>
		            <th> Salaire </th>
		        </tr>
		    </thead>
		    <tbody>
				<xsl:for-each-group select="dataset/ligne" group-by="date/@annee">
					<xsl:sort select="current-grouping-key()" />
					<xsl:variable name="annee" select="current-grouping-key()" />
						<xsl:for-each-group select="current-group()" group-by="localisation/region">
							<xsl:variable name="region" select="current-grouping-key()" />
							<xsl:for-each-group select="current-group()" group-by="categorie/@nom">
								<tr>
									<td><xsl:value-of select="$region" /></td>
									<td><xsl:value-of select="current-grouping-key()" /></td>
									<td><xsl:value-of select="$annee" /></td>									
									<td><xsl:value-of select="format-number(avg(current-group()/salaire), '##.###')" /></td>
								</tr>
							</xsl:for-each-group>
					</xsl:for-each-group>
				</xsl:for-each-group>
			</tbody>
		</table>
	</xsl:template>
</xsl:stylesheet>

