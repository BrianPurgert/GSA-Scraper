/*
				    .ooooo.          ooo. .oo.     .ooooo.    oooo d8b
				   d88" `88b         `888P"Y88b   d88" `88b   `888""8P
				   888888888  88888   888   888   888   888    888
				   888        88888   888   888   888   888    888       
				   `"88888"          o888o o888o  `Y8bod8P"   d888b      

***********************************************************************************************************
Copyright 2015 by E-Nor Inc.
Authors: Ahmed Awwad & Mohamed Adel
Universal Federated Analytics: Google Analytics Government Wide Site Usage Measurement.
04/16/2015 Version: 1.04
***********************************************************************************************************/

var oCONFIG = {
	GWT_UAID: ['UA-33523145-1'],
	FORCE_SSL: true,
	ANONYMIZE_IP: true,
	AGENCY: '',
	SUB_AGENCY: '',
	VERSION: '20150416 v1.04 - Universal Analytics',
	USE_MAIN_CUSTOM_DIMENSIONS: true,
	MAIN_AGENCY_CUSTOM_DIMENSION_SLOT: 'dimension1',
	MAIN_SUBAGENCY_CUSTOM_DIMENSION_SLOT: 'dimension2',
	MAIN_CODEVERSION_CUSTOM_DIMENSION_SLOT: 'dimension3',
	USE_PARALLEL_CUSTOM_DIMENSIONS: false,
	PARALLEL_AGENCY_CUSTOM_DIMENSION_SLOT: 'dimension1',
	PARALLEL_SUBAGENCY_CUSTOM_DIMENSION_SLOT: 'dimension2',
	PARALLEL_CODEVERSION_CUSTOM_DIMENSION_SLOT: 'dimension3',
	COOKIE_DOMAIN: location.hostname.replace('www.', '').toLowerCase(),
	COOKIE_TIMEOUT: 60 * 60 * 24 * 2 * 365,
	SEARCH_PARAMS: 'q|querytext|nasaInclude|k|qt',
	YOUTUBE: true,
	AUTOTRACKER: true,
	EXTS: 'doc|docx|xls|xlsx|xlsm|ppt|pptx|exe|zip|pdf|js|txt|csv|dxf|dwgd|rfa|rvt|dwfx|dwg|wmv|jpg|msi|7z|gz|tgz|wma|mov|avi|mp3|mp4|csv|mobi|epub|swf|rar',
	SUBDOMAIN_BASED: true,
	DOUNBLECLICK_LINK: false,
	ENHANCED_LINK: false,
	OPTOUT_PAGE: false,
	PUA_NAME: 'GSA_ENOR'
};
function _onEveryPage() {
	_updateConfig();
	_defineCookieDomain();
	_defineAgencyCDsValues();
}
_onEveryPage();
function _defineCookieDomain() {
	var domainPattern = /(([^.\/]+\.[^.\/]{2,3}\.[^.\/]{2})|(([^.\/]+\.)[^.\/]{2,4}))(\/.*)?$/;
	if (domainPattern.test(oCONFIG.SUBDOMAIN_BASED.toString())) {
		oCONFIG.COOKIE_DOMAIN = oCONFIG.SUBDOMAIN_BASED.toLowerCase().replace('www.', '');
		oCONFIG.SUBDOMAIN_BASED = true;
	} else {
		if (oCONFIG.SUBDOMAIN_BASED.toString() == 'false') {
			oCONFIG.COOKIE_DOMAIN = document.location.hostname.match(/(([^.\/]+\.[^.\/]{2,3}\.[^.\/]{2})|(([^.\/]+\.)[^.\/]{2,4}))(\/.*)?$/)[1];
			oCONFIG.SUBDOMAIN_BASED = true;
		} else if (oCONFIG.SUBDOMAIN_BASED.toString() == 'auto' || oCONFIG.SUBDOMAIN_BASED == 'true') {
			oCONFIG.COOKIE_DOMAIN = location.hostname.toLowerCase().replace('www.', '');
			oCONFIG.SUBDOMAIN_BASED = false;
		} else {
			oCONFIG.COOKIE_DOMAIN = location.hostname.toLowerCase().replace('www.', '');
			oCONFIG.SUBDOMAIN_BASED = false;
		}
	}
}
function _defineAgencyCDsValues() {
	oCONFIG.AGENCY = oCONFIG.AGENCY || 'unspecified:' + oCONFIG.COOKIE_DOMAIN;
	oCONFIG.SUB_AGENCY = oCONFIG.SUB_AGENCY || ('' + oCONFIG.COOKIE_DOMAIN);
	oCONFIG.SUB_AGENCY = oCONFIG.AGENCY + ' - ' + oCONFIG.SUB_AGENCY;
}
function _cleanBooleanParam(_paramValue) {
	switch (_paramValue.toString().toLowerCase()) {
	case 'true':
	case 'on':
	case 'yes':
	case '1':
		return 'true';
	case 'false':
	case 'off':
	case 'no':
	case '0':
		return 'false';
	default:
		return _paramValue;
	}
}
function _isValidUANum(_UANumber) {
	_UANumber = _UANumber.toLowerCase();
	var _regEx = /^ua\-([0-9]+)\-[0-9]+$/;
	var match = _UANumber.match(_regEx);
	return (match != null && match.length > 0);
}
function _cleanDimensionValue(_paramValue) {
	try {
		pattern = /^dimension([1-9]|[1-9][0-9]|1([0-9][0-9])|200)$/;
		if (pattern.test(_paramValue))
			return _paramValue;
		var _tmpValue = 'dimension' + _paramValue.match(/\d+$/g)[0];
		if (pattern.test(_tmpValue))
			return _tmpValue;
		return '';
	} catch (err) {}
}
function _updateConfig() {
	var _JSElement = document.getElementById('_fed_an_ua_tag').getAttribute('src');
	_JSElement = _JSElement.replace(/\?/g, '&');
	var _paramList = _JSElement.split('&');
	for (var i = 1; i < _paramList.length; i++) {
		_keyValuePair = _paramList[i].toLowerCase();
		_key = _keyValuePair.split('=')[0];
		_value = _keyValuePair.split('=')[1];
		switch (_key) {
		case 'pua':
			var _UAList = _value.split(',');
			for (var j = 0; j < _UAList.length; j++)
				if (_isValidUANum(_UAList[j]))
					oCONFIG.GWT_UAID.push(_UAList[j].toUpperCase());
			break;
		case 'agency':
			oCONFIG.AGENCY = _value.toUpperCase();
			break;
		case 'subagency':
			oCONFIG.SUB_AGENCY = _value.toUpperCase();
			break;
		case 'maincd':
			_value = _cleanBooleanParam(_value);
			if ('true' == _value || 'false' == _value)
				oCONFIG.USE_MAIN_CUSTOM_DIMENSIONS = _value;
			break;
		case 'fedagencydim':
			_value = _cleanDimensionValue(_value);
			if ('' != _value)
				oCONFIG.MAIN_AGENCY_CUSTOM_DIMENSION_SLOT = _value.toLowerCase();
			break;
		case 'fedsubagencydim':
			_value = _cleanDimensionValue(_value);
			if ('' != _value)
				oCONFIG.MAIN_SUBAGENCY_CUSTOM_DIMENSION_SLOT = _value.toLowerCase();
			break;
		case 'fedversiondim':
			_value = _cleanDimensionValue(_value);
			if ('' != _value)
				oCONFIG.MAIN_CODEVERSION_CUSTOM_DIMENSION_SLOT = _value.toLowerCase();
			break;
		case 'parallelcd':
			_value = _cleanBooleanParam(_value);
			if ('true' == _value || 'false' == _value)
				oCONFIG.USE_PARALLEL_CUSTOM_DIMENSIONS = _value;
			break;
		case 'palagencydim':
			_value = _cleanDimensionValue(_value);
			if ('' != _value)
				oCONFIG.PARALLEL_AGENCY_CUSTOM_DIMENSION_SLOT = _value.toLowerCase();
			break;
		case 'palsubagencydim':
			_value = _cleanDimensionValue(_value);
			if ('' != _value)
				oCONFIG.PARALLEL_SUBAGENCY_CUSTOM_DIMENSION_SLOT = _value.toLowerCase();
			break;
		case 'palversiondim':
			_value = _cleanDimensionValue(_value);
			if ('' != _value)
				oCONFIG.PARALLEL_CODEVERSION_CUSTOM_DIMENSION_SLOT = _value.toLowerCase();
			break;
		case 'cto':
			oCONFIG.COOKIE_TIMEOUT = parseInt(_value) * 2628000;
			break;
		case 'sp':
			oCONFIG.SEARCH_PARAMS += '|' + _value.replace(/,/g, '|');
			break;
		case 'exts':
			oCONFIG.EXTS += '|' + _value.replace(/,/g, '|');
			break;
		case 'yt':
			_value = _cleanBooleanParam(_value);
			if ('true' == _value || 'false' == _value)
				oCONFIG.YOUTUBE = _value;
			break;
		case 'autotracker':
			_value = _cleanBooleanParam(_value);
			if ('true' == _value || 'false' == _value)
				oCONFIG.AUTOTRACKER = _value;
			break;
		case 'sdor':
			oCONFIG.SUBDOMAIN_BASED = _cleanBooleanParam(_value);
			break;
		case 'dclink':
			_value = _cleanBooleanParam(_value);
			if ('true' == _value || 'false' == _value)
				oCONFIG.DOUNBLECLICK_LINK = _value;
			break;
		case 'enhlink':
			_value = _cleanBooleanParam(_value);
			if ('true' == _value || 'false' == _value)
				oCONFIG.ENHANCED_LINK = _value;
			break;
		case 'optout':
			_value = _cleanBooleanParam(_value);
			if ('true' == _value || 'false' == _value)
				oCONFIG.OPTOUT_PAGE = _value;
			break;
		default:
			break;
		}
	}
}
function _sendCustomDimensions(_slotNums, _val) {
	if (_slotNums.length > 0 && _val != '' && _val != undefined) {
		if (tObjectCheck != window['GoogleAnalyticsObject']) {
			createTracker(false);
		}
		for (var i = 0; i < oCONFIG.GWT_UAID.length; i++) {
			if (_slotNums[i] != 'dimension0') {
				try {
					window[window['GoogleAnalyticsObject']](oCONFIG.PUA_NAME + i + '.set', _slotNums[i], _val);
				} catch (err) {}
			}
		}
	}
}
function _sendCustomMetrics(_slotNums, _val) {
	if (_slotNums.length > 0 && _val != '' && _val != undefined) {
		if (tObjectCheck != window['GoogleAnalyticsObject']) {
			createTracker(false);
		}
		for (var i = 0; i < oCONFIG.GWT_UAID.length; i++) {
			if (_slotNums[i] != 'metric0') {
				try {
					window[window['GoogleAnalyticsObject']](oCONFIG.PUA_NAME + i + '.set', _slotNums[i], _val);
				} catch (err) {}
			}
		}
	}
}
function _sendEvent(_cat, _act, _lbl, _val, _nonInteraction) {
	if (_cat != '' && _cat != undefined && _act != '' && _act != undefined) {
		if (tObjectCheck != window['GoogleAnalyticsObject']) {
			createTracker(false);
		}
		for (var i = 0; i < oCONFIG.GWT_UAID.length; i++) {
			try {
				window[window['GoogleAnalyticsObject']](oCONFIG.PUA_NAME + i + '.send', 'event', _cat, _act, ((_lbl != undefined) ? _lbl : ''), ((_val != '' || !isNaN(_val) || _val != undefined) ? parseInt(_val) : 0), {
					'nonInteraction': _nonInteraction
				});
			} catch (err) {}
		}
	}
}
function _sendPageview(_virtualPath, _virtualTitle) {
	if (_virtualPath != '' && _virtualPath != undefined) {
		if (tObjectCheck != window['GoogleAnalyticsObject']) {
			createTracker(false);
		}
		for (var i = 0; i < oCONFIG.GWT_UAID.length; i++) {
			try {
				window[window['GoogleAnalyticsObject']](oCONFIG.PUA_NAME + i + '.send', 'pageview', {
					'page': _virtualPath,
					'title': ((_virtualTitle != '' || _virtualTitle != undefined) ? _virtualTitle : document.title)
				});
			} catch (err) {}
		}
	}
}
function gas(_command, _hitType, _param1, _param2, _param3, _param4, _param5) {
	if (_command != undefined && _command != '' && _hitType != undefined && _hitType != '' && _param1 != undefined && _param1 != '') {
		if (_hitType.toLowerCase() == 'pageview') {
			try {
				_sendPageview(_param1, ((_param2 != '' || _param2 != undefined) ? _param2 : document.title));
			} catch (err) {}
		} else if (_hitType.toLowerCase() == 'event' && _param2 != undefined && _param2 != '') {
			try {
				var _nonInteraction = 'false';
				if (_param5 == undefined) {
					_param5 = _nonInteraction;
				} else {
					_nonInteraction = _cleanBooleanParam(_param5);
				}
				_sendEvent(_param1, _param2, ((_param3 != undefined) ? _param3 : ''), ((_param4 != '' || !isNaN(_param4) || _param4 != undefined) ? parseInt(_param4) : 0), ((_nonInteraction == 'true') ? 1 : 0));
			} catch (err) {}
		} else if (_hitType.toLowerCase().indexOf('dimension') != -1) {
			try {
				var cdsTmpArr = _hitType.toLowerCase().split(',');
				var cdsArr = [];
				dimsPattern = /^dimension([1-9]|[1-9][0-9]|1([0-9][0-9])|200)$/;
				for (var ix = 0; ix < cdsTmpArr.length; ix++) {
					if (dimsPattern.test(cdsTmpArr[ix])) {
						cdsArr.push(cdsTmpArr[ix]);
					} else {
						var tmpDim = 'dimension' + cdsTmpArr[ix].match(/\d+$/g)[0];
						if (dimsPattern.test(tmpDim) || tmpDim == 'dimension0') {
							cdsArr.push(tmpDim);
						}
					}
				}
				if (cdsArr.length > 0) {
					_sendCustomDimensions(cdsArr, ((_param1 != undefined) ? _param1 : ''));
				}
			} catch (err) {}
		} else if (_hitType.toLowerCase().indexOf('metric') != -1) {
			try {
				var mtrcsTmpArr = _hitType.toLowerCase().split(',');
				var mtrcsArr = [];
				mtrcsPattern = /^metric([1-9]|[1-9][0-9]|1([0-9][0-9])|200)$/;
				for (var ixx = 0; ixx < mtrcsTmpArr.length; ixx++) {
					if (mtrcsPattern.test(mtrcsTmpArr[ixx])) {
						mtrcsArr.push(mtrcsTmpArr[ixx]);
					} else {
						var tmpMtrcs = 'metric' + mtrcsTmpArr[ixx].match(/\d+$/g)[0];
						if (mtrcsPattern.test(tmpMtrcs) || tmpMtrcs == 'metric0') {
							mtrcsArr.push(tmpMtrcs);
						}
					}
				}
				if (mtrcsArr.length > 0) {
					_sendCustomMetrics(mtrcsArr, ((_param1 != '' || _param1 != undefined || !isNaN(_param1)) ? parseFloat(_param1) : 1));
				}
			} catch (err) {}
		}
	}
}
function _URIHandler(pageName) {
	var re = new RegExp('([?&])(' + oCONFIG.SEARCH_PARAMS + ')(=[^&]*)','i');
	if (re.test(pageName)) {
		pageName = pageName.replace(re, '$1query$3');
	}
	return pageName;
}

