<cfsetting enablecfoutputonly="true">

<cfparam name="FORM.letter" default="all">

<cfoutput>

	<cfscript>
		loc = {};
		loc.plugin = {};
		loc.config = {};
		loc.error = {};
		loc.message = {};
		
		loc.plugin.author = "Simon Allard";
		loc.plugin.name = "localizator";
		loc.plugin.version = "1.0";
		loc.plugin.compatibility = "1.1.8";
		
		loc.config.isDB = "No";
		loc.config.dataSource = application.wheels.dataSourceName;
		loc.config.url = "#CGI.script_name#?controller=wheels&action=wheels&view=plugins&name=#loc.plugin.name#";
		
		// CHECK IF WE CAN CONNECT TO DATABASE
		try {
			loc.dataSource = new Query(datasource="#loc.config.dataSource#", sql="SELECT TOP 1 * FROM #get('localizatorLanguageTable')#").execute().getResult();
			loc.config.isDB = "Yes";
			formTextDB = model(get('localizatorLanguageTable')).new();
		} catch ( any e) {
			if ( Len(e.message) ) {
				if ( FindNoCase("Datasource", e.message) ) {
					loc.error.datasource = e.message;
				}
				if ( FindNoCase("Database", e.message) ) {
					loc.error.table = e.message;
				}
			}			
		}
		
		// GET LANGUAGES COLUMNS CONFIGURED IN LOCALIZATION TABLE
		if ( loc.config.isDB ) {
			loc.config.languages = "";
			for (loc.i = 1; loc.i <= ListLen(loc.dataSource.columnList); loc.i++) {
				if ( findOneOf("_", ListGetAt(loc.dataSource.columnList,loc.i)) ) {
					loc.config.languages = ListAppend(loc.config.languages, ListGetAt(loc.dataSource.columnList,loc.i));
				}
			}
		
		} else {
			loc.config.languages = getLocalizationLanguagesList();
		}
		
		// GENERATE LOCALIZATION FILES
		if ( loc.config.isDB && isDefined("params.generator") ) {
			loc.message.generator = generateLocalizationFiles();
		}

		// --> ADD
		if ( isDefined("params.type") && params.type == "new") {
			if ( loc.config.isDB ) {
				// ADD TEXT TO DATABASE
				if ( isDefined("params.formTextDB") && isDefined("params.formTextDB.text") && Len(params.formTextDB.text) ) {
					// CHECK IF TEXT IS ALREADY IN LOCALIZATION TABLE
					formTextDB = model(get('localizatorLanguageTable')).findAll(where="text='#params.formTextDB.text#'");
					
					if ( !formTextDB.recordCount ) {		
						// ADD TEXT TO LOCALIZATION TABLE			
						formTextDB = model(get('localizatorLanguageTable')).new(params.formTextDB);
						
						if ( formTextDB.save() ) {
							// ADD TEXT TO LOCALIZATION FILES
							loc.message.file = $addTextToFile(params.formTextDB);
							
							loc.message.type = "success";
							loc.message.formTextDB = "Text saved successfully";
							
							// RESET FORM
							formTextDB = model(get('localizatorLanguageTable')).new();
						
						} else {
							loc.message.type = "error";
							loc.message.formTextDB = "An error occured while saving";
						}
						
					} else {
						formTextDB = model(get('localizatorLanguageTable')).new();
						loc.message.type = "error";
						loc.message.formTextDB = "<i>#params.formTextDB.text#</i> <-- is already configured";
					}
					
				} else {
					loc.message.type = "error";
					loc.message.formTextDB = "Text is mandatory";
				}
			
			// ADD TEXT TO LOCALIZATION FILES
			} else if ( isDefined("params.formTextFile") && isDefined("params.formTextFile.text") && Len(params.formTextFile.text) ) {
				loc.formTextFile = $addTextToFile(params.formTextFile);
				
				if ( isDefined("loc.formTextFile.found") ) {
					loc.message.type = "error";
					loc.message.formTextFile = "<strong><u>#loc.formTextFile.text#</u></strong> already in your localizations files";
				} else {
					loc.message.type = "success";
					loc.message.formTextFile = "<strong><u>#loc.formTextFile.text#</u></strong> added to your localizations files successfully";
				}
				
			}
			
		}
		
		// --> EDIT
		if ( loc.config.isDB ) {
			if ( isDefined("params.editText") && Len(params.editText) && isNumeric(params.editText) ) {
				// EDIT LOCALIZATION TEXT
				formTextDB = model(get('localizatorLanguageTable')).findByKey(key=params.editText);
			}
			
		} else {
			// EDIT LOCALIZATION TEXT
			if ( isDefined("params.editText") && Len(params.editText) ) {
				formTextFile = getTextsFromFile(params.editText);
				formTextFile.update = true;
			}
		}
		
		
		// --> UPDATE
		if ( loc.config.isDB ) {
			if ( isDefined("params.type") && params.type == "update") {
				// UPDATE TEXT
				if ( isDefined("params.formTextDB.key") && Len(params.formTextDB.key) ) {
					// GET TEXT FROM LOCALIZATION TABLE
					formTextDB = model(get('localizatorLanguageTable')).findByKey(params.formTextDB.key);
					// UPDATE TEXT IN LOCALIZATION TABLE
					if ( formTextDB.update(params.formTextDB) ) {
						// UPDATE LOCALIZATION FILES
						loc.message.formTextDB = updateLocalizationFiles(params.formTextDB, "update");
						
						loc.message.type = "success";
						//loc.message.formTextDB = "Text updated successfully";
					
					} else {
						loc.message.type = "error";
						loc.message.formTextDB = "An error occured while updating text";
					}				
				}
			}
			
		} else if ( isDefined("params.type") && params.type == "update") {
			loc.message.type = "success";
			loc.message.formTextFile = updateLocalizationFiles(params.formTextFile, "update");
		}
		
		// --> DELETE
		if ( loc.config.isDB ) {
			// DELETE LOCALIZED TEXT
			if ( isDefined("params.deleteText") ) {
				// GET TEXT FROM DATABASE
				loc.obj = model(get('localizatorLanguageTable')).findByKey(params.deleteText);
				if ( isObject(loc.obj) ) {
					// DELETE FROM DATABASE
					if ( loc.obj.delete() ) {
						// DELETE FROM REPOSITORY AND LOCALIZATION FILES
						loc.message.formTextDB = updateLocalizationFiles(loc.obj, "delete");
						
						loc.message.type = "success";
						loc.message.delete = "Text deleted successfully";
					
					} else {
						loc.message.type = "error";
						loc.message.delete = "An error occured while deleting the text";
					}
					
				} else {
					loc.message.type = "error";
					loc.message.delete = "An error occured while deleting the text";
				}
			}
		
		// DELETE FROM REPOSITORY AND LOCALIZATION FILES
		} else {
			if ( isDefined("params.deleteText") ) {
				params.languages = getLocalizationLanguagesList();
				
				loc.formTextFile = {};
				loc.formTextFile.text = params.deleteText;

				for (loc.i = 1; loc.i <= ListLen(params.languages); loc.i++) {
					loc.formTextFile[ListGetAt(params.languages, loc.i)] = "";
				}
				
				loc.message.type = "success";
				loc.message.formTextFile = updateLocalizationFiles(loc.formTextFile, "delete");
			}
		}
		
		// --> GET
		if ( loc.config.isDB ) {
			// GET LOCALIZED TEXTS
			if ( isDefined("FORM.letter") AND FORM.letter NEQ "all" ) {
				loc.localizations = model(get('localizatorLanguageTable')).findAll(select="*, Left(UPPER(text), 1) as firstLetter", where="text LIKE '#FORM.letter#%'", order="text ASC");
			
			} else {
				loc.localizations = model(get('localizatorLanguageTable')).findAll(select="*, Left(UPPER(text), 1) as firstLetter", order="text ASC");	
			}
			
			// GET ALL FIRSTLETTERS FROM LOCALIZED TEXTS
			loc.letters = model(get('localizatorLanguageTable')).findAll(select="Left(UPPER(text), 1) as firstLetter", order="text ASC");
			
			// GET DISTINCT FIRSTLETTERS FROM LOCALIZED TEXTS
			loc.query = new query();
			loc.query.setAttributes(
				dbtype="query",
				QoQ=loc.letters,
				SQL="SELECT DISTINCT firstLetter FROM QoQ"
			);
			
			loc.query = loc.query.execute();
			loc.letters = loc.query.getResult();
		
		} else {
			
			if ( isDefined("FORM.letter") AND FORM.letter NEQ "all" ) {
				loc.localizations = getLocalizationsFromRepository(FORM.letter);
				
				// GET DISTINCT FIRSTLETTERS FROM LOCALIZED TEXTS
				loc.query = new query();
				loc.query.setAttributes(
					dbtype="query",
					QoQ=loc.localizations,
					SQL="SELECT DISTINCT firstLetter FROM QoQ ORDER BY firstLetter ASC"
				);
				
				loc.query = loc.query.execute();
				loc.letters = loc.query.getResult();
				
				loc.query = new query();
				loc.query.setAttributes(
					dbtype="query",
					QoQ=loc.localizations,
					SQL="SELECT * FROM QoQ WHERE firstLetter = '#FORM.letter#' ORDER BY firstLetter ASC"
				);
			
				loc.query = loc.query.execute();
				loc.localizations = loc.query.getResult();
			
			} else {
				loc.localizations = getLocalizationsFromRepository();
				
				// REORDER QUERY
				loc.query = new query();
				loc.query.setAttributes(
					dbtype="query",
					QoQ=loc.localizations,
					SQL="SELECT * FROM QoQ ORDER BY firstLetter ASC"
				);
			
				loc.query = loc.query.execute();
				loc.localizations = loc.query.getResult();
				
				// GET DISTINCT FIRSTLETTERS FROM LOCALIZED TEXTS
				loc.query = new query();
				loc.query.setAttributes(
					dbtype="query",
					QoQ=loc.localizations,
					SQL="SELECT DISTINCT firstLetter FROM QoQ ORDER BY firstLetter ASC"
				);
				
				loc.query = loc.query.execute();
				loc.letters = loc.query.getResult();
			}
			
			
			if ( !isDefined("params.editText") ) {
				formTextFile = {};
			}
			
		}
		
	</cfscript>

	<cfinclude template="layout.cfm" />

</cfoutput>
