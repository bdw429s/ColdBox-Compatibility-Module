ColdBox-Compatibility-Module
============================

A module for ColdBox 4.0 apps that restores functions, conventions, and plugin functionality from ColdBox 3.x to make upgrading easier.

A module for ColdBox 4.0 apps that restores functions, conventions, and plugin functionality from ColdBox 3.x to make upgrading easier.
This module should add back the following functionality:

* Original getModuleSettings() behavior
* getPlugin() function
* getMyPlugin() function
* getColdBoxOCM() function
* UDFLibraryFile setting
* "model" convention for WireBox scan locations
* coldbox.system.plugin base class

The following WireBox mapping DSL namespaces are restored

* ocm
* ocm:{keyName}
* coldbox:plugin:{pluginName}
* coldbox:myplugin:{pluginName}
* coldbox:myplugin:{pluginName@moduleName}
* coldbox:fwconfigbean
* coldbox:configbean
* coldbox:cacheManager

This plugin also comes packaged with all the original ColdBox 3.8.1 plugins, so you only need to install this module and you'll have it all back again.

Known issues;
* When this module loads, it will copy Plugin.cfc to the coldbox/system directory.  If you uninstall this module, it will not remove that file.
* Plugins only work for the default convention location of "plugins". 

Installation
Drop this module in the modules folder or run "install cbcompat" from CommandBox and reinit the application.
