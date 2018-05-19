<xsl:stylesheet version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:t="file://root.zadanie2/"
    xmlns:m="file://root.zadanie2/meta"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"> 

	<xsl:output method="text" encoding="utf-8"/>
		
<xsl:template match="/">
	Kraje
	=====
		<xsl:value-of select="t:raport/t:streszczenie" />

		## Autorzy: 
			<xsl:for-each select="t:raport/t:autorzy/t:autor">
				### <xsl:value-of select="." />
			</xsl:for-each>			

		## Kraje zawarte w XML'u:
			<xsl:for-each select="t:raport/t:kraj">
				### <xsl:value-of select="t:nazwa" />
			</xsl:for-each>
			
		## Regiony zawarte w XML'u:
			<xsl:for-each select="t:raport/t:regiony/t:region">
				### <xsl:value-of select="t:id" />
			</xsl:for-each>
			
		## Grupy etniczne zawarte w XML'u:
			<xsl:for-each select="t:raport/t:grupy-etniczne/t:grupa-etniczna"> 
				### <xsl:value-of select="t:nazwa" />
			</xsl:for-each>
		
		## Wydarzenia zawarte w XML'u:
			<xsl:for-each select="t:raport/t:wydarzenia/t:wydarzenie">
				### <xsl:value-of select="t:nazwa" />
			</xsl:for-each>

		## Dane:
		
			### Kraje:
			<xsl:apply-templates select="/t:raport/t:kraj" />
			### Regiony:<xsl:apply-templates select="/t:raport/t:regiony" />
		 
			### Grupy etniczne:
		<xsl:apply-templates select="/t:raport/t:grupy-etniczne/t:grupa-etniczna" />
		 
			### Wydarzenia:
		<xsl:apply-templates select="/t:raport/t:wydarzenia/t:wydarzenie" />
</xsl:template>

<xsl:template match="/t:raport/t:kraj">
				Nazwa kraju:<xsl:value-of select="concat(' ', t:nazwa)" />
				Stolica:<xsl:value-of select="concat(' ', t:stolica/t:nazwa)" /><xsl:value-of select="concat(' (', t:stolica/t:x, ' ', t:stolica/t:y, ')')" />
				PKB:<xsl:value-of select="concat(' ', t:PKB)" />
				Region:<xsl:value-of select="concat(' ', t:region)" />
				Grupy etniczne w kraju:<xsl:for-each select="t:grupy/t:grupa-etniczna"><xsl:text>
					</xsl:text><xsl:value-of select="concat(t:nazwa, ' (', t:liczność, ')')" />
					</xsl:for-each>
				Ważne wydarzenia:<xsl:for-each select="t:ważne-wydarzenia/t:wydarzenie"><xsl:text>
					</xsl:text><xsl:value-of select="concat(t:wydarzenie/t:nazwa, ' - ')" /><xsl:apply-templates select="t:wydarzenie/t:data" />
				</xsl:for-each>
				<xsl:text>
				</xsl:text>
</xsl:template>

<xsl:template match="/t:raport/t:regiony/t:region">
				Nazwa regionu:<xsl:value-of select="concat(' ',t:id)" />
				Ilość krajów:<xsl:value-of select="concat(' ',t:krajów)" />
				Średnie PKB:<xsl:value-of select="concat(' ',t:średnie-pkb)" />
				Łączna populacja:<xsl:value-of select="concat(' ',t:łączna-populacja)" />
				Kraje składowe:<xsl:value-of select="concat(' ',t:kraje)" />
</xsl:template>

<xsl:template match="/t:raport/t:wydarzenia/t:wydarzenie">
					Nazwa wydarzenia:<xsl:value-of select="concat(' ', t:nazwa)" />
					Data wydarzenia: <xsl:value-of select="concat(t:data/@dzień, ' ', t:data/@miesiąc, ' ', t:data/@rok)" /><xsl:value-of select="t:kiedy" />
					<xsl:text>
					</xsl:text>
</xsl:template>

<xsl:template match="/t:raport/t:grupy-etniczne/t:grupa-etniczna">
				Nazwa grupy etnicznej:<xsl:value-of select="t:nazwa" />
				Występuje w krajach: <xsl:value-of select="t:kraje" />
				<xsl:text>
				</xsl:text>
</xsl:template>

<xsl:template match="t:data">
	<xsl:value-of select="concat(@dzień, ' ', @miesiąc, ' ', @rok)" />
</xsl:template>


</xsl:stylesheet> 
