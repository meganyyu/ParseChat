//
//  LoginViewController.m
//  ParseChat
//
//  Created by meganyu on 7/6/20.
//  Copyright © 2020 meganyu. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

static NSString *const kLoginSegue = @"loginSegue";

#pragma mark - Interface

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

#pragma mark - Implementation

@implementation LoginViewController

#pragma mark - Setup

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - User interaction

- (IBAction)didTapSignUp:(id)sender {
    [self registerUser];
}

- (IBAction)didTapLogin:(id)sender {
    [self loginUser];
}

#pragma mark - Authentication

- (void)registerUser {
    PFUser *const newUser = [PFUser user];
    
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    
    if ([self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""]) {
        [self showAlert:@"Empty fields" withMessage:@"Username or password field empty" completion:nil];
    } else {
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error != nil) {
                [self showAlert:@"Error" withMessage:error.localizedDescription completion:nil];
                NSLog(@"User registration failed: %@", error.localizedDescription);
            } else {
                NSLog(@"User registered successfully");
                
                [self performSegueWithIdentifier:kLoginSegue sender:nil];
            }
        }];
    }
}

- (void)loginUser {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            [self showAlert:@"User login failed" withMessage:error.localizedDescription completion:nil];
            NSLog(@"User login failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
            
            [self performSegueWithIdentifier:kLoginSegue sender:nil];
        }
    }];
}

- (void)showAlert:(NSString *)title withMessage:(NSString *)message completion:(void(^)(void))completion{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
