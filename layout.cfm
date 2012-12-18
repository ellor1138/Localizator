
	<!DOCTYPE html>
	<!--[if lt IE 7]><html class="no-js lt-ie9 lt-ie8 lt-ie7"><![endif]-->
	<!--[if IE 7]><html class="no-js lt-ie9 lt-ie8"><![endif]-->
	<!--[if IE 8]><html class="no-js lt-ie9"><![endif]-->
	<!--[if gt IE 8]><!-->
	<html class="no-js">
	<!--<![endif]-->
	<head>
	
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		
		<title><cfoutput>#capitalize(loc.plugin.name)# #loc.plugin.version#</cfoutput></title>
		
		<meta name="description" content="">
		<meta name="viewport" content="width=device-width">
		
		<script src="//ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
		<script src="//netdna.bootstrapcdn.com/twitter-bootstrap/2.2.1/js/bootstrap.min.js"></script>
		
		<link href="//netdna.bootstrapcdn.com/twitter-bootstrap/2.2.1/css/bootstrap.min.css" rel="stylesheet">
		
		<style>
			a.no-link:link, 
			a.no-link:active, 
			a.no-link:visited, 
			a.no-link:hover,
			.btn a.no-link:link, 
			.btn a.no-link:active, 
			.btn a.no-link:visited, 
			.btn a.no-link:hover {text-decoration:none !important; background:none !important; color:#333 !important;}
			#wrapper {border:none;}
			.hero-unit {margin-bottom:10px; padding:20px;}
			.hero-unit h2, .container h2 {margin: 0 !important; padding:0 !important; line-height:16px;}
			.hero-unit p {margin:0 0 10px 0 !important; padding:0;}
			.hero-unit ul.small li {font-size:14px; line-height:24px;}
			.container a:link, .container a:active, .container a:visited, .container a:hover {background:none !important; color:#B00701 !important;}
			#maintabs {margin:0 !important;}
			#maintabs li a:link, 
			#maintabs li a:active, 
			#maintabs li a:visited, 
			#maintabs li a:hover,
			.alert a:link,
			.alert a:active,
			.alert a:visited,
			.alert a:hover {text-decoration:none !important; color:#333 !important; padding:5px 8px; border-bottom:0;}
			.alert.alert-info a:link {color:#066da0 !important; text-decoration:underline !important;}
			.alert.alert-info a:hover { text-decoration:none !important;}
			#maintabs li.active a:link, 
			#maintabs li.active a:active, 
			#maintabs li.active a:visited, 
			#maintabs li.active a:hover {border-bottom:1px solid #fff;}
			#maincontent {border:1px solid #dedede; border-top:none; padding:10px;}
			.tab-pane ul li {line-height:16px; margin-bottom:12px;}
			.tab-pane ul li ul li {line-height:16px; margin-bottom:4px;}
			.tab-pane dl dt, .tab-pane dl dd {margin-bottom:4px;}
			.tab-pane dl dd ul {margin:2px 0 0 20px !important;}
			.tab-pane dl dd ul li {line-height:16px;}
		</style>
		
		<script language="javascript">
			$(function() {
				$('.delete').click(function(){
					if ( confirm("Are you sure want to delete this text?") ) {
						return true;
					} else {
						return false;
					}
				});
				
				$('.cancel').click(function(){
					window.location.reload();	
				});
			});
		</script>
	</head>
	
	<body>
		<!--[if lt IE 7]>
			<p class="chromeframe">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade your browser</a> or <a href="http://www.google.com/chromeframe/?redirect=true">activate Google Chrome Frame</a> to improve your experience.</p>
		<![endif]-->
		
		<cfoutput>

			<div class="container"> 
				
				<!-- Main hero unit for a primary marketing message or call to action -->
				<div class="hero-unit">
					<h1>#capitalize(loc.plugin.name)# #loc.plugin.version#</h1>
					<p>This plugin offer a complete solution to add localization capabilities to your application.</p>
					<h2>Benefits of using this plugin:</h2>
					<ul class="small">
						<li>Get text translation from a localization database or localization files.</li>
						<li>Populate your localization database or localization files by "harvesting" the text of your application.</li>
						<li>Use the editor to add translation to your localization database and localization files.</li>
						<li>Generate localization files from your localization database.</li>
					</ul>
				</div>
				
				<!-- Example row of columns -->
				
				<div class="row">
					<a id="generate"></a>
					<div class="span12">
						<h1>Plugin usage</h1>
					</div>
					<div class="span8">
						<ul class="nav nav-tabs" id="maintabs">
							<li class="active"><a href="##Settings" data-toggle="tab">Settings</a></li>
							<li><a href="##Translator" data-toggle="tab">Translator</a></li>
							<li><a href="##Harvester" data-toggle="tab">Harvester</a></li>
							<li><a href="##Editor" data-toggle="tab">Editor</a></li>
							<li><a href="##Generator" data-toggle="tab">Generator</a></li>
							<li><a href="##Log" data-toggle="tab">Change Log</a></li>
							<li><a href="##Credits" data-toggle="tab">Credits</a></li>
						</ul>
						
						<div class="tab-content" id="maincontent">
							<div class="tab-pane active" id="Settings">
								<div class="alert">
									<span class="label label-warning">Important</span> &nbsp;&nbsp;All the plugin settings should be place in config/settings.cfm files.
								</div>
								<dl>
									<dt>Default language</dt>
									<dd>The plugin use the default server Locale ID as the default language. You can use a different Locale ID by using this setting.
										<ul>
											<li><u>set(localizatorLanguageDefault="Locale ID")</u></li>
										</ul>
									</dd>
									<dt>Session variable</dt>
									<dd>The plugin can retrieve the language (Locale ID) from the session scope (e.g. from a user session). Just set the structure/key where the plugin should go check for the Locale ID.
										<ul>
											<li><u>set(localizatorLanguageSession="currentuser.language")</u></li>
										</ul>
									</dd>
									<dt>Harvester</dt>
									<dd>To activate the "Harvester" during development/design mode, simply set it to TRUE.
										<ul>
											<li><u>set(localizatorLanguageHarvest=true)</u></li>
										</ul>
									</dd>
									<dt>Localization table</dt>
									<dd>The default name of the localization table is... drum roll... "localizations". To use a different table name, just set it like this:
										<ul>
											<li><u>set(localizatorLanguageTable="MyTableName")</u></li>
										</ul>
									</dd>
								</dl>
								<hr />
								<div class="well well-small" style="text-align:center; margin-bottom:0;">
									<span class="label label-inverse">Important</span> &nbsp;&nbsp;This plugin use the standard Java locale names (Locale ID). <a href="http://docs.oracle.com/javase/1.4.2/docs/guide/intl/locale.doc.html" target="_blank">http://docs.oracle.com/javase/1.4.2/docs/guide/intl/locale.doc.html</a>
								</div>
							</div>
							<div class="tab-pane" id="Translator">
								<ul>
									<li>Pass in the text you wish to translate in the "<strong>localizeme</strong>" or&nbsp;"<strong>l</strong>" function.
										<ul>
											<li>##localizeme("Thi is a static string")##</li>
											<li>##l("Thi is a dynamic string {##LsDateFormat(Now())##}")##</li>
											<li>If no translation is found, the original text is return.</li>
										</ul>
									</li>
									
									<li>For dynamic text, simply pass the variable in curly bracket.
										<ul>
											<li>##localizeme("Hi {##user.fullname##},")##</li>
											<li>##l("Next appointment is {##LSDateFormat(appointment.date))##}")##</li>
										</ul>
									</li>

									<li>You can specify the language you want by passing the Locale ID with the "<strong>localizeme</strong>" or&nbsp;"<strong>l</strong>" function.
										<ul>
											<li>##localizeme("This string will be transalted in French (Canadian)", "fr_CA")##</li>
											<li>##l("This string will be transalted in Icelandic (Iceland)", "is_IS")##</li>
										</ul>
									</li>
									
									<li>If no language is passed via the "<strong>localizeme</strong>" or&nbsp;"<strong>l</strong>" function, the plugin will:
										<ol>
											<li>check for a Locale ID in the session scope (e.g. a user session).</li>
											<li>or get the default Locale ID.</li>
										</ol>
									</li>
									<li>If no translation is found, the original text is return.</li>
								</ul>
							</div>
							
							<div class="tab-pane" id="Harvester">
								<ul>
									<li>The "Harvester" only work in design/development mode.</li>
									<li>The plugin will grab the text passed by the "<strong>localizeme</strong>" or "<strong>l</strong>" function.</li>
									<li>When you execute the code the plugin will:
										<ol>
											<li>Save the text to your database.<br />Be sure to configure your localization table with at least these columns:
												<ul>
													<li><em>id</em> (int Primary Key).</li>
													<li><em>text</em> (VarChar(MAX)).</li>
													<li>Your default language <em>en_US</em>, <em>en_CA</em> (VarChar(MAX)) or other Locale ID.</li>
												</ul>
											</li>
											<li>Fill the main repository.cfm file.<br />--> /plugins/localizator/repository/repository.cfm</li>
											<li>Fill the default language file, based on the default language you have configured. The file will be named with the Locale ID (en_US.cfm, en_CA.cfm, fr_CA.cfm). <br />--> /plugins/localizator/locales/en_US.cfm</li>
											<li>Fill all localization files you have created in the locales folder. <br />--> /plugins/localizator/locales/
												<ul>
													<li>You can add any number of localization files. Create "blank" .cfm pages named with the Locale ID (en_US.cfm, en_CA.cfm, fr_CA.cfm) in the locales folder.</li>
												</ul>
											</li>
										</ol>
									</li>
									<li>The plugin prevent duplicate entries.</li>
									<li>Once you have finished harvesting your site, open the localization files and put your transaltion in.</li>
								</ul>
							</div>
							
							<div class="tab-pane" id="Editor">
								<ul>
									<li>The editor let you enter text with their translation.</li>
									<li>You can add dynamic content in your text by adding "{variable}" as a placeholder.
										<dl class="well well-small" style="display:inline-block; margin-bottom:0;">
											<dt>In your database or localization files, this text entry:</dt>
											<dd>Hi {variable}!</dd>
											<dt>Once used with the plugin function:</dt>
											<dd>##localizeme("Hi {##user.firstname##}!", "fr_CA")##</dd>
											<dt>Will result in this:</dt>
											<dd>Bonjour Bob!</dd>
										</dl>
									</li>
									<li>The text is saved to your database and/or localization files.</li>
									<li>You can edit, update and delete text entries. This will update your database and your localization files.</li>
								</ul>
								<ul>
									<li>To use the editor with a database:
										<ul>
											<li>Configure your localization table with at least these columns:
												<ul>
													<li><em>id</em> (int Primary Key).</li>
													<li><em>text</em> (VarChar(MAX)).</li>
													<li>Your default language <em>en_US</em>, <em>en_CA</em> (VarChar(MAX)) or other Locale ID.</li>
												</ul>
											</li>
											<li>To add form fields for other languages, simply add new columns, named with the Locale ID, <em>en_US</em>, <em>en_CA</em>, <em>fr_CA</em> (VarChar(MAX)) or other Locale ID, to your localization table.</li>
										</ul>
									</li>
									<li>To use the editor with localizations files:
									<ul>
										<li>Create "blank" .cfm pages named with the Locale ID (<em>en_US</em>.cfm, <em>en_CA</em>.cfm, <em>fr_CA</em>.cfm) in the locales folder. <br />--> /plugins/localizator/locales/</li>
										<li>To add form fields for other languages, create other "blank" .cfm pages  named with the Locale ID (<em>en_US</em>.cfm, <em>en_CA</em>.cfm, <em>fr_CA</em>.cfm) in the locales folder. <br />--> /plugins/localizator/locales/</li>
									</ul>
								</ul>
							</div>
							
							<div class="tab-pane" id="Generator">
								<ul>
									<li>You can generate your localizations files from the data of your localization table.
										<ul>
											<li>The localization files will be saved in the locales folder.<br />--> /plugins/localizator/locales/</li>
											<li>A new repository file will also be created in the repository folder.<br />--> /plugins/localizator/repository/</li>
											<li>Be aware that the previous repository and localization files will be overwritten.</li>
										</ul>
									</li>
								</ul>
								<hr />
								<div class="well well-small" style="text-align:center; margin-bottom:0;">
									<span class="label label-inverse">Important</span> &nbsp;&nbsp;The generator is only available if you have setup a datasource and a localization table.
								</div>
							</div>
							
							<div class="tab-pane" id="Log">
								<dl class="dl-horizontal">
									<dt>Version 1.0</dt>
									<dd>December 2012
										<ul>
											<li>First commit</li>
										</ul>
									</dd>
								</dl>
							</div>

							<div class="tab-pane" id="Credits">
								<dl class="dl-horizontal">
									<dt>Author</dt>
									<dd>#loc.plugin.author#</dd>
									<dt>Plugin name</dt>
									<dd>#capitalize(loc.plugin.name)#</dd>
									<dt>Plugin version</dt>
									<dd>#loc.plugin.version#</dd>
									<dt>Wheels compatibility</dt>
									<dd>#loc.plugin.compatibility#</dd>
									<dt>Release date</dt>
									<dd>December 2012</dd>
									<dt>Project home</dt>
									<dd><a href="http://github.com/ellor1138/Localizator" target="_blank">http://github.com/ellor1138/Localizator</a></dd>
									<dt>Find any bugs?</dt>
									<dd>You can file an issue here:<br /><a href="https://github.com/ellor1138/Aquanote/issues" target="_blank">https://github.com/ellor1138/Localizator/issues</a></dd>
									<dt>License</dt>
									<dd>#capitalize(loc.plugin.name)# is licensed under the Apache License, Version 2.0.<br /><a href="http://www.apache.org/licenses/LICENSE-2.0" target="_blank">http://www.apache.org/licenses/LICENSE-2.0</a></dd>
								</dl>
								<div class="alert alert-info" style="margin-bottom:0;">Largely inspired by Raúl Riera's Localizer plugin. <a href="http://github.com/raulriera/Localizer" target="_blank">http://github.com/raulriera/Localizer</a></div>
							</div>
														
						</div>
						
					</div>
					
					<div class="span4" style="margin-top:30px;">
						<cfif loc.config.isDB>
							<cfif isDefined("loc.message.generator")>
								<div class="alert alert-success" style="text-align:center; padding:10px 0;"><strong>#loc.message.generator#</strong></div>
							</cfif>
							<div class="alert alert-success" style="padding:10px 8px 0;">
								<h4>Datasource status</h4>
								<ul>
									<li>Datasource found (<strong style="color:##090;">#loc.config.dataSource#</strong>)</li>
									<li>Localization table found (<strong style="color:##090;">#get("localizatorLanguageTable")#</strong>)</li>
									<cfif isDefined("loc.config.languages") AND ListLen(loc.config.languages)>
										<li>#pluralize(word="Language", count=ListLen(loc.config.languages), returnCount=false)# configured:
											<ul>
												<cfloop list="#loc.config.languages#" index="loc.langue">
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
											<input type="submit" value="Generate localization files" class="btn">
										</form>
									</div>
								</cfif>
							</div>
						<cfelseif isDefined("loc.error.datasource")>
							<div class="alert alert-error" style="padding:10px 8px 0;">
								<h4>Datasource <strong style="color:##F30;">not found</strong></h4>
								<ol>
									<li>Create a new datasource and add it to config/settings.cfm</li>
									<li>Reload your application.</li>
								</ol>
							</div>
						<cfelseif isDefined("loc.error.table")>
							<div class="alert alert-error" style="padding:10px 8px 0;">
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
									<small>You can give any name to your table. Just set <abbr title='set(localizatorLanguageTable="YourTableName")'>localizatorLanguageTable</abbr> with your table name in your config/settings.cfm</small>
								</div>
							</div>
						</cfif>
					</div>
				</div>
				
				<a id="edit"></a>
				<div class="row">
					<div class="span12">
						<cfif isDefined("formTextDB")>
							<h1>Editor (Database and localization files)</h1>
							<cfelseif isDefined("formTextFile")>
							<h1>Editor (Localization files)</h1>
						</cfif>
					</div>

					<div class="span6">
						<cfif isDefined("loc.message.formTextDB")>
							<div class="alert alert-#loc.message.type#" style="text-align:center;">
								#loc.message.formTextDB#
							</div>
						</cfif>
						<cfif isDefined("loc.message.formTextFile")>
							<div class="alert alert-#loc.message.type#" style="text-align:center;">
								#loc.message.formTextFile#
							</div>
						</cfif>
						<div class="well well-small" style="padding:20px 10px 0;">
							<cfif isDefined("formTextDB")>
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
									<cfif isDefined("loc.config.languages")>
										<cfloop list="#loc.config.languages#" index="loc.language">
											<div class="control-group">
												<label class="control-label"><strong>#GetLocaleDisplayName(loc.language, getLocale())#</strong></label>
												<div class="controls">
													<input type="text" name="formTextDB[#loc.language#]" value="#isDefined('formTextDB.#loc.language#') ? formTextDB[loc.language] : ''#" />
												</div>
												<cfif loc.language EQ ListLast(loc.config.languages)>
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
							</cfif>
							<cfif isDefined("formTextFile")>
								<!--- FORM IF NO DATABASE/TABLE FOUND (POPULATE LOCALIZATION FILES) --->
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
									<cfif isDefined("loc.config.languages")>
										<cfloop list="#loc.config.languages#" index="loc.language">
											<div class="control-group">
												<label class="control-label"><strong>#GetLocaleDisplayName(loc.language, getLocale())#</strong></label>
												<div class="controls">
													<input type="text" name="formTextFile[#loc.language#]" value="#isDefined('formTextFile.#loc.language#') ? formTextFile[loc.language] : ''#" />
												</div>
												
												<cfif loc.language EQ ListLast(loc.config.languages)>
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
							</cfif>
						</div>
					</div>
					
					<div class="span6">
						<cfif isDefined("loc.message.delete")>
							<div class="alert alert-#loc.message.type#" style="text-align:center;">
								#loc.message.delete#
							</div>
						</cfif>
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
							<div class="alert" style="text-align:center;">
								<cfif isDefined("formTextDB")>
									There is no text in your localization table.
								<cfelseif isDefined("formTextFile")>
									There is no text in your localization files.
								</cfif>
							</div>
						</cfif>
					</div>
				</div>
			</div>
			
		</cfoutput>
		
		<!-- /container -->
	
	</body>
	
</html>