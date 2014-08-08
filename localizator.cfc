<cfscript>
	component output=false {
		/*
			---------------------------------------------------------------------------------------------------
				Copyright © 2014 Simon Allard
				
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
			var loc = {};

			this.version = "1.3";

			application.localizator = {};
			application.localizator = initLocalizatorPluginSettings();

			return this;
		}

		/* ---------------------------------------------------------------------------------------------------
		 * @hint Init plugin config
		 * ---------------------------------------------------------------------------------------------------
		*/
		public struct function initLocalizatorPluginSettings() {
			var loc  = {};
			var temp = {};

			/* ---------------------------------------------------------------------------------------------------
			 * APPLY DEFAULT SETTINGS IF NOT SUPPLIED IN --> (environment/config/localizator.cfm)
		 	 * ---------------------------------------------------------------------------------------------------
			*/

			/* ---------------------------------------------------------------------------------------------------
			 * IMPORTANT MESSAGE
			 * ---------------------------------------------------------------------------------------------------
			 * August 6, 2014 - Wheels 1.3 has just been released and it look awesome!
			 * August 8, 2014 - Localizator 3.0 is launched to make it compatible with Wheels 1.3
			 * Here's the new way to configure Localizator 3.x and up
			 * In your config/environment folder create a new file called "localizator.cfm"

			<cfset loc = {
				dataSourceName="YourDataSourceName",
				localizatorLanguageDefault="localeid",
				localizatorLanguageSession="user.localeid",
				localizatorGetLocalizationFromFile=false,
				localizatorLanguageHarvest=false,
				localizatorLanguageTable="localizationTable"
			}>

			* ---------------------------------------------------------------------------------------------------
			*/
			// Set application wheels path
			if ( StructKeyExists(application, "$wheels") ) {
				temp.application = application.$wheels;

			} else if (StructKeyExists(application, "wheels") ) {
				temp.application = application.wheels;
			}

			// Set path to config file)
			temp.configFile  = temp.application["rootPath"] & "/config/" & temp.application["environment"] & "/localizator.cfm";
			temp.configCheck = FileExists(ExpandPath(temp.configFile));

			// Check if exists and load it
			if ( temp.configCheck ) {
				include temp.configFile;
			}

			// - SET DATASOURCE NAME (dataSourceName)
			// - set(localizatorLanguageDefault="localeid") --> (config/settings.cfm)
			if ( !StructKeyExists(loc, "dataSourceName") || !Len(loc.dataSourceName) ) {
				loc.dataSourceName = temp.application["dataSourceName"];
			}

			// - SET DEFAULT LANGUAGE (localeid)
			// - set(localizatorLanguageDefault="localeid") --> (config/settings.cfm)
			if ( !StructKeyExists(loc, "localizatorLanguageDefault") || !Len(loc.localizatorLanguageDefault) ) {
				loc.localizatorLanguageDefault = CreateObject("java", "java.util.Locale").getDefault().toString();				
			}
			
			// - SET DEFAULT HARVEST FLAG (default to false)
			// - set(localizatorLanguageHarvest=true/false) --> (config/settings.cfm)
			if ( !StructKeyExists(loc, "localizatorLanguageHarvest") || !Len(loc.localizatorLanguageHarvest) ) {
				loc.localizatorLanguageHarvest = false;				
			}
			
			// - SET DEFAULT LOCALIZATION TABLE (default to "localizations")
			// - set(localizatorLanguageTable="NameOfYourLocalizationTable") --> (config/settings.cfm)
			if ( !StructKeyExists(loc, "localizatorLanguageTable") || !Len(loc.localizatorLanguageTable) ) {
				loc.localizatorLanguageTable = "localizations";				
			}

			// - FORCE THE PLUGIN TO GET TRANSLATION FROM LOCALIZATION FILES
			// - set(localizatorGetLocalizationFromFile=true/false) --> (config/settings.cfm)
			if ( !StructKeyExists(loc, "localizatorGetLocalizationFromFile") || !Len(loc.localizatorGetLocalizationFromFile) ) {
				loc.localizatorGetLocalizationFromFile = false;				
			}

			// Add variables to wheels application struct
			temp.application["localizatorLanguageDefault"]         = loc.localizatorLanguageDefault;
			temp.application["localizatorLanguageHarvest"]         = loc.localizatorLanguageHarvest;
			temp.application["localizatorLanguageTable"]           = loc.localizatorLanguageTable;
			temp.application["localizatorGetLocalizationFromFile"] = loc.localizatorGetLocalizationFromFile;

			if ( StructKeyExists(loc, "localizatorLanguageSession") && Len(loc.localizatorLanguageSession) ) {
				temp.application["localizatorLanguageSession"] = loc.localizatorLanguageSession;
			}
			
			loc.plugin = {};
			loc.plugin.author        = "Simon Allard";
			loc.plugin.name          = "localizator";
			loc.plugin.version       = "3.0";
			loc.plugin.compatibility = "1.3";
			loc.plugin.project       = "https://github.com/ellor1138/Localizator";
			loc.plugin.documentation = "https://github.com/ellor1138/Localizator/wiki";
			loc.plugin.issues        = "https://github.com/ellor1138/Localizator/issues";

			// CREATE LIST OF AVAILABLE SERVER LOCALE ID
			temp.serverLocales = CreateObject('java','java.util.Locale').getAvailableLocales();

			loc.localizatorServerLocales = "";

			for (temp.i=1; temp.i <= ArrayLen(temp.serverLocales); temp.i++) {
				loc.localizatorServerLocales = ListAppend(loc.localizatorServerLocales, temp.serverLocales[temp.i].toString());
			}

			loc.localizatorSettings = {};

			loc.localizatorSettings.datasource        = loc.dataSourceName;
			loc.localizatorSettings.languageDefault   = loc.localizatorLanguageDefault;
			loc.localizatorSettings.harvester         = loc.localizatorLanguageHarvest;
			loc.localizatorSettings.localizationTable = loc.localizatorLanguageTable;
			loc.localizatorSettings.getFromFile       = loc.localizatorGetLocalizationFromFile;
			
			loc.localizatorSettings.isAvailableDatabase      = isAvailableDatabase(loc.localizatorSettings.datasource);
			loc.localizatorSettings.isAvailableDatabaseTable = isAvailableDatabaseTable(loc.localizatorSettings.isAvailableDatabase,loc.localizatorSettings.datasource,loc.localizatorLanguageTable);

			if ( loc.localizatorSettings.isAvailableDatabase && loc.localizatorSettings.isAvailableDatabaseTable ){
				loc.localizatorSettings.isDB = true;
			
			} else {
				loc.localizatorSettings.isDB        = false;
				loc.localizatorSettings.getFromFile = true;
			}

			loc.localizatorSettings.folder = {};
			loc.localizatorSettings.folder.plugins    = "plugins/localizator/";
			loc.localizatorSettings.folder.locales    = loc.localizatorSettings.folder.plugins & "locales";
			loc.localizatorSettings.folder.repository = loc.localizatorSettings.folder.plugins & "repository";
			
			loc.localizatorSettings.languages = {};
			loc.localizatorSettings.languages.database = getLanguagesDatabase(loc.localizatorSettings.isAvailableDatabaseTable,loc.localizatorSettings.datasource,loc.localizatorLanguageTable,loc.localizatorServerLocales);
			loc.localizatorSettings.languages.locales  = getLanguagesFiles(loc.localizatorSettings.languageDefault, loc.localizatorSettings.folder.locales, loc.localizatorServerLocales);
			
			loc.localizatorSettings.files = {};
			loc.localizatorSettings.files.repository = getFileRepository(loc.localizatorSettings.folder.repository);
			loc.localizatorSettings.files.locales    = getFileLocales(loc.localizatorSettings.folder.locales, loc.localizatorSettings.languages.locales, loc.localizatorSettings.languages.database);

			return loc;
		}

		public function getLocalizatorPluginSettings() {
			var loc = {};

			loc.config        = application.localizator.localizatorsettings;
			loc.config.plugin = application.localizator.plugin;

			return loc.config;
		}

		/* ---------------------------------------------------------------------------------------------------
		 * @hint Shortcut to localizeme function
		 * ---------------------------------------------------------------------------------------------------
		*/
		public string function l(required string text, string localeid) {
			return localizeme(argumentCollection=arguments);
		}

		/* ---------------------------------------------------------------------------------------------------
		 * @hint Public function to init text translation
		 * ---------------------------------------------------------------------------------------------------
		*/
		public string function localizeme(required string text, string localeid) {
			var loc = {};

			// REPLACE DOUBLE CURLY BRACKET WITH SINGLE CURLY BRACKET
			// --> Convention is to put dynamic text (variable) between single curly brackets.
			// --> localizeme("{#Now()#}") will return {{ts '2012-12-14 13:38:04'}}
			loc.text     = ReplaceNoCase(ReplaceNoCase(arguments.text, "{{", "{"), "}}", "}");
			loc.original = loc.text;

			// SET TRANSLATION LANGUAGE
			if ( isDefined("arguments.localeid") && Len(arguments.localeid) ) {
				loc.localeid = arguments.localeid; // Language passed by function
			
			} else if ( isDefined("application.localizator.localizatorLanguageSession") && isStruct(session) && isDefined("session." & application.localizator.localizatorLanguageSession) ) {
				loc.localeid = StructGet("session." & application.localizator.localizatorLanguageSession); // Language from session
			
			} else {
				loc.localeid = application.localizator.localizatorLanguageDefault; // Language from default settings
			}

			loc.localized = initLocalization(loc);

			return loc.localized.text;
		}

		/* ---------------------------------------------------------------------------------------------------
		 * @hint Public function to get struct of languages
		 * ---------------------------------------------------------------------------------------------------
		*/
		public any function localizatorGetLanguages(string localeid) {
			var loc = {};

			loc.languages = {};
			loc.database  = application.localizator.localizatorSettings.languages.database;
			loc.files     = application.localizator.localizatorSettings.languages.locales;

			loc.locales = ListLen(loc.database) GT ListLen(loc.files) ? loc.database : loc.files;

			if ( isDefined("arguments.localeid") && Len(arguments.localeid) ) {
				loc.localeid = arguments.localeid; // Language passed by function
			
			} else if ( isDefined("application.localizator.localizatorLanguageSession") && isStruct(session) && isDefined("session." & application.localizator.localizatorLanguageSession) ) {
				loc.localeid = StructGet("session." & application.localizator.localizatorLanguageSession); // Language from session
			
			} else {
				loc.localeid = application.localizator.localizatorLanguageDefault; // Language from default settings
			}

			if ( ListLen(loc.locales) ) {
				for (loc.i = 1; loc.i <= ListLen(loc.locales); loc.i++) {
					StructInsert(loc.languages, ListGetAt(loc.locales, loc.i), capitalize(GetLocaleDisplayName(ListGetAt(loc.locales, loc.i), loc.localeid)));
				}
			}

			return loc.languages;
		}

		/* ---------------------------------------------------------------------------------------------------
		 * @hint Return aa struct of available server locales
		 * ---------------------------------------------------------------------------------------------------
		*/
		public any function localizatorGetAvailableLocaleid(string localeid) {
			var loc = {};

			loc.locales = {};

			if ( isDefined("arguments.localeid") && Len(arguments.localeid) ) {
				loc.localeid = arguments.localeid; // Language passed by function
			
			} else if ( isDefined("application.localizator.localizatorLanguageSession") && isStruct(session) && isDefined("session." & application.localizator.localizatorLanguageSession) ) {
				loc.localeid = StructGet("session." & application.localizator.localizatorLanguageSession); // Language from session
			
			} else {
				loc.localeid = application.localizator.localizatorLanguageDefault; // Language from default settings
			}

			for (loc.i = 1; loc.i <= ListLen(application.localizator.localizatorServerLocales); loc.i++) {
				StructInsert(loc.locales, ListGetAt(application.localizator.localizatorServerLocales, loc.i), capitalize(GetLocaleDisplayName(ListGetAt(application.localizator.localizatorServerLocales, loc.i), loc.localeid)));
			}

			return loc.locales;
		}

		/* ---------------------------------------------------------------------------------------------------
		 * @hint Create localeid column in database table & add localeid file to locales folder
		 * ---------------------------------------------------------------------------------------------------
		*/
		public any function localizatorAddLocaleid(required string localeid) {
			var loc = {};

			loc.result  = false;
			loc.columns = model(application.localizator.localizatorLanguageTable).columnNames();
			loc.file    = ExpandPath(application.localizator.localizatorSettings.folder.locales & "\" & arguments.localeid & ".cfm");

			// Add localeid column to table
			if ( application.localizator.localizatorSettings.isAvailableDatabaseTable && !ListFind(loc.columns, arguments.localeid) ) {
				loc.query = New Query(); 

				loc.query.setAttributes(
					dataSource=get("dataSourceName"),
					SQL="ALTER TABLE localizations ADD #arguments.localeid# VarChar(MAX)"
				);
				
				loc.query  = loc.query.execute();
				loc.result = true;
			}
			
			// Add localeid file to locales folder
			if ( !FileExists(loc.file) ) {
				loc.file = createFile(loc.file);
				loc.read = FileRead(application.localizator.localizatorSettings.files.repository);
				
				FileWrite(loc.file, loc.read);

				loc.result = true;
			}
			
			application.localizator = initLocalizatorPluginSettings();

			return loc.result;
		}

		/* ---------------------------------------------------------------------------------------------------
		 * @hint Delete localeid from databaase & locales folder
		 * ---------------------------------------------------------------------------------------------------
		*/
		public any function localizatorDeleteLocaleid(required string localeid) {
			var loc = {};

			loc.result  = false;
			loc.columns = model(application.localizator.localizatorLanguageTable).columnNames();
			loc.file 	= ExpandPath(application.localizator.localizatorSettings.folder.locales & "\" & arguments.localeid & ".cfm");

			// Delete localeid column from table
			if ( application.localizator.localizatorSettings.isAvailableDatabaseTable && ListFind(loc.columns, arguments.localeid) ) {
				loc.query = New Query(); 

				loc.query.setAttributes(
					dataSource=get("dataSourceName"),
					SQL="ALTER TABLE localizations DROP COLUMN #arguments.localeid#"
				);
				
				loc.query  = loc.query.execute();
				loc.result = true;
			}

			// Delete localeid file from locales folder
			if ( FileExists(loc.file) ) {
				FileDelete(loc.file);

				loc.result = true;
			}

			application.localizator = initLocalizatorPluginSettings();
			
			return loc.result;
		}

		/* ---------------------------------------------------------------------------------------------------
		 * Public function to translated error messages
		 * ---------------------------------------------------------------------------------------------------
		*/
		public void function localizatorCheckForErrors(required struct object, string localeid){
			var loc = {};
			
			loc.obj = arguments.object;
			
			if ( isDefined("arguments.localeid") && Len(arguments.localeid) ) {
				loc.localeid = arguments.localeid; // Language passed by function
			
			} else if ( isDefined("application.localizator.localizatorLanguageSession") && isStruct(session) && isDefined("session." & application.localizator.localizatorLanguageSession) ) {
				loc.localeid = StructGet("session." & application.localizator.localizatorLanguageSession); // Language from session
			
			} else {
				loc.localeid = application.localizator.localizatorLanguageDefault; // Language from default settings
			}
	
			if ( loc.obj.errorCount() ) {
				loc.errors = loc.obj.allErrors();
				
				for (loc.struct IN loc.errors) {
					for (loc.key IN loc.struct) {
						if ( loc.key == "message" ) {
							StructInsert(loc.struct, "message", l(StructFind(loc.struct, "message"), loc.localeid), 1);
						}
					}
				}
			}	
		}

		/* ---------------------------------------------------------------------------------------------------
		 * @hint Return localized structure
		 * ---------------------------------------------------------------------------------------------------
		*/
		public struct function initLocalization(required struct localize) {
			var loc = arguments;

			if ( application.localizator.localizatorSettings.harvester && (get("environment") == "Design" || get("environment") == "Development") ) {
				loc.localized = addText(argumentCollection=loc.localize);
			
			} else {
				loc.localized = getText(argumentCollection=loc.localize);
			}

			return loc.localized;
		}

		/* ---------------------------------------------------------------------------------------------------
		 * @hint Return text translation
		 * ---------------------------------------------------------------------------------------------------
		*/
		public struct function getText(required string text, required string localeid) {
			var loc = arguments;

			loc.original  = loc.text;
			loc.isDynamic = isDynamic(loc.text);
			loc.database  = {}; 
			loc.file      = {};

			if ( loc.isDynamic ) {
				loc.text = replaceVariable(loc.text);
			}

			if ( !application.localizator.localizatorGetLocalizationFromFile && ListLen(application.localizator.localizatorSettings.languages.database) && ListFindNoCase(application.localizator.localizatorSettings.languages.database, loc.localeid) ) {
				loc.database.check = checkTextInDatabase(loc.text, loc.localeid);
				
				if ( loc.database.check.recordCount && Len(loc.database.check.textTranslation) ) {
					loc.text = loc.database.check.textTranslation;
					loc.foundInDatabase = 1;
				}
			}

			if ( !isDefined("loc.foundInDatabase") && ListLen(application.localizator.localizatorSettings.languages.locales) && ListFindNoCase(application.localizator.localizatorSettings.languages.locales, loc.localeid) ) {
				loc.file.filePath = ExpandPath(application.localizator.localizatorSettings.folder.locales & "\" & loc.localeid & ".cfm");
				loc.file.struct   = includePluginFile(loc.file.filePath, 1);
				loc.file.check    = checkTextInFile(loc.file.struct, loc.text);
				
				if ( loc.file.check && Len(loc.file.struct[loc.text]) ) {
					loc.text = loc.file.struct[loc.text];
					loc.file.foundInLocalizationFile = 1;
				}
			}

			if ( loc.isDynamic ) {
				loc.text = replaceVariable(loc.text, loc.original);
			}

			return loc;
		}


		/* ---------------------------------------------------------------------------------------------------
		 * @hint Add text to database and/or locales files
		 * ---------------------------------------------------------------------------------------------------
		*/
		public struct function addText(required string original, required string text) {
			var loc = arguments;

			loc.isDynamic = isDynamic(loc.text);
			loc.database  = {}; 
			loc.file      = {};

			if ( loc.isDynamic ) {
				loc.text = replaceVariable(loc.text);
			}

			if ( ListLen(application.localizator.localizatorSettings.languages.database) ) {
				loc.database.check = checkTextInDatabase(loc.text);
				
				if ( !loc.database.check.recordCount ) {
					loc[get("localizatorLanguageDefault")] = loc.text;
					loc.database.obj = model(application.localizator.localizatorSettings.localizationTable).create(loc);
				}
			}

			loc.text_default   = '<cfset loc["' & loc.text & '"] = "">';
			loc.text_localized = '<cfset loc["' & loc.text & '"] = "' & loc.text & '">';

			if ( ListLen(application.localizator.localizatorSettings.files.repository) ) {
				loc.file.filePath = application.localizator.localizatorSettings.files.repository;
				loc.file.struct   = includePluginFile(loc.file.filePath);
				loc.file.check    = checkTextInFile(loc.file.struct, loc.text);
				
				if ( !loc.file.check ) {
					loc.file.textAppend = appendTextToFile(loc.file.filePath, loc.text_default);
				}
			}

			if ( ListLen(application.localizator.localizatorSettings.files.locales) ) {
				for (loc.i = 1; loc.i <= ListLen(application.localizator.localizatorSettings.files.locales); loc.i++) {
					loc.file.filePath = ListGetAt(application.localizator.localizatorSettings.files.locales, loc.i);
					loc.file.struct   = includePluginFile(loc.file.filePath);
					loc.file.check    = checkTextInFile(loc.file.struct, loc.text);
					loc.language      = ReplaceNoCase(Mid(loc.file.filePath, loc.file.filePath.lastIndexOf("\")+2, loc.file.filePath.lastIndexOf(".")), ".cfm", "");
					
					if ( !loc.file.check ) {
						if ( loc.language == application.localizator.localizatorLanguageDefault ) {
							loc.file.textAppend = appendTextToFile(loc.file.filePath, loc.text_localized);
						
						} else {
							loc.file.textAppend = appendTextToFile(loc.file.filePath, loc.text_default);
						}
					}

				}
			}

			if ( loc.isDynamic ) {
				loc.text = replaceVariable(loc.text, loc.original);
			}

			return loc;
		}

		/* ---------------------------------------------------------------------------------------------------
		 * @hint  Append text to locale file
		 * ---------------------------------------------------------------------------------------------------
		*/	
		public struct function appendTextToFile(required string filePath, required string text) {
			var loc = arguments;

			loc.file = FileOpen(loc.filePath, "append", "utf-8");

			FileWriteLine(loc.file, loc.text);

			FileClose(loc.file);

			return loc;
		}

		/* ---------------------------------------------------------------------------------------------------
		 * @hint  Check text in database
		 * ---------------------------------------------------------------------------------------------------
		*/	
		public query function checkTextInDatabase(required string text, string localeid) {
			var loc = arguments;

			if ( isDefined("loc.localeid") ) {
				loc.qr = model(application.localizator.localizatorSettings.localizationTable).findOne(select="#loc.localeid# AS textTranslation", where="text='#loc.text#'", returnAs="query");
			
			} else{
				loc.qr = model(application.localizator.localizatorSettings.localizationTable).findOne(where="text='#loc.text#'", returnAs="query");
			}

			return loc.qr;
		}

		/* ---------------------------------------------------------------------------------------------------
		 * @hint  Check text in file
		 * ---------------------------------------------------------------------------------------------------
		*/	
		public boolean function checkTextInFile(required struct fileContent, required string text) {
			var loc = arguments;

			if ( StructKeyExists(loc.fileContent, loc.text) ) {
				return true;
			
			} else {
				return false;
			}
		}

		/* ---------------------------------------------------------------------------------------------------
		 * @hint  Include plugin file
		 * ---------------------------------------------------------------------------------------------------
		*/		
		public struct function includePluginFile(required string filePath, required boolean cacheFile=0) {
			var loc      = {};
			var template = ReplaceNoCase(arguments.filePath, ExpandPath(application.localizator.localizatorSettings.folder.plugins), "");

			if ( arguments.cacheFile ) {
				if ( !StructKeyExists(request, "localizator") || !StructKeyExists(request.localizator, "cache") ) {
					request.localizator.cache = {};
				}

				if ( StructKeyExists(request.localizator.cache, template) ) {
					return request.localizator.cache[template];
				
				} else {
					include template;

					request.localizator.cache[template] = Duplicate(loc);

					return loc;
				}

			} else {
				if ( FileExists(ExpandPath("plugins/localizator/" & template)) ){
					include template;
				}

				return loc;
			}
			
		}

		/* ---------------------------------------------------------------------------------------------------
		 * @hint Replace variable text {variable}
		 * ---------------------------------------------------------------------------------------------------
		*/
		public string function replaceVariable(required string text, string original) {
			var loc = {};

			if ( arguments.text DOES NOT CONTAIN "{variable}" && (arguments.text CONTAINS "{" && arguments.text CONTAINS "}") ) {
				loc.textBetweenDynamicText = ReMatch("{(.*?)}", arguments.text);
				loc.iEnd = ArrayLen(loc.textBetweenDynamicText);
				
				for (loc.i = 1; loc.i <= loc.iEnd; loc.i++) {
					loc.text = Replace(arguments.text, loc.textBetweenDynamicText[loc.i], "{variable}", "all");
				}
			
			} else if (arguments.text CONTAINS "{variable}") {
				loc.textBetweenDynamicText = ReMatch("{(.*?)}", arguments.original);
				loc.text = Replace(arguments.text, "{variable}", loc.textBetweenDynamicText[1]);
				loc.text = ReplaceList(loc.text, "{,}", "");
			
			} else {
				loc.text = arguments.text;
			}
			
			return loc.text;
		}

		/* ---------------------------------------------------------------------------------------------------
		 * @hint Create file in plugin folder
		 * ---------------------------------------------------------------------------------------------------
		*/
		public string function createFile(required string filePath) {
			var loc = arguments;

			/* ----------------------------------------------------------------------------
			 * Using Java as there's a bug writing UTF-8 text files with ColdFusion 
			 * http://tim.bla.ir/tech/articles/writing-utf8-text-files-with-coldfusion
			 * ----------------------------------------------------------------------------
			 */
			
			// Create the file stream  
			loc.jFile   = CreateObject("java", "java.io.File").init(loc.filepath);  
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

			return loc.filePath;
		}

		/* ---------------------------------------------------------------------------------------------------
		 * @hint Validate language list against server Locale ID
		 * ---------------------------------------------------------------------------------------------------
		*/
		public string function validateLanguagesList(required string languages="", required string localizatorServerLocales=application.localizator.localizatorServerLocales) {
			var loc = arguments;

			loc.list = "";

			for ( loc.i = 1; loc.i <= ListLen(loc.languages); loc.i++ ) {
				loc.locale = ListGetAt(loc.languages, loc.i);
				
				if ( isValidLocale(loc.locale, arguments.localizatorServerLocales) ) {
					loc.list = ListAppend(loc.list, loc.locale);
				}
			}

			return loc.list;
		}

		/* ---------------------------------------------------------------------------------------------------
		 * @hint Get languages list from database
		 * ---------------------------------------------------------------------------------------------------
		*/
		public string function getLanguagesDatabase(required boolean isAvailableDatabaseTable, required string dataSourceName=application.localizator.dataSourceName, required string localizatorLanguageTable=application.localizator.localizatorLanguageTable, required string localizatorServerLocales=application.localizator.localizatorServerLocales) {
			var loc = arguments;
			
			loc.languages = "";

			if ( loc.isAvailableDatabaseTable ) {
				loc.query = New dbinfo(datasource=arguments.dataSourceName, table=arguments.localizatorLanguageTable).columns();
				
				loc.list      = ValueList(loc.query.column_name);
				loc.languages = validateLanguagesList(loc.list, arguments.localizatorServerLocales);
			}

			return loc.languages;
		}

		/* ---------------------------------------------------------------------------------------------------
		 * @hint Return languages list from localization files in the locales folder
		 * ---------------------------------------------------------------------------------------------------
		*/
		public function getLanguagesFiles(required string localeid, required string folder, required string localizatorServerLocales=application.localizator.localizatorServerLocales) {
			var loc = arguments;
			
			loc.array     = DirectoryList(ExpandPath(loc.folder), false, "name", "*.cfm");
			loc.list      = ReplaceNoCase(ArrayToList(loc.array), ".cfm", "", "ALL");
			loc.languages = validateLanguagesList(loc.list, arguments.localizatorServerLocales);

			return loc.languages;
		}


		/* ---------------------------------------------------------------------------------------------------
		 * @hint Return repository filepath
		 * ---------------------------------------------------------------------------------------------------
		*/
		public function getFileRepository(required string folder) {
			var loc = arguments;
			
			loc.file = ExpandPath(loc.folder & "/repository.cfm");

			if ( !FileExists(loc.file) ) {
				loc.file = createFile(loc.file);
			}

			return loc.file;
		}

		/* ---------------------------------------------------------------------------------------------------
		 * @hint Return locales filepath list
		 * ---------------------------------------------------------------------------------------------------
		*/
		public function getFileLocales(required string folder, required string locales, required string database) {
			var loc = arguments;
			
			loc.list  = "";
			loc.files = "";
			loc.list  = ListAppend(loc.list, loc.locales);
			loc.list  = ListAppend(loc.list, loc.database);
			
			loc.objKeyExists = {};
			loc.arrayNewList = [];

		  	for (loc.i = 1; loc.i <= ListLen(loc.list); loc.i++){
		  		loc.item = ListGetAt(loc.list, loc.i);
		  		
		  		if ( !StructKeyExists(loc.objKeyExists,  loc.item) ) {
					loc.objKeyExists[loc.item] = true;
					loc.file = ExpandPath(loc.folder & "/" & loc.item & ".cfm");
					
					if ( !FileExists(loc.file) ) {
						// loc.file = createFile(loc.file);
					}

					ArrayAppend(loc.arrayNewList, loc.file);
	  			}
		  	}

		  	loc.files = ArrayToList(loc.arrayNewList);

			return loc.files;
		}

		/* ---------------------------------------------------------------------------------------------------
		 * @hint Check if text contains dynamic text
		 * ---------------------------------------------------------------------------------------------------
		*/
		public boolean function isDynamic(required string text) {
			if ( arguments.text CONTAINS "{variable}") {
				return false;
			
			} else {
				return (arguments.text CONTAINS "{" && arguments.text CONTAINS "}");
			}
		}

		/* ---------------------------------------------------------------------------------------------------
		 * @hint Check if Locale ID is available in server
		 * ---------------------------------------------------------------------------------------------------
		*/
		public boolean function isValidLocale(required string locale, required string localizatorServerLocales=application.localizator.localizatorServerLocales) {
			return ListFindNoCase(arguments.localizatorServerLocales, arguments.locale);
		}

		/* ---------------------------------------------------------------------------------------------------
		 * @hint Check if Localizations table is present
		 * ---------------------------------------------------------------------------------------------------
		*/
		public boolean function isAvailableDatabaseTable(required boolean isAvailableDatabase, required string dataSourceName=application.localizator.dataSourceName, required string localizatorLanguageTable=application.localizator.localizatorLanguageTable) {
			var loc = arguments;

			if ( StructKeyExists(application, "$wheels") ) {
				loc.application = application.$wheels;

			} else if (StructKeyExists(application, "wheels") ) {
				loc.application = application.wheels;
			}

			if ( loc.isAvailableDatabase ) {
				try {
					loc.info = New dbinfo(datasource=arguments.dataSourceName, username=loc.application["dataSourceUserName"], password=loc.application["dataSourcePassword"]);
					
					loc.tables = loc.info.tables();
					loc.tables = ValueList(loc.tables.table_name);

					return YesNoFormat(ListFindNoCase(loc.tables, arguments.localizatorLanguageTable));
				
				} catch ( any error ) {
					return false;
				}
			
			} else {
				return false;
			}
		}

		/* ---------------------------------------------------------------------------------------------------
		 * @hint Check if database is online
		 * ---------------------------------------------------------------------------------------------------
		*/
		public boolean function isAvailableDatabase(required string dataSourceName=application.localizator.dataSourceName) {
			var loc = {};

			if ( StructKeyExists(application, "$wheels") ) {
				loc.application = application.$wheels;

			} else if (StructKeyExists(application, "wheels") ) {
				loc.application = application.wheels;
			}

			try {
				loc.info = New dbinfo(datasource=arguments.dataSourceName, username=loc.application["dataSourceUserName"], password=loc.application["dataSourcePassword"]).version();

				return true;
			
			} catch ( any error ) {
				return false;
			}
		}

		/* ---------------------------------------------------------------------------------------------------
		 * @hint Public functions for plugin front end interface
		 * ---------------------------------------------------------------------------------------------------
		*/

		/* ---------------------------------------------------------------------------------------------------
		 * @hint Get texts from database
		 * ---------------------------------------------------------------------------------------------------
		*/
		public struct function getLocalizationsFromDatabase(required string letter="all"){
			var loc = arguments;

			loc.type = "database";
			
			loc.texts = New query();

			loc.texts.setAttributes(
				datasource=get("dataSourceName"),
				SQL="SELECT DISTINCT LEFT(UPPER(text),1) AS firstLetter FROM #application.localizator.localizatorLanguageTable#"
			);
			
			loc.texts   = loc.texts.execute();
			loc.letters = loc.texts.getResult();
			
			if ( arguments.letter EQ "all") {
				loc.texts = New query();

				loc.texts.setAttributes(
					datasource=get("dataSourceName"),
					SQL="SELECT *, LEFT(UPPER(text),1) as firstLetter FROM #application.localizator.localizatorLanguageTable# ORDER BY text ASC"
				);

				loc.texts = loc.texts.execute();
				loc.texts = loc.texts.getResult();

			} else {
				loc.texts = New query();

				loc.texts.setAttributes(
					datasource=get("dataSourceName"),
					SQL="SELECT *, LEFT(UPPER(text),1) as firstLetter FROM #application.localizator.localizatorLanguageTable# WHERE text LIKE '#loc.letter#%' ORDER BY text ASC"
				);

				loc.texts = loc.texts.execute();
				loc.texts = loc.texts.getResult();
			}

			return loc;
		}

		/* ---------------------------------------------------------------------------------------------------
		 * @hint Get texts from repository
		 * ---------------------------------------------------------------------------------------------------
		*/
		public function getLocalizationsFromFile(required string letter) {
			var loc = arguments;
			
			loc.repository  = "";

			loc.result      = {};
			loc.result.type = "file";

			loc.queryNew    = QueryNew("text,firstLetter", "VarChar,VarChar");

			// Get defailt language translation file (if found)
			if ( YesNoFormat(FindNoCase(application.localizator.localizatorSettings.languageDefault, application.localizator.localizatorSettings.files.locales)) ) {
				loc.file = ListToArray(application.localizator.localizatorSettings.files.locales);

				for ( loc.i IN loc.file ) {
					if ( FindNoCase(application.localizator.localizatorSettings.languageDefault, loc.i) ) {
						loc.repository = includePluginFile(loc.i);

						break;
					}
				}

			// Get default repository file (if no default found)
			} else if ( FileExists(application.localizator.localizatorSettings.files.repository) ) {
				loc.repository = includePluginFile(application.localizator.localizatorSettings.files.repository);

			}

			if ( isStruct(loc.repository) && StructCount(loc.repository) ) {
				loc.i = 0;

				for ( loc.key IN loc.repository ) {
					loc.i++;

					QueryAddRow(loc.queryNew);

					QuerySetCell(loc.queryNew, "text", loc.key, loc.i);
					QuerySetCell(loc.queryNew, "firstLetter", Left(loc.key,1), loc.i);
				}

				if ( loc.letter == "all" ) {
					loc.sql_letters = "SELECT DISTINCT firstLetter FROM QoQ ORDER BY firstLetter ASC";
					loc.sql_texts   = "SELECT * FROM QoQ ORDER BY firstLetter ASC";		
					
				} else {
					loc.sql_letters = "SELECT DISTINCT firstLetter FROM QoQ ORDER BY firstLetter ASC";
					loc.sql_texts   = "SELECT * FROM QoQ WHERE firstLetter = '#loc.letter#' ORDER BY firstLetter ASC";	
				}

				loc.query = new query();

				loc.query.setAttributes(
					dbtype="query",
					QoQ=loc.queryNew,
					SQL=loc.sql_letters
				);
				
				loc.query = loc.query.execute();

				loc.result.letters = loc.query.getResult();
				
				loc.query = new query();

				loc.query.setAttributes(
					dbtype="query",
					QoQ=loc.queryNew,
					SQL=loc.sql_texts
				);
			
				loc.query = loc.query.execute();

				loc.result.texts = loc.query.getResult();

			} else {
				loc.result = "";
			}

			return loc.result;
		}

		/* ---------------------------------------------------------------------------------------------------
		 * @hint Generate localization files from database
		 * ---------------------------------------------------------------------------------------------------
		*/
		public function generateLocalizationDatabase() {
			var loc = {};

			loc.repository = includePluginFile(application.localizator.localizatorSettings.files.repository);
			loc.deleted    = model(application.localizator.localizatorLanguageTable).deleteAll(softDelete=false);

			for ( loc.j IN loc.repository) {
				loc.translation      = {};
				loc.translation.text = loc.j;
				loc.translation      = editTranslation(loc.translation);

				loc.addition = model(application.localizator.localizatorLanguageTable).create(loc.translation);
			}

			loc.count = model(application.localizator.localizatorLanguageTable).count();
			
			if ( loc.count ) {
				return l("The translation of your localization files has been added to the database table");
			
			} else {
				return l("Unable to add the translation of your localization files to the database table");
			}
		}

		/* ---------------------------------------------------------------------------------------------------
		 * @hint Generate localization files from database
		 * ---------------------------------------------------------------------------------------------------
		*/
		public string function generateLocalizationFiles() {
			var loc = {};

			loc.query   = model(application.localizator.localizatorLanguageTable).findAll();
			loc.message = l("No localization files were generated");

			if ( loc.query.recordCount ) {
				loc.texts = "";

				FileDelete(application.localizator.localizatorSettings.files.repository);

				loc.file = createFile(application.localizator.localizatorSettings.files.repository);

				for (loc.x = 1; loc.x <= loc.query.recordCount; loc.x++) {
					loc.text  = loc.query.text[loc.x];
					loc.texts = loc.texts & '<cfset loc["' & loc.text & '"] = "">';
					
					if ( loc.x != loc.query.recordCount ) {
						loc.texts = loc.texts & Chr(13) & Chr(10);
					}
				}

				loc.file_text = appendTextToFile(application.localizator.localizatorSettings.files.repository, loc.texts);

				for (loc.i = 1; loc.i <= ListLen(application.localizator.localizatorSettings.files.locales); loc.i++) {
					loc.texts = "";
					loc.item  = ListGetAt(application.localizator.localizatorSettings.files.locales, loc.i);

					FileDelete(loc.item);

					loc.file     = createFile(loc.item);
					loc.language = ReplaceNoCase(Mid(loc.item, loc.item.lastIndexOf("\")+2, loc.item.lastIndexOf(".")), ".cfm", "");

					for (loc.x = 1; loc.x <= loc.query.recordCount; loc.x++) {
						loc.text  = loc.query.text[loc.x];
						loc.texts = loc.texts & '<cfset loc["' & loc.text & '"] = "' & loc.query[loc.language][loc.x] & '">';
						
						if ( loc.x != loc.query.recordCount ) {
							loc.texts = loc.texts & Chr(13) & Chr(10);
						}
					}

					loc.file_text = appendTextToFile(loc.item, loc.texts);
				}

				loc.message = l("Localization file(s) generated successfully");
			}

			return loc.message;
		}

		/* ---------------------------------------------------------------------------------------------------
		 * @hint Add text & translation to database and/or locales files
		 * ---------------------------------------------------------------------------------------------------
		*/
		public struct function addTranslation(required struct params) {
			var loc = {};

			loc.form = arguments.params.localizationForm;

			if ( !isDefined("loc.form.text") || (isDefined("loc.form.text") && !Len(loc.form.text)) ) {
				redirectTo(back=true, message=l("Text is mandatory"), messageType="error", addList=true);
			}

			loc.text      = loc.form.text;
			loc.isDynamic = isDynamic(loc.text);
			loc.database  = {}; 
			loc.file      = {};
			loc.message   = "";

			if ( loc.isDynamic ) {
				loc.text = replaceVariable(loc.text);
			}

			for ( loc.i IN loc.form ) {
				if ( loc.i == "text" ) {
					loc.text_default = '<cfset loc["' & loc.text & '"] = "">';
					
					if ( ListLen(application.localizator.localizatorSettings.files.repository) ) {
						loc.file.filePath = application.localizator.localizatorSettings.files.repository;
						loc.file.struct   = includePluginFile(loc.file.filePath);
						loc.file.check    = checkTextInFile(loc.file.struct, loc.text);
						
						if ( !loc.file.check ) {
							loc.file.textAppend = appendTextToFile(loc.file.filePath, loc.text_default);
							loc.message = loc.message & l("Text added to <u>repository.cfm</u> successfully.&nbsp;");
						
						} else {
							loc.message = loc.message & l("Text already in your <u>repository</u> file.&nbsp;");
						}
					}

				} else {
					loc.language = ListFindNoCase(application.localizator.localizatorSettings.files.locales, ExpandPath(application.localizator.localizatorSettings.folder.locales & "\" & loc.i & ".cfm"));
					
					if ( loc.language ) {
						if ( loc.isDynamic ) {
							loc.form[loc.i] = replaceVariable(loc.form[loc.i]);
						}
						
						loc.text_localized = '<cfset loc["' & loc.text & '"] = "' & loc.form[loc.i] & '">';
						loc.file.filePath  = ListGetAt(application.localizator.localizatorSettings.files.locales, loc.language);
						loc.file.struct    = includePluginFile(loc.file.filePath);
						loc.file.check     = checkTextInFile(loc.file.struct, loc.text);
						
						if ( !loc.file.check ) {
							loc.file.textAppend = appendTextToFile(loc.file.filePath, loc.text_localized);
							loc.message         = loc.message & l("Text added to <u>{#loc.i#}.cfm</u> successfully.&nbsp;");
						
						} else {
							loc.message = loc.message & l("Text already in your <u>{#loc.i#}.cfm</u> file.&nbsp;");
						}
					}
				}
			}

			if ( ListLen(application.localizator.localizatorSettings.languages.database) ) {
				loc.database.check = checkTextInDatabase(loc.text);
				
				if ( !loc.database.check.recordCount ) {
					loc.form.text    = loc.text;
					loc.database.obj = model(application.localizator.localizatorSettings.localizationTable).create(loc.form);
					loc.message      = loc.message & l("Text added to <u>database</u> successfully.&nbsp;");
				
				} else {
					loc.message = loc.message & l("Text already in your <u>database</u>.&nbsp;");
				}
			}

			if ( Len(loc.message) ) {
				if ( loc.message CONTAINS "already" ) {
					flashInsert(message=loc.message, messageType="error");
				
				} else {
					flashInsert(message=loc.message, messageType="success");
				}
			}

			redirectTo(back=true);
		}

		/* ---------------------------------------------------------------------------------------------------
		 * @hint Edit translation
		 * ---------------------------------------------------------------------------------------------------
		*/
		public struct function editTranslation(required struct params) {
			var loc = arguments;
			
			if ( isDefined("loc.params.key") ) {
				loc.struct        = model(application.localizator.localizatorLanguageTable).findByKey(loc.params.key);
				loc.struct.update = true;
			
			} else if ( isDefined("loc.params.text") ) {
				loc.struct = {};
				loc.text   = loc.params.text;
				
				for (loc.i = 1; loc.i <= ListLen(application.localizator.localizatorSettings.files.locales); loc.i++) {
					loc.file.filePath = ListGetAt(application.localizator.localizatorSettings.files.locales, loc.i);
					loc.language      = ReplaceNoCase(Mid(loc.file.filePath, loc.file.filePath.lastIndexOf("\")+2, loc.file.filePath.lastIndexOf(".")), ".cfm", "");
					loc.file.struct   = includePluginFile(loc.file.filePath);
					loc.file.check    = checkTextInFile(loc.file.struct, loc.text);

					if ( loc.file.check ) {
						loc.struct[loc.language] = StructFind(loc.file.struct, loc.text);
					}
				}
				
				loc.struct.update = true;
				loc.struct.text   = loc.text;
			
			} else {
				loc.struct = {};
			}

			return loc.struct;
		}

		/* ---------------------------------------------------------------------------------------------------
		 * @hint Update translation in database and/or locales files
		 * ---------------------------------------------------------------------------------------------------
		*/
		public struct function updateTranslation(required struct params) {
			var loc = {};

			loc.form      = arguments.params.localizationForm;
			loc.text      = loc.form.text;
			loc.isDynamic = isDynamic(loc.text);
			loc.database  = {}; 
			loc.file      = {};
			loc.message   = "";

			if ( isDefined("loc.form.key") ) {
				loc.key = loc.form.key;

				StructDelete(loc.form, "key");	
			}
			
			StructDelete(loc.form, "text");

			if ( loc.isDynamic ) {
				loc.text = replaceVariable(loc.text);
			}

			for (loc.i IN loc.form) {
				loc.language = ListFindNoCase(application.localizator.localizatorSettings.files.locales, ExpandPath(application.localizator.localizatorSettings.folder.locales & "\" & loc.i & ".cfm"));

				if ( loc.language ) {
					if ( loc.isDynamic ) {
						loc.form[loc.i] = replaceVariable(loc.form[loc.i]);
					}

					loc.text_localized = '<cfset loc["' & loc.text & '"] = "' & loc.form[loc.i] & '">';
					loc.file.filePath  = ListGetAt(application.localizator.localizatorSettings.files.locales, loc.language);
					loc.file.struct    = includePluginFile(loc.file.filePath);
					loc.file.check     = checkTextInFile(loc.file.struct, loc.text);

					if ( !loc.file.check ) {
						loc.file.textAppend = appendTextToFile(loc.file.filePath, loc.text_localized);
						loc.message         = loc.message & l("Text added to <u>{#loc.i#}.cfm</u> successfully.&nbsp;");
					
					} else if ( IsStruct(loc.file.struct) ) {
						loc.textLine  = "";
						loc.file.open = FileOpen(loc.file.filePath, "read", "utf-8");

						while (!FileIsEOF(loc.file.open)) {
							loc.line       = FileReadLine(loc.file.open);
							loc.textArray  = ReMatch('\[(.*?)\]', loc.line);
							loc.textParsed = ReplaceNoCase(ReplaceNoCase(ArrayToList(loc.textArray,"~"), '["', '', 'all'), '"]', '', 'all');

							if ( loc.textParsed == loc.text ) {
								loc.localizedTextFound = 1;
								loc.textLine = loc.textLine & loc.text_localized & Chr(13) & Chr(10);
							
							} else {
								loc.textLine = loc.textLine & loc.line & Chr(13) & Chr(10);
							}
						}

						FileClose(loc.file.open);

						if ( isDefined("loc.localizedTextFound") && loc.localizedTextFound ) {
							FileWrite(loc.file.filePath, loc.textLine, "utf-8");
							loc.message = loc.message & l("<u>{#loc.i#}.cfm</u> file updated successfully.&nbsp;");
						}
					}
				}
			}

			if ( ListLen(application.localizator.localizatorSettings.languages.database) ) {
				loc.database.obj = model(application.localizator.localizatorLanguageTable).findByKey(loc.key);
				
				if ( loc.database.obj.update(loc.form) ) {
					loc.message = loc.message & l("<u>Database</u> updated successfully.&nbsp;");
				}
			}

			if ( Len(loc.message) ) {
				flashInsert(message=loc.message, messageType="success");
			}

			redirectTo(back=true);
		}

		/* ---------------------------------------------------------------------------------------------------
		 * @hint Delete translation in database and/or locales files
		 * ---------------------------------------------------------------------------------------------------
		*/
		public struct function deleteTranslation(required struct params) {
			var loc = arguments;

			loc.database  = {}; 
			loc.file      = {};
			loc.message   = "";

			if ( isDefined("loc.params.key") && isNumeric(loc.params.key)) {
				loc.key = loc.params.key;
				
				if ( ListLen(application.localizator.localizatorSettings.languages.database) ) {
					loc.database.obj = model(application.localizator.localizatorLanguageTable).findByKey(loc.key);
					loc.text         = loc.database.obj.text;

					if ( loc.database.obj.delete(softDelete=false) ) {
						loc.message = loc.message & l("Text in <u>database</u> deleted successfully. ");
					}
				}
			}
			
			if ( isDefined("loc.params.text") && Len(loc.params.text) ) {
				loc.text = loc.params.text;
			}

			if ( ListLen(application.localizator.localizatorSettings.files.repository) ) {
				loc.file.filePath = application.localizator.localizatorSettings.files.repository;
				loc.file.struct   = includePluginFile(loc.file.filePath);
				loc.file.check    = checkTextInFile(loc.file.struct, loc.text);
				
				if ( loc.file.check ) {
					loc.textLine  = "";
					loc.file.open = FileOpen(loc.file.filePath, "read", "utf-8");

					while (!FileIsEOF(loc.file.open)) {
						loc.line       = FileReadLine(loc.file.open);
						loc.textArray  = ReMatch('\[(.*?)\]', loc.line);
						loc.textParsed = ReplaceNoCase(ReplaceNoCase(ArrayToList(loc.textArray,"~"), '["', '', 'all'), '"]', '', 'all');

						if ( loc.textParsed == loc.text ) {
							loc.foundInRepository = 1;
						
						} else {
							loc.textLine = loc.textLine & loc.line & Chr(13) & Chr(10);
						}
					}

					FileClose(loc.file.open);

					if ( isDefined("loc.foundInRepository") && loc.foundInRepository ) {
						FileWrite(loc.file.filePath, loc.textLine, "utf-8");
						loc.message = loc.message & l("Text in <u>repository.cfm</u> file deleted successfully. ");
					}
				}
			}

			for (loc.i = 1; loc.i <= ListLen(application.localizator.localizatorSettings.files.locales); loc.i++) {
				loc.foundInLocaleFile = 0;
				loc.file.filePath     = ListGetAt(application.localizator.localizatorSettings.files.locales, loc.i);
				loc.language          = ReplaceNoCase(Mid(loc.file.filePath, loc.file.filePath.lastIndexOf("\")+2, loc.file.filePath.lastIndexOf(".")), ".cfm", "");
				loc.file.struct       = includePluginFile(loc.file.filePath);
				loc.file.check        = checkTextInFile(loc.file.struct, loc.text);

				if ( loc.file.check ) {
					loc.textLine  = "";
					loc.file.open = FileOpen(loc.file.filePath, "read", "utf-8");

					while (!FileIsEOF(loc.file.open)) {
						loc.line       = FileReadLine(loc.file.open);
						loc.textArray  = ReMatch('\[(.*?)\]', loc.line);
						loc.textParsed = ReplaceNoCase(ReplaceNoCase(ArrayToList(loc.textArray,"~"), '["', '', 'all'), '"]', '', 'all');

						if ( loc.textParsed == loc.text ) {
							loc.foundInLocaleFile = 1;
						
						} else {
							loc.textLine = loc.textLine & loc.line & Chr(13) & Chr(10);
						}
					}

					FileClose(loc.file.open);

					if ( loc.foundInLocaleFile ) {
						FileWrite(loc.file.filePath, loc.textLine, "utf-8");
						loc.message = loc.message & l("Text in <u>{#loc.language#}.cfm</u> file deleted successfully. ");
					}
				}
			}

			if ( Len(loc.message) ) {
				flashInsert(message=loc.message, messageType="success");
			}

			redirectTo(back=true);
		}
	}
</cfscript>