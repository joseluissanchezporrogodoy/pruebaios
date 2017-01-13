//
//  ViewController.m
//  PruebaIOS
//
//  Created by José Luis Sánchez-Porro Godoy on 13/1/17.
//  Copyright © 2017 José Luis Sánchez-Porro Godoy. All rights reserved.
//

#import "LoginViewController.h"
#import "UIViewController+Alert.h"
@import FirebaseAuth;
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)didTapEmailLogin:(id)sender {
    [self showSpinner:^{
        // [START headless_email_auth]
        [[FIRAuth auth] signInWithEmail:_emailField.text
                               password:_passwordField.text
                             completion:^(FIRUser *user, NSError *error) {
                                 // [START_EXCLUDE]
                                 [self hideSpinner:^{
                                     if (error) {
                                         [self showMessagePrompt:error.localizedDescription];
                                         return;
                                     }
                                     [self.navigationController popViewControllerAnimated:YES];
                                 }];
                                 // [END_EXCLUDE]
                             }];
        // [END headless_email_auth]
    }];
}


@end
