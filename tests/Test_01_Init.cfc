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

		public function test_01_verify_plugin_settings() {
			assert('IsStruct(loc.config)');

			assert('StructKeyExists(loc.config, "plugin")');
			assert('IsStruct(loc.config.plugin)');
			assert('StructKeyExists(loc.config.plugin,"author")');
			assert('StructKeyExists(loc.config.plugin,"name")');
			assert('StructKeyExists(loc.config.plugin,"version")');
			assert('StructKeyExists(loc.config.plugin,"compatibility")');
			assert('StructKeyExists(loc.config.plugin,"project")');
			assert('StructKeyExists(loc.config.plugin,"documentation")');
			assert('StructKeyExists(loc.config.plugin,"issues")');

			assert('StructKeyExists(loc.config, "datasource")');
			assert('StructKeyExists(loc.config, "languageDefault")');
			assert('StructKeyExists(loc.config, "harvester")');
			assert('StructKeyExists(loc.config, "localizationTable")');
			assert('StructKeyExists(loc.config, "getFromFile")');
			assert('isBoolean(loc.config.getFromFile)');

			assert('StructKeyExists(loc.config, "isAvailableDatabase")');
			assert('isBoolean(loc.config.isAvailableDatabase)');

			assert('StructKeyExists(loc.config, "isAvailableDatabaseTable")');
			assert('isBoolean(loc.config.isAvailableDatabaseTable)');

			assert('StructKeyExists(loc.config, "isDB")');
			assert('isBoolean(loc.config.isDB)');

			assert('StructKeyExists(loc.config, "folder")');
			assert('isStruct(loc.config.folder)');
			assert('StructKeyExists(loc.config.folder, "plugins")');
			assert('StructKeyExists(loc.config.folder, "locales")');
			assert('StructKeyExists(loc.config.folder, "repository")');

			assert('StructKeyExists(loc.config, "languages")');
			assert('isStruct(loc.config.languages)');
			assert('StructKeyExists(loc.config.languages, "database")');
			assert('StructKeyExists(loc.config.languages, "locales")');

			assert('StructKeyExists(loc.config, "files")');
			assert('isStruct(loc.config.files)');
			assert('StructKeyExists(loc.config.files, "repository")');
			assert('StructKeyExists(loc.config.files, "locales")');
		}
		
		public function test_02_plugin_version() {
			assert('loc.config.plugin.version EQ "2.0"');
		}

	}
</cfscript>
