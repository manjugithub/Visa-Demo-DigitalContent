#import "LocationHelper.h"

@interface LocationHelper ()
@property (nonatomic) CLLocationManager* locationManager;
@property (copy) CallbackBlock callback;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic) CLLocation *bestEffortAtLocation;;
@end

@implementation LocationHelper

@synthesize bestEffortAtLocation, locationManager;

+ (LocationHelper*)instance
{
    static LocationHelper *instance;
    
    @synchronized(self)
    {
        if (!instance)
            instance = [[LocationHelper alloc] init];
        
        return instance;
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	if ([CLLocationManager significantLocationChangeMonitoringAvailable]) {
		// Stop normal location updates and start significant location change updates for battery efficiency.
		[self.locationManager stopUpdatingLocation];
		[self.locationManager startMonitoringSignificantLocationChanges];
	}
	else {
		NSLog(@"Significant location change monitoring is not available.");
	}
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if ([CLLocationManager significantLocationChangeMonitoringAvailable]) {
		// Stop significant location updates and start normal location updates again since the app is in the forefront.
		[self.locationManager stopMonitoringSignificantLocationChanges];
		[self.locationManager startUpdatingLocation];
	}
	else {
		NSLog(@"Significant location change monitoring is not available.");
	}
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // test the age of the location measurement to determine if the measurement is cached
    // in most cases you will not want to rely on cached measurements
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 10.0) return;
    
    // test that the horizontal accuracy does not indicate an invalid measurement
    if (newLocation.horizontalAccuracy < 0) return;
    
    // test the measurement to see if it is more accurate than the previous measurement
    if (bestEffortAtLocation == nil || bestEffortAtLocation.horizontalAccuracy > newLocation.horizontalAccuracy) {
        
        NSString *gpsLocation = [[NSUserDefaults standardUserDefaults] valueForKey:@"gpsLocation"];
        if (gpsLocation && ![[gpsLocation lowercaseString] isEqualToString:@"phone"]) {
            NSString *gpsLocationCoords = [[NSUserDefaults standardUserDefaults] valueForKey:@"gpsLocationCoords"];
            NSArray *coords = [gpsLocationCoords componentsSeparatedByString:@","];

            double lat = [[coords objectAtIndex:0] doubleValue];
            double lng = [[coords objectAtIndex:1] doubleValue];

            CLLocationCoordinate2D location = CLLocationCoordinate2DMake(lat, lng);
            
            newLocation = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];

        }
        
        // store the location as the "best effort"
        self.bestEffortAtLocation = newLocation;
        
        // test the measurement to see if it meets the desired accuracy
        //
        // IMPORTANT!!! kCLLocationAccuracyBest should not be used for comparison with location coordinate or altitidue
        // accuracy because it is a negative value. Instead, compare against some predetermined "real" measure of
        // acceptable accuracy, or depend on the timeout to stop updating. This sample depends on the timeout.
        //
        if (newLocation.horizontalAccuracy <= locationManager.desiredAccuracy) {
            // we have a measurement that meets our requirements, so we can stop updating the location
            //
            // IMPORTANT!!! Minimize power usage by stopping the location manager as soon as possible.
            //
            [self stopUpdatingLocation:@"Aquired"];
            
            // we can also cancel our previous performSelector:withObject:afterDelay: - it's no longer necessary
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopUpdatingLocation:) object:nil];
            
            self.callback(bestEffortAtLocation, nil);
        }
    }
    
    if (bestEffortAtLocation != nil) {
        [self stopUpdatingLocation:@"Best"];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self.locationManager stopUpdatingLocation];
    //self.locationManager.delegate = nil;
    //self.locationManager = nil;
        
    dispatch_async(dispatch_get_main_queue(),^ {
        self.callback(bestEffortAtLocation, error);
    });
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusDenied:
            break;
        
        case kCLAuthorizationStatusRestricted:
            break;
            
        default:
            break;
    }
}

- (void)stopUpdatingLocation:(NSString *)state {

    [self.locationManager stopUpdatingLocation];
    
    dispatch_async(dispatch_get_main_queue(),^ {
        self.callback(bestEffortAtLocation, nil);
    });
}

- (CLLocation *)getBestEffortLocation
{
    return self.bestEffortAtLocation;
}

- (void)getLocation:(CallbackBlock)block
{
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    
    self.bestEffortAtLocation = nil;
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    self.callback = block;
    
    [self performSelector:@selector(stopUpdatingLocation:) withObject:@"Timeout" afterDelay:30.0];
    
    [self.locationManager startUpdatingLocation];
}

@end
