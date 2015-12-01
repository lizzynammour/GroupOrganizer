//
//  GroupMemberController.m
//  GroupOrganizer
//
//  Created by Aminat Musa on 11/30/15.
//  Copyright © 2015 enammour. All rights reserved.
//

#import "GroupMemberController.h"


@interface GroupMemberController()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) __block NSMutableArray *groupMembers;
@property (strong, nonatomic) __block NSMutableArray *groupMembersArray;
@property (strong, nonatomic) IBOutlet UILabel *groupName;
@property NSUserDefaults *defaults;

@end

@implementation GroupMemberController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
     _groupName.text = [_defaults objectForKey:@"currentGroup"];
     _groupMembers = [[NSMutableArray alloc] init];
     _groupMembersArray = [[NSMutableArray alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self getGroupMembers];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) getGroupMembers {
    PFQuery *query = [PFQuery queryWithClassName:@"Group"];
    [query whereKey:@"group" equalTo:_groupName.text];
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
