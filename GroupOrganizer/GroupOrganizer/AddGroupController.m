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

- (IBAction)createGroupButtonPressed:(id)sender {
    PFObject *group = [PFObject objectWithClassName:@"Group"];
    group[@"usernames"] = _groupNameMembers;
    NSString *groupname =_groupTextField.text;
    group[@"name"] = groupname;
    [self.groupNames addObject: groupname];
    
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
                    [self.groupNames addObject: groupname];
                    [self performSegueWithIdentifier:@"addedGroupSegue" sender:self];
                    
                }];
                
            }
        }
        else {
            //alert user that operation failed
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Operation failed"
                                                                           message:@"Could not create new group"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
    
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_groupNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [_groupNames objectAtIndex:indexPath.row];
    return cell;
}


@end
