<?xml version="1.0" encoding="UTF-8" ?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">

    <xsl:output method="html" doctype-public="XSLT-compat" omit-xml-declaration="yes" encoding="UTF-8" indent="yes" />

    <xsl:template match="/">
      <html>
        <table border="1">
            <thead>
                <tr>
                    <th>Meilleure Ville</th>
                    <th>Salaire</th>
                </tr>
            </thead>
            <tbody>
                    <tr>
                    <xsl:variable name="m" select="max(dataset/ligne/salaire)"/>
                    <xsl:variable name="max" select="dataset/ligne[salaire = $m]"/>
                        <td>
                            <xsl:value-of select="$max/localisation/ville"/>
                        </td>
                        <td>
                            <xsl:value-of select="$m"/>
                        </td>
                    </tr>
            </tbody>
        </table>
        </html>
    </xsl:template>
</xsl:transform>