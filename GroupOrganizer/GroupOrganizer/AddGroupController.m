//
//  AddGroupController.m
//  GroupOrganizer
//
//  Created by Lizzy Nammour on 11/28/15.
//  Copyright © 2015 enammour. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddGroupController.h"

@interface AddGroupController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITextField *userTextField;
@property (strong, nonatomic) IBOutlet UITextField *groupTextField;
@property (strong, nonatomic)  NSMutableArray *groupNameMembers;

@end

@implementation AddGroupController

- (void)viewDidLoad {
    [super viewDidLoad];
    PFUser *current = [PFUser currentUser];
    _groupNameMembers = [[NSMutableArray alloc] init];
    [_groupNameMembers addObject:current[@"username"]];


    self.tableView.delegate = self;
    self.tableView.dataSource = self;

}

- (IBAction)addUserButtonPressed:(id)sender {
    NSString *username =_userTextField.text;
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:username];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error) {
            if([objects count] > 0) {
                PFUser *obj = objects[0];
                if(![_groupNameMembers containsObject:obj[@"username"]]) {
                    [_groupNameMembers addObject:username];
                    self.userTextField.text = @"";
                    [self.tableView reloadData];
                }
            }
            else {
                NSLog(@"user does not exist");
                self.userTextField.text = @"";
            }
            
        }
        else {
            NSLog(error);
        }
    }];
    
    
}

- (IBAction)createGroupButtonPressed:(id)sender {
    PFObject *group = [PFObject objectWithClassName:@"Group"];
    group[@"usernames"] = _groupNameMembers;
    NSString *groupname =_groupTextField.text;
    group[@"name"] = groupname;
    [group saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            for(NSString *username in _groupNameMembers) {
                PFQuery *query = [PFQuery queryWithClassName:@"userToGroups"];
                [query whereKey:@"username" equalTo:username];
                [query getFirstObjectInBackgroundWithBlock:^(PFObject * userGroups, NSError *error) {
                    if (!error) {
                        // Found groups for given username
                        NSMutableArray *groups = userGroups[@"groupIDs"];
                        [groups addObject:group.objectId];
                        [userGroups setObject:groups forKey:@"groupIDs"];
                        [userGroups saveInBackground];
                    } else {
                        // Did not find any groups for user so creae new usergroup obj
                        PFObject *userG = [PFObject objectWithClassName:@"userToGroups"];
                        NSMutableArray *groups = [[NSMutableArray alloc] init];
                        [groups addObject:group.objectId];
                        [userG setObject:username forKey:@"username"];
                        [userG setObject:groups forKey:@"groupIDs"];
                        [userG saveInBackground];
                        
                       
                    }
                }];

            }
            [self performSegueWithIdentifier:@"addedGroupSegue" sender:self];


        } else {
            NSLog(error);
        }
    }];
    
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_groupNameMembers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // We previously set the cell identifier in the storyboard.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    NSString *user = [_groupNameMembers objectAtIndex:indexPath.row];
    
    cell.textLabel.text= user;
    
    return cell;
}


@end
