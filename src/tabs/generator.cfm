﻿<cfoutput>
	<div class="tab-pane" id="Generator">
		<ul>
			<li>You can generate your localizations files from the data of your localization table.
				<ul>
					<li>The localization files will be saved in the locales folder.<br />--> /plugins/localizator/locales/</li>
					<li>A new repository file will also be created in the repository folder.<br />--> /plugins/localizator/repository/</li>
					<li>Be aware that the previous repository and localization files will be overwritten.</li>
				</ul>
			</li>
		</ul>
		<hr />
		<div class="well well-small" style="text-align:center; margin-bottom:0;">
			<span class="label label-inverse">Important</span> &nbsp;&nbsp;The generator is only available if you have setup a datasource and a localization table.
		</div>
	</div>
</cfoutput>