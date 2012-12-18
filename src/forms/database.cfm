<cfoutput>
	<div class="span12">
		<h1>Editor (Database and localization files)</h1>
	</div>
	
	<div class="span6">
		<div class="well well-small" style="padding:20px 10px 0;">
			<!--- DATABASE FORM --->
			<form action="#loc.config.url###edit" method="post" name="formTextDB" class="form-horizontal">
				<cfif formTextDB.isNew()>
					<input type="hidden" name="type" value="new">
					<cfset txtButton = "Add">
				<cfelse>
					<input type="hidden" name="type" value="update">
					<input type="hidden" name="formTextDB[key]" value="#formTextDB.id#">
					<cfset txtButton = "Update">
				</cfif>
				<div class="control-group">
					<label class="control-label"><strong>Text</strong></label>
					<div class="controls">
						<cfif formTextDB.isNew()>
							<input type="text" name="formTextDB[text]" value="#isDefined('formTextDB.text') ? formTextDB.text : ''#" />
						<cfelse>
							<input type="hidden" name="formTextDB[text]" value="#isDefined('formTextDB.text') ? formTextDB.text : ''#">
							<input type="text" name="bogus" value="#isDefined('formTextDB.text') ? formTextDB.text : ''#" disabled />
						</cfif>
					</div>
				</div>
				<cfif isDefined("loc.config.languages.database")>
					<cfloop list="#loc.config.languages.database#" index="loc.language">
						<div class="control-group">
							<label class="control-label"><strong>#GetLocaleDisplayName(loc.language, getLocale())#</strong></label>
							<div class="controls">
								<input type="text" name="formTextDB[#loc.language#]" value="#isDefined('formTextDB.#loc.language#') ? formTextDB[loc.language] : ''#" />
							</div>
							<cfif loc.language EQ ListLast(loc.config.languages.database)>
								<div class="controls">
									<input type="submit" value="#txtButton#" class="btn" style="margin-top:20px;">
									<cfif !formTextDB.isNew()>
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