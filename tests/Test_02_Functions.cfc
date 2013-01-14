<cfscript>
	component extends="base" {

		public function setup() {
			super.setup();
		}

		public function teardown() {
			super.teardown();
		}

		public function test_00_setup_and_teardown() {
			assert('true');
		}

		public function test_01_isAvailableDatabase_return_boolean() {
			loc.config.isAvailableDatabase = pluginController.isAvailableDatabase();
			assert('isBoolean(loc.config.isAvailableDatabase)');
		}

		public function test_02_isAvailableDatabaseTable_return_boolean() {
			loc.config.isAvailableDatabaseTable = pluginController.isAvailableDatabaseTable(loc.config.isAvailableDatabase);
			assert('isBoolean(loc.config.isAvailableDatabaseTable)');
		}

		public function test_03_createFile_create_temp_file() {
			a = ExpandPath(loc.tests_folder_temp & "You_can_delete_me.cfm");
			a = pluginController.createFile(a);
			assert('FileExists(a)');
		}

		public function test_04_isDynamic_function_return_false() {
			a = pluginController.isDynamic("Hello");
			assert('a EQ false');
		}

		public function test_04_isDynamic_function_return_true() {
			a = pluginController.isDynamic("Hello {#Now()#}");
			assert('a EQ true');
		}

		public function test_05_isValidLocale_return_true() {
			a = pluginController.isValidLocale("fr_CA");
			assert('a NEQ 0');
		}

		public function test_06_isValidLocale_return_false() {
			a = pluginController.isValidLocale("en_CO");
			assert('a EQ 0');
		}

		public function test_07_getFileRepository_check_repository_file_presence() {
			loc.config.files.repository = pluginController.getFileRepository(loc.tests_folder_repository);
			application.wheels.localizatorSettings.files.repository = loc.config.files.repository;
			assert('FileExists(loc.config.files.repository)');

		}

		public function test_08_getFileLocales_check_localization_files_presence() {
			loc.config.files.locales = pluginController.getFileLocales(loc.tests_folder_locales, loc.config.languages.locales, loc.config.languages.database);
			application.wheels.localizatorSettings.files.locales = loc.config.files.locales;
			assert('ListLen(loc.config.files.locales) NEQ 0');
		}

		public function test_10_getLanguagesDatabase_return_database_languages() {
			loc.config.languages.database = pluginController.getLanguagesDatabase(loc.config.isAvailableDatabaseTable);
			assert('ListLen(loc.config.languages.database) NEQ 0') ;
		}

		public function test_11_getLanguagesFiles_return_localization_files_languages() {
			loc.config.languages.locales = pluginController.getLanguagesFiles(loc.config.languageDefault, loc.tests_folder_locales);
			assert('ListLen(loc.config.languages.locales) NEQ 0');
		}

		public function test_12_validateLanguagesList_return_same_num_as_arguments() {
			a = pluginController.validateLanguagesList(loc.config.languages.locales);
			assert('ListLen(a) EQ ListLen(loc.config.languages.locales)');
		}

		public function test_13_validateLanguagesList_remove_non_valid_localeid() {
			a = loc.config.languages.locales & ",en_CO,fr_CO";
			a = pluginController.validateLanguagesList(a);
			assert('ListLen(a) EQ ListLen(loc.config.languages.locales)');
		}

		public function test_14_replaceVariable_replace_variable_with_placeholder() {
			a = "This is a dynamic string: {#CreateUUID()#}";
			a = pluginController.replaceVariable(a);
			assert('a CONTAINS "{variable}"');
		}

		public function test_15_replaceVariable_replace_placeholder_with_original_variable() {
			a = "This is a dynamic string: {#CreateUUID()#}";
			b = pluginController.replaceVariable(a);
			c = pluginController.replaceVariable(b,a);
			assert('c DOES NOT CONTAIN "{variable}"');
			assert('c DOES NOT CONTAIN "{"');
			assert('c DOES NOT CONTAIN "}"');
		}
	}
</cfscript>
