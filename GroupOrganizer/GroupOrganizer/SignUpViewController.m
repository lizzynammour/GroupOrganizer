//
//  SignupViewController.m
//  GroupOrganizer
//
//  Created by Aminat Musa on 11/20/15.
//  Copyright © 2015 Aminat Musa. All rights reserved.
//

#import "SignupViewController.h"


@interface SignupViewController ()
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation SignupViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)signUpButtonPressed:(id)sender {
    [self isValidUserData];
    [self createNewUser];
    
}

-(void) createNewUser{
    PFUser *newUser = [PFUser user];
    newUser.username = _usernameTextField.text;
    newUser.email = _emailTextField.text;
    newUser.password = _passwordTextField.text;
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded){
            [self performSegueWithIdentifier:@"SignupSegue" sender:self];
        }
        else{
            NSLog(@"Registration Failed");
        }
    }];
}
- (BOOL)isValidUserData {
    //check if all fields have been completed
    if (_emailTextField.text.length != 0 && _usernameTextField.text.length != 0 && _passwordTextField.text.length != 0){
        return true;
    }
    //alert user that fields are missing
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Signup Cannot Be Completed"
                                                                   message:@"Please complete all fields."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
    
    return false;
}

@end
