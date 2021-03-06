﻿component output="false" singleton{
	
	property name="pluginfoo" inject="coldbox:myplugin:foo";
	property name="cookieStorage" inject="coldbox:plugin:cookieStorage";
	property name="cookieStorage2" inject="coldbox:myplugin:cookieStorage@cbcompat";
	property name="ocm" inject="ocm";
	property name="ocmfoo" inject="ocm:foo";
	property name="fwconfigbean" inject="coldbox:fwconfigbean";
	property name="configbean" inject="coldbox:configbean";
	property name="cacheManager" inject="coldbox:cacheManager";
	property name="myService" inject="myService"; // Pulled from "model" scan location
	property name="mailsettingsbean" inject="coldbox:mailsettingsbean";
	property name="debuggerService" inject="coldbox:debuggerService";
	property name="validationManager" inject="coldbox:validationManager";


	// Default Action
	function index(event,rc,prc){
		
		getModuleSettings( 'cbcompat' );
		getColdboxOCM();

		prc.welcomeMessage = "Welcome to ColdBox!";
		event.setView("main/index");
	}
	

}