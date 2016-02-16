//
//  ViewController.h
//  CARS
//
//  Created by Panagiotis Christodoulopoulos on 5/27/14.
//  Copyright (c) 2014 Panagiotis Christodoulopoulos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreData/CoreData.h>
#import "Entity.h"
#import "AppDelegate.h"
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController <MKMapViewDelegate>
{
    
    AppDelegate *appDelegate;
    
    IBOutlet UILabel *activityLbl;
    
    IBOutlet UILabel *xlbl;
    IBOutlet UILabel *ylbl;
    IBOutlet UILabel *zlbl;
    
    NSTimer *timer;
    
    CLLocation *latestLocation;
    
    NSMutableArray *metriseis;
    
    int pointsCounter;
    double average;
    double athroismaMetriseon;
    
    IBOutlet MKMapView *myMapView;
    
}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong,nonatomic) CMMotionManager *motionManager;
@property (strong,nonatomic) CMMotionActivityManager *motionActivityManager;

@end
