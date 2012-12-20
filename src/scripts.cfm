<cfoutput>

	<cfscript>
		loc = {};
		loc.plugin = {};
		loc.config = {};
		loc.error = {};
		loc.message = {};
		
		loc.plugin.author = "Simon Allard";
		loc.plugin.name = "localizator";
		loc.plugin.version = "1.3";
		loc.plugin.compatibility = "1.1.8";
		
		loc.config.isDB = "No";
		loc.config.dataSource = application.wheels.dataSourceName;
		loc.config.url = "#CGI.script_name#?controller=wheels&action=wheels&view=plugins&name=#loc.plugin.name#";
		
		loc.config.languages = {};
		
		// CHECK IF WE CAN CONNECT TO DATABASE & LOCALIZATION TABLE
		loc.config.db = isDatabaseAvailable();
		loc.config.dbTable = isDatabaseTableAvailable(loc.config.db);
		
		if ( loc.config.db && loc.config.dbTable ) {
			loc.config.isDB = "Yes";
			loc.config.languages.database = "";
			
			formTextDB = model(get('localizatorLanguageTable')).new();
			
			// GET LANGUAGES COLUMNS CONFIGURED IN LOCALIZATION TABLE
			loc.columnList = new dbinfo(datasource=get("dataSourceName"), table=get('localizatorLanguageTable')).columns();
			loc.columnList = ValueList(loc.columnList.column_name);
			
			for (loc.i = 1; loc.i <= ListLen(loc.columnList); loc.i++) {
				if ( isValidLocale(ListGetAt(loc.columnList,loc.i)) ) {
					loc.config.languages.database = ListAppend(loc.config.languages.database, ListGetAt(loc.columnList,loc.i));
				}
			}
		}
		
		// GET LANGUAGES FROM LOCALIZATION FILES
		loc.config.languages.files = getLocalizationLanguagesList();
		
		// GENERATE LOCALIZATION FILES
		if ( loc.config.isDB && isDefined("params.generator") ) {
			loc.message.generator = generateLocalizationFiles();
		}
		
		//  --------------------------------------------------------------------------------------
		//	DATABASE
		//  --------------------------------------------------------------------------------------
		if ( loc.config.isDB ) {
			// ADD
			if ( isDefined("params.type") && params.type == "new") {
				// ADD TEXT TO DATABASE
				if ( isDefined("params.formTextDB") && isDefined("params.formTextDB.text") && Len(params.formTextDB.text) ) {
					// CHECK IF TEXT IS ALREADY IN LOCALIZATION TABLE
					formTextDB = model(get('localizatorLanguageTable')).findAll(where="text='#params.formTextDB.text#'");
					
					if ( !formTextDB.recordCount ) {		
						// ADD TEXT TO LOCALIZATION TABLE			
						formTextDB = model(get('localizatorLanguageTable')).new(params.formTextDB);
						
						if ( formTextDB.save() ) {
							// ADD TEXT TO LOCALIZATION FILES
							loc.message.file = addTextToFile(params.formTextDB);
							
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
			}
			// ADD />
			
			// EDIT
			if ( isDefined("params.editText") && Len(params.editText) && isNumeric(params.editText) ) {
				// EDIT LOCALIZATION TEXT
				formTextDB = model(get('localizatorLanguageTable')).findByKey(key=params.editText);
			}
			// EDIT />
			
			// UPDATE
			if ( isDefined("params.type") && params.type == "update") {
				// UPDATE TEXT
				if ( isDefined("params.formTextDB.key") && Len(params.formTextDB.key) ) {
					// GET TEXT FROM LOCALIZATION TABLE
					formTextDB = model(get('localizatorLanguageTable')).findByKey(params.formTextDB.key);
					// UPDATE TEXT IN LOCALIZATION TABLE
					if ( formTextDB.update(params.formTextDB) ) {
						// UPDATE LOCALIZATION FILES
						loc.formTextDB = updateLocalizationFiles(params.formTextDB, "update");

						loc.message.type = "success";
						loc.message.formTextDB = "Text in database updated successfully<br />" & loc.formTextDB;
					
					} else {
						loc.message.type = "error";
						loc.message.formTextDB = "An error occured while updating text";
					}				
				}
			}
			// UPDATE />
			
			// DELETE
			if ( isDefined("params.deleteText") ) {
				// GET TEXT FROM DATABASE
				loc.obj = model(get('localizatorLanguageTable')).findByKey(params.deleteText);
				if ( isObject(loc.obj) ) {
					// DELETE FROM DATABASE
					if ( loc.obj.delete() ) {
						// DELETE FROM REPOSITORY AND LOCALIZATION FILES
						loc.formTextDB = updateLocalizationFiles(loc.obj, "delete");
						
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
			// DELETE />
			
			// GET
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
			// GET />
			
		//  --------------------------------------------------------------------------------------
		//	LOCALIZATION FILES
		//  --------------------------------------------------------------------------------------
		} else {
			
			// ADD
			if ( isDefined("params.type") && params.type == "new") {
				// ADD TEXT TO LOCALIZATION FILES
				if ( isDefined("params.formTextFile") && isDefined("params.formTextFile.text") && Len(params.formTextFile.text) ) {
					// ADD TO LOCALIZATION FILES
					loc.formTextFile = addTextToFile(params.formTextFile);
					if ( isDefined("loc.formTextFile.found") ) {
						loc.message.type = "error";
						loc.message.formTextFile = "<strong><u>#loc.formTextFile.text#</u></strong> already in your localizations files";
					} else {
						flashInsert(message="<strong><u>#loc.formTextFile.text#</u></strong> added to your localizations files successfully", messageType="success");
						location(url=loc.config.url, addtoken=false);
					}
				}
			}
			// ADD />
			
			// EDIT
			if ( isDefined("params.editText") && Len(params.editText) ) {
				formTextFile = getTextsFromFile(params.editText);
				formTextFile.update = true;
			}
			// EDIT />
			
			// UPDATE
			if ( isDefined("params.type") && params.type == "update") {
				loc.message.type = "success";
				loc.message.formTextFile = updateLocalizationFiles(params.formTextFile, "update");
			}
			// UPDATE />
			
			// DELETE
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
			// DELETE />
			
			// GET
			loc.results = getLocalizationsFromRepository(FORM.letter);
			loc.letters = loc.results.letters;
			loc.localizations = loc.results.localizations;
			// GET />
			
			// INIT FORM
			if ( !isDefined("params.editText") ) {
				formTextFile = {};
			}
			// INIT FORM />
		}

	</cfscript>
	
</cfoutput>