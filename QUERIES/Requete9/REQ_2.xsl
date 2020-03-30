<?xml version="1.0" encoding="UTF-8" ?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    <xsl:output method="html" doctype-public="XSLT-compat" omit-xml-declaration="yes" encoding="UTF-8" indent="yes" />

    <xsl:template match="/">
      <html>
        <table border="1">
            <thead>
                <tr>
                    <th>Département</th>
                    <th>Catégorie</th>
                    <th>Ville</th>
                    <th>Salaire</th>
                </tr>
            </thead>
            <tbody>
                <xsl:for-each-group select="dataset/ligne[date/@annee = '2016']" 
                group-by="localisation/departement">
                
                
                    <xsl:variable name="dep" select="current-grouping-key()"/>
                    
                <xsl:for-each-group select="current-group()" group-by="categorie/@nom">
                <tr>
                    <xsl:variable name="m" select="max(current-group()/salaire)"/>
                    <xsl:variable name="max" select="current-group()[salaire= $m]"/>
                    <td><xsl:value-of select="$dep"/></td>
                    <td><xsl:value-of select="current-grouping-key()"/></td>
                    <td><xsl:value-of select="$max/localisation/ville"/></td>
                    <td><xsl:value-of select="$m"/></td>
                    </tr>
                </xsl:for-each-group>       
               
               
            
                   
                </xsl:for-each-group>
            </tbody>
        </table>
        </html>
    </xsl:template>
</xsl:transform>