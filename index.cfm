<cfsetting enablecfoutputonly="true">

<cfset pluginSettings = getPluginSettings()>

<cfparam name="params.letter" default="all">

<cfinclude template="src/scripts.cfm" />
<cfinclude template="src/layout.cfm" />