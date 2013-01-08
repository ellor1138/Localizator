<cfoutput>
	<cfscript>
		loc = {};
		
		loc.message       = {};
		loc.localizations = {};
		loc.url           = "#CGI.script_name#?controller=wheels&action=wheels&view=plugins&name=#pluginSettings.plugin.name#";

		// GET TEXTS
		if ( pluginSettings.isDB ) {
			loc.localizations = getLocalizationsFromDatabase(params.letter);
			localizationForm  = model(get('localizatorLanguageTable')).new();
		} else {
			loc.localizations = getLocalizationsFromFile(params.letter);
		}

		// GENERATE LOCALIZATION FILES
		if ( isDefined("params.type") && params.type == "generate" && pluginSettings.isDB ) {
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