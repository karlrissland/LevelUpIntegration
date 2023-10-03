<xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:math="http://www.w3.org/2005/xpath-functions/math" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:dm="http://azure.workflow.datamapper" xmlns:ef="http://azure.workflow.datamapper.extensions" exclude-result-prefixes="xsl xs math dm ef" version="3.0" expand-text="yes">
  <xsl:output indent="yes" media-type="text/xml" method="xml" />
  <xsl:template match="/">
    <xsl:apply-templates select="." mode="azure.workflow.datamapper" />
  </xsl:template>
  <xsl:template match="/" mode="azure.workflow.datamapper">
    <root>
      <catalogitems>
        <xsl:for-each select="/root/catalogitems/catalogitem">
          <catalogitem>
            <vendor>{/root/vendor}</vendor>
            <sku>{concat(/root/vendor, string(sku))}</sku>
            <vendorsku>{string(sku)}</vendorsku>
            <name>{name}</name>
            <shortdesc>{shortdesc}</shortdesc>
            <specifications>
              <xsl:for-each select="specifications/specification">
                <specification>
                  <name>{name}</name>
                  <value>{value}</value>
                </specification>
              </xsl:for-each>
            </specifications>
            <suggestedretailprices>
              <xsl:for-each select="/root/catalogitems/catalogitem">
                <suggestedretailprice>
                  <currency>{'USD'}</currency>
                </suggestedretailprice>
              </xsl:for-each>
            </suggestedretailprices>
          </catalogitem>
        </xsl:for-each>
      </catalogitems>
    </root>
  </xsl:template>
</xsl:stylesheet>