<cfoutput>
	<div class="#pluginSettings.isDB NEQ true ? 'tab-pane active' : 'tab-pane'#" id="Files">
		<cfif isDefined("pluginSettings.languages.locales") AND ListLen(pluginSettings.languages.locales)>
			<div class="alert alert-success" style="margin-bottom:0; padding:10px 8px 0;">
				<h4>Localization #pluralize(word="file", count=ListLen(pluginSettings.languages.locales), returnCount=false)# found!</h4>
				<ul>
					<li>#pluralize(word="Language", count=ListLen(pluginSettings.languages.locales), returnCount=false)# configured:
						<ul>
							<cfloop list="#pluginSettings.languages.locales#" index="loc.langue">
								<li>#GetLocaleDisplayName(loc.langue, getLocale())#</li>
							</cfloop>
						</ul>
					</li>
				</ul>
				<cfif !pluginSettings.isDB AND isDefined("loc.localizations.texts") AND loc.localizations.texts.recordCount>
					<hr />
					<p>There is #pluralize(word="entry", count=loc.localizations.texts.recordCount)# in the repository file.</p>
				</cfif>
			</div>
		<cfelse>
			<div class="alert alert-error" style="margin-bottom:0; padding:10px 8px 0;">
				<h4>Localization files <strong style="color:##F30;">not found</strong></h4>
				<ul>
					<li>Create "blank" .cfm pages named with the Locale ID (en_US.cfm, en_CA.cfm, fr_CA.cfm) in the locales folder.<br /> --> /plugins/localizator/locales/</li>
				</ul>
			</div>
		</cfif>
	</div>
</cfoutput>