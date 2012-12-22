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

			localizator = {};

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

			// - FORCE THE PLUGIN TO GET TRANSLATION FROM LOCALIZATION FILES
			// - set(localizatorGetLocalizationFromFile=true/false) --> (config/settings.cfm)
			if ( !isDefined("application.wheels.localizatorGetLocalizationFromFile") ) {
				application.wheels.localizatorGetLocalizationFromFile = false;
			}

			application.wheels.serverLocales = createObject('java','java.util.Locale').getAvailableLocales();
			application.wheels.localizatorServerLocales = "";

			for (this.i = 1; this.i <= ArrayLen(application.wheels.serverLocales); this.i++) {
				application.wheels.localizatorServerLocales = ListAppend(application.wheels.localizatorServerLocales, application.wheels.serverLocales[this.i].toString());
			}

			StructDelete(application.wheels, "serverLocales");

			this.settings = initPluginSettings();

			return this;
		}

		/* ---------------------------------------------------------------------------------------------------
		 * @hint Return plugin settings
		 * ---------------------------------------------------------------------------------------------------
		*/
		public struct function getPluginSettings() {
			return localizator.settings;
		}

		/* ---------------------------------------------------------------------------------------------------
		 * @hint Init plugin config
		 * ---------------------------------------------------------------------------------------------------
		*/
		public struct function initPluginSettings() {
			var loc = {};
			
			loc.datasource        = application.wheels.dataSourceName;
			loc.languageDefault   = application.wheels.localizatorLanguageDefault;
			loc.harvester         = application.wheels.localizatorLanguageHarvest;
			loc.localizationTable = application.wheels.localizatorLanguageTable;
			loc.getFromFile       = application.wheels.localizatorGetLocalizationFromFile;
			
			loc.isAvailableDatabase      = isAvailableDatabase(loc.datasource);
			loc.isAvailableDatabaseTable = isAvailableDatabaseTable(loc.isAvailableDatabase);

			if ( loc.isAvailableDatabase && loc.isAvailableDatabaseTable ){
				loc.isDB = true;
			} else {
				loc.isDB        = false;
				loc.getFromFile = true;
			}

			loc.folder = {};
			loc.folder.plugins    = "plugins/localizator/";
			loc.folder.locales    = loc.folder.plugins & "locales";
			loc.folder.repository = loc.folder.plugins & "repository";
			
			loc.languages = {};
			loc.languages.database = getLanguagesDatabase(loc.isAvailableDatabaseTable);
			loc.languages.locales  = getLanguagesFiles(loc.folder.locales);
			
			loc.files = {};
			loc.files.repository = getFileRepository(loc.folder.repository);
			loc.files.locales    = getFileLocales(loc.folder.locales, loc.languages.locales, loc.languages.database);

			return loc;
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
			
			} else if ( isDefined("application.wheels.localizatorLanguageSession") && isStruct(session) && isDefined("session." & get('localizatorLanguageSession')) ) {
				loc.localeid = StructGet("session." & get('localizatorLanguageSession')); // Language from user session

			} else {
				loc.localeid = get('localizatorLanguageDefault'); // Language from default settings
			}

			loc.localized = initLocalization(loc);

			return loc.localized.text;
		}

		/* ---------------------------------------------------------------------------------------------------
		 * @hint Return localized structure
		 * ---------------------------------------------------------------------------------------------------
		*/
		public struct function initLocalization(required struct localize) {
			var loc = {};

			loc = arguments;

			if ( localizator.settings.harvester ) {
				loc.localized = addText(argumentCollection=loc.localize);
			} else {
				loc.localized = getText(argumentCollection=loc);
			}

			return loc.localized;
		}

		/* ---------------------------------------------------------------------------------------------------
		 * @hint Return text translation
		 * ---------------------------------------------------------------------------------------------------
		*/
		public string function getText(required string text, required string localeid) {
			var loc = {};

			// ORIGINAL LOCALIZATION REQUEST
			loc.localize          = {};
			loc.localize          = arguments;
			loc.localize.original = arguments.text;

			writeDump(loc);
			abort;
			return loc.localized.text;
		}

		/* ---------------------------------------------------------------------------------------------------
		 * @hint Return text translation
		 * ---------------------------------------------------------------------------------------------------
		*/
		public struct function addText(required string original, required string text) {
			var loc = {};

			loc.localize  = arguments;
			loc.isDynamic = isDynamic(loc.localize.text);
			loc.database  = {}; 
			loc.files     = {};
			loc.text      = loc.localize.text;

			if ( loc.isDynamic ) {
				loc.text = replaceVariable(loc.localize.text);
			}

			if ( ListLen(localizator.settings.languages.database) ) {
				loc.database.check = model(localizator.settings.localizationTable).findOne(where="text='#loc.text#'", returnAs="query");

				if ( !loc.database.check.recordCount ) {
					loc.database.obj = model(localizator.settings.localizationTable).new(loc);
					if ( loc.database.obj.save() ) {
						loc.database.saved = true;
					} else {
						loc.database.saved = false;
					}
				} else {
					loc.database.saved = false;
				}
			}

			loc.string = '<cfset loc["' & loc.text & '"] = "">';
			loc.default = '<cfset loc["' & loc.text & '"] = "' & loc.text & '">';

			if ( ListLen(localizator.settings.files.repository) ) {
				
			}

			if ( ListLen(localizator.settings.files.locales) ) {
				
			}

			writeDump(loc);
			abort;
			return loc;
		}

		/* ---------------------------------------------------------------------------------------------------
		 * @hint Replace variable text {variable}
		 * ---------------------------------------------------------------------------------------------------
		*/
		public string function replaceVariable(required string text) {
			var loc = {};

			if ( arguments.text DOES NOT CONTAIN "{variable}" && arguments.text CONTAINS "{" && arguments.text CONTAINS "}" ) {
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

			
			return loc.filePath;
		}

		/* ---------------------------------------------------------------------------------------------------
		 * @hint Validate language list against server Locale ID
		 * ---------------------------------------------------------------------------------------------------
		*/
		public string function validateLanguagesList(required string languages="") {
			var loc = {};

			loc      = arguments;
			loc.list = "";

			for (loc.i = 1; loc.i <= ListLen(loc.languages); loc.i++) {
				
				loc.locale = ListGetAt(loc.languages, loc.i);
				
				if ( isValidLocale(loc.locale) ) {
					loc.list = ListAppend(loc.list, loc.locale);
				}
			}

			return loc.list;
		}

		/* ---------------------------------------------------------------------------------------------------
		 * @hint Get languages list from database
		 * ---------------------------------------------------------------------------------------------------
		*/
		public string function getLanguagesDatabase(required boolean isAvailableDatabaseTable) {
			var loc = {};
			
			loc.languages = "";

			if ( arguments.isAvailableDatabaseTable ) {
				loc.query     = new dbinfo(datasource=application.wheels.dataSourceName, table=application.wheels.localizatorLanguageTable).columns();
				loc.list      = ValueList(loc.query.column_name);
				loc.languages = validateLanguagesList(loc.list);
			}

			return loc.languages;
		}

		/* ---------------------------------------------------------------------------------------------------
		 * @hint Return languages list from localization files in the locales folder
		 * ---------------------------------------------------------------------------------------------------
		*/
		public function getLanguagesFiles(required string folder) {
			var loc = {};
			
			loc.array = DirectoryList(ExpandPath(arguments.folder), false, "name", "*.cfm");
			loc.list  = ReplaceNoCase(ArrayToList(loc.array), ".cfm","","ALL");
			
			loc.languages = validateLanguagesList(loc.list);
			
			return loc.languages;
		}


		/* ---------------------------------------------------------------------------------------------------
		 * @hint Return repository filepath
		 * ---------------------------------------------------------------------------------------------------
		*/
		public function getFileRepository(required string folder) {
			var loc = {};
			
			loc.file = ExpandPath(arguments.folder & "/repository.cfm");

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
			var loc = {};
			
			loc.list = "";
			loc.list = ListAppend(loc.list, arguments.locales);
			loc.list = ListAppend(loc.list, arguments.database);
			loc.array = ListToArray(loc.list);

			loc.files = "";
		  	
		  	for (loc.i = 1; loc.i LTE ArrayLen(loc.array); loc.i++) {
		  		if ( !ListFindNoCase(loc.files, loc.array[loc.i]) ) {
		  			loc.files = ListAppend(loc.files, loc.array[loc.i] & ".cfm");
		  		}
		  	}

			for (loc.i = 1; loc.i <= ListLen(loc.files); loc.i++) {
				loc.file = ExpandPath(arguments.folder & "/" & ListGetAt(loc.files,loc.i));

				if ( !FileExists(loc.file) ) {
					loc.file = createFile(loc.file);
				}

				loc.files = ListSetAt(loc.files, loc.i, loc.file);
			}

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
		public boolean function isValidLocale(required string locale) {
			return ListFindNoCase(application.wheels.localizatorServerLocales, arguments.locale);
		}

		/* ---------------------------------------------------------------------------------------------------
		 * @hint Check if Localizations table is present
		 * ---------------------------------------------------------------------------------------------------
		*/
		public boolean function isAvailableDatabaseTable(required boolean isAvailableDatabase) {
			var loc = {};
			
			if ( arguments.isAvailableDatabase ) {
				try {
					loc.info = new dbinfo(datasource=application.wheels.dataSourceName, username=application.wheels.dataSourceUserName, password=application.wheels.dataSourcePassword).tables();
					return YesNoFormat(FindNoCase(application.wheels.localizatorLanguageTable, ValueList(loc.info.table_name)));
				} catch ( any e ) {
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
		public boolean function isAvailableDatabase() {
			var loc = {};

			try {
				loc.info = new dbinfo(datasource=application.wheels.dataSourceName, username=application.wheels.dataSourceUserName, password=application.wheels.dataSourcePassword).version();
				return true;
			} catch ( any erroe ) {
				return false;
			}
		}

	}
</cfscript>