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
			<h4>
				<xsl:value-of select="t:raport/t:streszczenie" />
			</h4>
			<h3>Autorzy: </h3>
			<ul>
				<xsl:for-each select="t:raport/t:autorzy/t:autor">
					<li><xsl:value-of select="." /></li>
				</xsl:for-each>			
			</ul>
			 
			<h3>Kraje zawarte w XML'u:</h3>
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
			<h3>Regiony zawarte w XML'u:</h3>
			<ul>
				<xsl:for-each select="t:raport/t:regiony/t:region">
				<li>
					<xsl:attribute name="title">Nazwa regionu: <xsl:value-of select="t:id" /></xsl:attribute>
					<a href="#{generate-id(.)}">
						<xsl:value-of select="t:id" />
					</a>
				</li>
				</xsl:for-each>
			</ul>
			<h3>Grupy etniczne zawarte w XML'u:</h3>
			<ul>
				<xsl:for-each select="t:raport/t:grupy-etniczne/t:grupa-etniczna">
				<li>
					<xsl:attribute name="title">Nazwa grupy etnicznej: <xsl:value-of select="t:nazwa" /></xsl:attribute>
					<a href="#{generate-id(.)}">
						<xsl:value-of select="t:nazwa" />
					</a>
				</li>
				</xsl:for-each>
			</ul>
			<h3>Wydarzenia zawarte w XML'u:</h3>
			<ul>
				<xsl:for-each select="t:raport/t:wydarzenia/t:wydarzenie">
				<li>
					<xsl:attribute name="title">Nazwa kraju: <xsl:value-of select="t:nazwa" /></xsl:attribute>
					<a href="#{generate-id(.)}">
						<xsl:value-of select="t:nazwa" />
					</a>
				</li>
				</xsl:for-each>
			</ul>
			<h3>Dane:</h3>
			 <xsl:apply-templates select="/t:raport/t:kraj" />
			 <xsl:apply-templates select="/t:raport/t:regiony" />
			 <xsl:apply-templates select="/t:raport/t:grupy-etniczne/t:grupa-etniczna" />
			 <xsl:apply-templates select="/t:raport/t:wydarzenia/t:wydarzenie" />
		</body>
	</html>
	</xsl:template>

	<xsl:template match="/t:raport/t:kraj">
		<table style="clear: both; margin: 3ex 2em; color: black; background-color: aliceblue; font-weight: bold;" border="2">
			<tr><td><a name="{generate-id(.)}"></a>Nazwa kraju:</td><td style="text-align: right;"><xsl:value-of select="t:nazwa" /></td></tr>
			<tr><td>Stolica:</td><td style="text-align: right;"><xsl:value-of select="t:stolica/t:nazwa" /></td><td style="text-align: right;"><xsl:value-of select="concat(t:stolica/t:x, ' ', t:stolica/t:y)" /></td></tr>
			<tr><td>PKB:</td><td style="text-align: right;"><xsl:value-of select="t:PKB" /></td></tr>
			<tr><td>Region:</td><td style="text-align: right;"><xsl:value-of select="t:region" /></td></tr>
			<tr>
				<td>Grupy etniczne w kraju:</td>
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

	<xsl:template match="/t:raport/t:regiony/t:region">
		<table style="clear: both; margin: 3ex 2em; color: black; background-color: cornsilk; font-weight: bold;" border="2">
			<tr><td><a name="{generate-id(.)}"></a>Nazwa regionu:</td><td style="text-align: right;"><xsl:value-of select="t:id" /></td></tr>
			<tr><td>Ilość krajów:</td><td style="text-align: right;"><xsl:value-of select="t:krajów" /></td></tr>
			<tr><td>Średnie PKB:</td><td style="text-align: right;"><xsl:value-of select="t:średnie-pkb" /></td></tr>
			<tr><td>Łączna populacja:</td><td style="text-align: right;"><xsl:value-of select="t:łączna-populacja" /></td></tr>
			<tr><td>Kraje składowe:</td><td style="text-align: right;"><xsl:value-of select="t:kraje" /></td></tr>
		</table>
	</xsl:template>
	
	<xsl:template match="/t:raport/t:wydarzenia/t:wydarzenie">
		<table style="clear: both; margin: 3ex 2em; color: black; background-color: thistle; font-weight: bold;" border="2">
			<tr><td><a name="{generate-id(.)}"></a>Nazwa wydarzenia:</td><td style="text-align: right;"><xsl:value-of select="t:nazwa" /></td></tr>
			<tr><td>Data wydarzenia:</td><td style="text-align: right;">
				<xsl:value-of select="concat(t:data/@dzień, ' ', t:data/@miesiąc, ' ', t:data/@rok)" />
				<xsl:value-of select="t:kiedy" />
			</td></tr>
		</table>
	</xsl:template>
	
	<xsl:template match="/t:raport/t:grupy-etniczne/t:grupa-etniczna">
		<table style="clear: both; margin: 3ex 2em; color: black; background-color: honeydew; font-weight: bold;" border="2">
			<tr><td><a name="{generate-id(.)}"></a>Nazwa grupy etnicznej:</td><td style="text-align: right;"><xsl:value-of select="t:nazwa" /></td></tr>
			<tr><td>Występuje w krajach:</td><td style="text-align: right;">
				<xsl:value-of select="t:kraje" />
			</td></tr>
		</table>
	</xsl:template>
	
	<xsl:template match="t:data">
		<xsl:value-of select="concat(@dzień, ' ', @miesiąc, ' ', @rok)" />
	</xsl:template>


</xsl:stylesheet> 
