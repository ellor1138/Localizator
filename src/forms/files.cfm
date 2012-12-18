<cfoutput>
	<div class="span12">
		<h1>Editor (Localization files)</h1>
	</div>
	
	<div class="span6">
		<div class="well well-small" style="padding:20px 10px 0;">
			<form action="#loc.config.url###edit" method="post" name="formTextFile" class="form-horizontal">
				<cfif isDefined("formTextFile.update")>
					<input type="hidden" name="type" value="update">
					<cfset txtButton = "Update">
				<cfelse>
					<input type="hidden" name="type" value="new">
					<cfset txtButton = "Add">
				</cfif>
				<div class="control-group">
					<label class="control-label"><strong>Text</strong></label>
					<div class="controls">
						<cfif isDefined("formTextFile.update")>
							<input type="hidden" name="formTextFile[text]" value="#isDefined('formTextFile.text') ? formTextFile.text : ''#">
							<input type="text" name="bogus" value="#isDefined('formTextFile.text') ? formTextFile.text : ''#" disabled />
						<cfelse>
							<input type="text" name="formTextFile[text]" value="#isDefined('formTextFile.text') ? formTextFile.text : ''#" />
						</cfif>
					</div>
				</div>
				<cfif isDefined("loc.config.languages.files")>
					<cfloop list="#loc.config.languages.files#" index="loc.language">
						<div class="control-group">
							<label class="control-label"><strong>#GetLocaleDisplayName(loc.language, getLocale())#</strong></label>
							<div class="controls">
								<input type="text" name="formTextFile[#loc.language#]" value="#isDefined('formTextFile.#loc.language#') ? formTextFile[loc.language] : ''#" />
							</div>
							<cfif loc.language EQ ListLast(loc.config.languages.files)>
								<div class="controls">
									<input type="submit" value="#txtButton#" class="btn" style="margin-top:20px;">
									<cfif isDefined("formTextFile.update")>
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
	</div>
	
	<cfinclude template="list.cfm">
</cfoutput>