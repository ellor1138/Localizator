<cfoutput>
	<div class="tab-pane active" id="Settings">
		<div class="pad">
			<div class="alert alert-danger">
				<span class="label label-danger">Important</span> &nbsp;&nbsp;Here's the new way to configure #capitalize(loc.config.settings.plugin.name)# #loc.config.settings.plugin.version# with Wheels 1.3
			</div>
			<div class="alert alert-info">
				<p style="font-weight:bold;">In your config/environment folders, create a new file called "localizator.cfm", and add this structure:</p>
				<hr>
				<p>
					<div>&lt;cfset loc = {</div>
						<div style="margin-left:40px;">dataSourceName="YourDataSourceName",</div>
						<div style="margin-left:40px;">localizatorLanguageDefault="Locale ID",</div>
						<div style="margin-left:40px;">localizatorLanguageSession="user.localeid",</div>
						<div style="margin-left:40px;">localizatorGetLocalizationFromFile=false,</div>
						<div style="margin-left:40px;">localizatorLanguageHarvest=false,</div>
						<div style="margin-left:40px;">localizatorLanguageTable="localizationTable"</div>
					<div>}&gt;</div>
				</p>
				<hr>
				<p><strong>Note that you'll need a "localizator.cfm" file in each environment you want to use with the plugin.</strong></p>
			</div>

			<dl>
				<dt>Datasource Name</dt>
				<dd>You need to specify the datasource name if you planned to use a database to store your translations. Otherwise the plugin use your default Wheels datasource (application.$wheels.dataSourceName).
					<ul>
						<li><u>dataSourceName="YourDataSourceName"</u></li>
					</ul>
				</dd>

				<dt>Localization table</dt>
				<dd>The default name of the localization table is... drum roll... "localizations". To use a different table name, just set it like this:
					<ul>
						<li><u>localizatorLanguageTable="MyTableName"</u></li>
					</ul>
				</dd>

				<dt>Default language</dt>
				<dd>The plugin use the default server Locale ID as the default language. You can use a different Locale ID by using this setting.
					<ul>
						<li><u>localizatorLanguageDefault="Locale ID"</u></li>
					</ul>
				</dd>

				<dt>Harvester</dt>
				<dd>To activate the "Harvester" during development/design mode, simply set it to TRUE (Default: False).
					<ul>
						<li><u>localizatorLanguageHarvest=true</u></li>
					</ul>
				</dd>

				<dt>Localization file(s)</dt>
				<dd>You can force the plugin to get translation from localization files instead of the database (Default: False).
					<ul>
						<li><u>localizatorGetLocalizationFromFile=true</u></li>
					</ul>
				</dd>

				<dt>Session variable</dt>
				<dd>The plugin can retrieve the language (Locale ID) from the session scope (e.g. from a user session). Enter the structure/key where the Locale ID is stored.
					<ul>
						<li><u>localizatorLanguageSession="currentuser.language"</u></li>
					</ul>
					<div class="alert alert-info alert-sm" style="text-align:center;">
						No need to specify "<strong><u>session.</u></strong>", the plugin will automatically go in the session scope.
					</div>
				</dd>
			</dl>

			<hr />
			
			<div class="alert alert-success" style="text-align:center; margin-bottom:0;">
				<p><span class="label label-success">Important</span> &nbsp;This plugin use the standard Java locale names (Locale ID).</p>
				<p><a href="http://docs.oracle.com/javase/1.4.2/docs/guide/intl/locale.doc.html" target="_blank">http://docs.oracle.com/javase/1.4.2/docs/guide/intl/locale.doc.html</a></p>
			</div>
		</div>
	</div>
</cfoutput>