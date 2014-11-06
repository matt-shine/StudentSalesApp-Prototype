//
//  DetailViewControllerTests.m
//  StudentSalesAppII
//
//  Conducts testing on the DetailViewController class
//  Note: Unit Testing not possible/unapplicable for the following methods:
//          * initWithNibName (initializer, simply calls super class)
//          * didReceiveMemeoryWarning (simply calls super class to unload resources)
//          * callPressed (IBAction - must be tested manually)
//          * emailPressed (IBAction - must be tested manually)
//          * alertView (

//  Created by Matt-MAC on 11/05/13.
//  Copyright (c) 2013 UQ DECO3800. All rights reserved.
//

#import "DetailViewControllerTests.h"


@implementation DetailViewControllerTests

@synthesize testDetailViewController;
@synthesize testObject; //the object we'll use with tests
@synthesize storyboard;

/*
 * Setup the DetailViewController and testObject [which are used throughout the tests]
 */
-(void)setUp
{
    [super setUp];
   
    //Get an object from parse to test with
    testObject = [self retrieveObjectWithID:@"nf4v4HzDJU"];
    
    //Setup the storyboard so we can assign the DetailViewController to it
    storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    //instantiate the view controller, push it to the storyboard
    self.testDetailViewController = [storyboard instantiateViewControllerWithIdentifier:@"Detail"];
    //point the instance variables to our current object --(should be handled in initialization in final product)--
    self.testDetailViewController.selectedObject = testObject;
    self.testDetailViewController.selectedObjectID = testObject.objectId;
    [self.testDetailViewController loadView]; //load the view
    
}

#pragma mark TESTS
/*
 *Test the DetailViewController viewDidLoad method
 */
-(void)testViewDidLoad
{
    [testDetailViewController viewDidLoad];
    
    //First test the controllers' properties have been created as expected
    STAssertTrue([testDetailViewController.ItemTitle isKindOfClass:[UILabel class]], @"Instead of the %@, we have %@",[UILabel class], [testDetailViewController.ItemTitle class]);
    STAssertTrue([testDetailViewController.ItemDetails isKindOfClass:[UITextView class]],@"Instead of the %@, we have $@", [UITextView class], [testDetailViewController.ItemDetails class]);
    STAssertTrue([testDetailViewController.selectedObject isKindOfClass:[PFObject class]], @"Instead of the %@, we have %@", [PFObject class], [testDetailViewController.selectedObject class]);
    STAssertTrue([testDetailViewController.ItemImage isKindOfClass:[UIImageView class]], @"Instead of the %@, we have %@", [UIImage class],[testDetailViewController.ItemImage class]);
    STAssertTrue([testDetailViewController.ItemPrice isKindOfClass:[UILabel class]], @"Instead of the %@, we have %@", [UILabel class], [testDetailViewController.ItemPrice class]);
    STAssertTrue([testDetailViewController.ItemLocation isKindOfClass:[UILabel class]], @"Instead of the %@, we have %@", [UILabel class], [testDetailViewController.ItemLocation class]);
    STAssertTrue([testDetailViewController.callButton isKindOfClass:[UIButton class]], @"Instead of the %@, we have %@", [UIButton class], [testDetailViewController.callButton class]);
    STAssertTrue([testDetailViewController.emailButton isKindOfClass:[UIButton class]], @"Instead of the %@, we have %@", [UIButton class], [testDetailViewController.emailButton class]);
    STAssertTrue([testDetailViewController.geoPoint isKindOfClass:[PFGeoPoint class]], @"Instead of the %@, we have %@", [PFGeoPoint class], [testDetailViewController.geoPoint class]);
    
    //now test the call/email buttons
    STAssertFalse([testDetailViewController.callButton isHidden], @"Expected call button hidden to be false, got true");
    STAssertFalse([testDetailViewController.emailButton isHidden], @"Expected email button hidden to be false, got true"); //this should actually fail, as no email set on this item
    
    //now test the contents of the UI elements match our test objects
    STAssertEqualObjects(testDetailViewController.ItemTitle.text, [testObject objectForKey:KEY_TITLE],
                         @"Expected the ItemTitle to be set to '%@' instead was %@",[testObject objectForKey:KEY_TITLE], testDetailViewController.ItemTitle.text);
    STAssertEqualObjects(testDetailViewController.ItemDetails.text, [testObject objectForKey:KEY_COMMENT],
                         @"Expected the ItemDetails to be set to '%@' instead was %@",[testObject objectForKey:KEY_COMMENT], testDetailViewController.ItemDetails.text);
    STAssertEqualObjects(testDetailViewController.ItemPrice.text, [testObject objectForKey:KEY_PRICE],
                         @"Expected the ItemPrice to be set to '%@' instead was %@",[testObject objectForKey:KEY_COMMENT], testDetailViewController.ItemPrice.text);
    
    //test the locaction is correct
    PFGeoPoint *geoPoint = [testObject objectForKey:KEY_GEOLOC];
    STAssertEqualObjects(testDetailViewController.ItemLocation.text, ([NSString stringWithFormat:@"Lat: %f Long: %f", geoPoint.latitude, geoPoint.longitude]),
                         @"Expected the ItemLocation to be set to '%@' instead was %@",[testObject objectForKey:KEY_GEOLOC], testDetailViewController.ItemLocation.text);
}


