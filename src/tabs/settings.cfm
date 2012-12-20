<cfoutput>
	<div class="tab-pane active" id="Settings">
		<div class="alert">
			<span class="label label-warning">Important</span> &nbsp;&nbsp;All the plugin settings should be place in config/settings.cfm files.
		</div>
		<dl>
			<dt>Default language</dt>
			<dd>The plugin use the default server Locale ID as the default language. You can use a different Locale ID by using this setting.
				<ul>
					<li><u>set(localizatorLanguageDefault="Locale ID")</u></li>
				</ul>
			</dd>
			<dt>Session variable</dt>
			<dd>The plugin can retrieve the language (Locale ID) from the session scope (e.g. from a user session). Just set the structure/key where the plugin should go check for the Locale ID.
				<ul>
					<li><u>set(localizatorLanguageSession="currentuser.language")</u></li>
				</ul>
			</dd>
			<dt>Harvester</dt>
			<dd>To activate the "Harvester" during development/design mode, simply set it to TRUE.
				<ul>
					<li><u>set(localizatorLanguageHarvest=true)</u></li>
				</ul>
			</dd>
			<dt>Localization table</dt>
			<dd>The default name of the localization table is... drum roll... "localizations". To use a different table name, just set it like this:
				<ul>
					<li><u>set(localizatorLanguageTable="MyTableName")</u></li>
				</ul>
			</dd>
			<dt>Localization file(s)</dt>
			<dd>You can force the plugin to get translation from localization files instead of the database.
				<ul>
					<li><u>set(localizatorGetLocalizationFromFile=true)</u></li>
				</ul>
			</dd>
		</dl>
		<hr />
		<div class="well well-small" style="text-align:center; margin-bottom:0;">
			<span class="label label-inverse">Important</span> &nbsp;&nbsp;This plugin use the standard Java locale names (Locale ID). <a href="http://docs.oracle.com/javase/1.4.2/docs/guide/intl/locale.doc.html" target="_blank">http://docs.oracle.com/javase/1.4.2/docs/guide/intl/locale.doc.html</a>
		</div>
	</div>
</cfoutput>