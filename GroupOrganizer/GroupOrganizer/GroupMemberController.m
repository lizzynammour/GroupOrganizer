//
//  GroupMemberController.m
//  GroupOrganizer
//
//  Created by Aminat Musa on 11/30/15.
//  Copyright © 2015 enammour. All rights reserved.
//

#import "GroupMemberController.h"


@interface GroupMemberController()

@property (strong, nonatomic) IBOutlet UITextField *userTextField;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) __block NSMutableArray *groupMembers;
@property (strong, nonatomic) __block NSMutableArray *groupMembersArray;
@property (strong, nonatomic) IBOutlet UILabel *groupName;
@property (strong, nonatomic) NSString *groupId;
@property NSUserDefaults *defaults;

@end

@implementation GroupMemberController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.defaults = [NSUserDefaults standardUserDefaults];
     _groupName.text = [_defaults objectForKey:@"currentGroup"];
    _groupId = [_defaults objectForKey:@"currentGroupId"];
     _groupMembers = [[NSMutableArray alloc] init];
     _groupMembersArray = [[NSMutableArray alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self getGroupMembers];
    
}



- (IBAction)addNewMember:(id)sender {
    //2 things: add to groups and update usertogroups
    NSString *username =_userTextField.text;
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:username];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error) {
            if([objects count] > 0) {
                PFUser *obj = objects[0];
                if(![_groupMembers containsObject:obj[@"username"]]) {
                    [_groupMembers addObject:username];
                    PFQuery *query = [PFQuery queryWithClassName:@"userToGroups"];
                    [query whereKey:@"username" equalTo:username];
                    [query getFirstObjectInBackgroundWithBlock:^(PFObject * userGroups, NSError *error) {
                        if (!error) {
                            // Found groups for given username
                            NSMutableArray *groups = userGroups[@"groupIDs"];
                            [groups addObject:_groupId];
                            [userGroups setObject:groups forKey:@"groupIDs"];
                            [userGroups saveInBackground];
                        } else {
                            // Did not find any groups for user so creae new usergroup obj
                            PFObject *userG = [PFObject objectWithClassName:@"userToGroups"];
                            NSMutableArray *groups = [[NSMutableArray alloc] init];
                            [groups addObject:_groupId];
                            [userG setObject:username forKey:@"username"];
                            [userG setObject:groups forKey:@"groupIDs"];
                            [userG saveInBackground];
                            
                        }

                    //self.userTextField.text = @"";
                    [self.tableView reloadData];
                        
                    }];
            }
            else {
                NSLog(@"user does not exist");
                self.userTextField.text = @"";
            }
            
        }
        else {
            //NSLog(error);
        }
    }
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) getGroupMembers {
    PFQuery *query = [PFQuery queryWithClassName:@"Group"];
    [query whereKey:@"name" equalTo:_groupName.text];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error) {
            for (PFObject *object in objects) {
                [self.groupMembersArray addObject: [object objectForKey:@"usernames"]];
            }
            self.groupMembers = self.groupMembersArray[0];
            [self.tableView reloadData];
            
        }
        else {
            // NSLog(error);
        }
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_groupMembers count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // We previously set the cell identifier in the storyboard.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    NSString *group = [_groupMembers objectAtIndex:indexPath.row];
    
    cell.textLabel.text= group;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   }




@end
