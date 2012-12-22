<cfsetting enablecfoutputonly="true">

<cfparam name="FORM.letter" default="all">

<!--- <cfinclude template="src/scripts.cfm" />
<cfinclude template="src/layout.cfm" /> --->

<cfoutput>
	<!-- <cfset pluginSettings = getPluginSettings()> -->
	<cfdump var="#pluginSettings#">
	#l("Welcome {bob}")#
</cfoutput>