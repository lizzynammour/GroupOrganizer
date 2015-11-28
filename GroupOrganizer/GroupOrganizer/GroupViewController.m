//
//  GroupViewController.m
//  GroupOrganizer
//
//  Created by Aminat Musa on 11/19/15.
//  Copyright © 2015 Aminat Musa. All rights reserved.
//

#import "GroupViewController.h"

@interface GroupViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) __block NSMutableArray *groups;
@property (strong, nonatomic) __block NSMutableArray *groupIds;
@property (strong, nonatomic) __block NSMutableArray *groupNames;

@end

@implementation GroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self getGroupIds];

    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) getGroupIds {
    PFUser *current = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"userToGroups"];
    [query whereKey:@"username" equalTo:current[@"username"]];
    NSMutableArray *groups =  [[NSMutableArray alloc] init];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error) {
            NSMutableArray *groupList = [[NSMutableArray alloc] init];
            PFObject *obj = objects[0];
            [obj saveInBackground];
            groupList = [obj objectForKey:@"groupIDs"];
            NSLog(@"no error");
            int i = [groupList count];
            for (int j = 0; j < i ; j++) {
                NSLog(@"groupIDis ");
                 NSString *gid = groupList[j];
                [_groupIds addObject:gid];
                
            }
            _groupIds = groupList;
            [self getGroupObject:groupList];
        }
        else {
           // NSLog(error);
        }
    }];

}

- (void) getGroupObject:(NSMutableArray *) groupIDs {
    PFQuery *query = [PFQuery queryWithClassName:@"Group"];
    for(int i = 0; i < [groupIDs count] ; i++) {
        [query whereKey:@"objectId" equalTo:groupIDs[i]];
        NSMutableArray *groupList = [[NSMutableArray alloc] init];

        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded.
                for (PFObject *object in objects) {
                    [self.groups addObject:object];
                    NSString *name = [object objectForKey:@"name"];
                    [groupList addObject:name];
                    [object saveInBackground];
                }
               
                _groupNames = groupList;
                [self.tableView reloadData];
            
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        
        }];
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_groupNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // We previously set the cell identifier in the storyboard.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    NSString *group = [_groupNames objectAtIndex:indexPath.row];

    cell.textLabel.text= group;

    return cell;
}


@end
