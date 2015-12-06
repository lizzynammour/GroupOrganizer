//
//  AddGroupTask.m
//  GroupOrganizer
//
//  Created by Aminat Musa on 11/29/15.
//  Copyright © 2015 enammour. All rights reserved.
//

#import "AddGroupTask.h"


@interface AddGroupTask ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITextField *task;
@property (strong, nonatomic) IBOutlet UILabel *groupName;
@property NSUserDefaults *defaults;
@end

@implementation AddGroupTask

- (void)viewDidLoad {
    [super viewDidLoad];
    self.defaults = [NSUserDefaults standardUserDefaults];
    _groupName.text = [_defaults objectForKey:@"currentGroup"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}
- (IBAction)addGroupTaskButton:(id)sender {
    [self.tasks addObject:_task.text];
    PFObject *groupTask = [PFObject objectWithClassName:@"Task"];
    groupTask[@"task"] = _task.text;
    groupTask[@"group"] = _groupName.text;
    [groupTask saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded){
            [_tasks addObject:_task.text];
            [self performSegueWithIdentifier:@"addedGroupTasks" sender:self];
        }
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_tasks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    NSString *task = [_tasks objectAtIndex:indexPath.row];
    cell.textLabel.text= task;
    return cell;
}


@end
