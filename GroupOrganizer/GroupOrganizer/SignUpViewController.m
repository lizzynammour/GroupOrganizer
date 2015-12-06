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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)signUpButtonPressed:(id)sender {
    [_usernameTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    [_emailTextField resignFirstResponder];
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
            //alert user that sign up failed
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Signup Failed"
                                                                           message:error.localizedDescription
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}
- (BOOL)isValidUserData {
    //check if all fields have been completed
    if (_emailTextField.text.length != 0 && _usernameTextField.text.length != 0 && _passwordTextField.text.length != 0){
        return true;
    }
    //alert user that fields are missing
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Incomplete Signup"
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
