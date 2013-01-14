<cfscript>
	component extends="wheelsMapping.Test" {
		public function setup() {
			loc.orgApp = Duplicate(application);

			loc.tests_folder            = "plugins/Localizator/tests/";
			loc.tests_folder_locales    = "plugins/Localizator/tests/locales/";
			loc.tests_folder_repository = "plugins/Localizator/tests/repository/";
			loc.tests_folder_temp       = "plugins/Localizator/tests/temp/";

			params = {controller="foo", action="bar"};

			pluginController = controller("localizator", params);

			loc.config = pluginController.initPluginSettings();
		}

		public function teardown() {
			application = loc.orgApp;
		}
	}
</cfscript>