component implements="coldbox.system.ioc.dsl.IDSLBuilder"  {
	
	function init( required any injector ) output=false {
		variables.injector = arguments.injector;
		return this;
	}
	
	function process( required any definition, targetObject ) output=false {
		var dsl = arguments.definition.dsl;
		
		// Return CacheBox's default cache
		if( dsl == 'ocm' ) {
			return injector.getInstance( dsl='cachebox:default' );
		}
		
		// Return a given key from the default cache
		return injector.getInstance( dsl='cachebox:default:#listLast( dsl, ':' )#' );
		
	}
	
}