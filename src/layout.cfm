<!DOCTYPE html>
	<head>
		<meta charset="utf-8">
		<title><cfoutput>#capitalize(pluginSettings.plugin.name)# #pluginSettings.plugin.version#</cfoutput></title>
		
		<script src="//ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
		<script src="//netdna.bootstrapcdn.com/twitter-bootstrap/2.2.1/js/bootstrap.min.js"></script>
		
		<link href="//netdna.bootstrapcdn.com/twitter-bootstrap/2.2.1/css/bootstrap.min.css" rel="stylesheet">
		
		<cfinclude template="styles.cfm">
		<cfinclude template="js.cfm">
	</head>
	
	<body>
		<cfoutput>
			<div class="container"> 
				
				<div class="hero-unit">
					<h1>#capitalize(pluginSettings.plugin.name)# #pluginSettings.plugin.version#</h1>
					<p>This plugin offer a complete solution to add localization (translation) capabilities to your application.</p>
					<h2>Benefits of using this plugin:</h2>
					<ul class="small">
						<li>Get text translation from a localization database or localization file(s).</li>
						<li>Populate your localization database or localization file(s) by "harvesting" the text of your application.</li>
						<li>Use the editor to add translation to your localization database and localization file(s).</li>
						<li>Generate localization file(s) from your localization database.</li>
					</ul>
				</div>
				
				<a id="generate" style="margin:0; padding:0;"></a>
				
				<div class="row">
					<cfif isDefined("loc.message.generator")>
						<div>&nbsp;</div>
						<div class="span12">
							<div class="alert alert-success" style="text-align:center;">#loc.message.generator#</div>
						</div>
					</cfif>
					<div class="span8">
						<h1>Plugin usage</h1>
						
						<ul class="nav nav-tabs" id="maintabs">
							<li class="active"><a href="##Settings" data-toggle="tab">Settings</a></li>
							<li><a href="##Translator" data-toggle="tab">Translator</a></li>
							<li><a href="##Harvester" data-toggle="tab">Harvester</a></li>
							<li><a href="##Editor" data-toggle="tab">Editor</a></li>
							<li><a href="##Generator" data-toggle="tab">Generator</a></li>
							<li><a href="##Log" data-toggle="tab">Change Log</a></li>
							<li><a href="##Credits" data-toggle="tab">Credits</a></li>
						</ul>
						
						<div class="tab-content" id="maincontent">
							<cfinclude template="tabs/settings.cfm">
							<cfinclude template="tabs/translator.cfm">
							<cfinclude template="tabs/harvester.cfm">
							<cfinclude template="tabs/editor.cfm">
							<cfinclude template="tabs/generator.cfm">
							<cfinclude template="tabs/log.cfm">
							<cfinclude template="tabs/credits.cfm">
						</div>
					</div>
					
					<div class="span4">
						<h1>&nbsp;</h1>
						
						<ul class="nav nav-tabs" id="subtabs">

							<li class="#pluginSettings.isDB EQ true ? 'active' : ''#"><a href="##Database" data-toggle="tab">Localization database</a></li>
							<li class="#pluginSettings.isDB NEQ true ? 'active' : ''#"><a href="##Files" data-toggle="tab">Localization files</a></li>
						</ul>
						
						<div class="tab-content" id="subcontent">
							<cfinclude template="tabs/database.cfm">
							<cfinclude template="tabs/files.cfm">
						</div>
					</div>
				</div>
				
				<a id="edit"></a>
				
				<cfif flashKeyExists("message")>
					<div>&nbsp;</div>
					<div class="alert alert-#flash('messageType')#" style="text-align:center;">
						#flash("message")#
					</div>
				</cfif>
				
				<div class="row">
					<cfif pluginSettings.isDB>
						<cfinclude template="forms/database.cfm">
					<cfelse>
						<cfinclude template="forms/files.cfm">
					</cfif>
				</div>
			</div>
		</cfoutput>
	</body>
</html>