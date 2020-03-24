<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/1999/xhtml"
	>
	<xsl:output method="html" encoding="UTF-8"/>
	
	<xsl:template match="/">    
		<html>
			<head>
				<meta charset="utf-8" />
				<style>
					.femme
					{
						color: blue;
					}
					
					.homme
					{
						color: red;
					}
				</style>
			</head>
			
			<body>
				<table border="1">
					<tr>
						<th>Annee</th>
						<th>Total Salaire Femme</th>
						<th>Total Salaire Homme</th>
					</tr>
					<xsl:for-each-group select="dataset/ligne" group-by="date/@annee">
						<xsl:sort select="current-grouping-key()" />
						<tr>
							<td><xsl:value-of select="current-grouping-key()" /></td>
							<xsl:for-each-group select="current-group()" group-by="genre/@nom">
								<td><xsl:value-of select="format-number((avg(current-group()/salaire)), '##.###')" /></td>
							</xsl:for-each-group>
						</tr>
					</xsl:for-each-group>
				</table>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>

