//
//  ViewController.m
//  GroupOrganizer
//
//  Created by Aminat Musa on 11/19/15.
//  Copyright © 2015 Aminat Musa. All rights reserved.
//

#import "LoginViewController.h"


@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)isValidUserData {
    //check if all fields have been completed
    if (_usernameTextField.text.length != 0 && _passwordTextField.text.length != 0){
        return true;
    }
    //alert user that fields are missing
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Sigin Cannot Be Completed"
                                                                   message:@"Please complete all fields."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    return false;
}
- (IBAction)signinButtonPressed:(id)sender {
    [self isValidUserData];
    [self logInUser: _usernameTextField.text withPassword:_passwordTextField.text];
    
}

-(void) logInUser:(NSString *)userName withPassword:(NSString *)password {
    [PFUser logInWithUsernameInBackground:userName
                                 password:password
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            [self performSegueWithIdentifier:@"SigninSegue" sender:self];
                                            
                                        } else {
                                            //alert user that login failed
                                            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Login Failed"
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


@end
