//
//  AddViewController.m
//  StudentSalesAppII
//
//  Created by Lion User on 7/05/13.
//  Copyright (c) 2013 UQ DECO3800. All rights reserved.
//

#import "AddViewController.h"
#import "Constants.h"
#import "Device.h"

@interface AddViewController ()

-(void)showErrorView:(NSString *)errorMsg;
-(BOOL)isIntegerNumber:(NSString*)input;

@end

@implementation AddViewController

@synthesize imgToUpload = _imgToUpload;
@synthesize username = _username;
@synthesize commentTextField = _commentTextField;
@synthesize itemTitle = _itemTitle;
@synthesize itemPrice = _itemPrice;
@synthesize userEmail = _userEmail;
@synthesize userPhone = _userPhone;
@synthesize userLocation;
@synthesize loadingSpinner;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //Get the users location
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            self.userLocation = geoPoint;
        } 
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark IB Actions

-(IBAction)selectPicturePressed:(id)sender
{
    //Open a UIImagePickerController to select the picture
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [imgPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    else
    {
        [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    [imgPicker setDelegate:self];
    [self presentViewController:imgPicker animated:YES completion:nil];
    
    
    //set the sourcetype to photolibrary
    //imgPicker.delegate = self;
    //imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
       
    //[self.navigationController presentModalViewController:imgPicker animated:YES];
}

#pragma mark UIImagePicker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editInfo
{
    
    //Place the image in the imageview
    UIImage *image = [editInfo objectForKey:UIImagePickerControllerOriginalImage];
    
    
    
    [self.imgToUpload setImage:image];
    [self dismissModalViewControllerAnimated:YES];
    
}

-(IBAction)sendPressed:(id)sender
{
    [self.commentTextField resignFirstResponder];
    
    //Disable the send button until we are ready
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    //validate the users input
    BOOL *valid = TRUE;
    NSError *error;
    NSString *errorString = @"Invalid form data \n";
    
    if (![self verifyTitle]) {
        errorString = [errorString stringByAppendingString:@"Title is required \n"];
        valid = FALSE;
    }
    if (![self verifyDescription]) {
        errorString = [errorString stringByAppendingString:@"Description must be 20+ characters \n"];
        valid = FALSE;
    }
    if (![self verifyImgNotNull]) {
        errorString = [errorString stringByAppendingString:@"Image is required \n"];
        valid = FALSE;
    }
    if (![self verifyPrice]) {
        errorString = [errorString stringByAppendingString:@"Price is required \n"];
        valid = FALSE;
    }
    //make sure both a valid email and valid phone exists
    if (![self verifyEmail] && ![self verifyPhone]) {
        errorString = [errorString stringByAppendingString:@"Email or Phone is required \n"];
        valid = FALSE;
    }
    //user has entered a correct phone number but an incorrect email
    if (![self verifyEmail] && [self verifyPhone] && (![_userEmail.text isEqualToString:@"Email"] || ![_userEmail.text isEqualToString:@""])) {
        errorString = [errorString stringByAppendingString:@"Invalid email address \n"];
        valid = FALSE;
    }
    //user has entered an incorret phone number but a correct email
    if ([self verifyEmail] && ![self verifyPhone] && (![_userPhone.text isEqualToString:@"Phone"] || ![_userPhone.text isEqualToString:@""])) {
        errorString = [errorString stringByAppendingString:@"Invalid phone number \n"];
        valid = FALSE;
    }
    
    
    if (!valid) {
        [self showErrorView:errorString];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else {
    
    //Place the loading spinner
        [self presentLoadSpinner];
    
    
    //Upload a new picture
    UIImage *image = self.imgToUpload.image;
    UIGraphicsBeginImageContext(CGSizeMake(320, 200));
    [image drawInRect: CGRectMake(0, 0, 320, 200)];
    UIImage *largeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContext(CGSizeMake(60, 60));
    [image drawInRect: CGRectMake(0, 0, 60, 60)];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *pictureLargeData = UIImagePNGRepresentation(largeImage);
    NSData *pictureSmallData = UIImagePNGRepresentation(smallImage);
    
    PFFile *largeFile = [PFFile fileWithName:@"img" data:pictureLargeData];
    [largeFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        PFFile *smallFile = [PFFile fileWithName:@"img" data:pictureSmallData];
        [smallFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                // The ad saved successfully.
            } else {
                // There was an error saving the ad.
            }
        }];
        
        
        if (succeeded){
            
            //create the Parse object
            PFObject *itemObject = [self createParseObject:largeFile :smallFile];
            
            //save to parse
            [itemObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                if (succeeded){
                    
                    //Go back to the wall
                    [self.navigationController popViewControllerAnimated:YES];
                    
                    
                    
                }
                else{
                    NSString *errorString = [[error userInfo] objectForKey:@"error"];
                    [self showErrorView:errorString];
                }
            }];
        }
        else{
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            [self showErrorView:errorString];
        }
        
        [self dismissLoadSpinner];
        
    } progressBlock:^(int percentDone) {
        
    }];
    }

}