function _initAutoTracker() {
	var mainDomain = oCONFIG.COOKIE_DOMAIN;
	var extDoc = oCONFIG.EXTS.split("|");
	var arr = document.getElementsByTagName("a");
	for (i = 0; i < arr.length; i++) {
		var flag = 0;
		var flagExt = 0;
		var doname = "";
		var mailPattern = /^mailto\:[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}/;
		var urlPattern = /(ftp|http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/;
		var telPattern = /^tel\:(.*)([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$/;
		if (mailPattern.test(arr[i].href) || urlPattern.test(arr[i].href) || telPattern.test(arr[i].href)) {
			try {
				if (urlPattern.test(arr[i].href)) {
					doname = arr[i].hostname.toLowerCase().replace("www.", "");
				} else if (mailPattern.test(arr[i].href)) {
					doname = arr[i].href.split('@')[1];
				} else if (telPattern.test(arr[i].href)) {
					doname = arr[i].href;
					doname = doname.toLowerCase();
				}
			} catch (err) {
				continue;
			}
		} else {
			continue;
		}
		var condition = false;
		if (oCONFIG.SUBDOMAIN_BASED) {
			condition = (doname.indexOf(mainDomain) != -1);
		} else {
			condition = (doname == mainDomain);
		}
		if (condition) {
			if (arr[i].href.toLowerCase().indexOf("mailto:") != -1 && arr[i].href.toLowerCase().indexOf("tel:") == -1) {
				var gaUri = arr[i].href.match(/[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}/);
				_addEventListener(arr[i], 'Mailto', gaUri[0], '', 0);
			} else if (arr[i].href.toLowerCase().indexOf("mailto:") == -1 && arr[i].href.toLowerCase().indexOf("tel:") != -1) {
				_addEventListener(arr[i], 'Telephone Clicks', arr[i].href.split("tel:")[1], '', 0);
			} else if (arr[i].href.toLowerCase().indexOf("mailto:") == -1 && arr[i].href.toLowerCase().indexOf("tel:") == -1) {
				for (var j = 0; j < extDoc.length; j++) {
					var arExt = arr[i].href.split(".");
					var ext = arExt[arExt.length - 1].split(/[#?&?]/);
					if (ext[0].toLowerCase() == extDoc[j]) {
						_addEventListener(arr[i], 'Download', ext[0].toLowerCase(), arr[i].href.split(/[#?&?]/)[0], 0);
						break;
					}
				}
			}
		} else {
			for (var l = 0; l < extDoc.length; l++) {
				var arExt = arr[i].href.split(".");
				var ext = arExt[arExt.length - 1].split(/[#?]/);
				if (ext[0].toLowerCase() == extDoc[l]) {
					var gaUri = arr[i].href.split(extDoc[l]);
					_addEventListener(arr[i], 'Outbound Downloads', ext[0].toLowerCase(), arr[i].href.split(/[#?&?]/)[0], 0);
					break;
				} else if (ext[0].toLowerCase() != extDoc[l]) {
					flagExt++;
					if (flagExt == extDoc.length) {
						if (arr[i].href.toLowerCase().indexOf("mailto:") == -1 && arr[i].href.toLowerCase().indexOf("tel:") == -1) {
							_addEventListener(arr[i], 'Outbound', arr[i].hostname, arr[i].pathname, 0);
						} else if (extDoc.length && arr[i].href.toLowerCase().indexOf("mailto:") != -1 && arr[i].href.toLowerCase().indexOf("tel:") == -1) {
							var gaUri = arr[i].href.match(/[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}/);
							_addEventListener(arr[i], 'Outbound MailTo', gaUri[0], '', 0);
						} else if (extDoc.length && arr[i].href.toLowerCase().indexOf("mailto:") == -1 && arr[i].href.toLowerCase().indexOf("tel:") != -1) {
							_addEventListener(arr[i], 'Telephone Clicks', arr[i].href.split("tel:")[1], '', 0);
						}
					}
				}
			}
		}
