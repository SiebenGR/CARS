//
//  ViewController.m
//  CARS
//
//  Created by Panagiotis Christodoulopoulos on 5/27/14.
//  Copyright (c) 2014 Panagiotis Christodoulopoulos. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    xlbl.text = @"0.00";
    ylbl.text = @"0.00";
    zlbl.text = @"0.00";
    
    myMapView.delegate = self;
    myMapView.showsUserLocation = YES;
    
    metriseis = [[NSMutableArray alloc]init];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if([CMMotionActivityManager isActivityAvailable]) {
        
        self.motionManager = [[CMMotionManager alloc] init];
        self.motionActivityManager = [[CMMotionActivityManager alloc] init];
        
        //starting accel
        self.motionManager.accelerometerUpdateInterval = 0.1;  // 10 Hz
        [self.motionManager startAccelerometerUpdates];
        
        //timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(getValues:) userInfo:nil repeats:YES];
        
        [self.motionActivityManager startActivityUpdatesToQueue:[[NSOperationQueue alloc] init]
                                                withHandler:^(CMMotionActivity *activity) {
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 if (activity.stationary)
                 {
                     activityLbl.text = @"Κατάσταση συσκευής: Ακίνητη";
                     [self stoprecording];
                 }
                 else if (activity.walking)
                 {
                     activityLbl.text = @"Κατάσταση συσκευής: Περπάτημα";
                     [self stoprecording];
                 }
                 else if (activity.running)
                 {
                     activityLbl.text = @"Κατάσταση συσκευής: Τρέξιμο";
                     [self stoprecording];
                 }
                 else if (activity.automotive)
                 {
                     activityLbl.text = @"Κατάσταση συσκευής: Αυτοκίνητο";
                     [self startRecording];
                 }
                 else if (activity.unknown)
                 {
                     activityLbl.text = @"Κατάσταση συσκευής: Άγνωστη";
                     [self stoprecording];
                 }
                 
             });
         }];
        
    }
    
//    if([CMMotionActivityManager isActivityAvailable]) {
//        CMMotionActivityManager *cm = [[CMMotionActivityManager alloc] init];
//        CMStepCounter *sc = [[CMStepCounter alloc] init];
//        NSDate *today = [NSDate date];
//        NSDate *lastWeek = [today dateByAddingTimeInterval:-(86400*7)];
//        [cm queryActivityStartingFromDate:lastWeek toDate:today toQueue:[NSOperationQueue mainQueue] withHandler:^(NSArray *activities, NSError *error){
//            for(int i=0;i<[activities count]-1;i++) {
//                CMMotionActivity *a = [activities objectAtIndex:i];
//                NSString *confidence = @"low";
//                if (a.confidence == CMMotionActivityConfidenceMedium) confidence = @"medium";
//                if (a.confidence == CMMotionActivityConfidenceHigh) confidence = @"high";
//                NSString *motion = @"";
//                if (a.stationary) motion = [motion stringByAppendingString:@"stationary "];
//                if (a.walking) motion = [motion stringByAppendingString:@"walking "];
//                if (a.running) motion = [motion stringByAppendingString:@"running "];
//                if (a.automotive) motion = [motion stringByAppendingString:@"automotive "];
//                
//                // Now get steps as well
//                [sc queryStepCountStartingFrom:a.startDate to:[[activities objectAtIndex:i+1] startDate] toQueue:[NSOperationQueue mainQueue] withHandler:^(NSInteger numberOfSteps, NSError *error) {
//                    NSLog(@"%@ confidence %@ type %@ steps %ld", [NSDateFormatter localizedStringFromDate:a.startDate dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterShortStyle], confidence, motion, (long)numberOfSteps);
//                }];
//            }
//        }];
//    } else {
//        NSLog(@"cm not ok");
//    }
    
}

-(void)startRecording
{
    
    if (![timer isValid])
    {
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(getValues:) userInfo:nil repeats:YES];
    }
    
}

-(void)stoprecording
{
    
    [timer invalidate];
    timer = nil;
    
    xlbl.text = @"0.00";
    ylbl.text = @"0.00";
    zlbl.text = @"0.00";
    
}

-(void) getValues:(NSTimer *) timer
{
    
    if (latestLocation != appDelegate.currentLocation)
    {
        
        average = ((double)athroismaMetriseon / pointsCounter);
        
        for (int i = 0; i < metriseis.count; i++)
        {
            
            double quality = ((double)[[metriseis objectAtIndex:i]doubleValue] - (double)average);
            
            Entity* newEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Entity" inManagedObjectContext:self.managedObjectContext];
            
            [newEntity setQuality:[NSString stringWithFormat:@"%.3f",fabs(quality)]];
            [newEntity setLat:[NSString stringWithFormat:@"%+.6f", appDelegate.currentLocation.coordinate.latitude]];
            [newEntity setLongit:[NSString stringWithFormat:@"%+.6f", appDelegate.currentLocation.coordinate.longitude]];
            
            NSError *mocSaveError = nil;
            
            if (![self.managedObjectContext save:&mocSaveError])
            {
                NSLog(@"Error: %@",
                      [mocSaveError localizedDescription]);
            }
            
        }
        
        [metriseis removeAllObjects];
        
        latestLocation = appDelegate.currentLocation;
        
        athroismaMetriseon = 0;
        
        pointsCounter = 0;
        
    }
    else
    {
        
        pointsCounter ++;
        
        athroismaMetriseon += (self.motionManager.accelerometerData.acceleration.x + self.motionManager.accelerometerData.acceleration.y + self.motionManager.accelerometerData.acceleration.z);
        
        double temp = ((double)self.motionManager.accelerometerData.acceleration.x + (double)self.motionManager.accelerometerData.acceleration.y + (double)self.motionManager.accelerometerData.acceleration.z);
        
        [metriseis addObject:[NSNumber numberWithDouble:temp]];
        
    }
    
    xlbl.text = [NSString stringWithFormat:@"%.2f",self.motionManager.accelerometerData.acceleration.x];
    ylbl.text = [NSString stringWithFormat:@"%.2f",self.motionManager.accelerometerData.acceleration.y];
    zlbl.text = [NSString stringWithFormat:@"%.2f",self.motionManager.accelerometerData.acceleration.z];
    
}

- (NSManagedObjectContext *) managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    return _managedObjectContext;
}

//2
- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return _managedObjectModel;
}

//3
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory]
                                               stringByAppendingPathComponent: @"CarsData.sqlite"]];
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                   initWithManagedObjectModel:[self managedObjectModel]];
    if(![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                  configuration:nil URL:storeUrl options:nil error:&error]) {
        /*Error for store creation should be handled in here*/
    }
    
    return _persistentStoreCoordinator;
}

- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
