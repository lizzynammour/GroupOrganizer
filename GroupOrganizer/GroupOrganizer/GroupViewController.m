//
//  GroupViewController.m
//  GroupOrganizer
//
//  Created by Aminat Musa on 11/19/15.
//  Copyright © 2015 Aminat Musa. All rights reserved.
//

#import "GroupViewController.h"
#import "GroupTaskController.h"
#import "AddGroupController.h"

@interface GroupViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) __block NSMutableArray *groups;
@property (strong, nonatomic) __block NSMutableArray *groupIds;
@property (strong, nonatomic) __block NSMutableArray *groupNames;
@property (strong, nonatomic) NSString *selectedGroup;
@property (strong, nonatomic) NSString *selectedGroupId;
@end

@implementation GroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.defaults = [NSUserDefaults standardUserDefaults];
    _groupNames = [[NSMutableArray alloc] init];
    _groupIds =[[NSMutableArray alloc] init];
     _groups =[[NSMutableArray alloc] init];
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
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error) {
            NSMutableArray *groupList = [[NSMutableArray alloc] init];
            PFObject *obj = objects[0];
            [obj saveInBackground];
            groupList = [obj objectForKey:@"groupIDs"];
            int i = [groupList count];
            for (int j = 0; j < i ; j++) {
                 NSString *gid = groupList[j];
                [_groupIds addObject:gid];
                
            }
            _groupIds = groupList;
            [self getGroupObject:groupList];
             [self.tableView reloadData];
        }
        else {
           // NSLog(error);
        }
    }];

}

- (void) getGroupObject:(NSMutableArray *) groupIDs {
    PFQuery *query = [PFQuery queryWithClassName:@"Group"];
    NSMutableArray *groupList = [[NSMutableArray alloc] init];
    [query whereKey:@"objectId" containedIn:groupIDs];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
                // The find succeeded.
            for (PFObject *object in objects) {
                NSString *name = [object objectForKey:@"name"];
                [self.groups addObject:object];
                [self.groupNames addObject: name];
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_groupNames count];
}

- (IBAction)addGroupButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"AddGroupSegue" sender:self];
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedGroup = [_groupNames objectAtIndex:indexPath.row];
    self.selectedGroupId = [_groupIds objectAtIndex:indexPath.row];
    [_defaults setObject:_selectedGroup forKey:@"currentGroup"];
    [_defaults setObject:_selectedGroupId forKey:@"currentGroupId"];
    [self performSegueWithIdentifier:@"GroupSelectedSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"AddGroupSegue"]) {
        AddGroupController *add = (AddGroupController *)segue.destinationViewController;
        add.groupNames = self.groupNames;
    }
    
}





@end
