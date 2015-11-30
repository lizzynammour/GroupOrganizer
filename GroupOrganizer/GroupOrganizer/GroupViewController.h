//
//  GroupViewController.h
//  GroupOrganizer
//
//  Created by Aminat Musa on 11/19/15.
//  Copyright © 2015 Aminat Musa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface GroupViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property NSUserDefaults *defaults;

@end
