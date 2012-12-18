<cfoutput>
	<div class="tab-pane" id="Files">
		<cfif isDefined("loc.config.languages.files") AND ListLen(loc.config.languages.files)>
			<div class="alert alert-success" style="margin-bottom:0; padding:10px 8px 0;">
				<h4>Localization #pluralize(word="file", count=ListLen(loc.config.languages.files), returnCount=false)# found!</h4>
				<ul>
					<li>#pluralize(word="Language", count=ListLen(loc.config.languages.files), returnCount=false)# configured:
						<ul>
							<cfloop list="#loc.config.languages.files#" index="loc.langue">
								<li>#GetLocaleDisplayName(loc.langue, getLocale())#</li>
							</cfloop>
						</ul>
					</li>
					<cfif isDefined("loc.localizations") AND loc.localizations.recordCount AND !loc.config.isDB>
						<li>There is #pluralize(word="entry", count=loc.localizations.recordCount)# in the localizaton #pluralize(word="file", count=ListLen(loc.config.languages.files), returnCount=false)#</li>
					</cfif>
				</ul>
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