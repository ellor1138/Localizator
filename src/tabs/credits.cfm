<cfoutput>
	<div class="tab-pane" id="Credits">
		<dl class="dl-horizontal">
			<dt>Author</dt>
			<dd>#pluginSettings.plugin.author#</dd>
			<dt>Plugin name</dt>
			<dd>#capitalize(pluginSettings.plugin.name)#</dd>
			<dt>Plugin version</dt>
			<dd>#pluginSettings.plugin.version#</dd>
			<dt>Wheels compatibility</dt>
			<dd>#pluginSettings.plugin.compatibility#</dd>
			<dt>Release date</dt>
			<dd>December 2012</dd>
			<dt>Project home</dt>
			<dd><a href="#pluginSettings.plugin.project#" target="_blank">#pluginSettings.plugin.project#</a></dd>
			<dt>Documentation</dt>
			<dd><a href="#pluginSettings.plugin.documentation#" target="_blank">#pluginSettings.plugin.documentation#</a></dd>
			<dt>Find any bugs?</dt>
			<dd>You can file an issue here:<br /><a href="#pluginSettings.plugin.issues#" target="_blank">#pluginSettings.plugin.issues#</a></dd>
			<dt>License</dt>
			<dd>#capitalize(pluginSettings.plugin.name)# is licensed under the Apache License, Version 2.0.<br /><a href="http://www.apache.org/licenses/LICENSE-2.0" target="_blank">http://www.apache.org/licenses/LICENSE-2.0</a></dd>
		</dl>
		<div class="alert alert-info" style="margin-bottom:0;">Largely inspired by Raúl Riera's Localizer plugin. <a href="http://github.com/raulriera/Localizer" target="_blank">http://github.com/raulriera/Localizer</a></div>
	</div>
</cfoutput>