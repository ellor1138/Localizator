<cfoutput>
	<div class="span6">
		<cfif isDefined("loc.localizations") AND loc.localizations.recordCount>
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
											<cfloop query="loc.letters">
												<cfif loc.letters.firstLetter EQ FORM.letter>
													<option value="#loc.letters.firstLetter#" selected="selected">#loc.letters.firstLetter#</option>
												<cfelse>
													<option value="#loc.letters.firstLetter#">#loc.letters.firstLetter#</option>
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
					<cfloop query="loc.localizations">
						<cfif isDefined("params.editText") AND (isDefined("loc.localizations.id") AND params.editText EQ loc.localizations.id) OR (isDefined("params.editText") AND params.editText EQ loc.localizations.text)>
							<cfset tr_class = "info">
						<cfelse>
							<cfset tr_class = "">
						</cfif>
						<tr class="#tr_class#">
							<td style="width:100%; vertical-align:middle;">#loc.localizations.text#</td>
							<td style="text-align:center;">
								<form action="#loc.config.url###edit" method="post" style="margin:0; padding:0;">
									<cfif isDefined("loc.localizations.id")>
										<input type="hidden" name="editText" value="#loc.localizations.id#">
									<cfelse>
										<input type="hidden" name="editText" value="#loc.localizations.text#">
									</cfif>
									<input type="submit" value="Edit" class="btn">
								</form>
							</td>
							<td style="text-align:center;">
								<form action="#loc.config.url###edit" method="post" style="margin:0; padding:0;">
									<cfif isDefined("loc.localizations.id")>
										<input type="hidden" name="deleteText" value="#loc.localizations.id#">
									<cfelse>
										<input type="hidden" name="deleteText" value="#loc.localizations.text#">
									</cfif>
									<input type="submit" value="Delete" class="btn delete">
								</form>
							</td>
						</tr>
					</cfloop>
				</tbody>
			</table>
		<cfelse>
			<div class="alert alert-error" style="text-align:center;">
				<cfif isDefined("formTextDB")>
					There is no text in your localization table.
				<cfelseif isDefined("formTextFile")>
					There is no text in your localization files.
				</cfif>
			</div>
		</cfif>
	</div>
</cfoutput>