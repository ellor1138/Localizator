<cfsetting enablecfoutputonly="true">

<cfset pluginSettings = getPluginSettings()>

<cfparam name="FORM.letter" default="all">



<!--- <cfinclude template="src/scripts.cfm" />
<cfinclude template="src/layout.cfm" /> --->

<!--- <cfoutput>
	<cfdump var="#pluginSettings#">
	<hr>
	#l("Welcome {bob}","fr_CA")#
	#pluginSettings.isDB#
</cfoutput> --->