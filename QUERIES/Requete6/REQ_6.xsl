<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/1999/xhtml"
	>
	<xsl:output method="html" encoding="UTF-8"/>
	
	<xsl:template match="/">
		<!-- calcul evolution salaire 2012 - 2013 -->
		<xsl:variable name="salaire_total_homme_2012" select="avg(dataset/ligne[date/@annee = '2012' and genre/@nom = 'Homme']/salaire)" />
		<xsl:variable name="salaire_total_femme_2012" select="avg(dataset/ligne[date/@annee = '2012' and genre/@nom = 'Femme']/salaire)" />
		
		<xsl:variable name="salaire_total_homme_2013" select="avg(dataset/ligne[date/@annee = '2013' and genre/@nom = 'Homme']/salaire)" />
		<xsl:variable name="salaire_total_femme_2013" select="avg(dataset/ligne[date/@annee = '2013' and genre/@nom = 'Femme']/salaire)" />
		
		
		<!-- calculs evolution salaire 2013 - 2014 -->
		<xsl:variable name="salaire_total_homme_2014" select="avg(dataset/ligne[date/@annee = '2014' and genre/@nom = 'Homme']/salaire)" />
		<xsl:variable name="salaire_total_femme_2014" select="avg(dataset/ligne[date/@annee = '2014' and genre/@nom = 'Femme']/salaire)" />

		
		<!-- calculs evolution salaire 2014 - 2015 -->
		<xsl:variable name="salaire_total_homme_2015" select="avg(dataset/ligne[date/@annee = '2015' and genre/@nom = 'Homme']/salaire)" />
		<xsl:variable name="salaire_total_femme_2015" select="avg(dataset/ligne[date/@annee = '2015' and genre/@nom = 'Femme']/salaire)" />
		
		<!-- calculs evolution salaire 2015 - 2016 -->
		<xsl:variable name="salaire_total_homme_2016" select="avg(dataset/ligne[date/@annee = '2016' and genre/@nom = 'Homme']/salaire)" />
		<xsl:variable name="salaire_total_femme_2016" select="avg(dataset/ligne[date/@annee = '2016' and genre/@nom = 'Femme']/salaire)" />

		
		<table border="1">
			<tr>
				<th>Periode</th>
				<th>Evolution femme</th>
				<th>Evolution homme</th>
			</tr>
			<tr>
				<td>2012 - 2013</td>
				<td><xsl:value-of select="(($salaire_total_femme_2013 - $salaire_total_femme_2012) div $salaire_total_femme_2012) * 100" /></td>
				<td><xsl:value-of select="(($salaire_total_homme_2013 - $salaire_total_homme_2012) div $salaire_total_homme_2012) * 100" /></td>
			</tr>
			<tr>
				<td>2013 - 2014</td>
				<td><xsl:value-of select="(($salaire_total_femme_2014 - $salaire_total_femme_2013) div $salaire_total_femme_2013) * 100" /></td>
				<td><xsl:value-of select="(($salaire_total_homme_2014 - $salaire_total_homme_2013) div $salaire_total_homme_2013) * 100" /></td>
			</tr>
			<tr>
				<td>2014 - 2015</td>
				<td><xsl:value-of select="(($salaire_total_femme_2015 - $salaire_total_femme_2014) div $salaire_total_femme_2014) * 100" /></td>
				<td><xsl:value-of select="(($salaire_total_homme_2015 - $salaire_total_homme_2014) div $salaire_total_homme_2014) * 100" /></td>
			</tr>
			<tr>
				<td>2015 - 2016</td>
				<td><xsl:value-of select="(($salaire_total_femme_2016 - $salaire_total_femme_2015) div $salaire_total_femme_2015) * 100" /></td>
				<td><xsl:value-of select="(($salaire_total_homme_2016 - $salaire_total_homme_2015) div $salaire_total_homme_2015) * 100" /></td>
			</tr>
		</table>
	</xsl:template>
</xsl:stylesheet>