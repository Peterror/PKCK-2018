<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:t="file://root.zadanie2/"
    xmlns:m="file://root.zadanie2/meta"> 
	
		<xsl:attribute-set name="table-borders">
		<xsl:attribute name="border-top-style">solid</xsl:attribute>
		<xsl:attribute name="border-top-width">0.2mm</xsl:attribute>
		<xsl:attribute name="border-right-style">solid</xsl:attribute>
		<xsl:attribute name="border-right-width">0.2mm</xsl:attribute>
		<xsl:attribute name="border-left-style">solid</xsl:attribute>
		<xsl:attribute name="border-left-width">0.2mm</xsl:attribute>
		<xsl:attribute name="border-bottom-style">solid</xsl:attribute>
		<xsl:attribute name="border-bottom-width">0.2mm</xsl:attribute>
	</xsl:attribute-set>	
	
	<xsl:output method="xml" encoding="utf-8"
	omit-xml-declaration="no" indent="yes" />
	<xsl:template match="/" encoding="utf-8">
		<fo:root>
			<fo:layout-master-set>
				<fo:simple-page-master master-name="Kraje"
					page-height="29.7cm" page-width="21.0cm" margin="2cm" >
				<fo:region-body />
				</fo:simple-page-master>
			</fo:layout-master-set>
			<fo:page-sequence master-reference="Kraje">
				<fo:flow flow-name="xsl-region-body">
					<fo:block font-size="24pt" font-weight="bold">Kraje</fo:block>
					<fo:block font-size="12pt">
						<xsl:value-of select="t:raport/t:streszczenie" />
					</fo:block>
					<fo:block font-size="20pt" font-weight="bold">Autorzy</fo:block>
					<xsl:for-each select="t:raport/t:autorzy/t:autor">
						<fo:block font-size="12pt">
							<xsl:value-of select="." />
						</fo:block>
					</xsl:for-each>		
					<fo:block font-size="20pt" font-weight="bold">
						Kraje zawarte w XML'u: 
					</fo:block>
					<xsl:apply-templates select="/t:raport/t:kraj" />
					
					<fo:block font-size="20pt" font-weight="bold">
						Grupy etniczne:
					</fo:block>
					<xsl:apply-templates select="/t:raport/t:grupy-etniczne/t:grupa-etniczna" />
		 
					<fo:block font-size="20pt" font-weight="bold">
						Wydarzenia:
					</fo:block>
					<xsl:apply-templates select="/t:raport/t:wydarzenia/t:wydarzenie" />

				</fo:flow>
			</fo:page-sequence>
		</fo:root>
	</xsl:template>
	<xsl:template match="/t:raport/t:kraj">
		<fo:table xsl:use-attribute-sets="table-borders" margin-bottom="5mm">
			<fo:table-header>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="table-borders" text-align="center">
						<fo:block font-weight="bold">Nazwa kraju</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="table-borders" text-align="center">
						<fo:block font-size="10pt">
							<xsl:value-of select="concat(' ', t:nazwa)" />
						</fo:block>
					</fo:table-cell>
				</fo:table-row>
			</fo:table-header>
			<fo:table-body>
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="table-borders" text-align="center">
						<fo:block font-weight="bold">Stolica</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="table-borders" text-align="center">
						<fo:block font-size="10pt">
							<xsl:value-of select="concat(' ', t:stolica/t:nazwa)" /><xsl:value-of select="concat(' (', t:stolica/t:x, ' ', t:stolica/t:y, ')')" />
						</fo:block>
					</fo:table-cell>
				</fo:table-row>								
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="table-borders" text-align="center">
						<fo:block font-weight="bold">PKB</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="table-borders" text-align="center">
						<fo:block font-size="10pt">
							<xsl:value-of select="concat(' ', t:PKB)" />
						</fo:block>
					</fo:table-cell>
				</fo:table-row>								
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="table-borders" text-align="center">
						<fo:block font-weight="bold">Region</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="table-borders" text-align="center">
						<fo:block font-size="10pt">
							<xsl:value-of select="concat(' ', t:region)" />
						</fo:block>
					</fo:table-cell>
				</fo:table-row>								
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="table-borders" text-align="center">
						<fo:block font-weight="bold">Grupy etniczne w kraju</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="table-borders" text-align="center">
						<xsl:for-each select="t:grupy/t:grupa-etniczna">
							<fo:block font-size="10pt">
								<xsl:value-of select="concat(t:nazwa, ' (', t:liczność, ')')" />
							</fo:block>
						</xsl:for-each>
					</fo:table-cell>
				</fo:table-row>								
				<fo:table-row>
					<fo:table-cell xsl:use-attribute-sets="table-borders" text-align="center">
						<fo:block font-weight="bold">Ważne wydarzenia</fo:block>
					</fo:table-cell>
					<fo:table-cell xsl:use-attribute-sets="table-borders" text-align="center">
						<xsl:for-each select="t:ważne-wydarzenia/t:wydarzenie">
							<fo:block font-size="10pt">
								<xsl:value-of select="concat(t:wydarzenie/t:nazwa, ' - ')" /><xsl:apply-templates select="t:wydarzenie/t:data" />
							</fo:block>
						</xsl:for-each>
						<fo:block font-size="10pt">
						</fo:block>
					</fo:table-cell>
				</fo:table-row>								
			</fo:table-body>
		</fo:table>
</xsl:template>

