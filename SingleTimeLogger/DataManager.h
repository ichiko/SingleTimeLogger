//
//  DataManager.h
//  EorzeaRecord
//
//  Created by ichiko on 2013/12/30.
//  Copyright (c) 2013年 ichiko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ActivityLog.h"

@interface DataManager : NSObject

+ (DataManager *)sharedDataManager;

- (NSFetchedResultsController *)fetchedResultController;
- (void)addRecordAndSave;
- (void)deleteAndSave:(NSManagedObjectModel *)obj;

@end
