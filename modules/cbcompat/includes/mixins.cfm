<cfscript>
	
	/**
	* Get a module's configuration structure
	* @module.hint The module to retrieve the configuration structure from
	*/
	struct function __getModuleSettings( required module ){
		var mConfig = controller.getSetting( "modules" );
		if( structKeyExists( mConfig, arguments.module ) ){
			return mConfig[ arguments.module ];
		}
		throw( message="The module you passed #arguments.module# is invalid.",
			   detail="The loaded modules are #structKeyList( mConfig )#",
			   type="FrameworkSuperType.InvalidModuleException");
	}
	
	function __getPlugin( required plugin, customPlugin=false, newInstance=false, module='', init=true ){
		var pluginService = getInstance( 'pluginService@cbcompat' );
		return pluginService.getPlugin( argumentCollection=arguments );
	}
	
	function __getMyPlugin( required plugin, newInstance=false, module='', init=true ){
		var pluginService = getInstance( 'pluginService@cbcompat' );
		arguments.customPlugin = true;
		return pluginService.getPlugin( argumentCollection=arguments );
	}
	
	function __getColdBoxOCM( cacheName='default' ){
		return controller.getCacheBox().getCache( arguments.cacheName );
	}
	
	// To avoid compilation errors with duplicate functions of the same name, I need to get CF to 
	// compile it with a different name first, then overwrite it in memory.
	this.getModuleSettings = __getModuleSettings;
	variables.getModuleSettings = __getModuleSettings;
	
	this.getPlugin = __getPlugin;
	variables.getPlugin = __getPlugin;
	
	this.getMyPlugin = __getMyPlugin;
	variables.getMyPlugin = __getMyPlugin;
	
	this.getColdBoxOCM = __getColdBoxOCM;
	variables.getColdBoxOCM = __getColdBoxOCM;
	
</cfscript>