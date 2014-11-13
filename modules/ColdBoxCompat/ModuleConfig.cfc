/**
Module Directives as public properties
this.title 				= "Title of the module";
this.author 			= "Author of the module";
this.webURL 			= "Web URL for docs purposes";
this.description 		= "Module description";
this.version 			= "Module Version";
this.viewParentLookup   = (true) [boolean] (Optional) // If true, checks for views in the parent first, then it the module.If false, then modules first, then parent.
this.layoutParentLookup = (true) [boolean] (Optional) // If true, checks for layouts in the parent first, then it the module.If false, then modules first, then parent.
this.entryPoint  		= "" (Optional) // If set, this is the default event (ex:forgebox:manager.index) or default route (/forgebox) the framework
									       will use to create an entry link to the module. Similar to a default event.
this.cfmapping			= "The CF mapping to create";
this.modelNamespace		= "The namespace to use for registered models, if blank it uses the name of the module."

structures to create for configuration
- parentSettings : struct (will append and override parent)
- settings : struct
- datasources : struct (will append and override parent)
- interceptorSettings : struct of the following keys ATM
	- customInterceptionPoints : string list of custom interception points
- interceptors : array
- layoutSettings : struct (will allow to define a defaultLayout for the module)
- routes : array Allowed keys are same as the addRoute() method of the SES interceptor.
- wirebox : The wirebox DSL to load and use

Available objects in variable scope
- controller
- appMapping (application mapping)
- moduleMapping (include,cf path)
- modulePath (absolute path)
- log (A pre-configured logBox logger object for this object)
- binder (The wirebox configuration binder)
- wirebox (The wirebox injector)

Required Methods
- configure() : The method ColdBox calls to configure the module.

Optional Methods
- onLoad() 		: If found, it is fired once the module is fully loaded
- onUnload() 	: If found, it is fired once the module is unloaded

*/
component {

	// Module Properties
	this.title 				= "ColdBoxCompoat";
	this.author 			= "Brad Wood";
	this.webURL 			= "http://www.codersrevolution.com";
	this.description 		= "";
	this.version			= "1.0.0";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint			= "ColdBoxCompoat";
	// Model Namespace
	this.modelNamespace		= "cbcompat";
	// CF Mapping
	this.cfmapping			= "cbcompat";

	function configure(){

		// Mixin our own methods on handlers, interceptors and views via the ColdBox UDF Library File setting
		arrayAppend( controller.getSetting( "ApplicationHelper" ), "#moduleMapping#/includes/mixins.cfm" );
	

		// No support for a custom plugins convention since I can't easily parse the config cfc
		var pluginsConvention = 'plugins';
		var settingStruct = controller.getSettingStructure();
		
		// Custom Plugins Registration
		settingStruct[ "MyPluginsInvocationPath" ] = reReplace(pluginsConvention,"(/|\\)",".","all" );
		settingStruct[ "MyPluginsPath" ] = settingStruct.ApplicationPath & pluginsConvention;

		//Set the Handlers,Models, & Custom Plugin Invocation & Physical Path for this Application
		if( len(settingStruct[ "AppMapping" ]) ){
			appMappingAsDots = reReplace(settingStruct[ "AppMapping" ],"(/|\\)",".","all" );
			// Custom Plugins Registrations
				settingStruct[ "MyPluginsInvocationPath" ] = appMappingAsDots & ".#reReplace(pluginsConvention,"(/|\\)",".","all" )#";
				settingStruct[ "MyPluginsPath" ] = "/" & settingStruct.AppMapping & "/#pluginsConvention#";
				settingStruct[ "MyPluginsPath" ] = expandPath(settingStruct[ "MyPluginsPath" ]);
		}
		
		// Add model as scan location
		var appMapping = controller.getSetting( 'appMapping' );
		if( len( appMapping ) ) {
			appMappingAsDots = reReplace( appMapping, "(/|\\)",".","all" );
			binder.scanLocations( listAppend( appMappingAsDots, 'model', '.' ) );
		} else {
			binder.scanLocations( 'model' );			
		}
		
		// parent settings
		parentSettings = {

		};

		// module settings - stored in modules.name.settings
		settings = {

		};

		// Layout Settings
		layoutSettings = {
			defaultLayout = ""
		};

		// datasources
		datasources = {

		};

		// SES Routes
		routes = [
			// Module Entry Point
			{pattern="/", handler="home",action="index"},
			// Convention Route
			{pattern="/:handler/:action?"}
		];

		// Custom Declared Points
		interceptorSettings = {
			customInterceptionPoints = ""
		};

		// Custom Declared Interceptors
		interceptors = [
			{ class='#moduleMapping#.interceptors.compat' }
		];

		// Binder Mappings
		// binder.map("Alias").to("#moduleMapping#.model.MyService");

		binder.getInjector().registerDSL("coldbox","#moduleMapping#.models.compatColdBoxBuilder");
		binder.getInjector().registerDSL("ocm","#moduleMapping#.models.compatOCMBuilder");
		
		controller.getCacheBox().getDefaultCache().set('foo','test');
	}

	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){
		// Configure the pluginService and register it as an interceptor
		var pluginService = controller.getWireBox().getInstance( 'pluginService@cbcompat' );
		pluginService.configure();
		controller.getInterceptorService().registerInterceptor( interceptorObject=pluginService );
		
		// Copy over the plugin base class
		fileCopy( expandPath( '#moduleMapping#/models/Plugin.cfc' ), expandPath( '/coldbox/system/Plugin.cfc' ) );
	}

	/**
	* Fired when the module is unregistered and unloaded
	*/
	function onUnload(){

	}

}