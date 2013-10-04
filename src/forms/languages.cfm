<cfoutput>
		<h4>Add new language</h4>
		<form action="#loc.config.url###addLanguage" method="post" name="addLanguage" class="form-horizontal">
			<input type="hidden" name="type" value="addLanguage">
			#selectTag(name="locales[localeid]", options=localizatorGetAvailableLocaleid(), class="span5")#
			<input type="submit" value="Add" class="btn pull-right">
		</form>

		<h4>Delete language</h4>
		<form action="#loc.config.url###deleteLanguage" method="post" name="deleteLanguage" class="form-horizontal">
			<input type="hidden" name="type" value="deleteLanguage">
			#selectTag(name="locales[localeid]", options=localizatorGetLanguages(), class="span5")#
			<input type="submit" value="Delete" class="btn pull-right">
		</form>
</cfoutput>