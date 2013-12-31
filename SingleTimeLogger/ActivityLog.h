//
//  ActivityLog.h
//  EorzeaRecord
//
//  Created by ichiko on 2013/12/27.
//  Copyright (c) 2013年 ichiko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ActivityLog : NSManagedObject

@property (nonatomic, retain) NSNumber * activityType;
@property (nonatomic, retain) NSDate * timestamp;

@end
