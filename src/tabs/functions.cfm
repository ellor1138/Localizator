<cfoutput>
	<div class="tab-pane" id="Functions">
		<ul>
			<li><b>localizatorGetLanguages()</b>
				<div style="margin-top:10px;">This function will return a struct that you can use to populate a drop down menu with your language choices.</div>
				<dl class="well well-small" style="display:inline-block; margin-bottom:0;">
					<dt>How to use with the select form helper:</dt>
					<dd>##select(label="label", objectName="objectName", property="property", options=<b>localizatorGetLanguages()</b>)##</dd>
					<dt>This will render a drop down like this:</dt>
					<dd>
						<select>
							<option value="en_CA">English (Canada)</option>
							<option value="fr_CA">Français (Canada)</option>
						</select>
					</dd>
				</dl>
			</li>
			<li><b>localizatorCheckForErrors(required struct object, string localeid)</b>
				<div style="margin-top:10px;">Since error messages, set in the init block in your model files, are cached when your application is reloaded. This function will return their translation based on argument, session or default localeid. This function is to be used with the error messages view helper.</div>
				<dl class="well well-small" style="display:inline-block; margin-bottom:0;">
					<dt>How to use this function in your controller:</dt>
					<dd>
						object = model("model").new(params.form);<br />
						if ( object.save() ) {<br />
						&nbsp;&nbsp;&nbsp;&nbsp;...<br />
						} else {<br />
						&nbsp;&nbsp;&nbsp;&nbsp;localizatorCheckForErrors(object);<br />
						&nbsp;&nbsp;&nbsp;&nbsp;...<br />
						}
					</dd>
				</dl>
			</li>
			<li><b>localizatorGetAvailableLocaleid(string localeid)</b>
				<div style="margin-top:10px;">This function will return a struct that you can use to populate a drop down menu with available localeid server. The localeid argument let you return the localeid display name in the language you need.</div>
				<dl class="well well-small" style="display:inline-block; margin-bottom:0;">
					<dt>How to use with the select form helper:</dt>
					<dd>##select(label="label", objectName="objectName", property="property", options=<b>localizatorGetAvailableLocaleid()</b>)##</dd>
					<dt>This will render a drop down like this:</dt>
					<dd>
						<select>
							<option value="ar">Arabic</option>
							<option value="ar_ae">Arabic (United Arab Emirates)</option>
							<option value="ar_bh">Arabic (Bahrain)</option>
							<option value="ar_dz">Arabic (Algeria)</option>
							<option value="ar_eg">Arabic (Egypt)</option>
							<option value="ar_iq">Arabic (Iraq)</option>
							<option value="ar_jo">Arabic (Jordan)</option>
							<option value="ar_kw">Arabic (Kuwait)</option>
							<option value="ar_lb">Arabic (Lebanon)</option>
							<option value="ar_ly">Arabic (Libya)</option>
							<option value="ar_ma">Arabic (Morocco)</option>
							<option value="ar_om">Arabic (Oman)</option>
							<option value="ar_qa">Arabic (Qatar)</option>
							<option value="ar_sa">Arabic (Saudi Arabia)</option>
							<option value="ar_sd">Arabic (Sudan)</option>
							<option value="ar_sy">Arabic (Syria)</option>
							<option value="ar_tn">Arabic (Tunisia)</option>
							<option value="ar_ye">Arabic (Yemen)</option>
							<option value="be">Belarusian</option>
							<option value="be_by">Belarusian (Belarus)</option>
							<option value="bg">Bulgarian</option>
							<option value="bg_bg">Bulgarian (Bulgaria)</option>
							<option value="ca">Catalan</option>
							<option value="ca_es">Catalan (Spain)</option>
							<option value="cs">Czech</option>
							<option value="cs_cz">Czech (Czech Republic)</option>
							<option value="da">Danish</option>
							<option value="da_dk">Danish (Denmark)</option>
							<option value="de">German</option>
							<option value="de_at">German (Austria)</option>
							<option value="de_ch">German (Switzerland)</option>
							<option value="de_de">German (Germany)</option>
							<option value="de_lu">German (Luxembourg)</option>
							<option value="el">Greek</option>
							<option value="el_cy">Greek (Cyprus)</option>
							<option value="el_gr">Greek (Greece)</option>
							<option value="en">English</option>
							<option value="en_au">English (Australia)</option>
							<option value="en_ca">English (Canada)</option>
							<option value="en_gb">English (United Kingdom)</option>
							<option value="en_ie">English (Ireland)</option>
							<option value="en_in">English (India)</option>
							<option value="en_mt">English (Malta)</option>
							<option value="en_nz">English (New Zealand)</option>
							<option value="en_ph">English (Philippines)</option>
							<option value="en_sg">English (Singapore)</option>
							<option value="en_us">English (United States)</option>
							<option value="en_za">English (South Africa)</option>
							<option value="es">Spanish</option>
							<option value="es_ar">Spanish (Argentina)</option>
							<option value="es_bo">Spanish (Bolivia)</option>
							<option value="es_cl">Spanish (Chile)</option>
							<option value="es_co">Spanish (Colombia)</option>
							<option value="es_cr">Spanish (Costa Rica)</option>
							<option value="es_do">Spanish (Dominican Republic)</option>
							<option value="es_ec">Spanish (Ecuador)</option>
							<option value="es_es">Spanish (Spain)</option>
							<option value="es_gt">Spanish (Guatemala)</option>
							<option value="es_hn">Spanish (Honduras)</option>
							<option value="es_mx">Spanish (Mexico)</option>
							<option value="es_ni">Spanish (Nicaragua)</option>
							<option value="es_pa">Spanish (Panama)</option>
							<option value="es_pe">Spanish (Peru)</option>
							<option value="es_pr">Spanish (Puerto Rico)</option>
							<option value="es_py">Spanish (Paraguay)</option>
							<option value="es_sv">Spanish (El Salvador)</option>
							<option value="es_us">Spanish (United States)</option>
							<option value="es_uy">Spanish (Uruguay)</option>
							<option value="es_ve">Spanish (Venezuela)</option>
							<option value="et">Estonian</option>
							<option value="et_ee">Estonian (Estonia)</option>
							<option value="fi">Finnish</option>
							<option value="fi_fi">Finnish (Finland)</option>
							<option value="fr">French</option>
							<option value="fr_be">French (Belgium)</option>
							<option value="fr_ca">French (Canada)</option>
							<option value="fr_ch">French (Switzerland)</option>
							<option value="fr_fr">French (France)</option>
							<option value="fr_lu">French (Luxembourg)</option>
							<option value="ga">Irish</option>
							<option value="ga_ie">Irish (Ireland)</option>
							<option value="hi_in">Hindi (India)</option>
							<option value="hr">Croatian</option>
							<option value="hr_hr">Croatian (Croatia)</option>
							<option value="hu">Hungarian</option>
							<option value="hu_hu">Hungarian (Hungary)</option>
							<option value="in">Indonesian</option>
							<option value="in_id">Indonesian (Indonesia)</option>
							<option value="is">Icelandic</option>
							<option value="is_is">Icelandic (Iceland)</option>
							<option value="it">Italian</option>
							<option value="it_ch">Italian (Switzerland)</option>
							<option value="it_it">Italian (Italy)</option>
							<option value="iw">Hebrew</option>
							<option value="iw_il">Hebrew (Israel)</option>
							<option value="ja">Japanese</option>
							<option value="ja_jp">Japanese (Japan)</option>
							<option value="ja_jp_jp">Japanese (Japan,JP)</option>
							<option value="ko">Korean</option>
							<option value="ko_kr">Korean (South Korea)</option>
							<option value="lt">Lithuanian</option>
							<option value="lt_lt">Lithuanian (Lithuania)</option>
							<option value="lv">Latvian</option>
							<option value="lv_lv">Latvian (Latvia)</option>
							<option value="mk">Macedonian</option>
							<option value="mk_mk">Macedonian (Macedonia)</option>
							<option value="ms">Malay</option>
							<option value="ms_my">Malay (Malaysia)</option>
							<option value="mt">Maltese</option>
							<option value="mt_mt">Maltese (Malta)</option>
							<option value="nl">Dutch</option>
							<option value="nl_be">Dutch (Belgium)</option>
							<option value="nl_nl">Dutch (Netherlands)</option>
							<option value="no">Norwegian</option>
							<option value="no_no">Norwegian (Norway)</option>
							<option value="no_no_ny">Norwegian (Norway,Nynorsk)</option>
							<option value="pl">Polish</option>
							<option value="pl_pl">Polish (Poland)</option>
							<option value="pt">Portuguese</option>
							<option value="pt_br">Portuguese (Brazil)</option>
							<option value="pt_pt">Portuguese (Portugal)</option>
							<option value="ro">Romanian</option>
							<option value="ro_ro">Romanian (Romania)</option>
							<option value="ru">Russian</option>
							<option value="ru_ru">Russian (Russia)</option>
							<option value="sk">Slovak</option>
							<option value="sk_sk">Slovak (Slovakia)</option>
							<option value="sl">Slovenian</option>
							<option value="sl_si">Slovenian (Slovenia)</option>
							<option value="sq">Albanian</option>
							<option value="sq_al">Albanian (Albania)</option>
							<option value="sr">Serbian</option>
							<option value="sr_ba">Serbian (Bosnia and Herzegovina)</option>
							<option value="sr_cs">Serbian (Serbia and Montenegro)</option>
							<option value="sr_me">Serbian (Montenegro)</option>
							<option value="sr_rs">Serbian (Serbia)</option>
							<option value="sv">Swedish</option>
							<option value="sv_se">Swedish (Sweden)</option>
							<option value="th">Thai</option>
							<option value="th_th">Thai (Thailand)</option>
							<option value="th_th_th">Thai (Thailand,TH)</option>
							<option value="tr">Turkish</option>
							<option value="tr_tr">Turkish (Turkey)</option>
							<option value="uk">Ukrainian</option>
							<option value="uk_ua">Ukrainian (Ukraine)</option>
							<option value="vi">Vietnamese</option>
							<option value="vi_vn">Vietnamese (Vietnam)</option>
							<option value="zh">Chinese</option>
							<option value="zh_cn">Chinese (China)</option>
							<option value="zh_hk">Chinese (Hong Kong)</option>
							<option value="zh_sg">Chinese (Singapore)</option>
							<option value="zh_tw">Chinese (Taiwan)</option>
						</select>
					</dd>
				</dl>
			</li>
			<li><b>localizatorAddLocaleid(required string localeid)</b>
				<div style="margin-top:10px;">This function will add localeid column to the database table & create a localeid file in locales plugin folder. The new localeid file will be filled with the repository file text.</div>
				<dl class="well well-small" style="display:inline-block; margin-bottom:0;">
					<dt>How to use with the select form helper:</dt>
					<dd>##localizatorAddLocaleid("fr_CA")##</dd>
					<dt>This will add a new column ("fr_CA" VarChar(Max)) in your database table &amp; a new localeid file ("fr_CA.cfm") in the locales plugin folder.</dt>
					<dd></dd>
				</dl>
			</li>
			<li><b>localizatorDeleteLocaleid(required string localeid)</b>
				<div style="margin-top:10px;">This function will delete the localeid column from the database table & delete the localeid file from the locales plugin folder.</div>
				<dl class="well well-small" style="display:inline-block; margin-bottom:0;">
					<dt>How to use with the select form helper:</dt>
					<dd>##localizatorDeleteLocaleid("fr_CA")##</dd>
				</dl>
			</li>
		</ul>
	</div>
</cfoutput>