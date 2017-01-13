//
//  UIViewController+Alert.m
//  PruebaIOS
//
//  Created by José Luis Sánchez-Porro Godoy on 13/1/17.
//  Copyright © 2017 José Luis Sánchez-Porro Godoy. All rights reserved.
//

#import "UIViewController+Alert.h"
#import <objc/runtime.h>
/*! @var kOK
 @brief Text for an 'OK' button.
 */
static NSString *const kOK = @"OK";
/*! @var kCancel
 @brief Text for an 'Cancel' button.
 */
static NSString *const kCancel = @"Cancel";

/*! @var kPleaseWaitAssociatedObjectKey
 @brief Key used to identify the "please wait" spinner associated object.
 */
static NSString *const kPleaseWaitAssociatedObjectKey =
@"_UIViewControllerAlertCategory_PleaseWaitScreenAssociatedObject";

@implementation UIViewController (Alert)

- (void)showMessagePrompt:(NSString *)message {
   
        UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:nil
                                            message:message
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction =
        [UIAlertAction actionWithTitle:kOK style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)showTextInputPromptWithMessage:(NSString *)message
                       completionBlock:(AlertPromptCompletionBlock)completion {
            UIAlertController *prompt =
        [UIAlertController alertControllerWithTitle:nil
                                            message:message
                                     preferredStyle:UIAlertControllerStyleAlert];
        __weak UIAlertController *weakPrompt = prompt;
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:kCancel
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *_Nonnull action) {
                                                                 completion(NO, nil);
                                                             }];
        UIAlertAction *okAction =
        [UIAlertAction actionWithTitle:kOK
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *_Nonnull action) {
                                   UIAlertController *strongPrompt = weakPrompt;
                                   completion(YES, strongPrompt.textFields[0].text);
                               }];
        [prompt addTextFieldWithConfigurationHandler:nil];
        [prompt addAction:cancelAction];
        [prompt addAction:okAction];
        [self presentViewController:prompt animated:YES completion:nil];
    
}
- (void)showSpinner:(nullable void (^)(void))completion {
    UIAlertController *pleaseWaitAlert =
    objc_getAssociatedObject(self, (__bridge const void *)(kPleaseWaitAssociatedObjectKey));
    if (pleaseWaitAlert) {
        if (completion) {
            completion();
        }
        return;
    }
    pleaseWaitAlert = [UIAlertController alertControllerWithTitle:nil
                                                          message:@"Please Wait...\n\n\n\n"
                                                   preferredStyle:UIAlertControllerStyleAlert];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]
                                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.color = [UIColor blackColor];
    spinner.center = CGPointMake(pleaseWaitAlert.view.bounds.size.width / 2,
                                 pleaseWaitAlert.view.bounds.size.height / 2);
    spinner.autoresizingMask =
    UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [spinner startAnimating];
    [pleaseWaitAlert.view addSubview:spinner];
    
    objc_setAssociatedObject(self, (__bridge const void *)(kPleaseWaitAssociatedObjectKey),
                             pleaseWaitAlert, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self presentViewController:pleaseWaitAlert animated:YES completion:completion];
}

- (void)hideSpinner:(nullable void (^)(void))completion {
    UIAlertController *pleaseWaitAlert =
    objc_getAssociatedObject(self, (__bridge const void *)(kPleaseWaitAssociatedObjectKey));
    
    [pleaseWaitAlert dismissViewControllerAnimated:YES completion:completion];
    
    objc_setAssociatedObject(self, (__bridge const void *)(kPleaseWaitAssociatedObjectKey), nil,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
