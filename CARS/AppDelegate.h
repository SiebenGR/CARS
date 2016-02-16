//
//  AppDelegate.h
//  CARS
//
//  Created by Panagiotis Christodoulopoulos on 5/27/14.
//  Copyright (c) 2014 Panagiotis Christodoulopoulos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;

@end