<xsl:template match="/t:raport/t:regiony/t:region">
	<fo:table xsl:use-attribute-sets="table-borders" margin-bottom="5mm">
		<fo:table-body>
			<fo:table-row>
				<fo:table-cell xsl:use-attribute-sets="table-borders" text-align="center">
					<fo:block font-weight="bold">Nazwa regionu</fo:block>
				</fo:table-cell>
				<fo:table-cell xsl:use-attribute-sets="table-borders" text-align="center">
					<fo:block font-size="10pt">
						<xsl:value-of select="concat(' ',t:id)" />
					</fo:block>
				</fo:table-cell>
			</fo:table-row>								
			<fo:table-row>
				<fo:table-cell xsl:use-attribute-sets="table-borders" text-align="center">
					<fo:block font-weight="bold">Ilość krajów</fo:block>
				</fo:table-cell>
				<fo:table-cell xsl:use-attribute-sets="table-borders" text-align="center">
					<fo:block font-size="10pt">
						<xsl:value-of select="concat(' ',t:krajów)" />
					</fo:block>
				</fo:table-cell>
			</fo:table-row>								
			<fo:table-row>
				<fo:table-cell xsl:use-attribute-sets="table-borders" text-align="center">
					<fo:block font-weight="bold">Średnie PKB</fo:block>
				</fo:table-cell>
				<fo:table-cell xsl:use-attribute-sets="table-borders" text-align="center">
					<fo:block font-size="10pt">
						<xsl:value-of select="concat(' ',t:średnie-pkb)" />
					</fo:block>
				</fo:table-cell>
			</fo:table-row>								
			<fo:table-row>
				<fo:table-cell xsl:use-attribute-sets="table-borders" text-align="center">
					<fo:block font-weight="bold">Łączna populacja</fo:block>
				</fo:table-cell>
				<fo:table-cell xsl:use-attribute-sets="table-borders" text-align="center">
					<fo:block font-size="10pt">
						<xsl:value-of select="concat(' ',t:łączna-populacja)" />
					</fo:block>
				</fo:table-cell>
			</fo:table-row>								
			<fo:table-row>
				<fo:table-cell xsl:use-attribute-sets="table-borders" text-align="center">
					<fo:block font-weight="bold">Kraje składowe</fo:block>
				</fo:table-cell>
				<fo:table-cell xsl:use-attribute-sets="table-borders" text-align="center">
					<fo:block font-size="10pt">
						<xsl:value-of select="concat(' ',t:kraje)" />
					</fo:block>
				</fo:table-cell>
			</fo:table-row>								
		</fo:table-body>
	</fo:table>
</xsl:template>

<xsl:template match="/t:raport/t:wydarzenia/t:wydarzenie">
	<fo:table xsl:use-attribute-sets="table-borders" margin-bottom="5mm">
		<fo:table-body>
			<fo:table-row>
				<fo:table-cell xsl:use-attribute-sets="table-borders" text-align="center">
					<fo:block font-weight="bold">Nazwa wydarzenia</fo:block>
				</fo:table-cell>
				<fo:table-cell xsl:use-attribute-sets="table-borders" text-align="center">
					<fo:block font-size="10pt">
						<xsl:value-of select="concat(' ', t:nazwa)" />
					</fo:block>
				</fo:table-cell>
			</fo:table-row>														
			<fo:table-row>
				<fo:table-cell xsl:use-attribute-sets="table-borders" text-align="center">
					<fo:block font-weight="bold">Data wydarzenia</fo:block>
				</fo:table-cell>
				<fo:table-cell xsl:use-attribute-sets="table-borders" text-align="center">
					<fo:block font-size="10pt">
						<xsl:value-of select="concat(t:data/@dzień, ' ', t:data/@miesiąc, ' ', t:data/@rok)" /><xsl:value-of select="t:kiedy" />
					</fo:block>
				</fo:table-cell>
			</fo:table-row>														
		</fo:table-body>
	</fo:table>
</xsl:template>

<xsl:template match="/t:raport/t:grupy-etniczne/t:grupa-etniczna">
	<fo:table xsl:use-attribute-sets="table-borders" margin-bottom="5mm">
		<fo:table-body>
			<fo:table-row>
				<fo:table-cell xsl:use-attribute-sets="table-borders" text-align="center">
					<fo:block font-weight="bold">Nazwa grupy etnicznej</fo:block>
				</fo:table-cell>
				<fo:table-cell xsl:use-attribute-sets="table-borders" text-align="center">
					<fo:block font-size="10pt">
						<xsl:value-of select="t:nazwa" />
					</fo:block>
				</fo:table-cell>
			</fo:table-row>														
			<fo:table-row>
				<fo:table-cell xsl:use-attribute-sets="table-borders" text-align="center">
					<fo:block font-weight="bold">Występuje w krajach</fo:block>
				</fo:table-cell>
				<fo:table-cell xsl:use-attribute-sets="table-borders" text-align="center">
					<fo:block font-size="10pt">
						<xsl:value-of select="t:kraje" />
					</fo:block>
				</fo:table-cell>
			</fo:table-row>														
		</fo:table-body>
	</fo:table>
				Nazwa grupy etnicznej:<xsl:value-of select="t:nazwa" />
				Występuje w krajach: <xsl:value-of select="t:kraje" />
				<xsl:text>
				</xsl:text>
</xsl:template>

<xsl:template match="t:data">
	<xsl:value-of select="concat(@dzień, ' ', @miesiąc, ' ', @rok)" />
</xsl:template>

</xsl:stylesheet>