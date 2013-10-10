<cfoutput>
	<div class="span12">
		<h1>Editor (Localization files only)</h1>
	</div>
	
	<div class="span6">
		<div class="well well-small" style="padding:20px 10px 0;">
			<form action="#loc.config.url###edit" method="post" name="localizationForm" class="form-horizontal">
				<cfif isDefined("localizationForm.update")>
					<input type="hidden" name="type" value="update">
					<cfset txtButton = "Update">
				<cfelse>
					<input type="hidden" name="type" value="add">
					<cfset txtButton = "Add">
				</cfif>
				<div class="control-group">
					<label class="control-label"><strong>Text</strong></label>
					<div class="controls">
						<cfif isDefined("localizationForm.update")>
							<input type="hidden" name="localizationForm[text]" value="#isDefined('localizationForm.text') ? localizationForm.text : ''#">
							<input type="text" name="bogus" value="#isDefined('localizationForm.text') ? localizationForm.text : ''#" disabled />
						<cfelse>
							<input type="text" name="localizationForm[text]" value="#isDefined('localizationForm.text') ? localizationForm.text : ''#" />
						</cfif>
					</div>
				</div>
				<cfif ListLen("loc.config.settings.languages.locales")>
					<cfloop list="#loc.config.settings.languages.locales#" index="loc.language">
						<div class="control-group">
							<label class="control-label"><strong>#GetLocaleDisplayName(loc.language, getLocale())#</strong></label>
							<div class="controls">
								<input type="text" name="loc.config.settings.languages.locales" value="#isDefined('localizationForm.#loc.language#') ? localizationForm[loc.language] : ''#" />
							</div>
							<cfif loc.language EQ ListLast(loc.config.settings.languages.locales)>
								<div class="controls">
									<input type="submit" value="#txtButton#" class="btn" style="margin-top:20px;">
									<cfif isDefined("localizationForm.update")>
										<input type="button" value="Cancel" class="btn cancel" style="margin-top:20px;" />
									</cfif>
								</div>
							</cfif>
						</div>
					</cfloop>
				<cfelse>
					<div class="controls">
						<input type="submit" value="#txtButton#" class="btn">
					</div>
				</cfif>
			</form>
		</div>
		<cfinclude template="languages.cfm">
	</div>
	
	<cfinclude template="list.cfm">
</cfoutput>