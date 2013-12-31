//
//  DataManager.m
//  EorzeaRecord
//
//  Created by ichiko on 2013/12/30.
//  Copyright (c) 2013年 ichiko. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager
{
    NSManagedObjectContext *_context;
    NSPersistentStoreCoordinator *_coordinator;
}

static DataManager *_instance;

+ (DataManager *) sharedDataManager
{
    if (_instance != nil)
        return _instance;
    
    _instance = [[DataManager alloc] init];
    return _instance;
}

#pragma mark - Managed Object Context

static NSString *const MODEL_NAME = @"RecordModel";
static NSString *const DB_NAME = @"eorzearecord.sqlite";

- (NSString *) applicationDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (NSManagedObjectContext *) managedObjectContext
{
    if (_context != nil)
        return _context;
    
    NSPersistentStoreCoordinator *persistentStoreCoodinator = [self coodinator];
    if (persistentStoreCoodinator != nil)
    {
        _context = [[NSManagedObjectContext alloc] init];
        [_context setPersistentStoreCoordinator:persistentStoreCoodinator];
    }
    
    return _context;
}

- (NSPersistentStoreCoordinator *) coodinator
{
    if (_coordinator != nil)
        return _coordinator;
    
    NSURL *modelURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:MODEL_NAME ofType:@"momd"]];
    NSURL *storeURL = [NSURL fileURLWithPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:DB_NAME]];
    
    NSManagedObjectModel *managedObjectModel;
    NSError *error = nil;
    
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    _coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: managedObjectModel];
    
    if (! [_coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                    configuration:nil URL:storeURL options:nil error:&error
           ])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _coordinator;
}

#pragma mark - Record Read/Write

- (NSFetchedResultsController *)fetchedResultController
{
    NSManagedObjectContext *context = [self managedObjectContext];
    // ActivityLogをFetchしてくる
    NSFetchRequest *request = [[NSFetchRequest alloc] init];

    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ActivityLog" inManagedObjectContext:context];
    [request setEntity:entity];

    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObject:sort]];

    [request setFetchBatchSize:10];

    NSFetchedResultsController *fetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];

    return fetchedResultController;
}

- (void)addRecordAndSave
{
    NSManagedObjectContext *context = [self managedObjectContext];
    ActivityLog *activity = (ActivityLog *)[NSEntityDescription insertNewObjectForEntityForName:@"ActivityLog" inManagedObjectContext:context];
    
    activity.activityType = [[NSNumber alloc] initWithInt:1];
    activity.timestamp = [NSDate date];
    
    [self save];
}

- (void)deleteAndSave:(NSManagedObjectModel *)obj
{
    NSManagedObjectContext *context = [self managedObjectContext];
    ActivityLog *activity = (ActivityLog *)obj;

    [context deleteObject:activity];

    [self save];
}

- (void)save
{
    NSManagedObjectContext *context = [self managedObjectContext];

    NSError *error = nil;
    if (! [context save:&error])
    {
        NSLog(@"CoreData save Error : %@, %@", error, [error userInfo]);
    }
}

@end
