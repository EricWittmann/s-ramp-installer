<?xml version="1.0" encoding="UTF-8"?>
<!-- XSLT file to add the security domains to the standalone.xml -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:as="urn:jboss:domain:1.2"
  xmlns="urn:jboss:domain:1.2" xmlns:inf="urn:jboss:domain:infinispan:1.2"
  xmlns:ds="urn:jboss:domain:datasources:1.0" xmlns:scan="urn:jboss:domain:deployment-scanner:1.1"
  xmlns:sd="urn:jboss:domain:security:1.1" xmlns:xalan="http://xml.apache.org/xalan" version="1.0">

  <xsl:output method="xml" encoding="UTF-8" indent="yes" xalan:indent-amount="2" />

  <xsl:template match="as:profile/ds:subsystem/ds:datasources">
            <datasources xmlns="urn:jboss:domain:datasources:1.0">
                <datasource jta="true" jndi-name="java:jboss/datasources/jbpmDS" pool-name="H2DS" enabled="true" use-java-context="true" use-ccm="true">
                    <connection-url>jdbc:h2:${jboss.server.data.dir}/jbpm</connection-url>
                    <driver>h2</driver>
                    <pool>
                        <min-pool-size>1</min-pool-size>
                        <max-pool-size>4</max-pool-size>
                        <prefill>false</prefill>
                        <use-strict-min>false</use-strict-min>
                        <flush-strategy>FailingConnectionOnly</flush-strategy>
                    </pool>
                    <security>
                        <user-name>sa</user-name>
                    </security>
                    <validation>
                        <check-valid-connection-sql>SELECT 1</check-valid-connection-sql>
                        <validate-on-match>false</validate-on-match>
                        <background-validation>false</background-validation>
                    </validation>
                </datasource>
                <xsl:apply-templates select="@* | *" />
            </datasources>
  </xsl:template>

  <xsl:template match="as:profile/scan:subsystem/scan:deployment-scanner">
    <xsl:copy>
      <xsl:attribute name="deployment-timeout">300</xsl:attribute>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>

  <!-- Copy everything else. -->
  <xsl:template match="@*|node()|text()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()|text()" />
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>