/*
 * Note: This test also sufficiently tests the refreshItem test, which is called 
 * within setItemObject
 */
-(void)testSetItemObject
{
    //Grab a new item
    PFObject *setItemObject = [self retrieveObjectWithID:@"fOqxvyiTGa"];
    
    [testDetailViewController setItemObject:setItemObject]; //call the update method
    //test some of the elements to make sure they have been updated
    STAssertEqualObjects(testDetailViewController.ItemTitle.text, [setItemObject objectForKey:KEY_TITLE], @"Expected the ItemTitle to be set to '%@' instead was %@",[setItemObject objectForKey:KEY_TITLE], testDetailViewController.ItemTitle.text);
    STAssertEqualObjects(testDetailViewController.ItemDetails.text, [setItemObject objectForKey:KEY_COMMENT], @"Expected the ItemDetails to be set to '%@' instead was %@",[setItemObject objectForKey:KEY_COMMENT], testDetailViewController.ItemDetails.text);
    STAssertEqualObjects([testDetailViewController.selectedObject objectId], [setItemObject objectId], @"Expected the objectId to be set to '%@' instead was %@",[setItemObject objectId], [testDetailViewController.selectedObject objectId]);
    STAssertEqualObjects(testDetailViewController.ItemPrice.text, [setItemObject objectForKey:KEY_PRICE], @"Expected the ItemPrice to be set to '%@' instead was %@",[setItemObject objectForKey:KEY_PRICE], testDetailViewController.ItemPrice.text);

    //test the locaction is correct
    PFGeoPoint *geoPoint = [setItemObject objectForKey:KEY_GEOLOC];
    STAssertEqualObjects(testDetailViewController.ItemLocation.text, ([NSString stringWithFormat:@"Lat: %f Long: %f", geoPoint.latitude, geoPoint.longitude]),
                         @"Expected the ItemLocation to be set to '%@' instead was %@",[setItemObject objectForKey:KEY_GEOLOC], testDetailViewController.ItemLocation.text);
    
}




#pragma mark Test Helper Methods

/*
 * Queries Parse and returns the object with the given id
 *
 * @pre idForItem must be valid object id
 */
-(PFObject *)retrieveObjectWithID:(NSString *)idForItem
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"objectId = %@", idForItem];
    PFQuery *query = [PFQuery queryWithClassName:@"Todo" predicate:predicate];
    return [query getFirstObject];
}



@end
