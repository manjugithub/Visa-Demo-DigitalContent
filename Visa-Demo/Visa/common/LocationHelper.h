#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

typedef void (^ CallbackBlock)(CLLocation *location, NSError *error);

@interface LocationHelper : NSObject <CLLocationManagerDelegate>
+ (LocationHelper*) instance;
- (void) getLocation:(CallbackBlock)block;
- (CLLocation *)getBestEffortLocation;
- (void)applicationDidEnterBackground:(UIApplication *)application;
- (void)applicationDidBecomeActive:(UIApplication *)application;

@end