#pragma mark Input Verification

/*
 *verify the users' inputs are valid
 */

-(BOOL)verifyTitle
{
    if ((self.itemTitle.text.length < 4) || (self.itemTitle.text.length > 255) ||([self.itemTitle.text isEqualToString:@"Title"])) {
        return false;
    } else {
        return true;
    }
}

-(BOOL)verifyDescription
{
    if ((self.commentTextField.text.length < 20) || (self.commentTextField.text.length > 255) || ([self.commentTextField.text isEqualToString:@"Description"])) {
        return false;
    } else {
        return true;
    }
}

-(BOOL)verifyImgNotNull {
    if (self.imgToUpload.image == nil) {
        return false;
    } else {
        return true;
    }
}

-(BOOL)verifyPrice {
    if ((![self isIntegerNumber:self.itemPrice.text])) {
        return false;
    } else {
        return true;
    }
}
//source: blog.logichigh.com/2010/09/02/validating-an-e-mail-address
-(BOOL)verifyEmail
{
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\].[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilterString ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self.userEmail.text];
}

//currently does not support area codes or "+" prefix
-(BOOL)verifyPhone
{
    NSString *phoneRegexLocal = @"[3456789][0-9]{7}";
    NSString *phoneRegexMobile = @"[0][4][0-9]{8}";
    NSPredicate *testLocal = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegexLocal];
    NSPredicate *testMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegexMobile];
    return ([testLocal evaluateWithObject:self.userPhone.text] || [testMobile evaluateWithObject:self.userPhone.text]);                                     
}



#pragma mark loading spinner methods

-(void)presentLoadSpinner
{
    loadingSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    [loadingSpinner setCenter:CGPointMake(self.view.frame.size.width/2.0, self.view.frame.size.height/2.0)];
    [loadingSpinner startAnimating];
    
    [self.view addSubview:loadingSpinner];
}

-(void)dismissLoadSpinner
{
    [loadingSpinner stopAnimating];
    [loadingSpinner removeFromSuperview];
}

#pragma mark PFObject methods

-(PFObject *)createParseObject:(PFFile *)largeFile :(PFFile *)smallFile
{
    //create the object
    PFObject *itemObject = [PFObject objectWithClassName:WALL_OBJECT];
    //assign the images
    [itemObject setObject:largeFile forKey:KEY_IMAGE];
    [itemObject setObject:smallFile forKey:KEY_IMAGETHUMB];
    //set the post details
    [itemObject setObject:self.itemTitle.text forKey:KEY_TITLE];
    [itemObject setObject:self.itemPrice.text forKey:KEY_PRICE];
    [itemObject setObject:self.userPhone.text forKey:KEY_PHONE];
    [itemObject setObject:self.userEmail.text forKey:KEY_EMAIL];
    [itemObject setObject:self.commentTextField.text forKey:KEY_COMMENT];
    //location details
    [itemObject setObject:self.userLocation forKey:KEY_GEOLOC];
    //get the device id (to identify user)
    NSString *dId = [Device getDeviceIDString];
    [itemObject setObject:dId forKey:KEY_USER];
    
    return itemObject;
}


#pragma mark Error View


-(void)showErrorView:(NSString *)errorMsg
{
    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMsg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [errorAlertView show];
}

-(IBAction)cancelPressed:(id)sender
{
    NSLog(@"cancel tapped");
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL) isIntegerNumber: (NSString*)input
{
    return [input integerValue] != 0 || [input isEqualToString:@"0"];
}





@end
