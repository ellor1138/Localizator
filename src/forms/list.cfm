<cfoutput>
	<div class="span6">
		<cfif isDefined("loc.localizations.texts") AND loc.localizations.texts.recordCount>
			<table class="table table-bordered table-condensed">
				<thead>
					<tr>
						<th colspan="3" style="text-align:right;">
							<form action="#loc.config.url###edit" method="post" class="form-horizontal" style="margin:0; padding:0;">
								<div class="control-group" style="margin:0; padding:0;">
									<label class="control-label" style="text-align:left; font-weight:bold;">Filter by first letter</label>
									<div class="controls" style="margin:0; padding:0;">
										<select name="letter" class="span1">
											<option value="all">All</option>
											<cfloop query="loc.localizations.letters">
												<cfif loc.localizations.letters.firstLetter EQ params.letter>
													<option value="#loc.localizations.letters.firstLetter#" selected="selected">#loc.localizations.letters.firstLetter#</option>
												<cfelse>
													<option value="#loc.localizations.letters.firstLetter#">#loc.localizations.letters.firstLetter#</option>
												</cfif>
											</cfloop>
										</select>
										<input type="submit" value="Filter" class="btn">
									</div>
								</div>
							</form>
						</th>
					</tr>
				</thead>
				<tbody>
					<cfloop query="loc.localizations.texts">
						<cfif isDefined("params.editText") AND (isDefined("loc.localizations.texts.id") AND params.editText EQ loc.localizations.texts.id) OR (isDefined("params.editText") AND params.editText EQ loc.localizations.texts.text)>
							<cfset tr_class = "info">
						<cfelse>
							<cfset tr_class = "">
						</cfif>
						<tr class="#tr_class#">
							<td style="width:100%; vertical-align:middle;">#loc.localizations.texts.text#</td>
							<td style="text-align:center;">
								<cfset x = 0>
								<cfloop collection="#localizatorGetLanguages()#" item="localeid">
									<cfif Len(loc.localizations.texts["#localeid#"][currentrow])>
										<cfset x += 1>
									</cfif>
								</cfloop>
								<cfif x GT 1>
									<span class="label label-success"><i class="icon-white icon-ok"></i></span>
								<cfelse>
									<span class="label label-important"><i class="icon-white icon-remove"></i></span>
								</cfif>
							</td>
							<td style="text-align:center;">
								<form action="#loc.config.url###edit" method="post" style="margin:0; padding:0;">
									<cfif isDefined("loc.localizations.texts.id")>
										<input type="hidden" name="type" value="edit">
										<cfif isDefined("application.wheels.lobotProtectionIsEnabled") AND application.wheels.lobotProtectionIsEnabled>
											<input type="hidden" name="key" value="#lobotEncryptKey(loc.localizations.texts.id)#">
										<cfelse>
											<input type="hidden" name="key" value="#loc.localizations.texts.id#">
										</cfif>
									<cfelse>
										<input type="hidden" name="type" value="edit">
										<input type="hidden" name="text" value="#loc.localizations.texts.text#">
									</cfif>
									<input type="submit" value="Edit" class="btn btn-small">
								</form>
							</td>
							<td style="text-align:center;">
								<form action="#loc.config.url###edit" method="post" style="margin:0; padding:0;">
									<cfif isDefined("loc.localizations.texts.id")>
										<input type="hidden" name="type" value="delete">
										<cfif isDefined("application.wheels.lobotProtectionIsEnabled") AND application.wheels.lobotProtectionIsEnabled>
											<input type="hidden" name="key" value="#lobotEncryptKey(loc.localizations.texts.id)#">
										<cfelse>
											<input type="hidden" name="key" value="#loc.localizations.texts.id#">
										</cfif>
									<cfelse>
										<input type="hidden" name="type" value="delete">
										<input type="hidden" name="text" value="#loc.localizations.texts.text#">
									</cfif>
									<input type="submit" value="Delete" class="btn btn-small delete">
								</form>
							</td>
						</tr>
					</cfloop>
				</tbody>
			</table>
		<cfelse>
			<div class="alert alert-error" style="text-align:center;">
				<cfif loc.config.settings.isDB>
					There is no text in your localization table.
				<cfelse>
					There is no text in your localization files.
				</cfif>
			</div>
		</cfif>
	</div>
</cfoutput>