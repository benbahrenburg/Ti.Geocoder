package ti.geocoder;

import org.appcelerator.kroll.common.Log;
import org.appcelerator.titanium.TiApplication;

import android.location.Location;
import android.location.LocationManager;
import android.location.Address;
import android.os.Build;

import java.util.HashMap;
import java.util.List;

public class CommonHelpers {

	public static boolean providerEmpty(String value){
		if(value == null){
			return true;
		}
		if(value.trim().length()==0){
			return true;
		}
		return false;
	}
	public Location getLastBestLocation(LocationManager locationManager,int minDistance, long minTime) {
	    Location bestResult = null;
	    float bestAccuracy = Float.MAX_VALUE;
	    long bestTime = Long.MIN_VALUE;
	    
	    // Iterate through all the providers on the system, keeping
	    // note of the most accurate result within the acceptable time limit.
	    // If no result is found within maxTime, return the newest Location.
	    List<String> matchingProviders = locationManager.getAllProviders();
	    for (String provider: matchingProviders) {
	      Location location = locationManager.getLastKnownLocation(provider);
	      if (location != null) {
	        float accuracy = location.getAccuracy();
	        long time = location.getTime();
	        
	        if ((time > minTime && accuracy < bestAccuracy)) {
	          bestResult = location;
	          bestAccuracy = accuracy;
	          bestTime = time;
	        }
	        else if (time < minTime && bestAccuracy == Float.MAX_VALUE && time > bestTime) {
	          bestResult = location;
	          bestTime = time;
	        }
	      }
	    }
	    
	    return bestResult;
	  }
	
	public static void Log(String message){
		if(TigeocoderModule.DEBUG){
			Log.i(TigeocoderModule.MODULE_FULL_NAME, message);
		}
		
	}
	public static void Log(Exception e){
		if(TigeocoderModule.DEBUG){
			Log.i(TigeocoderModule.MODULE_FULL_NAME, e.toString());
		}
		
	}	
	public static void DebugLog(String message){
		if(TigeocoderModule.DEBUG){
			Log.d(TigeocoderModule.MODULE_FULL_NAME, message);
		}
	}
	public static HashMap<String, Object> buildAddress(double lat, double lng, Address place)
	{
		HashMap<String, Object> results = CommonHelpers.buildAddress(place);
		//If we can't get lat and lng from the GeoCoder, add them in
		if(!place.hasLatitude()){
			results.put("latitude", lat);			
		}
		if(!place.hasLongitude()){
			results.put("longitude", lng);
		}
		return results;
	}
	public static boolean hasProviders(){
		LocationManager locationManager = (LocationManager) TiApplication.getInstance().getApplicationContext().getSystemService(TiApplication.LOCATION_SERVICE);
		boolean Enabled = (locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER) || 
				locationManager.isProviderEnabled(LocationManager.PASSIVE_PROVIDER) || 
				locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER));
		locationManager = null;
		return Enabled;
	}
	public static HashMap<String, Object> buildAddress(Address place)
	{
		HashMap<String, Object> results = new HashMap<String, Object>();
		int addressLoop = 0;
		StringBuilder sb = new StringBuilder();
		for (addressLoop = 0; addressLoop < place.getMaxAddressLineIndex(); addressLoop++){
			if(addressLoop==0){
				sb.append("\n");
			}
			sb.append(place.getAddressLine(addressLoop));
		}		
			
		results.put("address", sb.toString());
		results.put("countryCode", place.getCountryCode());
		results.put("countryName", place.getCountryName());
		results.put("administrativeArea", place.getAdminArea());
		results.put("subAdministrativeArea", place.getSubAdminArea());
		results.put("locality", place.getLocality());
		results.put("subLocality", place.getSubLocality());
		results.put("postalCode", place.getPostalCode());
		results.put("thoroughfare", place.getThoroughfare());
		results.put("subThoroughfare", place.getSubThoroughfare());		
		try{
			results.put("phone", place.getPhone());
		 } catch (Exception e) {
			 results.put("phone", "");
		}
		results.put("url", place.getUrl());

		if(place.hasLatitude()){
			results.put("latitude", place.getLatitude());
		}
		if(place.hasLongitude()){
			results.put("longitude", place.getLongitude());
		}
		return results;		
	}
	public static Boolean reverseGeoSupported(){
		if("google_sdk".equals( Build.PRODUCT )) {
			Log.d(TigeocoderModule.MODULE_FULL_NAME, "You are in the emulator, now checking if you have the min API level required");
			if(Build.VERSION.SDK_INT<14){
				Log.e(TigeocoderModule.MODULE_FULL_NAME, "You need to run API level 14 (ICS) or greater to work in emulator");
				Log.e(TigeocoderModule.MODULE_FULL_NAME, "This is a google emulator bug. Sorry you need to test on device.");
				return false;
			}else{
				return true;
			}
		}else{
			return true;
		}		
	}
}
