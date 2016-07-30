//
//  LoginVC.m
//  walking-tours-manager
//
//  Created by Keli'i Martin on 7/26/16.
//  Copyright © 2016 WERUreo. All rights reserved.
//

#import "LoginVC.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
@import Firebase;
@import FirebaseAuth;
#import "DataService.h"

@interface LoginVC ()

@end

@implementation LoginVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    //self.navigationController.navigationBar.backgroundColor = [UIColor gladeGreen];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"uid"])
    {
        [self performSegueWithIdentifier:@"UserLoggedInSegue" sender:nil];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)loginButtonTapped:(id)sender
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"email"]
                 fromViewController:self
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
                            {
                                if (error)
                                {
                                    NSLog(@"Facebook login failed.  Error %@", error.localizedDescription);
                                }
                                else
                                {
                                    NSString *accessToken = [[FBSDKAccessToken currentAccessToken] tokenString];
                                    FIRAuthCredential *credential = [FIRFacebookAuthProvider credentialWithAccessToken:accessToken];

                                    [[FIRAuth auth] signInWithCredential:credential
                                                              completion:^(FIRUser * _Nullable user, NSError * _Nullable error)
                                                              {
                                                                  if (error)
                                                                  {
                                                                      NSLog(@"Login failed. %@", error);
                                                                  }
                                                                  else
                                                                  {
                                                                      [[NSUserDefaults standardUserDefaults] setValue:user.uid forKey:@"uid"];
                                                                      [self performSegueWithIdentifier:@"UserLoggedInSegue" sender:nil];
                                                                  }
                                                              }];
                                }
                            }];
}

@end
