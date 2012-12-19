<cfoutput>
	<div class="tab-pane active" id="Database">
		
		<cfif loc.config.isDB>
			<div class="alert alert-success" style="margin-bottom:0; padding:10px 8px 0;">
				<h4>Datasource found!</h4>
				<ul>
					<li>#loc.config.dataSource#</li>
				</ul>
				<h4>Localization table found!</h4>
				<ul>
					<li>#get("localizatorLanguageTable")#</li>
					
					<cfif isDefined("loc.config.languages.database") AND ListLen(loc.config.languages.database)>
						<li>#pluralize(word="Language", count=ListLen(loc.config.languages.database), returnCount=false)# configured:
							<ul>
								<cfloop list="#loc.config.languages.database#" index="loc.langue">
									<li>#GetLocaleDisplayName(loc.langue, getLocale())#</li>
								</cfloop>
							</ul>
						</li>
					</cfif>
					
					<cfif isDefined("loc.localizations") AND loc.localizations.recordCount>
						<li>There is #pluralize(word="entry", count=loc.localizations.recordCount)# in the localizaton table</li>
					</cfif>
				</ul>
				
				<cfif isDefined("loc.localizations") AND loc.localizations.recordCount>
					<div style="text-align:center;">
						<form action="#loc.config.url###generate" method="post">
							<input type="hidden" name="generator" value="1">
							<input type="submit" value="Generate localization file(s)" class="btn">
						</form>
					</div>
				</cfif>
			</div>
			
		<cfelseif isDefined("loc.error.datasource")>
			<div class="alert alert-error" style="margin-bottom:0; padding:10px 8px 0;">
				<h4>Datasource <strong style="color:##F30;">not found</strong></h4>
				<ol>
					<li>Create a new datasource and add it to config/settings.cfm</li>
					<li>Reload your application.</li>
				</ol>
			</div>
		<cfelseif isDefined("loc.error.table")>
			<div class="alert alert-error" style="margin-bottom:0; padding:10px 8px 0;">
				<h4>Table <strong style="color:##F30;">not found</strong></h4>
				<ol>
					<li>Create a new table called "localizations" with these columns:
						<ul>
							<li>id (int Primary Key)</li>
							<li>text (VarChar(MAX))</li>
							<li>Your default language <em>en_US</em>, <em>en_CA</em> (VarChar(MAX)) or other Locale ID</li>
							<li>Other languages <em>en_CA</em>, <em>fr_CA</em> (VarChar(MAX)) or other Locale ID</li>
						</ul>
					</li>
					<li>Reload your application.</li>
				</ol>
				<div class="well well-small">
					<small>You can give any name to your table. Just set <abbr title='set(localizatorLanguageTable="YourTableName")'>localizatorLanguageTable</abbr> with your table name in your config/settings.cfm files.</small>
				</div>
			</div>
		</cfif>
		
	</div>
</cfoutput>