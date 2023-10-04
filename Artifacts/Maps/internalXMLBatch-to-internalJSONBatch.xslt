<xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:math="http://www.w3.org/2005/xpath-functions/math" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:dm="http://azure.workflow.datamapper" xmlns:ef="http://azure.workflow.datamapper.extensions" xmlns="http://www.w3.org/2005/xpath-functions" exclude-result-prefixes="xsl xs math dm ef" version="3.0" expand-text="yes">
  <xsl:output indent="yes" media-type="text/json" method="text" omit-xml-declaration="yes" />
  <xsl:template match="/">
    <xsl:variable name="xmloutput">
      <xsl:apply-templates select="." mode="azure.workflow.datamapper" />
    </xsl:variable>
    <xsl:value-of select="xml-to-json($xmloutput,map{'indent':true()})" />
  </xsl:template>
  <xsl:template match="/" mode="azure.workflow.datamapper">
    <map>
      <array key="catalogItems">
        <xsl:for-each select="/root/catalogitems/catalogitem">
          <map>
            <string key="vendor">{vendor}</string>
            <string key="sku">{sku}</string>
            <string key="vendorSku">{vendorsku}</string>
            <string key="name">{name}</string>
            <string key="shortDesc">{shortdesc}</string>
            <array key="specifications">
              <xsl:for-each select="specifications/specification">
                <map>
                  <string key="name">{name}</string>
                  <string key="value">{value}</string>
                </map>
              </xsl:for-each>
            </array>
            <string key="longDesc">{longdesc}</string>
            <array key="suggestedRetailPrices">
              <xsl:for-each select="suggestedretailprices/suggestedretailprice">
                <map>
                  <string key="currency">{currency}</string>
                  <string key="price">{string(price)}</string>
                </map>
              </xsl:for-each>
            </array>
          </map>
        </xsl:for-each>
      </array>
    </map>
  </xsl:template>
</xsl:stylesheet>