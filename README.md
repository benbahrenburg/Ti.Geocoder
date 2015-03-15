<h1>Ti.Geocoder</h1>

The Ti.Geocoder module provides access to the native geo decoders on Android and iOS.

<h2>Before you start</h2>
* You need Titanium 3.5.0.GA or greater.
* This module has only been tested on iOS7+ and Android 4+

<h2>tiapp.xml update</h2>

If you plan to support iOS you will need to add the NSLocationAlwaysUsageDescription or NSLocationUsageDescription entry in your tiapp.xml as shown below.  The string value displays the purpose message that the user will be alerted when GPS access is requested.
~~~
    <ios>
        <plist>
            <dict>
                <key>NSLocationUsageDescription</key>
                <string>Will do something awesome when the app is open</string>
                <key>NSLocationAlwaysUsageDescription</key>
                <string>Will do something awesome in the background</string>
            </dict>
        </plist>
    </ios>
~~~

<h2>Setup</h2>

* Android [dist folder](https://github.com/benbahrenburg/Ti.Geocoder/tree/master/android/dist) 
* iOS [dist folder](https://github.com/benbahrenburg/Ti.Geocoder/tree/master/iphone/dist) 
* Install the Ti.Geocoder module. If you need help here is a "How To" [guide](https://wiki.appcelerator.org/display/guides/Configuring+Apps+to+Use+Modules). 
* You can now use the module via the commonJS require method, example shown below.

<pre><code>
//Add the core module into your project
var geocoder = require('ti.geocoder');

</code></pre>

Now we have the module installed and avoid in our project we can start to use the components, see the feature guide below for details.


<h2>Methods</h2>

<h4>isSupported</h4>

Indicates of the module is supported

Method returns true or false

Returns a Boolean value indicating whether the location manager is able to generate heading-related events.

<h4>locationServicesEnabled</h4>

Indicates if the user has enabled or disabled location services for the device

Method returns true or false

<h4>getCurrentPlace</h4>

Retrieves the last known place information (address) from the device.

Parameters
* callback : Function to invoke on success or failure of obtaining the current place information.

<b>Sample</b>

<pre><code>
//Add the core module into your project
var geocoder = require('ti.geocoder');

function resultsCallback(e){
	Ti.API.info("Did it work? " + e.success);
	if(e.success){
		Ti.API.info("It worked");
	}	

	var test = JSON.stringify(e);
	Ti.API.info("Results stringified" + test);
};

Ti.API.info("Let's get the places information (address) for our current location");
Ti.API.info("We make our call and provide a callback then wait...");
geocoder.getCurrentPlace(resultsCallback);
</code></pre>

<h4>reverseGeocoder</h4>

Tries to resolve a location to an address.

The callback receives a results object. If the request is successful, the object includes one or more addresses that are possible matches for the requested coordinates.

Parameters:
* latitude : Number
* longitude : Number
* callback : Function to invoke on success or failure.


All three parameters are required.

<b>Sample</b>

<pre><code>
//Add the core module into your project
var geocoder = require('ti.geocoder');

function reverseGeoCallback(e){
	Ti.API.info("Did it work? " + e.success);
	if(e.success){
		Ti.API.info("This is the number of places found, it can return many depending on your search");
		Ti.API.info("Places found = " + e.placeCount);	
	}	

	var test = JSON.stringify(e);
	Ti.API.info("Forward Results stringified" + test);
};

Ti.API.info("Let's now try to do a reverse Geo lookup using the Time Square coordinates");
Ti.API.info("Pass in our coordinates and callback then wait...");
geocoder.reverseGeocoder(40.75773,-73.985708,reverseGeoCallback);

</code></pre>

<h4>forwardGeocoder</h4>

Resolves an address to a location.
Parameters:
* Address : String
* callback : Function to invoke on success or failure.

Both parameters are required.

<b>Sample</b>

<pre><code>
//Add the core module into your project
var geocoder = require('ti.geocoder');

function forwardGeoCallback(e){
	Ti.API.info("Did it work? " + e.success);
	if(e.success){
		Ti.API.info("This is the number of places found, it can return many depending on your search");
		Ti.API.info("Places found = " + e.placeCount);	
	}	

	var test = JSON.stringify(e);
	Ti.API.info("Forward Results stringified" + test);
};

Ti.API.info("Now let's do some forward Geo and lookup the address for Appcelerator HQ");
var address="440 N. Bernardo Avenue Mountain View, CA";

Ti.API.info("We call the forward Geocoder providing an address and callback");
Ti.API.info("Now we wait for the lookup");
geocoder.forwardGeocoder(address,forwardGeoCallback);

</code></pre>

<h2>Contributing</h2>

The Ti.Geocoder is a open source project.  Please help us by contributing to documentation, reporting bugs, forking the code to add features or make bug fixes, etc.

<h2>Learn More</h2>

<h3>Twitter</h3>

Please consider following the [@bencoding Twitter](http://www.twitter.com/bencoding) for updates and more about Titanium.

<h3>Blog</h3>

For module updates, Titanium tutorials and more please check out my blog at [bencoding.Com](http://bencoding.com). 
