//
//  GroupTaskController.m
//  GroupOrganizer
//
//  Created by Aminat Musa on 11/29/15.
//  Copyright © 2015 enammour. All rights reserved.
//

#import "GroupTaskController.h"
#import "AddGroupTask.h"


@interface GroupTaskController ()

@property (strong, nonatomic) IBOutlet UITableView *groupTaskTableView;
@property (strong, nonatomic) IBOutlet UILabel *groupName;
@property(strong, nonatomic) NSMutableArray *groupTasks;
@property (strong, nonatomic) NSString *selectedTask;
@property NSUserDefaults *defaults;
@end

@implementation GroupTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.defaults = [NSUserDefaults standardUserDefaults];
    _groupName.text = [_defaults objectForKey:@"currentGroup"];
    _groupTasks = [[NSMutableArray alloc] init];
    self.groupTaskTableView.delegate = self;
    self.groupTaskTableView.dataSource = self;
    [self getGroupTasks];
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void) getGroupTasks {
    PFQuery *query = [PFQuery queryWithClassName:@"Task"];
    [query whereKey:@"group" equalTo:_groupName.text];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error) {
            for (PFObject *object in objects) {
                [self.groupTasks addObject: [object objectForKey:@"task"]];
            }
            [self.groupTaskTableView reloadData];
            
        }
        else {
            // NSLog(error);
        }
    }];
    
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_groupTasks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // We previously set the cell identifier in the storyboard.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [_groupTasks objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedTask = [_groupTasks objectAtIndex:indexPath.row];
    //update table to add user
    //we need to enforce unique tasks
    PFUser *user = [PFUser currentUser];
    PFObject *newObj = [PFObject objectWithClassName:@"MyTasks"];
    [newObj setValue:user.username forKey:@"user"];
    [newObj setValue:_groupName.text forKey:@"group"];
    [newObj setValue:self.selectedTask forKey:@"task"];
    [newObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
           [self performSegueWithIdentifier:@"taskSelectedSegue" sender:self];
        }
        else{
        }
        
    }];

}

//to do: did select row at index path

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"GroupTaskSegue"]) {
     AddGroupTask *add = (AddGroupTask *)segue.destinationViewController;
     add.tasks = self.groupTasks;
     }
   
}


@end
