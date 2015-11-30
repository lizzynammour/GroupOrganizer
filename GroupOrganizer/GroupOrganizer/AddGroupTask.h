//
//  AddGroupTask.h
//  GroupOrganizer
//
//  Created by Aminat Musa on 11/29/15.
//  Copyright © 2015 enammour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AddGroupTask : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic)  NSMutableArray *tasks;

@end