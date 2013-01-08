<cfoutput>
	<div class="span12">
		<h1>Editor (Database and localization files)</h1>
	</div>
	
	<div class="span6">
		<div class="well well-small" style="padding:20px 10px 0;">
			<!--- DATABASE FORM --->
			<form action="#loc.url###edit" method="post" name="localizationForm" class="form-horizontal">
				<cfif localizationForm.isNew()>
					<input type="hidden" name="type" value="add">
					<cfset txtButton = "Add">
				<cfelse>
					<input type="hidden" name="type" value="update">
					<input type="hidden" name="localizationForm[key]" value="#localizationForm.id#">
					<cfset txtButton = "Update">
				</cfif>
				<div class="control-group">
					<label class="control-label"><strong>Text</strong></label>
					<div class="controls">
						<cfif localizationForm.isNew()>
							<input type="text" name="localizationForm[text]" value="#isDefined('localizationForm.text') ? localizationForm.text : ''#" />
						<cfelse>
							<input type="hidden" name="localizationForm[text]" value="#isDefined('localizationForm.text') ? localizationForm.text : ''#">
							<input type="text" name="bogus" value="#isDefined('localizationForm.text') ? localizationForm.text : ''#" disabled />
						</cfif>
					</div>
				</div>
				<cfif ListLen("pluginSettings.languages.database")>
					<cfloop list="#pluginSettings.languages.database#" index="loc.language">
						<div class="control-group">
							<label class="control-label"><strong>#GetLocaleDisplayName(loc.language, getLocale())#</strong></label>
							<div class="controls">
								<input type="text" name="localizationForm[#loc.language#]" value="#isDefined('localizationForm.#loc.language#') ? localizationForm[loc.language] : ''#" />
							</div>
							<cfif loc.language EQ ListLast(pluginSettings.languages.database)>
								<div class="controls">
									<input type="submit" value="#txtButton#" class="btn" style="margin-top:20px;">
									<cfif !localizationForm.isNew()>
										<input type="button" value="Cancel" class="btn cancel" style="margin-top:20px;" />
									</cfif>
								</div>
							</cfif>
						</div>
					</cfloop>
				</cfif>
			</form>
		</div>
	</div>
	
	<cfinclude template="list.cfm">
</cfoutput>