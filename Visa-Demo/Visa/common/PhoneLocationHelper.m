//
//  PhoneLocationHelper.h
//  Venus
//
//  Created by Shailesh Namjoshi on 11/04/2014.
//  Copyright (c) 2014 Fastacash. All rights reserved.
//

#import "PhoneLocationHelper.h"
#import "LocationHelper.h"

@interface PhoneLocationHelper () {
    CLLocationCoordinate2D currentLocation;
    BOOL foundLocation;
}
@end

@implementation PhoneLocationHelper

@synthesize delegate = _delegate;
@synthesize locatedAtCountry = _locatedAtCountry;
@synthesize locatedAtISOCountry = _locatedAtISOCountry;
@synthesize dialingCode = _dialingCode;
@synthesize dialingCodeDictionary = _dialingCodeDictionary;

- (id)initWithDelegate:(id<PhoneLocationHelperDelegate>)delegate
{
    if (self = [super init]) {
        self.delegate = delegate;
        self.dialingCodeDictionary = [self getDialingCodes];
    }
    
    return self;
}


- (void)start
{
    foundLocation = NO;
    [[LocationHelper instance] getLocation:^(CLLocation *location, NSError *error) {
        if (error != nil) {
            if (_delegate && [_delegate respondsToSelector:@selector(phoneLocationHelper:locationDidFinish:)]) {
                [_delegate phoneLocationHelper:self locationDidFinish:error];
            }
            return;
        }
        if (foundLocation) {
            return;
        }
        foundLocation = YES;

        currentLocation = location.coordinate;
        
        // sydney
        //currentLocation = CLLocationCoordinate2DMake(1.3000, 103.8000);
        BOOL gpsSingapore = [[NSUserDefaults standardUserDefaults] boolForKey:@"gpsSingapore"];
        if (gpsSingapore) {
            currentLocation = CLLocationCoordinate2DMake(1.3000, 103.8000);
        }
        
        // san fran
        //currentLocation = CLLocationCoordinate2DMake(37.776278, -122.419367);
        
        // sydney
        //currentLocation = CLLocationCoordinate2DMake(-33.859972, 151.211111);
        
        // london
        //currentLocation = CLLocationCoordinate2DMake(51.50812890,-0.12800500);
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        CLLocation *geolocation = [[CLLocation alloc] initWithLatitude:currentLocation.latitude longitude:currentLocation.longitude];
        
        [geocoder reverseGeocodeLocation:geolocation completionHandler:^(NSArray *placemarks, NSError *error) {
            NSLog(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");
            
            if (error) {
                NSLog(@"Geocode failed with error: %@", error);
                
                if (_delegate && [_delegate respondsToSelector:@selector(phoneLocationHelper:locationDidFinish:)]) {
                    [_delegate phoneLocationHelper:self locationDidFinish:error];
                }

                return;
                //[self displayError:error];
            }
            
            NSLog(@"Received placemarks: %@", placemarks);
            
            //Get nearby address
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            
            //String to hold address
            self.locatedAtCountry = placemark.country;
            self.locatedAtISOCountry = placemark.ISOcountryCode;
            self.dialingCode = [self findDialingCode:_locatedAtISOCountry];
            NSLog(@"Dialing Code : %@",self.dialingCode);
    
            if (_delegate && [_delegate respondsToSelector:@selector(phoneLocationHelper:withCountry:withDialingCode:withCountryCode:)]) {
                [_delegate phoneLocationHelper:self withCountry:self.locatedAtCountry withDialingCode:self.dialingCode withCountryCode:self.locatedAtISOCountry];

            }
            
        }];
        
    }];
}


-(NSString *)findDialingCode:(NSString *)countryCode{
    // loop through the dictionary and get the code
    for (NSString* key in self.dialingCodeDictionary) {
        // get the value for a key
        id value = [self.dialingCodeDictionary objectForKey:key];
        // check if the key equals the selected Country Code
        if ( [key isEqualToString:countryCode]){
            // found the key, return from it.
            return value;
            break;
        }
    }
    return nil;
}


- (void)stop
{
    foundLocation = YES;
}

-(NSDictionary *)getDialingCodes{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"DialingCodes" ofType:@"plist"];
    return [NSDictionary dictionaryWithContentsOfFile:filePath];
}

@end
