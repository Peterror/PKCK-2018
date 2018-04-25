<xsl:stylesheet version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:t="file://root.zadanie2/"
    xmlns:m="file://root.zadanie2/meta"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"> 

	<xsl:output method="xhtml" encoding="utf-8"
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
		doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
		omit-xml-declaration="no" indent="yes" />
		
	<xsl:template match="/">
	<html>
		<head>
			<meta http-equiv="content-type" content="application/xhtml+xml; charset=utf-8" />
			<title>Kraje</title>
		</head>
		<body>
			<h1>Kraje XHTML 1.0 Strict</h1>
			<h3>
				<xsl:value-of select="t:raport/t:streszczenie" />
			</h3>
			<p>Autorzy: </p>
			<ul>
				<xsl:for-each select="t:raport/t:autorzy/t:autor">
					<li><xsl:value-of select="." /></li>
				</xsl:for-each>			
			</ul>
			 
			<h3>Kraje zawarte w XML'u</h3>
			<ul>
				<xsl:for-each select="t:raport/t:kraj">
				<li>
					<xsl:attribute name="title">Nazwa kraju: <xsl:value-of select="t:nazwa" /></xsl:attribute>
					<a href="#{generate-id(.)}">
						<xsl:value-of select="t:nazwa" />
					</a>
				</li>
				</xsl:for-each>
			</ul>
			 <xsl:apply-templates select="/t:raport/t:kraj" />
		</body>
	</html>
	</xsl:template>

	<xsl:template match="/t:raport/t:kraj">
		<table style="clear: both; margin: 3ex 2em; color: black; background-color: aliceblue;" border="1">
			<xsl:attribute name="summary"><xsl:value-of select="concat(t:nazwa, '(', t:stolica/t:nazwa, ')')" /></xsl:attribute>
			<tr><td><a name="{generate-id(.)}"></a>Nazwa kraju:</td><td style="text-align: right;"><xsl:value-of select="t:nazwa" /></td></tr>
			<tr><td>Stolica:</td><td style="text-align: right;"><xsl:value-of select="t:stolica/t:nazwa" /></td><td style="text-align: right;"><xsl:value-of select="concat(t:stolica/t:x, ' ', t:stolica/t:y)" /></td></tr>
			<tr><td>PKB:</td><td style="text-align: right;"><xsl:value-of select="t:PKB" /></td></tr>
			<tr><td>Region:</td><td style="text-align: right;"><xsl:value-of select="t:region" /></td></tr>
			<tr>
				<td>Grupy etniczne:</td>
			</tr>
			<xsl:for-each select="t:grupy/t:grupa-etniczna">
			<tr>
				<td></td> <td style="text-align: right;"><xsl:value-of select="t:nazwa" /></td><td style="text-align: right;"><xsl:value-of select="t:liczność" /></td>
			</tr>
			</xsl:for-each>
			<tr>
				<td>Ważne wydarzenia:</td>
			</tr>
			<xsl:for-each select="t:ważne-wydarzenia/t:wydarzenie">
			<tr>
				<td></td> <td style="text-align: right;"><xsl:value-of select="t:wydarzenie/t:nazwa" /></td><td style="text-align: right;"><xsl:apply-templates select="t:wydarzenie/t:data" /></td>
			</tr>
			</xsl:for-each>
		</table>
	</xsl:template>
	
	<xsl:template match="t:wydarzenie/t:data">
		<xsl:value-of select="concat(@dzień, ' ', @miesiąc, ' ', @rok)" />
	</xsl:template>


</xsl:stylesheet> 
