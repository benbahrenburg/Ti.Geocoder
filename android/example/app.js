var geocoder = require('ti.geocoder');
Ti.API.info("module is => " + geocoder);

var isAndroid = Ti.Platform.osname == "android";
Ti.API.info("Are we working with Android? " + isAndroid);

if(!isAndroid){
	Ti.API.info("On iOS we need to ask for permission. For this example we will use  Ti.Geolocation.AUTHORIZATION_ALWAYS");
	Ti.Geolocation.requestAuthorization(Ti.Geolocation.AUTHORIZATION_ALWAYS);
}

var isSupported = geocoder.isSupported();
Ti.API.info("Are we Supported? " + (isSupported) ? 'Yes' : 'No');

function showPlace(place){		
	Ti.API.info("CountryCode " + place.countryCode);
	Ti.API.info("CountryName " + place.countryName);
	Ti.API.info("AdminArea " + place.administrativeArea);
	Ti.API.info("SubAdminArea " + place.subAdministrativeArea);
    Ti.API.info("Locality " + place.locality);
    Ti.API.info("SubLocality " + place.subLocality);
    Ti.API.info("Thoroughfare " + place.thoroughfare);                      
	Ti.API.info("SubThoroughfare " + place.subThoroughfare); 
    Ti.API.info("PostalCode " + place.postalCode);  
	    
	if((place.latitude!=undefined)&&(place.latitude!=null)){
		Ti.API.info("latitude " + place.latitude);  	
	}
    if((place.longitude!=undefined)&&(place.longitude!=null)){       
  		Ti.API.info("longitude " + place.longitude);   
  	}
  	
  	Ti.API.info("Each platform has some custom elements so highlight them.");
  	if(isAndroid){
  		Ti.API.info("Address " + place.address);
	    Ti.API.info("phone " + place.phone); 
	    Ti.API.info("url " + place.url);     	  		
  	}else{
  		Ti.API.info("region " + JSON.stringify(place.region)); 
  		Ti.API.info("timestamp " + new Date(place.timestamp));
  	}
};

Ti.API.info("Now let's do some forward Geo and lookup the address for Appcelerator HQ");
var address="440 N. Bernardo Avenue Mountain View, CA";

Ti.API.info("We call the forward Geocoder providing an address and callback");
Ti.API.info("Now we wait for the lookup");
geocoder.forwardGeocoder(address,function(e){
	Ti.API.info("Did forwardGeocoder work? " + e.success);
	if(e.success){
		Ti.API.info("This is the number of places found, it can return many depending on your search");
		Ti.API.info("Places found = " + e.placeCount);
		for (var iLoop=0;iLoop<e.placeCount;iLoop++){
			Ti.API.info("Showing Place At Index " + iLoop);
			showPlace(e.places[iLoop]);
		}		
	}	

	var test = JSON.stringify(e);
	Ti.API.info("Forward Results stringified" + test);	
});

Ti.API.info("Let's now try to do a reverse Geo lookup using the Time Square coordinates");
Ti.API.info("Pass in our coordinates and callback then wait...");
geocoder.reverseGeocoder(40.75773,-73.985708,function(e){
	Ti.API.info("Did reverseGeocoder work? " + e.success);
	if(e.success){
		Ti.API.info("This is the number of places found, it can return many depending on your search");
		Ti.API.info("Places found = " + e.placeCount);
		for (var iLoop=0;iLoop<e.placeCount;iLoop++){
			Ti.API.info("Showing Place At Index " + iLoop);
			showPlace(e.places[iLoop]);
		}		
	}	

	var test = JSON.stringify(e);
	Ti.API.info("Forward Results stringified" + test);	
});

Ti.API.info("Let's get the places information (address) for our current location");
Ti.API.info("We make our call and provide a callback then wait...");
geocoder.getCurrentPlace(function(e){
    Ti.API.info("Did getCurrentPlace work? " + e.success);
    if(e.success){
        Ti.API.info("It worked");
    }   

    var test = JSON.stringify(e);
    Ti.API.info("Results stringified" + test);	
});