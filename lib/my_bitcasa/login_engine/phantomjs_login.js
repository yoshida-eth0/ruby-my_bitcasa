var page = require('webpage').create();
var args = require('system').args;

var user = args[1]==void 0 ? "" : args[1];
var password =  args[2]==void 0 ? "" : args[2];

page.onInitialized = function() {
	page.evaluate(function() {
		document.addEventListener('DOMContentLoaded', function() {
			window.callPhantom('DOMContentLoaded');
		}, false);
	});
};

var funcs = function(funcs) {
	this.funcs = funcs;
	this.init();
};
funcs.prototype = {
	init: function() {
		var self = this;
		page.onCallback = function(data){
			if (data === 'DOMContentLoaded') self.next();
		}
	},
	next: function() {
		var func = this.funcs.shift();
		if (func !== undefined) {
			func();
		} else {
			page.onCallback = function(){};
		}
	}
};

new funcs([
	function() {
		page.open('https://my.bitcasa.com/login');
	},
	function() {
		page.evaluate(function(user, password) {
			document.getElementById('user').value = user;
			document.getElementById('password').value = password;
			document.querySelector('form').submit();
		}, user, password);
	},
	function() {
		var cookie = page.evaluate(function() {
			if (window.location.pathname.indexOf("/login")==0) {
				return null;
			} else {
				return document.cookie;
			}
		});
		console.log(cookie);
		phantom.exit();
	}
]).next();
