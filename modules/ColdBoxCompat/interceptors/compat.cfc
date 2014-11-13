component {
	
	// Allow the old UDFLibraryFile setting to work.
	function afterConfigurationLoad() {
		// If this app has a legacy helper setting
		if( settingExists( 'UDFLibraryFile' ) ) {
			var compatApplicationHelper = getSetting( 'UDFLibraryFile' );
			// Turn it into an array if neccessary
			if( isSimpleValue( compatApplicationHelper ) ) {
				compatApplicationHelper = listToArray( compatApplicationHelper );
			}
			// Loop over each of the helpers
			for( var helper in compatApplicationHelper ) {
				// and if they aren't already defined
				if( !arrayFind( getSetting( "ApplicationHelper" ), helper ) ) {
					// add them to the new setting
					arrayAppend( getSetting( "ApplicationHelper" ), helper );
				}
			}
		}
	}
	
}