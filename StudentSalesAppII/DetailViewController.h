//
//  DetailViewController.h
//  StudentSalesAppII
//
//  Created by Lion User on 7/05/13.
//  Copyright (c) 2013 UQ DECO3800. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <CoreLocation/CoreLocation.h>

@interface DetailViewController : UIViewController
{
    IBOutlet UILabel *lblText;
    NSString *selectedObjectID;
    PFObject *selectedObject;
}

@property (nonatomic, retain) NSString *selectedObjectID;

@property (nonatomic, retain) PFObject *selectedObject;
@property (retain, nonatomic) IBOutlet UILabel *ItemTitle;
@property (retain, nonatomic) IBOutlet UIImageView *ItemImage;
@property (retain, nonatomic) IBOutlet UITextView *ItemDetails;
@property (retain, nonatomic) IBOutlet UILabel *ItemPrice;
@property (retain, nonatomic) IBOutlet UILabel *ItemLocation;
@property (retain, nonatomic) IBOutlet UIButton *callButton;
@property (retain, nonatomic) IBOutlet UIButton *emailButton;

@property (retain, nonatomic) PFGeoPoint *geoPoint;

-(IBAction)callPressed:(id)sender;
-(IBAction)emailPressed:(id)sender;
-(void)setItemObject:(PFObject *)itemObject;

@end
