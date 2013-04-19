<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dc="http://dublincore.org/documents/dces/"
	version="2.0">

	<xsl:output method="xml" />

	<xsl:param name="package-dir" />
	<xsl:variable name="cxan.org-id" select="//dc:creator/@id" />
	<xsl:variable name="module-prefix" select="//package:module-prefix" />
	<xsl:variable name="module-namespace" select="//package:module-namespace" />
	<xsl:variable name="package-version" select="/@version" />
	
	<xsl:variable name="abbrev" select="/@abbrev" />
	<xsl:param name="processor-ns">
		<xsl:text>http://exist-db.org/</xsl:text>
	</xsl:param>
	<xsl:param name="package-type-dependencies" />
	<xsl:param name="java-dependencies-list-url" />

	<xsl:variable name="spec-title">
		<xsl:copy-of select="concat('EXPath ', //element()[local-name() = 'title'])" />
	</xsl:variable>
	<xsl:variable name="author">
		<xsl:copy-of select="//element()[local-name() = 'author'][1]/element()[1]" />
	</xsl:variable>

	<xsl:variable name="package-descriptions">
		<package-descriptions>
			<package type="library">
				<name>
					<xsl:value-of select="concat('http://expath.org/lib/', $module-prefix)" />
				</name>
				<abbrev>
					<xsl:value-of select="concat('expath-', $module-prefix, '-', $processor-name, '-lib')" />
				</abbrev>
				<title>
					<xsl:value-of select="concat($spec-title, ' Implementation')" />
				</title>
			</package>
			<package type="application">
				<name>
					<xsl:value-of select="concat('http://exist-db.org/ns/expath-', $module-prefix)" />
				</name>
				<abbrev>
					<xsl:value-of select="concat('expath-', $module-prefix, '-', $processor-name, '-lib-demos')" />
				</abbrev>
				<title>
					<xsl:value-of select="concat($spec-title, ' Demos')" />
				</title>
			</package>
		</package-descriptions>
	</xsl:variable>

	<xsl:template match="/">

		<!-- generate the expath-pkg.xml files -->
		<xsl:call-template name="generate-expath-pkg-descriptor">
			<xsl:with-param name="package-type" select="'library'" />
		</xsl:call-template>
		<xsl:call-template name="generate-expath-pkg-descriptor">
			<xsl:with-param name="package-type" select="'application'" />
		</xsl:call-template>

		<!-- generate the repo.xml files -->
		<xsl:call-template name="generate-repo-descriptor">
			<xsl:with-param name="package-type" select="'library'" />
		</xsl:call-template>
		<xsl:call-template name="generate-repo-descriptor">
			<xsl:with-param name="package-type" select="'application'" />
		</xsl:call-template>

		<!-- generate the cxan.xml files -->
		<xsl:call-template name="generate-cxan-descriptor">
			<xsl:with-param name="package-type" select="'library'" />
		</xsl:call-template>
		<xsl:call-template name="generate-cxan-descriptor">
			<xsl:with-param name="package-type" select="'application'" />
		</xsl:call-template>

		<xsl:result-document href="{concat($package-dir, '/library-package-descriptors/exist.xml')}">
			<xsl:variable name="java-dependencies-list-entries" as="xs:string*"
				select="tokenize(unparsed-text($java-dependencies-list-url), '\r?\n')" />
			<package xmlns="http://exist-db.org/ns/expath-pkg">
				<jar>
					<!-- <xsl:value-of select="concat('expath-', $module-prefix, '-exist-lib/', $jar-name)" /> -->
					<xsl:value-of select="$jar-name" />
				</jar>
				<xsl:for-each select="$java-dependencies-list-entries[contains(., ':compile')]">
					<xsl:variable name="tokens" as="xs:string*" select="tokenize(., ':')" />
					<jar>
						<xsl:value-of select="concat($tokens[2], '-', $tokens[4], '.jar')" />
					</jar>
				</xsl:for-each>
				<java>
					<namespace>
						<xsl:value-of select="$module-namespace" />
					</namespace>
					<class>
						<xsl:value-of select="//java/class" />
					</class>
				</java>
			</package>
		</xsl:result-document>

		<xsl:result-document href="{concat($package-dir, '/application-package-descriptors/controller.xql')}"
			omit-xml-declaration="yes">
			xquery version "1.0";

			declare variable $exist:path external;
			declare variable $exist:resource external;
			declare variable
			$exist:controller external;
			declare variable $exist:prefix external;
			declare
			variable $exist:root external;

			(:

			Enter the
			following in the eXist client. $EXIST_HOME/bin/client.sh
			cd /db/apps/eco-meta
			chmod controller.xql user=+execute
			chmod
			controller.xql group=+execute
			chmod
			controller.xql other=+execute

			Use this to verify the $exist:path
			let $log :=
			util:log-system-out(concat('$exist:path=', $exist:path))
			return
			:)

			(: if we have a slash or a null then redirect to the
			index
			page. Note that null seems to be broken :)
			if ($exist:path = ('/', '')) then
			(: forward root path to index.xq :)
			<dispatch xmlns="http://exist.sourceforge.net/NS/exist">
				<redirect url="index.xml" />
			</dispatch>
			else
			(: everything else is passed through :)
			<dispatch xmlns="http://exist.sourceforge.net/NS/exist">
				<cache-control cache="yes" />
			</dispatch>
		</xsl:result-document>

	</xsl:template>

	<xsl:template name="generate-cxan-descriptor">
		<xsl:param name="package-type" />
		<xsl:variable name="package-description" select="$package-descriptions/element()/element()[@type = $package-type]" />
		<xsl:result-document href="{concat($package-dir, '/', $package-type, '-package-descriptors/cxan.xml')}">
			<package xmlns="http://cxan.org/ns/package" id="{$abbrev}"
				name="{$package-description/element()[local-name() = 'name']}" version="{$package-version}">
				<author id="{$cxan.org-id}">
					<xsl:value-of select="$author" />
				</author>
				<category id="libs">Libraries</category>
				<category id="exist">eXist extensions</category>
				<tag>
					<xsl:value-of select="$module-prefix" />
				</tag>
				<tag>expath</tag>
				<tag>
					<xsl:value-of select="$package-type" />
				</tag>
				<tag>
					<xsl:value-of select="$processor-name" />
				</tag>
			</package>
		</xsl:result-document>
	</xsl:template>

	<xsl:template name="generate-expath-pkg-descriptor">
		<xsl:param name="package-type" />
		<xsl:variable name="package-description" select="$package-descriptions/element()/element()[@type = $package-type]" />
		<xsl:result-document href="{concat($package-dir, '/', $package-type, '-package-descriptors/expath-pkg.xml')}">
			<package xmlns="http://expath.org/ns/pkg" name="{$package-description/element()[local-name() = 'name']}"
				abbrev="{$abbrev}" version="{$package-version}" spec="1.0">
				<title>
					<xsl:value-of select="$package-description/element()[local-name() = 'title']" />
				</title>
				<dependency processor="{$processor-ns}" />
				<xsl:choose>
					<xsl:when test="$package-type = 'application'">
						<dependency package="{$package-type-dependencies}" />
					</xsl:when>
				</xsl:choose>
			</package>
		</xsl:result-document>
	</xsl:template>

	<xsl:template name="generate-repo-descriptor">
		<xsl:param name="package-type" />
		<xsl:variable name="package-description" select="$package-descriptions/element()/element()[@type = $package-type]" />
		<xsl:result-document href="{concat($package-dir, '/', $package-type, '-package-descriptors/repo.xml')}">
			<meta xmlns="http://exist-db.org/xquery/repo">
				<description>
					<xsl:value-of select="$package-description/element()[local-name() = 'title']" />
				</description>
				<author>
					<xsl:value-of select="$author" />
				</author>
				<website />
				<status>stable</status>
				<license>GNU-LGPL</license>
				<copyright>true</copyright>
				<type>
					<xsl:value-of select="$package-type" />
				</type>
				<xsl:choose>
					<xsl:when test="$package-type = 'application'">
						<target>
							<xsl:value-of select="concat('expath-', $module-prefix)" />
						</target>
					</xsl:when>
				</xsl:choose>
			</meta>
		</xsl:result-document>
	</xsl:template>

</xsl:stylesheet>