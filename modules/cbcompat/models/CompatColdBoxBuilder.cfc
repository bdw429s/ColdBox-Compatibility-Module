component implements="coldbox.system.ioc.dsl.IDSLBuilder"  {
	
	function init( required any injector ) output=false {
		variables.injector = arguments.injector;
		
		// Create a ColdBox DSL builder to proxy everything else to
		variables.coldboxDSL = createObject("component","coldbox.system.ioc.dsl.ColdBoxDSL").init( arguments.injector );
		return this;
	}
	
	function process( required any definition, targetObject ) output=false {
		var dsl = arguments.definition.dsl;
		
		// intercept the coldbox:plugin namespace
		if( reFindNoCase( '^coldbox:myplugin:.*', dsl ) ) {
			var pluginService = injector.getInstance( 'pluginService@cbcompat' );
			var pluginName = listGetAt( dsl, 3, ':' );
			
			// module plugin
			if( find("@",pluginName) ){
				return pluginService.getPlugin(plugin=listFirst(pluginName,"@"),customPlugin=true,module=listLast(pluginName,"@"));
			}
			// normal custom plugin
			return pluginService.getPlugin( plugin=pluginName, customPlugin=true );
		// intercept the coldbox:myplugin namespace
		} else if( reFindNoCase( '^coldbox:plugin:.*', dsl ) ) {
			var pluginService = injector.getInstance( 'pluginService@cbcompat' );
			var pluginName = listGetAt( dsl, 3, ':' );
						
			return pluginService.getPlugin( pluginName );
			
		// intercept the coldbox:fwconfigbean namespace
		} else if( dsl == 'coldbox:fwconfigbean' ) {
			
			var configBean = injector.getInstance( 'configBean@cbcompat' );
			configBean.init( injector.getInstance( dsl='coldbox:fwSettings' ) );
			return configBean;
			
		// intercept the coldbox:configbean namespace
		} else if( dsl == 'coldbox:configbean' ) {
			
			var configBean = injector.getInstance( 'configBean@cbcompat' );
			configBean.init( injector.getInstance( dsl='coldbox:configSettings' ) );
			return configBean;
			
		// intercept the coldbox:cacheManager namespace
		} else if( dsl == 'coldbox:cacheManager' ) {
			return injector.getInstance( dsl='cachebox:default' );
						
		// intercept the coldbox:mailsettingsbean namespace
		} else if( dsl == 'coldbox:mailsettingsbean' ) {
			requireModule( 'mailservices', dsl, targetObject );
			
			var MailSettingsBean = injector.getInstance( 'MailSettingsBean@mailservices' );
			MailSettingsBean.init( argumentCollection=injector.getInstance( dsl='coldbox:setting:mailSettings' ) );
			return MailSettingsBean;
			
		// intercept the coldbox:debuggerService namespace
		} else if( dsl == 'coldbox:debuggerService' ) {
			requireModule( 'cbdebugger', dsl, targetObject );
			return injector.getInstance( 'debuggerService@cbdebugger' );
			
		// intercept the coldbox:validationManager namespace
		} else if( dsl == 'coldbox:validationManager' ) {
			requireModule( 'validation', dsl, targetObject );
			return injector.getInstance( 'validationManager@validation' );
			
		// for all else, defer to the ColdBox DSL builder
		} else {
			return coldboxDSL.process(argumentCollection=arguments);			
		}
	}
	
	private function requireModule( required moduleName, required namespace, required targetObject ) {
		var moduleService = injector.getInstance( dsl='coldbox:moduleService' );
		if( !moduleService.isModuleActive( arguments.moduleName ) ) {
			throw( "You can't use the '#arguments.namespace#' DSL in #getMetaData( arguments.targetObject ).name# until you install the #arguments.moduleName# module. " );
		}		
	}
	
}