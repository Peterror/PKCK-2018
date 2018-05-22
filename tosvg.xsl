<xsl:stylesheet version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:t="file://root.zadanie2/"
    xmlns:m="file://root.zadanie2/meta"
    xmlns:s="http://www.w3.org/2000/svg"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"> 
  <xsl:output
      method="xml"
      indent="yes"
      standalone="no"
      doctype-public="-//W3C//DTD SVG 1.1//EN"
      doctype-system="http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd"
      media-type="image/svg" />
  <xsl:template match="/">
    <xsl:variable name="svg_width" select="400"/>
    <xsl:variable name="svg_height" select="300"/>
    <s:svg width="1500" height="7000">
      <style type="text/css">
        .bar {
        fill: red;
        }
        .bar:hover { 
        fill: blue;
        }

        .nav {
        fill: blue;
        }
        .nav:hover {
        fill: green;
        }
        .navselected {
        fill: red;
        }
        .metadata {
        visibility: hidden;
        }
      </style>

      <script type="application/javascript" src="svg.js" />

      <xsl:for-each select="t:raport/t:kraj">
        <s:a href="#{generate-id(.)}" onclick="selectCountry('{generate-id(.)}')">
          <s:g>
            <s:rect id="{concat(generate-id(.), '-bar')}" x="{50+30*position()}"
                    y="50" width="25" height="20" class="nav">
              <s:animate attributeType="XML" attributeName="x" from="50" to="{50+30*position()}"
                         dur="2s" />
            </s:rect>
            <s:text x="{55+30*position()}" y="65" width="10" height="10">
              <s:animate attributeType="XML" attributeName="x" from="55" to="{55+30*position()}"
                         dur="2s" />
              <xsl:value-of select="substring(t:nazwa, 1, 1)" />
            </s:text>
            <s:title><xsl:value-of select="t:nazwa" /></s:title>
          </s:g>
        </s:a>
        <xsl:variable name="country_y_position"
                      select="80+400*(((position()-1) - (position()-1) mod 2) div 2)" />
        <s:g id="{concat(generate-id(.), '-desc')}"
             transform="translate(1000, {$country_y_position+100})"
             class="metadata">
          <s:text x="50" y="10" width="200" height="30">
            Stolica: <xsl:value-of select="t:stolica/t:nazwa" />
            (<xsl:value-of select="t:stolica/t:x" />, <xsl:value-of select="t:stolica/t:y" />)
          </s:text>
          <s:text x="50" y="50" width="100" height="30">
            PKB: <xsl:value-of select="t:PKB" />
          </s:text>
          <s:a href="#top">
            <s:text x="50" y="100" width="100" height="30">
              Powrót do nawigacji
            </s:text>
          </s:a>
        </s:g>
        <s:g id="{generate-id(.)}"
             transform="translate({50 + 500*((position()-1) mod 2)}, {$country_y_position})">
          <s:rect x="10" y="10" width="10" height="10" fill="green" />
          <s:text x="25" y="20" width="200" height="10">
            <xsl:value-of select="t:nazwa" />
          </s:text>
          <xsl:variable name="padding" select="5"/>
          <xsl:variable name="x_width"
		                    select="($svg_width - 2*$padding) div count(t:grupy/t:grupa-etniczna)"/>
          <xsl:for-each select="t:grupy/t:grupa-etniczna">
            <xsl:variable name="y_size"
                          select="3*number(substring(./t:liczność, 0, string-length(./t:liczność)-1))" />
            <s:rect x="{$padding + $x_width * (position()-1)}"
                    y="{($svg_height - $padding + 40) - $y_size}"
                    width="{$x_width}"
                    height="{$y_size}"
                    fill="red" stroke="black"
                    class="bar">
              <s:animate attributeType="XML" attributeName="y"
                         from="{($svg_height - $padding + 40)}"
                         to="{($svg_height - $padding + 40) - $y_size}"
                         dur="2s" />
              <s:animate attributeType="XML" attributeName="height"
                         from="0"
                         to="{$y_size}"
                         dur="2s" />
            </s:rect>
            <s:text x="{$padding + $x_width * (position()-1) + $x_width div 4}"
                    y="{($svg_height - $padding + 40) - $y_size - 5}"
                    width="{$x_width}"
                    height="{$y_size}">
              <s:animate attributeType="XML" attributeName="y"
                         from="{($svg_height - $padding + 35)}"
                         to="{($svg_height - $padding + 40) - $y_size - 5}"
                         dur="2s" />
              <xsl:value-of select="t:nazwa" />(<xsl:value-of select="t:liczność" />)
            </s:text>

          </xsl:for-each>
        </s:g>
      </xsl:for-each>
    </s:svg>
  </xsl:template>
</xsl:stylesheet>
