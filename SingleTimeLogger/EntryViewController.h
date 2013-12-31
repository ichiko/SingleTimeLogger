//
//  EntryViewController.h
//  EorzeaRecord
//
//  Created by ichiko on 2013/12/30.
//  Copyright (c) 2013年 ichiko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"

@interface EntryViewController : UIViewController <NSFetchedResultsControllerDelegate>

- (void)startTimer;
- (void)stopTimer;

@end
