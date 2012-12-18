<cfscript>
	component output=false {
		
		/*
			---------------------------------------------------------------------------------------------------
				Copyright 2012 Simon Allard
				
				Licensed under the Apache License, Version 2.0 (the "License");
				you may not use this file except in compliance with the License.
				You may obtain a copy of the License at
				
					http://www.apache.org/licenses/LICENSE-2.0
				
				Unless required by applicable law or agreed to in writing, software
				distributed under the License is distributed on an "AS IS" BASIS,
				WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
				See the License for the specific language governing permissions and
				limitations under the License.
			---------------------------------------------------------------------------------------------------
		*/
		
		/* ---------------------------------------------------------------------------------------------------
		 * @hint Constructor
		 * ---------------------------------------------------------------------------------------------------
		*/
		public function init() {
			this.version = "1.1.8";
			
			/* ---------------------------------------------------------------------------------------------------
			 * APPLY DEFAULT SETTINGS IF NOT SUPPLIED IN --> (config/settings.cfm)
		 	 * ---------------------------------------------------------------------------------------------------
			*/
			
			// - SET DEFAULT LANGUAGE (default to server locale)
			// - set(localizatorLanguageDefault="ShortDescriptionLocale") --> (config/settings.cfm)
			if ( !isDefined("application.wheels.localizatorLanguageDefault") ) {
				application.wheels.localizatorLanguageDefault = CreateObject("java", "java.util.Locale").getDefault().toString();
			}
			
			// - SET DEFAULT HARVEST FLAG (default to false)
			// - set(localizatorLanguageHarvest=true/false) --> (config/settings.cfm)
			if ( !isDefined("application.wheels.localizatorLanguageHarvest") ) {
				application.wheels.localizatorLanguageHarvest = false;
			}
			
			// - SET DEFAULT LOCALIZATION TABLE (default to "localizations")
			// - set(localizatorLanguageTable="NameOfYourLocalizationTable") --> (config/settings.cfm)
			if ( !isDefined("application.wheels.localizatorLanguageTable") ) {
				application.wheels.localizatorLanguageTable = "localizations";
			}

			// - SET DEFAULT SHOW LOG CONSOLE (default to false)
			// - set(localizatorShowLog=true/false) --> (config/settings.cfm)
			if ( !isDefined("application.wheels.localizatorShowLog") ) {
				application.wheels.localizatorShowLog = false;
			}

			// - SET DEFAULT WRITE DUMP (default to false)
			// - set(localizatorShowDump=true/false) --> (config/settings.cfm)
			if ( !isDefined("application.wheels.localizatorShowDump") ) {
				application.wheels.localizatorShowDump = false;
			}
			
			return this;
		}
		
		// ---------------------------------------------------------------------------------------------------
		// FUNCTIONS (Public)
		// ---------------------------------------------------------------------------------------------------
		
		/* ---------------------------------------------------------------------------------------------------
		 * @hint Shortcut to localizeme function
		 * ---------------------------------------------------------------------------------------------------
		*/
		public string function l(required string text, string language) {
			var loc = {};
			
			loc.bypass = true;
			loc.text = arguments.text;
			
			// SET TRANSLATION LANGUAGE
			if ( isDefined("arguments.language") && Len(arguments.language) ) {
				loc.language = arguments.language; // Language passed by function
			
			} else if ( isDefined("application.wheels.localizatorLanguageSession") && isDefined("session") && StructKeyExists(session, get('localizatorLanguageSession')) && Len(session[get("localizatorLanguageSession")]) ) {
				loc.language = session[get("localizatorLanguageSession")]; // Language from user session
			
			} else {
				loc.language = get('localizatorLanguageDefault'); // Language from default settings
			}

			return localizeme(argumentCollection=loc);
		}
		
		/* ---------------------------------------------------------------------------------------------------
		 * @hint Localizeme function (return localized text)
		 * ---------------------------------------------------------------------------------------------------
		*/
		public string function localizeme(required string text, string language, required boolean bypass=false) {
			var loc = {};

			// REPLACE DOUBLE CURLY BRACKET WITH SINGLE CURLY BRACKET
			// --> Convention is to put dynamic text (variable) between single curly brackets.
			// --> localizeme("{#Now()#}") will return {{ts '2012-12-14 13:38:04'}}
			loc.text = ReplaceNoCase(ReplaceNoCase(arguments.text, "{{", "{"), "}}", "}");
			
			if ( arguments.bypass ) {
				// BYPASS LANGUAGE CHECK BECAUSE ALREADY CHECKED
				loc.language = arguments.language;
			
			} else {
				// SET TRANSLATION LANGUAGE
				if ( isDefined("arguments.language") && Len(arguments.language) ) {
					loc.language = arguments.language; // Language passed by function
	
				} else if ( isDefined("application.wheels.localizatorLanguageSession") && isDefined("session") && StructKeyExists(session, get('localizatorLanguageSession')) && Len(session[get("localizatorLanguageSession")]) ) {
					loc.language = session[get("localizatorLanguageSession")]; // Language from user session
				
				} else {
					loc.language = get('localizatorLanguageDefault'); // Language from default settings
				}
			}

			return $initLocalization(argumentCollection=loc);
		}
	
		/* ---------------------------------------------------------------------------------------------------
		 * @hint Init localization process
		 * ---------------------------------------------------------------------------------------------------
		*/
		public string function $initLocalization(required string text, required string language) {
			var loc = {};

			// ORIGINAL LOCALIZATION REQUEST
			loc.localize = {};
			loc.localize = arguments;
			loc.localize.original = arguments.text;
			
			// CHECK DATABASE AVAILABILITY (Datasource, Table, Column (language = en_US, en_CA, etc...))
			loc.isDatabaseAvailable = $isDatabaseAvailable();
			//loc.isDatabaseAvailable = false; // Uncomment to test localization files
			loc.isDatabaseTableAvailable = $isDatabaseTableAvailable(loc.isDatabaseAvailable);
			loc.isDatabaseLanguageAvailable = $isDatabaseLanguageAvailable(loc.isDatabaseTableAvailable, loc.localize.language);
			
			// CHECK LOCALIZATION FILE AVAILABILITY 
			// --> Check if a localization file exists for the requested language
			loc.isLocalizationFileAvailable = $isLocalizationFileAvailable(loc.localize.language);

			// ADD TEXT TO DATABASE AND/OR LOCALIZATION FILES
			// --> Only if localizatorLanguageHarvest is true and environment not in production
			if ( get('localizatorLanguageHarvest') && (get("environment") == "Design" || get("environment") == "Development") ) {
				
				// ADD TEXT TO DATABASE
				if ( loc.isDatabaseAvailable && loc.isDatabaseTableAvailable ) {
					loc.localized["Database"] = $addTextToDatabase(loc.localize.text);
				}
				
				// ADD TEXT TO LOCALIZATION FILES
				loc.localized["Files"] = $addTextToFile(loc.localize.text);
				loc.localized.text = loc.localized["Files"].text;
				
				// GET TRANSLATION FROM DATABASE OR LOCALIZATION FILES
				if ( loc.isDatabaseAvailable && loc.isDatabaseTableAvailable && loc.isDatabaseLanguageAvailable ) {
					loc.translation = $findLocalizedDatabaseText(argumentCollection=loc.localize);
				}
				
				if ( isDefined("loc.translation") && isDefined("loc.translation.found") ) {
					loc.localized.text = loc.translation.text;
				
				} else if ( loc.isLocalizationFileAvailable ) {
					loc.translation = $findTextInLocalesFile(argumentCollection=loc.localize);
					
					if ( isDefined("loc.translation") && isDefined("loc.translation.found") ) {
						loc.localized.text = loc.translation.text;
					}
				}
			
			// GET TRANSLATED TEXT FROM DATABASE OR LOCALIZATION FILES
			} else {			
				
				// GET TRANSLATION FROM DATABASE
				if ( loc.isDatabaseAvailable && loc.isDatabaseTableAvailable && loc.isDatabaseLanguageAvailable ) {
					loc.translation = $findLocalizedDatabaseText(argumentCollection=loc.localize);
				}
				
				if ( isDefined("loc.translation") && isDefined("loc.translation.found") ) {
					loc.localized.text = loc.translation.text;
				
				// GET TRANSLATION FROM LOCALIZATION FILE
				} else if ( loc.isLocalizationFileAvailable ) {
					loc.translation = $findTextInLocalesFile(argumentCollection=loc.localize);
				}
				
				if ( isDefined("loc.translation") && isDefined("loc.translation.found") ) {
					loc.localized.text = loc.translation.text;

				// RETURN ORIGINAL TEXT
				// --> No translation found
				} else {
					loc.localized = Duplicate(loc.localize);
					loc.localized.message = "No translation found";
				}
				
				// REMOVE CURLY BRACKET IF TEXT CONTAINS DYNAMIC TEXT
				if ( $isTextContainsDynamicText(loc.localized.text) ) {
					loc.localized.text = ReplaceList(loc.localized.text, "{,}", "");
				}
			}

			// DUMP THE WHOLE STRUCTURE
			// --> Only if localizatorShowLog is true
			if ( get("localizatorShowLog") ) {
				WriteDump(loc);
			}
			
			// RETURN LOCALIZED TEXT
			return loc.localized.text;
		}
		
		/* ---------------------------------------------------------------------------------------------------
		 * @hint Add text & default language to file (repository and/or locales)
		 * ---------------------------------------------------------------------------------------------------
		*/
		public struct function $addTextToFile(required text) {
			var loc = {};
			var logConsole = {};
			
			logConsole.function = "$addTextToFile";
			
			loc.localized = {};
			
			if ( isStruct(arguments.text) ) {
				
				loc.pluginFolder = "plugins/localizator/";
				loc.localized = arguments.text;
				loc.fromEditor = true;
				loc.original = loc.localized.text;
				loc.localesFilesList = $initLocalizationFiles(loc.localized);
			
			} else {
				
				loc = arguments;
				loc.original = arguments.text;
				loc.pluginFolder = "plugins/localizator/";
				loc.localized.text = arguments.text;
				loc.fromEditor = false;
				
				// SET LOCALIZATION FILE FOR THE DEFAULT LANGUAGE
				loc.defaultLanguageFile = "locales/" & get("localizatorLanguageDefault") & ".cfm";
				loc.defaultLanguage = ExpandPath(loc.pluginFolder & loc.defaultLanguageFile);
				
				// IF DEFAULT LOCALIZATION FILE MISSING CREATE NEW ONE
				if ( !FileExists(loc.defaultLanguage) ) {
					loc.newDefaultFile = $createPluginFile(loc.defaultLanguage);
				}
				
				// GET LOCALIZATION FILES LIST FROM LOCALES FOLDER
				loc.localesFilesList = DirectoryList(ExpandPath(loc.pluginFolder & "locales"), false, "name", "*.cfm");

			}
			
			// INIT REPOSITORY
			loc.repo = $initRepositoryFile();
			
			// CHECK IF TEXT CONTAINS DYNAMIC TEXT
			loc.isTextContainsDynamicText = $isTextContainsDynamicText(loc.localized.text);
			
			// REPLACE DYNAMIC TEXT WITH "{variable}"			
			if ( loc.isTextContainsDynamicText ) {
				loc.localized.text = $replaceVariable(loc.original, loc.localized.text, 1);
			}
			
			// SET FORMATED LOCALIZED TEXT TO BE WRITTEN IN LOCALIZATION FILES
			loc.textToAddDefault = '<cfset loc["' & loc.localized.text & '"] = "' & loc.localized.text & '">';
			loc.textToAddOther = '<cfset loc["' & loc.localized.text & '"] = "">';
			
			// WRITE FORMATED LOCALIZED TEXT TO REPOSITORY IF REPOSITORY FILE EXISTS				
			if ( FileExists(loc.repo.repository) ) {
				
				// LOAD REPOSITORY FILE AS STRUCTURE
				loc.includeRepositoryFile = $includePluginFile(loc.repo.repositoryFile);
				
				// CHECK IF TEXT IS IN REPOSITORY (STRUCTURE)
				if ( !StructKeyExists(loc.includeRepositoryFile, loc.localized.text) ) {
					
					// IF TEXT NOT IN REPOSITORY = WRITE FORMATED LOCALIZED TEXT TO FILE & LOG RESULT TO LOG CONSOLE
					logConsole["Repository"] = $appendLocalizationText(loc.repo.repository, loc.textToAddOther);
				
				} else {
					loc.localized.found = true;
					logConsole["Repository"] = "Text already in repository";
				}				
			}
			
			// WRITE FORMATED LOCALIZED TEXT TO LOCALIZATION FILES
			// --> Loop list of localization files
			for (loc.i = 1; loc.i <= ArrayLen(loc.localesFilesList); loc.i++) {
				
				// SET LANGUAGE BASED ON LOCALIZATION FILES
				loc.language = Left(loc.localesFilesList[loc.i], Find(".", loc.localesFilesList[loc.i])-1);
				
				// SET LOCALIZATION FILES
				loc.localesFile = "locales/" & loc.localesFilesList[loc.i];
				loc.localesFilePath = ExpandPath(loc.pluginFolder & loc.localesFile);
				
				// LOAD LOCALIZATION FILE AS STRUCTURE
				loc.includeLocalesFile = $includePluginFile(loc.localesFile);
			
				// CHECK IF TEXT IS IN LOCALIZATION FILE (STRUCTURE)
				if ( !StructKeyExists(loc.includeLocalesFile, loc.localized.text) ) {
					
					// WRITE LOCALIZATION FILES FROM MANUAL FORM ENTRY
					if ( loc.fromEditor ) {
						
						// SET FORMATED LOCALIZED TEXT TO BE WRITTEN IN LOCALIZATION FILES
						loc.textToAddLocalization = '<cfset loc["' & loc.localized.text & '"] = "' & loc.localized[loc.language] & '">';
						
						// WRITE FORMATED LOCALIZED TEXT (KEY,VALUE) TO LOCALIZATION FILE AND LOG RESULT TO LOG CONSOLE
						logConsole["Localization file (" & loc.language & ")"] = $appendLocalizationText(loc.localesFilePath, loc.textToAddLocalization);
						
					} else {
						// WRITE FORMATED LOCALIZED TEXT TO LOCALIZATION FILES
						if ( loc.language == get('localizatorLanguageDefault') ) {
							
							// WRITE FORMATED LOCALIZED TEXT (KEY,VALUE) TO DEFAULT LOCALIZATION FILES AND LOG RESULT TO LOG CONSOLE
							logConsole["Localization file (" & loc.language & ")"] = $appendLocalizationText(loc.localesFilePath, loc.textToAddDefault);
						
						} else {
							// WRITE FORMATED LOCALIZED TEXT (KEY ONLY) TO OTHER LOCALIZATION FILES AND LOG RESULT TO LOG CONSOLE
							logConsole["Localization file (" & loc.language & ")"] = $appendLocalizationText(loc.localesFilePath, loc.textToAddOther);
						}
					}
				} else {
					logConsole["Localization file (" & loc.language & ")"] = "Text alreay in locales file (" & loc.language & ")";
				}
				
			}
			
			// REPLACE "{variable}" TEXT WITH ORIGINAL DYNAMIC TEXT
			if ( loc.isTextContainsDynamicText ) {
				loc.localized.text = $replaceVariable(loc.original, loc.localized.text, 2);
			}
			
			// RETURN CONSOLE LOG
			// --> Only if localizatorShowLog is true
			if ( get("localizatorShowLog") ) {
				loc.localized[logConsole.function] = logConsole;
			}
			
			// DUMP THE WHOLE STRUCTURE FOR THIS FUNCTION
			// --> Only if localizatorShowDump is true
			if ( get("localizatorShowDump") ) {
				WriteDump(loc);
			}
			
			// RETURN STRUCTURE
			return loc.localized;
		}
		
		/* ---------------------------------------------------------------------------------------------------
		 * @hint Generate localization files from database
		 * ---------------------------------------------------------------------------------------------------
		*/
		public string function generateLocalizationFiles() {
			var loc = {};
			
			loc.i = 0;
			loc.localized = {};
			loc.localizations = model(get("localizatorLanguageTable")).findAll();
			
			if ( loc.localizations.recordCount ) {
				// DELETE ALL FILES
				loc.deleteFile = $deleteLocalizationFiles();
				
				// INIT REPOSITORY FILE
				loc.repo = $initRepositoryFile();
				
				// INIT LOCALIZATION FILES
				loc.localesFilesList = $initLocalizationFiles(loc.localizations);
				
				loc.localizationsStruct = $queryToStruct(query=loc.localizations, forceArray=true);

				for (var i IN loc.localizationsStruct) { 
        	loc.i += 1;
					loc.localized[loc.i] = $addTextToFile(loc.localizationsStruct[loc.i]);
        }
			}
			
			if ( ListLen(StructKeyList(loc.localized)) ) {
				return "Localization files generated successfully";
			} else {
				return "No localization files were generated";
			}
		}
		
		/* ---------------------------------------------------------------------------------------------------
		 * @hint Convert Query to Struct
		 * ---------------------------------------------------------------------------------------------------
		*/		
		public function $queryToStruct(required query query, query row, boolean forceArray=false) {
			
			var loc = {};
			var local = {};
			var result = {};
			var idx = "";
			var columnLabels = arguments.query.getMetaData().getColumnLabels();
			
			if ( isDefined("arguments.row") ) {
				local.row = arguments.row;
			
			} else if ( arguments.query.recordCount == 1) {
				local.row = 1;
			}
			
			if ( isDefined("local.row") && !arguments.forceArray ) {
				for (loc.i = 1; loc.i <= ArrayLen(columnLabels); loc.i++) {
					StructInsert(result, columnLabels[loc.i], arguments.query[columnLabels[loc.i]][local.row]);
				}
				
			} else if ( isDefined("local.row") ) {
				result = ArrayNew(1);
				
				ArrayAppend(result, StructNew());
				
				for (loc.i = 1; loc.i <= ArrayLen(columnLabels); loc.i++) {
					StructInsert(result[1], columnLabels[loc.i], arguments.query[columnLabels[loc.i]][local.row]);
				}
				
			} else {
				result = ArrayNew(1);
				
				for (idx = 1; idx <= arguments.query.recordCount; idx++) {
					local.tempStruct = StructNew();
					
					for (loc.i = 1; loc.i <= ArrayLen(columnLabels); loc.i++) {
						StructInsert(local.tempStruct, columnLabels[loc.i], arguments.query[columnLabels[loc.i]][idx]);
					}
					
					ArrayAppend(result, local.tempStruct);
				}
			}
			
			return result;
		}
		
		/* ---------------------------------------------------------------------------------------------------
		 * @hint Get localizations from repository
		 * ---------------------------------------------------------------------------------------------------
		*/
		public query function getLocalizationsFromRepository(required string letter="all") {
			var loc = {};
			
			loc.i = 0;
			loc.repo = $initRepositoryFile();
			loc.query = QueryNew("text,firstLetter", "VarChar,VarChar");
			
			// CHECK IF REPOSITORY FILE EXISTS
			if ( FileExists(loc.repo.repository) ) {
				
				// LOAD REPOSITORY FILE AS STRUCTURE
				loc.includeRepositoryFile = $includePluginFile(loc.repo.repositoryFile);
				
				// BUILD QUERY FROM STRUCT
				if ( isStruct(loc.includeRepositoryFile) && StructCount(loc.includeRepositoryFile) ) {
					for (loc.key IN loc.includeRepositoryFile) {
						loc.i++;
						QueryAddRow(loc.query);
						QuerySetCell(loc.query, "text", loc.key, loc.i);
						QuerySetCell(loc.query, "firstLetter", Left(loc.key,1), loc.i);
					}
				}
			}
			
			return loc.query;
		}
		
		/* ---------------------------------------------------------------------------------------------------
		 * @hint Get texts from localizations files
		 * ---------------------------------------------------------------------------------------------------
		*/
		public struct function getTextsFromFile(required string text) {
			var loc = {};
			
			loc.struct = {};
			loc.localize = {};
			loc.localize.text = arguments.text;
			loc.localized.text = loc.localize.text;
			
			loc.pluginFolder = "plugins/localizator/";
			loc.folderRepository = loc.pluginFolder & "repository";
			loc.folderLocales = loc.pluginFolder & "locales";
			
			loc.filesRepositoryArray = DirectoryList(ExpandPath(loc.folderRepository), false, "name", "*.cfm");
			loc.filesLocalesArray = DirectoryList(ExpandPath(loc.folderLocales), false, "name", "*.cfm");
			loc.filesLocalesList = ReplaceNoCase(ArrayToList(loc.filesLocalesArray), ".cfm", "", "all");
			
			for (loc.i = 1; loc.i <= ListLen(loc.filesLocalesList); loc.i++) {
				loc.localize.language = ListGetAt(loc.filesLocalesList, loc.i);
				loc.localeText =  $findTextInLocalesFile(argumentCollection=loc.localize);
				loc.localized[loc.localize.language] = loc.localeText.text;
			}
			
			return loc.localized;
		}
		
		/* ---------------------------------------------------------------------------------------------------
		 * @hint Delete localization files
		 * ---------------------------------------------------------------------------------------------------
		*/		
		public void function $deleteLocalizationFiles() {
			var loc = {};
			
			loc.pluginFolder = "plugins/localizator/";
			loc.folderRepository = loc.pluginFolder & "repository";
			loc.folderLocales = loc.pluginFolder & "locales";
			
			loc.filesRepositoryArray = DirectoryList(ExpandPath(loc.folderRepository), false, "name", "*.cfm");
			loc.filesLocalesArray = DirectoryList(ExpandPath(loc.folderLocales), false, "name", "*.cfm");
			
			for (loc.i = 1; loc.i <= ArrayLen(loc.filesRepositoryArray); loc.i++) {
				FileDelete(ExpandPath(loc.folderRepository & "\" & loc.filesRepositoryArray[loc.i]));
			}
			
			for (loc.i = 1; loc.i <= ArrayLen(loc.filesLocalesArray); loc.i++) {
				FileDelete(ExpandPath(loc.folderLocales & "\" & loc.filesLocalesArray[loc.i]));
			}
		}
		
		/* ---------------------------------------------------------------------------------------------------
		 * @hint Update localization files
		 * ---------------------------------------------------------------------------------------------------
		*/
		public string function updateLocalizationFiles(required struct struct, required string action) {
			var loc = {};
			
			loc.localized = arguments.struct;
			loc.pluginFolder = "plugins/localizator/";
			loc.localesFilesList = $initLocalizationFiles(loc.localized);
			loc.action = arguments.action;
			loc.update = "";
			
			// LOOP OVER LOCALIZATION FILES
			for (loc.i = 1; loc.i <= ArrayLen(loc.localesFilesList); loc.i++) {
				
				// SET LANGUAGE BASED ON LOCALIZATION FILES
				loc.language = Left(loc.localesFilesList[loc.i], Find(".", loc.localesFilesList[loc.i])-1);
				
				// SET LOCALIZATION FILES
				loc.localesFile = "locales/" & loc.localesFilesList[loc.i];
				loc.localesFilePath = ExpandPath(loc.pluginFolder & loc.localesFile);
			
				if ( FileExists(loc.localesFilePath) ) {
					loc.textLine = "";
					
					// READ FILE
					loc.file = FileOpen(loc.localesFilePath, "read", "utf-8");
					
					// LOOP OVER EACH LINE
					while (!FileIsEOF(loc.file)) {
						
						// READ LINE
						loc.line = FileReadLine(loc.file);
						
						// GET PARSED TEXT FROM LINE
						loc.textArray = ReMatch('\[(.*?)\]', loc.line);
						loc.text = ReplaceNoCase(ReplaceNoCase(ArrayToList(loc.textArray,"~"), '["', '', 'all'), '"]', '', 'all');
						
						// COMPARE LOCALIZED TEXT TO TEXT OF LOCALIZATION FORM
						if ( loc.text == loc.localized.text ) {
							loc.localizedTextFound = 1;
							
							// UPDATE LOCALIZED TEXT
							if ( loc.action == "update" ) {
								loc.textLine = loc.textLine & '<cfset loc["' & loc.localized.text & '"] = "' & loc.localized[loc.language] & '">' & Chr(13) & Chr(10);
							
							// DELETE LOCALIZED TEXT
							} else if ( loc.action == "delete" ) {
							}
						} else {
							loc.textLine = loc.textLine & loc.line & Chr(13) & Chr(10);
						}
					}
					
					// CLOSE FILE
					FileClose(loc.file);

					// WRITE NEW LOCALIZATION FILE IF CHANGE WERE MADE
					if ( isDefined("loc.localizedTextFound") && loc.localizedTextFound ) {
						
						FileWrite(loc.localesFilePath, loc.textLine, "utf-8");
						
						if ( loc.action == "update" ) {
							loc.update = loc.update & GetLocaleDisplayName(loc.language, getLocale()) & " updated successfully.<br />";
						
						} else if ( loc.action == "delete" ) {
							loc.update = "Text deleted successfully.";
						}
					
					} else {
						loc.update = loc.update & GetLocaleDisplayName(loc.language, getLocale()) & " was not updated.<br />";
					}
				}
			}

			// UPDATE REPOSITORY IF CHANGE WERE MADE (ONLY IF DELETE)
				
				if ( loc.action == "delete" ) {
					
					// INIT REPOSITORY
					loc.repo = $initRepositoryFile();
					
					if ( FileExists(loc.repo.repository) ) {
						loc.textLine = "";
						
						// READ FILE
						loc.file = FileOpen(loc.repo.repository, "read", "utf-8");
						
						// LOOP OVER EACH LINE
						while (!FileIsEOF(loc.file)) {
							
							// READ LINE
							loc.line = FileReadLine(loc.file);
							
							// GET PARSED TEXT FROM LINE
							loc.textArray = ReMatch('\[(.*?)\]', loc.line);
							loc.text = ReplaceNoCase(ReplaceNoCase(ArrayToList(loc.textArray,"~"), '["', '', 'all'), '"]', '', 'all');
							
							// COMPARE LOCALIZED TEXT TO TEXT OF LOCALIZATION FORM
							if ( loc.text == loc.localized.text ) {
							} else {
								loc.textLine = loc.textLine & loc.line & Chr(13) & Chr(10);
							}
						}
						
						// CLOSE FILE
						FileClose(loc.file);
					}
					
					if ( FileExists(loc.repo.repository) ) {
						FileWrite(loc.repo.repository, loc.textLine, "utf-8");
					}
				}

			return loc.update;
		}
		
		/* ---------------------------------------------------------------------------------------------------
		 * @hint Check if locale is valid and available in server
		 * ---------------------------------------------------------------------------------------------------
		*/
		public boolean function $isValidLocale(required string locale) {
			var loc = {};
						
			loc.locales = createObject('java','java.util.Locale').getAvailableLocales();

			for (loc.i = 1; loc.i <= ArrayLen(loc.locales); loc.i++) {
				if ( Compare(loc.locales[loc.i].toString(), arguments.locale) == 0 ) {
					return true;
					break;
				}
			}
			
			return false;
		}
		
		/* ---------------------------------------------------------------------------------------------------
		 * @hint Return languages list based on localization files in the locales folder
		 * ---------------------------------------------------------------------------------------------------
		*/
		public function getLocalizationLanguagesList() {
			var loc = {};
			
			loc.pluginFolder = "plugins/localizator/";
			loc.folderLocales = loc.pluginFolder & "locales";
			loc.filesLocalesArray = DirectoryList(ExpandPath(loc.folderLocales), false, "name", "*.cfm");
			loc.filesTempLocalesList = ReplaceNoCase(ArrayToList(loc.filesLocalesArray), ".cfm","","ALL");
			loc.filesLocalesList = "";

			for (loc.i = 1; loc.i <= ListLen(loc.filesTempLocalesList); loc.i++) {
				loc.locale = ListGetAt(loc.filesTempLocalesList, loc.i);
				if ( $isValidLocale(loc.locale) ) {
					loc.filesLocalesList = ListAppend(loc.filesLocalesList, loc.locale);
				}
			}
			
			return loc.filesLocalesList;
		}
		
		/* ---------------------------------------------------------------------------------------------------
		 * @hint Init repository file
		 * ---------------------------------------------------------------------------------------------------
		*/
		public struct function $initRepositoryFile() {
			var loc = {};
			
			loc.pluginFolder = "plugins/localizator/";
			
			// SET REPOSITORY FILE
			loc.repositoryFile = "repository/repository.cfm";
			loc.repository = ExpandPath(loc.pluginFolder & loc.repositoryFile);
			
			// IF REPOSITORY FILE MISSING CREATE NEW ONE
			if ( !FileExists(loc.repository) ) {
				loc.newRepositoryFile = $createPluginFile(loc.repository);
			}
			
			return loc;
		}
		
		/* ---------------------------------------------------------------------------------------------------
		 * @hint Init localization files
		 * ---------------------------------------------------------------------------------------------------
		*/
		public array function $initLocalizationFiles(required structOrQuery) {
			var loc = {};
			
			loc.localized = arguments.structOrQuery;
			loc.pluginFolder = "plugins/localizator/";
			loc.localesFilesList = "";
			
			// SET LOCALIZATION FILES LIST FROM DATABASE COLUMNS OR FORM PARAMS
			if ( isQuery(loc.localized) ) {
				loc.formParamsList = loc.localized.columnList;
			
			} else {
				loc.formParamsList = StructKeyList(loc.localized);
			}
			
			for (loc.i = 1; loc.i <= ListLen(loc.formParamsList); loc.i++) {
				if ( FindOneOf("_", ListGetAt(loc.formParamsList, loc.i)) ) {
					
					// CREATE LIST OF LOCALIZATION FILES BASED ON THE FORM FIELDS
					loc.fileName = ListGetAt(loc.formParamsList, loc.i) & ".cfm";
					loc.localesFilesList = ListAppend(loc.localesFilesList, loc.fileName);
					
					// SET LOCALIZATION FILE BASED ON THE FORM FIELDS
					loc.languageFile = "locales/" & loc.fileName;
					loc.language = ExpandPath(loc.pluginFolder & loc.languageFile);
					
					// IF LOCALIZATION FILE BASED ON THE FORM FIELDS IS MISSING CREATE NEW ONE
					if ( !FileExists(loc.language) ) {
						loc.newDefaultFile = $createPluginFile(loc.language);
					}
				}
			}
			
			// CONVERT LIST OF LOCALIZATION FILES TO ARRAY
			return ListToArray(loc.localesFilesList);
		}
		
		/* ---------------------------------------------------------------------------------------------------
		 * @hint Create file in plugin folder
		 * ---------------------------------------------------------------------------------------------------
		*/
		public struct function $createPluginFile(required string filePath) {
			var loc = {};

			/* ----------------------------------------------------------------------------
			 * Using Java as there's a bug writing UTF-8 text files with ColdFusion 
			 * http://tim.bla.ir/tech/articles/writing-utf8-text-files-with-coldfusion
			 * ----------------------------------------------------------------------------
			 */
			
			loc = arguments;
			
			// Create the file stream  
			loc.jFile = CreateObject("java", "java.io.File").init(loc.filepath);  
			loc.jStream = CreateObject("java", "java.io.FileOutputStream").init(loc.jFile); 
			
			// Output the UTF-8 BOM byte by byte directly to the stream  
			loc.jStream.write(239); // 0xEF  
			loc.jStream.write(187); // 0xBB  
			loc.jStream.write(191); // 0xBF 
			 
			// Create the UTF-8 file writer and write the file contents  
			loc.jWriter = CreateObject("java", "java.io.OutputStreamWriter");  
			loc.jWriter.init(loc.jStream, "UTF-8");
			
			// flush the output, clean up and close  
			loc.jWriter.flush();  
			loc.jWriter.close();  
			loc.jStream.close();
			
			return loc;
		}
		
		/* ---------------------------------------------------------------------------------------------------
		 * @hint Append text to file
		 * ---------------------------------------------------------------------------------------------------
		*/
		public struct function $appendLocalizationText(required string filePath, required string text) {
			var loc = {};
			
			loc.localized.text = arguments.text;
			
			// OPEN FILE TO APPEND FORMATED LOCALIZED TEXT
			loc.file = FileOpen(arguments.filePath, "append", "utf-8");
			
			// WRITE FORMATED LOCALIZED TEXT
			FileWriteLine(loc.file, loc.localized.text);
			
			// CLOSE FILE
			FileClose(loc.file);
			
			// LOG INFO TO LOG CONSOSLE
			// --> Only if localizatorShowLog is true
			if ( get("localizatorShowLog") ) {
				var logConsole = {};
				logConsole.function = "$appendLocalizationText";
				logConsole.message = "Text added to file";
				logConsole.text = arguments.text;
				logConsole.file = arguments.filePath;
				
				loc.localized[logConsole.function] = logConsole;
			}
			
			// DUMP THE WHOLE STRUCTURE FOR THIS FUNCTION
			// --> Only if localizatorShowDump is true
			if ( get("localizatorShowDump") ) {
				WriteDump(loc);
			}

			// RETURN STRUCTURE
			return loc.localized;
		}
		
		/* ---------------------------------------------------------------------------------------------------
		 * @hint Add text & default language text to database
		 * ---------------------------------------------------------------------------------------------------
		*/
		public struct function $addTextToDatabase(required string text) {
			var loc = {};
			var logConsole = {};
			
			logConsole.function = "$addTextToDatabase";
			
			loc = arguments;
			loc.original = arguments.text;
			
			loc.localized = {};
			loc.localized.text = arguments.text;
			
			// CHECK IF TEXT CONTAINS DYNAMIC TEXT
			loc.isTextContainsDynamicText = $isTextContainsDynamicText(loc.text);
			
			// REPLACE DYNAMIC TEXT WITH "{variable}"			
			if ( loc.isTextContainsDynamicText ) {
				loc.localized.text = $replaceVariable(loc.original, loc.text, 1);
			}
			
			// FIND TEXT IN DATABASE
			loc.localization = model(get('localizatorLanguageTable')).findAll(where="text = '#loc.localized.text#'");
			
			// ADD TEXT IF NOT EXISTANT
			if ( !loc.localization.recordCount ) {
				loc.localized[get('localizatorLanguageDefault')] = loc.localized.text;
				
				// ADD TEXT TO DATABASE
				loc.localization = model(get('localizatorLanguageTable')).new(loc.localized);
				
				// LOG INFO TO LOG CONSOLE
				if ( loc.localization.save() ) {
					logConsole["Message"] = "Text added to database";
				} else {
					logConsole["Message"] = "Problem saving text to database";
				}
			} else {
				logConsole["Message"] = "Text already in database";
			}
			
			// REPLACE "{variable}" TEXT WITH ORIGINAL DYNAMIC TEXT
			if ( loc.isTextContainsDynamicText ) {
				loc.localized.text = $replaceVariable(loc.original, loc.localized.text, 2);
			}
			
			// RETURN CONSOLE LOG
			// --> Only if localizatorShowLog is true
			if ( get("localizatorShowLog") ) {
				
				// ADD QUERY INFO TO LOG CONSOLE
				// --> Only if not an object
				if ( !isObject(loc.localization) ) {
					logConsole["Query"] = loc.localization;
				}
				
				loc.localized[logConsole.function] = logConsole;
			}
			
			// DUMP THE WHOLE STRUCTURE FOR THIS FUNCTION
			// --> Only if localizatorShowDump is true
			if ( get("localizatorShowDump") ) {
				WriteDump(loc.localized);
			}

			// RETURN STRUCTURE
			return loc.localized;	
		}
						
		/* ---------------------------------------------------------------------------------------------------
		 * @hint Find localized text in database
		 * ---------------------------------------------------------------------------------------------------
		*/
		public struct function $findLocalizedDatabaseText(required string text, required string language) {
			var loc = {};
			var logConsole = {};
			
			logConsole.function = "$findLocalizedDatabaseText";

			loc = arguments;
			
			loc.localized = {};
			loc.localized.text = loc.text;
			
			// CHECK IF TEXT CONTAINS DYNAMIC TEXT
			loc.isTextContainsDynamicText = $isTextContainsDynamicText(loc.text);
			
			// REPLACE DYNAMIC TEXT WITH "{variable}"			
			if ( loc.isTextContainsDynamicText ) {
				loc.localized.text = $replaceVariable(loc.original, loc.text, 1);
			}
			
			// GET TEXT FROM DATABASE
			loc.translation = model(get('localizatorLanguageTable')).findOne(select="#loc.language# AS localizedText", where="text='#loc.localized.text#'", returnAs="query");

			if ( loc.translation.recordCount ) {
				// SET LOCALIZED TEXT TO RETURN STRUCTURE IF TEXT IS FOUND
				if ( Len(loc.translation.localizedText) ) {
					loc.localized.text = loc.translation.localizedText;
					loc.localized.found = true;
				}
				
				// ADD QUERY RESULT TO LOG CONSOLE
				logConsole["Result"] = loc.translation;
			} else {
				logConsole["Result"] = "Text not foud";
			}
			
			// REPLACE "{variable}" TEXT WITH ORIGINAL DYNAMIC TEXT
			if ( loc.isTextContainsDynamicText ) {
				loc.localized.text = $replaceVariable(loc.original, loc.localized.text, 2);
			}
			
			// RETURN CONSOLE LOG
			// --> Only if localizatorShowLog is true
			if ( get("localizatorShowLog") ) {
				loc.localized[logConsole.function] = logConsole;
			}
			
			// DUMP THE WHOLE STRUCTURE FOR THIS FUNCTION
			// --> Only if localizatorShowDump is true
			if ( get("localizatorShowDump") ) {
				WriteDump(loc.localized);
			}
			
			// RETURN STRUCTURE
			return loc.localized;
		}
		
		/* ---------------------------------------------------------------------------------------------------
		 * @hint  Find localized text (from localization file)
		 * ---------------------------------------------------------------------------------------------------
		*/		
		public struct function $findTextInLocalesFile(required string text, required string language) {
			var loc = {};
			var logConsole = {};
			
			logConsole.function = "$findTextInLocalesFile";
			
			loc = arguments;
			
			loc.localized = {};
			loc.localized.text = loc.text;
			loc.original = loc.text;
			
			// SET TEMPLATE OF REQUESTED LANGUAGE
			loc.template = "locales/" & loc.language & ".cfm";
			
			// LOAD LOCALIZATION FILE AS STRUCTURE
			loc.texts = $includeLocalesFile(loc.template);
			
			// ADD FILE PATH TO LOG CONSOLE
			logConsole["Localization file"] = ExpandPath("plugins/localizator/" & loc.template);
			
			// CHECK IF TEXT CONTAINS DYNAMIC TEXT
			loc.isTextContainsDynamicText = $isTextContainsDynamicText(loc.text);
			
			// REPLACE DYNAMIC TEXT WITH "{variable}"			
			if ( loc.isTextContainsDynamicText ) {
				loc.localized.text = $replaceVariable(loc.original, loc.text, 1);
			}

			// CHECK IF TEXT IS IN LOCALES FILE (STRUCTURE)
			if ( StructKeyExists(loc.texts, loc.localized.text) ) {
				
				// CHECK IF THE TERE'S A TRANSLATION
				if ( Len(loc.texts[loc.localized.text]) ) {
					// ADD LOCALIZED TEXT TO RETURN STRUCTURE
					loc.localized.text = loc.texts[loc.localized.text];
					loc.localized.found = true;
					
					// LOG LOOKUP STRUCTURE TO LOG CONSOLE
					logConsole["Struct"] = StructFindValue(loc.texts, loc.localized.text)[1].owner;
				}
				
			} else {
				logConsole["Error"] = "Text not found";
			}
			
			// REPLACE "{variable}" TEXT WITH ORIGINAL DYNAMIC TEXT
			if ( loc.isTextContainsDynamicText ) {
				loc.localized.text = $replaceVariable(loc.original, loc.localized.text, 2);
			}
			
			// DUMP THE WHOLE STRUCTURE FOR THIS FUNCTION
			// --> Only if localizatorShowDump is true
			if ( get("localizatorShowLog") ) {
				loc.localized[logConsole.function] = logConsole;
			}
			
			// DUMP THE WHOLE STRUCTURE FOR THIS FUNCTION
			// --> Only if localizatorShowDump is true			
			if ( get("localizatorShowDump") ) {
				WriteDump(loc.localized);
			}
			
			// RETURN STRUCTURE
			return loc.localized;			
		}
		
		/* ---------------------------------------------------------------------------------------------------
		 * @hint  Include plugin file
		 * ---------------------------------------------------------------------------------------------------
		*/		
		public struct function $includePluginFile(required string file) {
			var loc = {};
			
			// INCLUDE LOCALIZATION FILE AS A STRUCTURE
			include arguments.file;
			
			return loc;
		}
		
		

		/* ---------------------------------------------------------------------------------------------------
		 * @hint  Include locales file
		 * ---------------------------------------------------------------------------------------------------
		*/		
		public struct function $includeLocalesFile(required string template) {
			var loc = {};
			
			// CREATE CACHE STRUCTURE
			if ( !StructKeyExists(request, "localizator") || !StructKeyExists(request.localizator, "cache") ) {
				request.localizator.cache = {};
			}
			
			// RETURN LOCALIZATION FILE AS A STRUCTURE
			if ( StructKeyExists(request.localizator.cache, arguments.template) ) {
				
				// RETURN LOCALIZATION FILE FROM CACHE
				return request.localizator.cache[arguments.template];
			
			} else {
				
				// INCLUDE LOCALIZATION FILES
				include arguments.template;
				
				// ADD LOCALIZATION FILE TO CACHE
				request.localizator.cache[arguments.template] = Duplicate(loc);
				
				return loc;
			}
		}

		/* ---------------------------------------------------------------------------------------------------
		 * @hint Replace variable text {variable}
		 * ---------------------------------------------------------------------------------------------------
		*/
		public string function $replaceVariable(required string originalText, required string text, required numeric flag) {
			var loc = {};
			
			switch(arguments.flag) {
				// REPLACE DYNAMIC TEXT WITH "{variable}"
				case 1 :
					loc.textBetweenDynamicText = ReMatch("{(.*?)}", arguments.text);
					loc.iEnd = ArrayLen(loc.textBetweenDynamicText);
					for (loc.i = 1; loc.i <= loc.iEnd; loc.i++) {
						loc.text = Replace(arguments.text, loc.textBetweenDynamicText[loc.i], "{variable}", "all");
					}
					break;
				
				// REPLACE "{variable}" WITH ORIGINAL DYNAMIX TEXT
				case 2 :
					loc.textBetweenDynamicText = ReMatch("{(.*?)}", arguments.originalText);
					loc.text = Replace(arguments.text, "{variable}", loc.textBetweenDynamicText[1]);
					loc.text = ReplaceList(loc.text, "{,}", "");
					break;
					
			}
			
			return loc.text;
		}

		/* ---------------------------------------------------------------------------------------------------
		 * @hint Check if text contains dynamic text
		 * ---------------------------------------------------------------------------------------------------
		*/
		public boolean function $isTextContainsDynamicText(required string text) {
			if ( arguments.text CONTAINS "{variable}") {
				return false;
			} else {
				return (arguments.text CONTAINS "{" && arguments.text CONTAINS "}");
			}
		}

		/* ---------------------------------------------------------------------------------------------------
		 * @hint Check if localization file exist
		 * ---------------------------------------------------------------------------------------------------
		*/		
		public boolean function $isLocalizationFileAvailable(required string language) {
			var loc = {};
			
			loc.localesFolder = "plugins/localizator/locales";
			loc.localesFilesArray = DirectoryList(ExpandPath(loc.localesFolder), false, "name", "*.cfm");
			loc.localesFilesList = ArrayToList(loc.localesFilesArray);

			return YesNoFormat(ListFindNoCase(loc.localesFilesList, arguments.language & ".cfm"));
		}

		/* ---------------------------------------------------------------------------------------------------
		 * @hint Check if language is configured in Localizations table or localization file
		 * ---------------------------------------------------------------------------------------------------
		*/
		public boolean function $isDatabaseLanguageAvailable(required boolean isDatabaseTableAvailable, required string language) {
			var loc = {};
			
			if ( arguments.isDatabaseTableAvailable ) {
				loc.columnsList = new dbinfo(datasource=get("dataSourceName"), table=get('localizatorLanguageTable')).columns();
				
				return YesNoFormat(FindNoCase(arguments.language, ValueList(loc.columnsList.column_name)));
				
			} else {
				return false;
			}
		}

		/* ---------------------------------------------------------------------------------------------------
		 * @hint Check if Localizations table is present
		 * ---------------------------------------------------------------------------------------------------
		*/
		public boolean function $isDatabaseTableAvailable(required boolean isDatabaseAvailable) {
			var loc = {};
			
			if ( arguments.isDatabaseAvailable ) {
				try {
					loc.tablesList = new dbinfo(datasource=get("dataSourceName")).tables();
					return YesNoFormat(FindNoCase(get('localizatorLanguageTable'), ValueList(loc.tablesList.table_name)));
				
				} catch ( any e ) {
					return "No";
				}
			}
		}
		
		/* ---------------------------------------------------------------------------------------------------
		 * @hint Check if database is online
		 * ---------------------------------------------------------------------------------------------------
		*/
		public boolean function $isDatabaseAvailable() {
			var loc = {};
			
			try {
				loc.info = new dbinfo(type="version", datasource=get("dataSourceName"), username=application.wheels.dataSourceUserName, password=application.wheels.dataSourcePassword);
				return "Yes";
			} catch ( any e ) {
				return "No";
			}
		}

	}
</cfscript>