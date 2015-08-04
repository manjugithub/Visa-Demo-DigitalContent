//
//  AppSettings.h
//  Visa-Demo
//
//  Created by Shailesh Namjoshi on 11/3/14.
//  Copyright 2014 Fastacash. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppSettings : NSObject {
	
}

+ (id)get:(NSString *)key;
+ (NSString *)getEnvironment;
@end
