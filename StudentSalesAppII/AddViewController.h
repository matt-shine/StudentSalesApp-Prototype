//
//  AddViewController.h
//  StudentSalesAppII
//
//  Created by Lion User on 7/05/13.
//  Copyright (c) 2013 UQ DECO3800. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AddViewController : UIViewController <UIPickerViewDelegate>

@property (nonatomic, strong) IBOutlet UIImageView *imgToUpload;
@property (nonatomic, strong) IBOutlet UITextField *commentTextField;
@property (nonatomic, strong) IBOutlet UITextField *itemTitle;
@property (nonatomic, strong) IBOutlet UITextField *itemPrice;
@property (nonatomic, strong) IBOutlet UITextField *userEmail;
@property (nonatomic, strong) IBOutlet UITextField *userPhone;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) PFGeoPoint *userLocation;
@property (nonatomic, strong) UIActivityIndicatorView *loadingSpinner;

-(IBAction)selectPicturePressed:(id)sender;
-(IBAction)sendPressed:(id)sender;
-(IBAction)cancelPressed:(id)sender;

-(BOOL)verifyTitle;
-(BOOL)verifyDescription;
-(BOOL)verifyImgNotNull;
-(BOOL)verifyPrice;
-(BOOL)verifyEmail;
-(BOOL)verifyPhone;
-(void)presentLoadSpinner;
-(void)dismissLoadSpinner;
-(PFObject *)createParseObject:(PFFile *)largeFile :(PFFile *)smallFile;
-(BOOL)isIntegerNumber:(NSString *)input;
@end
