﻿<cfoutput>
	<div class="#loc.config.settings.isDB NEQ true ? 'tab-pane active' : 'tab-pane'#" id="Files">
		<cfif isDefined("loc.config.settings.languages.locales") AND ListLen(loc.config.settings.languages.locales)>
			<div class="alert alert-success" style="margin-bottom:0; padding:10px 8px 0;">
				<h4>Localization #pluralize(word="file", count=ListLen(loc.config.settings.languages.locales), returnCount=false)# found!</h4>
				<ul>
					<li>#pluralize(word="Language", count=ListLen(loc.config.settings.languages.locales), returnCount=false)# configured:
						<ul>
							<cfloop list="#loc.config.settings.languages.locales#" index="loc.langue">
								<li>#GetLocaleDisplayName(loc.langue, getLocale())#</li>
							</cfloop>
						</ul>
					</li>
				</ul>
				<!--- <cfif loc.fromFile && isDefined("loc.localizations.texts") AND loc.localizations.texts.recordCount> --->
				<hr />
				<p>There is #pluralize(word="entry", count=loc.countFile)# in the repository file.</p>
				<div style="text-align:center;">
					<form action="#loc.config.url###todatabase" method="post">
						<input type="hidden" name="type" value="todatabase">
						<input type="submit" value="Add localizations to database" class="btn">
					</form>
				</div>
				<!--- </cfif> --->
			</div>
		<cfelse>
			<div class="alert alert-error" style="margin-bottom:0; padding:10px 8px 0;">
				<h4>Localization files <strong style="color:##F30;">not found</strong></h4>
				<ul>
					<li><span class="label label-success">New!</span> Use the form below to add/delete new languages. The plugin will create/delete the locales files for you!</li>
					<li style="list-style:none; text-align:center;"><strong>OR</strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</li>
					<li>Create "blank" .cfm pages named with the Locale ID (en_US.cfm, en_CA.cfm, fr_CA.cfm) in the locales folder.<br /> --> /plugins/localizator/locales/</li>
				</ul>
			</div>
		</cfif>
	</div>
</cfoutput>