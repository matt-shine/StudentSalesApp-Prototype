//
//  DetailViewController.m
//  StudentSalesAppII
//
//  Created by Lion User on 7/05/13.
//  Copyright (c) 2013 UQ DECO3800. All rights reserved.
//
#import "ItemViewController.h"
#import "DetailViewController.h"
#import "Constants.h"

#define firstnumber                 @"1"
#define secondnumber                @"2"

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize selectedObjectID;
@synthesize selectedObject;
@synthesize ItemTitle;
@synthesize ItemImage;
@synthesize ItemDetails;
@synthesize ItemPrice;
@synthesize ItemLocation;
@synthesize callButton;
@synthesize emailButton;
@synthesize geoPoint;

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
	// Do any additional setup after loading the view.
    
    if([selectedObject objectForKey:KEY_PHONE] == nil){
        self.callButton.hidden = YES;
    }
    if([selectedObject objectForKey:KEY_EMAIL] == nil){
        self.emailButton.hidden = YES;
    }
    
    lblText.text = selectedObjectID;
    ItemTitle.text = [selectedObject objectForKey:KEY_TITLE];
    ItemDetails.text = [selectedObject objectForKey:KEY_COMMENT];
    ItemPrice.text = [selectedObject objectForKey:KEY_PRICE];
    
    self.geoPoint = [selectedObject objectForKey:KEY_GEOLOC];
    
    //Display the suburb
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:[[CLLocation alloc] initWithLatitude:geoPoint.latitude longitude:geoPoint.longitude] completionHandler:^(NSArray *placemarks, NSError *error) {
        //get the closest placemark
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        
        //string to hold the placemark
        NSString *locatedAt = [placemark locality];
        
        //set the items location text
        ItemLocation.text = locatedAt;
    }];
     
    
    
    PFFile *theImage = [selectedObject objectForKey:@"image"];
    NSData *imageData = [theImage getData];
    UIImage *image = [UIImage imageWithData:imageData];
    ItemImage.image = image;
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark object setting methods
-(void)setItemObject:(PFObject *)itemObject
{
    self.selectedObject = itemObject;
    [self refreshItem];
}

-(void)refreshItem
{
    self.selectedObjectID = [self.selectedObject objectForKey:KEY_ID];
    [self viewDidLoad];
}


#pragma mark IBAction methods

- (IBAction)callPressed:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[selectedObject objectForKey:KEY_PHONE] message:@"do you want to call?" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil];
    alert.tag = 1;
    [alert show];
    //[alert release];
}

- (IBAction)emailPressed:(id)sender
{
    NSString *stringURL = [NSString stringWithFormat:@"mailto:%@", [selectedObject objectForKey:KEY_EMAIL]];
    NSURL *url = [NSURL URLWithString:stringURL];
    [[UIApplication sharedApplication] openURL:url];\
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.placeholder = nil;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    textField.placeholder = @"Your Placeholdertext";
}

@end
