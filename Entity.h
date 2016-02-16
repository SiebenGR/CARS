//
//  Entity.h
//  CARS
//
//  Created by Panagiotis Christodoulopoulos on 5/28/14.
//  Copyright (c) 2014 Panagiotis Christodoulopoulos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Entity : NSManagedObject

@property (nonatomic, retain) NSString * quality;
@property (nonatomic, retain) NSString * lat;
@property (nonatomic, retain) NSString * longit;

@end
