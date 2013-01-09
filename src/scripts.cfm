<cfoutput>
	<cfscript>
		loc = {};

		loc.congig        = {};
		loc.message       = {};
		loc.localizations = {};

		loc.config.settings = application.wheels.localizatorSettings;
		loc.config.url      = "#CGI.script_name#?controller=wheels&action=wheels&view=plugins&name=#loc.config.settings.plugin.name#";

		// GET TEXTS
		if ( loc.config.settings.isDB ) {
			loc.localizations = getLocalizationsFromDatabase(params.letter);
			localizationForm  = model(get('localizatorLanguageTable')).new();
		} else {
			loc.localizations = getLocalizationsFromFile(params.letter);
		}

		// GENERATE LOCALIZATION FILES
		if ( isDefined("params.type") && params.type == "generate" && loc.config.settings.isDB ) {
			loc.message.generator = generateLocalizationFiles();
		}

		// ADD LOCALIZATION
		if ( isDefined("params.type") && params.type == "add") {
			localizationForm = addTranslation(params);
		}

		// EDIT LOCALIZATION
		if ( isDefined("params.type") && params.type == "edit" ) {
			localizationForm = editTranslation(params);
		}

		// UPDATE LOCALIZATION
		if ( isDefined("params.type") && params.type == "update") {
			localizationForm = updateTranslation(params);
		}

		// DELETE LOCALIZATION
		if ( isDefined("params.type") && params.type == "delete" ) {
			localizationForm = deleteTranslation(params);
		}
	</cfscript>
</cfoutput>