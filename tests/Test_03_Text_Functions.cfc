<cfscript>
	component extends="base" {

		public function setup() {
			super.setup();
		}

		public function teardown() {
			super.teardown();
		}

		public function test_00_setup_and_teardown() {
			application.wheels.localizatorSettings.folder.locales = loc.tests_folder_locales;
			// Comment next line if you want to test databse insertion
			assert('true');
		}

		public function test_01_appendTextToFile_append_line_at_end_of_temp_file() {
			a = ExpandPath(loc.tests_folder_temp & "You_can_delete_me.cfm");
			b = "Line added! (#Now()#)";
			a = pluginController.appendTextToFile(a,b);
			assert('IsStruct(a)');
			assert('StructKeyExists(a, "file")');
			assert('StructKeyExists(a.file, "mode")');
			assert('a.file.mode EQ "append"');
		}

		public function test_02_addText_add_static_string() {
			a = "Static string";
			a = pluginController.addText(a, a);
			assert('IsStruct(a)');
			assert('StructKeyExists(a, "isDynamic")');
			assert('a.isDynamic EQ false');
		}

		public function test_03_addText_add_dynamic_string() {
			a = "Dynamic string {##variable##}";
			a = pluginController.addText(a, a);
			assert('IsStruct(a)');
			assert('StructKeyExists(a, "isDynamic")');
			assert('a.isDynamic EQ true');
		}

		public function test_04_includePluginFile_include_repository_file_return_as_struct() {
			a = pluginController.includePluginFile(application.wheels.localizatorSettings.files.repository,0);
			assert('IsStruct(a)');
		}

		public function test_05_includePluginFile_include_locales_files_return_as_struct() {
			for (i=1; i <= ListLen(application.wheels.localizatorSettings.files.locales); i++) {
				a = ListGetAt(application.wheels.localizatorSettings.files.locales, 1);
				a = pluginController.includePluginFile(a,0);
				assert('IsStruct(a)');
			}
		}

		public function test_06_checkTextInFile_check_string_in_repository_file_return_true() {
			a = pluginController.includePluginFile(application.wheels.localizatorSettings.files.repository,0);
			a = pluginController.checkTextInFile(a, "Example Dynamic string {variable}");
			assert('a EQ true');
		}

		public function test_07_checkTextInFile_check_string_in_repository_file_return_false() {
			a = pluginController.includePluginFile(application.wheels.localizatorSettings.files.repository,0);
			a = pluginController.checkTextInFile(a, "Example Dynamic string");
			assert('a EQ false');
		}

		public function test_08_getText_get_database_translation_static_string_return_true() {
			a = pluginController.getText('Example Static string','fr_CA');
			assert('isStruct(a)');
			assert('StructKeyExists(a, "database")');
			assert('isStruct(a.database)');
			assert('StructKeyExists(a.database, "check")');
			assert('isQuery(a.database.check)');
			assert('a.database.check.recordCount');
			assert('a.text EQ "Exemple texte statique"');
		}

		public function test_09_getText_get_database_translation_dynamique_string_return_true() {
			variable = "Test!";
			a = pluginController.getText('Example Dynamic string {#variable#}','fr_CA');
			assert('isStruct(a)');
			assert('StructKeyExists(a, "database")');
			assert('isStruct(a.database)');
			assert('StructKeyExists(a.database, "check")');
			assert('isQuery(a.database.check)');
			assert('a.database.check.recordCount');
			assert('a.text EQ "Exemple texte dynamique #variable#"');
		}

		public function test_10_getText_get_file_translation_static_string_return_true() {
			application.wheels.localizatorGetLocalizationFromFile = true;
			a = pluginController.getText('Example Static string','fr_CA');
			assert('isStruct(a)');
			assert('StructKeyExists(a, "file")');
			assert('isStruct(a.file)');
			assert('StructKeyExists(a.file, "check")');
			assert('a.file.check EQ true');
			assert('a.text EQ "Exemple texte statique"');
		}

		public function test_11_getText_get_file_translation_dynamique_string_return_true() {
			variable = "Test!";
			a = pluginController.getText('Example Dynamic string {#variable#}','fr_CA');
			assert('isStruct(a)');
			assert('StructKeyExists(a, "file")');
			assert('isStruct(a.file)');
			assert('StructKeyExists(a.file, "check")');
			assert('a.file.check EQ true');
			assert('a.text EQ "Exemple texte dynamique #variable#"');
		}

	}
</cfscript>
