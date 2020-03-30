<?xml version="1.0" encoding="UTF-8" ?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">

    <xsl:output method="html" doctype-public="XSLT-compat" omit-xml-declaration="yes" encoding="UTF-8" indent="yes" />

    <xsl:template match="/">
      <html>
        <table border="1">
            <thead>
                <tr>
                    <th>Prévision 2020</th>
                    <th>Prévision 2025</th>
                    <th>Prévision 2030</th>
                </tr>
            </thead>
            <tbody>
                <xsl:variable name="ST2012" select="avg(dataset/ligne[date/@annee = '2012']/salaire)"/>
                <xsl:variable name="ST2013" select="avg(dataset/ligne[date/@annee = '2013']/salaire)"/>
                <xsl:variable name="ST2014" select="avg(dataset/ligne[date/@annee = '2014']/salaire)"/>
                <xsl:variable name="ST2015" select="avg(dataset/ligne[date/@annee = '2015']/salaire)"/>
                <xsl:variable name="ST2016" select="avg(dataset/ligne[date/@annee = '2016']/salaire)"/>
                
                <xsl:variable name="Diff12_13" select="1 + (($ST2013 - $ST2012) div $ST2013)"/>
                <xsl:variable name="Diff13_14" select="1 + (($ST2014 - $ST2013) div $ST2014)"/>
                <xsl:variable name="Diff14_15" select="1 + (($ST2015 - $ST2014) div $ST2015)"/>
                <xsl:variable name="Diff15_16" select="1 + (($ST2016 - $ST2015) div $ST2016)"/>
                
                <xsl:variable name="AvgEvolution" select="($Diff12_13 + $Diff13_14 + 
                $Diff14_15 + $Diff15_16) div 4"/>
                
                <xsl:variable name="Prevision2020" select="$ST2016 * ($AvgEvolution * $AvgEvolution * $AvgEvolution
                    * $AvgEvolution)"/>
                <xsl:variable name="Prevision2025" select="$Prevision2020 * ($AvgEvolution * $AvgEvolution * $AvgEvolution
                    * $AvgEvolution * $AvgEvolution)"/>
                <xsl:variable name="Prevision2030" select="$Prevision2025 *  ($AvgEvolution * $AvgEvolution * $AvgEvolution
                    * $AvgEvolution * $AvgEvolution)"/>
                
                <tr>
                    <td><xsl:value-of select="$Prevision2020"/></td>
                    <td><xsl:value-of select="$Prevision2025"/></td>
                    <td><xsl:value-of select="$Prevision2030"/></td>
                </tr>
                
            </tbody>
        </table>
        </html>
    </xsl:template>
</xsl:transform>