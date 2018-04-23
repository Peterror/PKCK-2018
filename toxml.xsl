
<xsl:stylesheet version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:t="file://root.zadanie2/"
    xmlns:m="file://root.zadanie2/meta"
    xmlns="file://root.zadanie2/"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"> 

  <xsl:output method="xml" encoding="utf-8" indent="yes" /> 

  <xsl:template match="/"> 
    <raport>
        <xsl:apply-templates select="t:dokument/m:opis" />
        <xsl:apply-templates select="t:dokument/t:kraje" />
        <xsl:apply-templates select="t:dokument/t:regiony" />
        <xsl:apply-templates select="t:dokument/t:grupy-etniczne" />
        <xsl:apply-templates select="t:dokument/t:wydarzenia" />
    </raport>
  </xsl:template> 

  <xsl:template match="t:dokument/m:opis">
    <streszczenie>
        <xsl:value-of select="m:streszczenie" />
    </streszczenie>
    <autorzy>
        <xsl:for-each select="m:autorzy/m:autor">
            <autor><xsl:value-of select="." />, nr indeksu: <xsl:value-of select="@index" /></autor>
        </xsl:for-each>
    </autorzy>
  </xsl:template>

  <xsl:template match="t:dokument/t:kraje">
    <xsl:for-each select="t:kraj">
        <xsl:sort select="t:PKB" data-type="number" order="descending" />
        <kraj>
            <nazwa><xsl:value-of select="t:nazwa" /></nazwa>
            <stolica>
                <nazwa><xsl:value-of select="t:stolica/t:nazwa" /></nazwa>
                <x><xsl:value-of select="t:stolica/t:współrzędne/t:wysokość" /><xsl:value-of select="t:stolica/t:współrzędne/t:wysokość/@typ"/></x>
                <y><xsl:value-of select="t:stolica/t:współrzędne/t:szerokość" /><xsl:value-of select="t:stolica/t:współrzędne/t:szerokość/@typ"/></y>
            </stolica>
            <PKB><xsl:value-of select="concat(t:PKB, t:PKB/@jednostka, ' ', t:PKB/@waluta)" /></PKB>
            <region><xsl:value-of select="t:region/@idref" /></region>
            <grupy>
                <xsl:for-each select="t:grupy-etniczne/t:grupa-etniczna">
                    <grupa-etniczna>
                        <nazwa><xsl:value-of select="@idref" /></nazwa>
                        <liczność><xsl:value-of select="concat(@wartość, @jednostka)" /></liczność>
                    </grupa-etniczna>
                </xsl:for-each>
            </grupy>
            <ważne-wydarzenia>
                <xsl:for-each select="t:ważne-wydarzenia/t:ważne-wydarzenie">
                    <wydarzenie>
                        <xsl:variable name="idref" select="@id" />
                        <xsl:copy-of select="/t:dokument/t:wydarzenia/t:wydarzenie[@id = $idref]" />
                    </wydarzenie>
                </xsl:for-each>
            </ważne-wydarzenia>
        </kraj>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="t:dokument/t:regiony">
    <regiony>
        <xsl:for-each-group select="t:region" group-by="@id">
            <region>
                <id><xsl:value-of select="@id" /></id>
                <krajów><xsl:value-of select="count(/t:dokument/t:kraje/t:kraj/t:region[@idref = current-grouping-key()])" /></krajów>
                <średnie-pkb><xsl:value-of select="format-number(avg(/t:dokument/t:kraje/t:kraj/t:region[@idref = current-grouping-key()]/../t:PKB), '0.00')" /></średnie-pkb>
                <łączna-populacja><xsl:value-of select="format-number(sum(/t:dokument/t:kraje/t:kraj/t:region[@idref = current-grouping-key()]/../t:populacja), '0')" /></łączna-populacja>
                <kraje><xsl:value-of select="/t:dokument/t:kraje/t:kraj/t:region[@idref = current-grouping-key()]/../t:nazwa" separator=", " /></kraje>
            </region>
        </xsl:for-each-group>
    </regiony>
  </xsl:template>

  <xsl:template match="t:dokument/t:grupy-etniczne">
    <grupy-etniczne>
        <xsl:for-each select="t:grupa-etniczna">
            <grupa-etniczna>
                <nazwa><xsl:value-of select="@id" /></nazwa>
                <xsl:variable name="idref" select="@id" />
                <kraje>
                    <xsl:value-of select="/t:dokument/t:kraje/t:kraj/t:grupy-etniczne/t:grupa-etniczna[@idref = $idref]/../../t:nazwa" separator=", "/>
                </kraje>
            </grupa-etniczna>
        </xsl:for-each>
    </grupy-etniczne>
  </xsl:template>

  <xsl:template match="t:dokument/t:wydarzenia">
    <xsl:copy-of select="." />
  </xsl:template>

</xsl:stylesheet> 