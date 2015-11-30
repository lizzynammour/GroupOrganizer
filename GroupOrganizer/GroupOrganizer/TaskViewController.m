//
//  TaskViewController.m
//  GroupOrganizer
//
//  Created by Aminat Musa on 11/19/15.
//  Copyright © 2015 Aminat Musa. All rights reserved.
//

#import "TaskViewController.h"

@interface TaskViewController ()
@property (strong, nonatomic) IBOutlet UITableView *taskTableView;
@property(strong, nonatomic) NSMutableArray *tasks;
@end

@implementation TaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tasks = [[NSMutableArray alloc] init];
    self.taskTableView.delegate = self;
    self.taskTableView.dataSource = self;
    [self getMyTasks];

    // Do any additional setup after loading the view, typically from a nib.
}

-(void) getMyTasks {
    PFUser *user = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"MyTasks"];
    [query whereKey:@"user" equalTo:user.username];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error) {
            for (PFObject *object in objects) {
                [self.tasks addObject: [object objectForKey:@"task"]];
            }
            [self.taskTableView reloadData];
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



-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_tasks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // We previously set the cell identifier in the storyboard.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [_tasks objectAtIndex:indexPath.row];
    return cell;
}


//to do: did select row at index path


@end
