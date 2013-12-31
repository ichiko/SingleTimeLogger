//
//  EntryViewController.m
//  EorzeaRecord
//
//  Created by ichiko on 2013/12/30.
//  Copyright (c) 2013年 ichiko. All rights reserved.
//

#import "EntryViewController.h"

@interface EntryViewController ()

@end

@implementation EntryViewController
{
    IBOutlet UILabel *latestRecordLabel;
    IBOutlet UILabel *timeBeforeLabel;
    NSTimer *updateTimer;

    NSFetchedResultsController *_fetchedResultController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSError *error = nil;
    if (! [[self fetchedResultController] performFetch:&error])
    {
        NSLog(@"Unresolved Error : %@, %@", error, [error userInfo]);
    }
    [self updateLabels];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateLabels];
    [self startTimer];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self stopTimer];
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSFetchedResultsController *)fetchedResultController
{
    if (_fetchedResultController != nil)
        return _fetchedResultController;

    _fetchedResultController = [[DataManager sharedDataManager] fetchedResultController];
    _fetchedResultController.delegate = self;
    return _fetchedResultController;
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self updateLabels];
            break;
        default:
            break;
    }
}

- (void)updateLabels
{
    NSFetchedResultsController *controller = [self fetchedResultController];

    if ([[controller sections] count] > 0 && [[[controller sections] objectAtIndex:0] numberOfObjects] > 0)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        ActivityLog *activity = [[self fetchedResultController] objectAtIndexPath:indexPath];

        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        // Localeの指定
        [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]];
        [df setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
        latestRecordLabel.text = [df stringFromDate:activity.timestamp];

        NSDate *now = [NSDate date];
        float tmp = [now timeIntervalSinceDate:activity.timestamp];
        int dd = (int)(tmp / (60 * 60 * 24));
        int hh = (int)((tmp - dd * 60 * 60 * 24) / (60 * 60));
        int mm = (int)((tmp - hh * 60 * 60) / 60);
        if (dd > 0)
        {
            timeBeforeLabel.text = [[NSString alloc] initWithFormat:@"%02d日 %02d:%02d 前", dd, hh, mm];
        }
        else
        {
            timeBeforeLabel.text = [[NSString alloc] initWithFormat:@"%02d:%02d 前", hh, mm];
        }
    }
    else
    {
        latestRecordLabel.text = @"レコードなし";
        timeBeforeLabel.text = @"";
    }
}

- (IBAction)putRecord
{
    [[DataManager sharedDataManager] addRecordAndSave];
}

- (void)startTimer
{
    if (updateTimer == nil)
    {
        updateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateLabels) userInfo:nil repeats:YES];
        NSLog(@"Timer created");
    }
}

- (void)stopTimer
{
    if (updateTimer != nil)
    {
        if ([updateTimer isValid])
        {
            [updateTimer invalidate];
            NSLog(@"Timer disabled");
            updateTimer = nil;
        }
    }
}

@end
