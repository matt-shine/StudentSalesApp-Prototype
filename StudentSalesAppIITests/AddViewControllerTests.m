//
//  AddViewControllerTests.m
//  StudentSalesAppII
//
//  Created by Matt-MAC on 15/05/13.
//  Copyright (c) 2013 UQ DECO3800. All rights reserved.
//

#import "AddViewControllerTests.h"

@implementation AddViewControllerTests

@synthesize storyboard;
@synthesize testAddViewController;

-(void)setUp
{
    storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    self.testAddViewController = [storyboard instantiateViewControllerWithIdentifier:@"AddItem"];
    [self.testAddViewController loadView];
}

-(void)testVerifyTitle
{
    //Verify false returned for title length < 4
    [testAddViewController.itemTitle setText:@"a"];
    STAssertFalse([testAddViewController verifyTitle], @"Expected verifyTitle to return false with title length < 4, got %@", [testAddViewController verifyTitle]);
    
    //Verify false returned for title length > 255
    NSString *longString = @"LzaP5xgyX2XmOQsPsJdLk0jJHI8OCAvYCElpcVTPx5Ao4AywURizGEFFOuuMQnV4ODAc0kxJP5krTU5WU2s4KCy6Sm5ETnKCnVbqi4GVfPrKZbepc64KwOkK3TdbF1CoJ5uoRGNBNQaxjrihFryhA1LzaP5xgyX2XmOQsPsJdLk0jJHI8OCAvYCElpcVTPx5Ao4AywURizGEFFOuuMQnV4ODAc0kxJP5krTU5WU2s4KCy6Sm5ETnKCnVbqi4GVfPrKZbepc64KwOkK3TdbF1CoJ5uoRGNBNQaxjrihFryhA1LzaP5xgyX2XmOQsPsJdLk0jJHI8OCAvYCElpcVTPx5Ao4AywURizGEFFOuuMQnV4ODAc0kxJP5krTU5WU2s4KCy6Sm5ETnKCnVbqi4GVfPrKZbepc64KwOkK3TdbF1CoJ5uoRGNBNQaxjrihFryhA1LzaP5xgyX2XmOQsPsJdLk0jJHI8OCAvYCElpcVTPx5Ao4AywURizGEFFOuuMQnV4ODAc0kxJP5krTU5WU2s4KCy6Sm5ETnKCnVbqi4GVfPrKZbepc64KwOkK3TdbF1CoJ5uoRGNBNQaxjrihFryhA1";
    [testAddViewController.itemTitle setText:longString];
    //testAddViewController.itemTitle.text = longString;
    STAssertFalse([testAddViewController verifyTitle], @"Expected verifyTitle to return false with title length > 255, got %@", [testAddViewController verifyTitle]);
    
    //verify true for valid title (4 < length < 255)
    [testAddViewController.itemTitle setText:@"cool pebble for sale"];
    STAssertTrue([testAddViewController verifyTitle], @"Expected verifyTitle to return true with valid title length, got %@", [testAddViewController verifyTitle]);
}


-(void)testVerifyDescription
{
    //verify false returned for description length < 20
    [testAddViewController.commentTextField  setText:@"a"];
    STAssertFalse([testAddViewController verifyDescription], @"Expected verifyDescription to return false with description length < 20, got %@", [testAddViewController verifyDescription]);
    
    //verify false returned for description length > 255
    NSString *longString = @"LzaP5xgyX2XmOQsPsJdLk0jJHI8OCAvYCElpcVTPx5Ao4AywURizGEFFOuuMQnV4ODAc0kxJP5krTU5WU2s4KCy6Sm5ETnKCnVbqi4GVfPrKZbepc64KwOkK3TdbF1CoJ5uoRGNBNQaxjrihFryhA1LzaP5xgyX2XmOQsPsJdLk0jJHI8OCAvYCElpcVTPx5Ao4AywURizGEFFOuuMQnV4ODAc0kxJP5krTU5WU2s4KCy6Sm5ETnKCnVbqi4GVfPrKZbepc64KwOkK3TdbF1CoJ5uoRGNBNQaxjrihFryhA1LzaP5xgyX2XmOQsPsJdLk0jJHI8OCAvYCElpcVTPx5Ao4AywURizGEFFOuuMQnV4ODAc0kxJP5krTU5WU2s4KCy6Sm5ETnKCnVbqi4GVfPrKZbepc64KwOkK3TdbF1CoJ5uoRGNBNQaxjrihFryhA1LzaP5xgyX2XmOQsPsJdLk0jJHI8OCAvYCElpcVTPx5Ao4AywURizGEFFOuuMQnV4ODAc0kxJP5krTU5WU2s4KCy6Sm5ETnKCnVbqi4GVfPrKZbepc64KwOkK3TdbF1CoJ5uoRGNBNQaxjrihFryhA1";
    [testAddViewController.commentTextField setText:longString];
    STAssertFalse([testAddViewController verifyDescription], @"Expected verifyDescription to return false for description length > 255, instead got %@", [testAddViewController verifyDescription]);
    
    //verify true returned for valid description (20 < length <= 255)
    [testAddViewController.commentTextField setText:@"This is a sample description about the cool pebble."];
    STAssertTrue([testAddViewController verifyDescription], @"Expected verifyDescription to return true with valid description, instead got %@", [testAddViewController verifyDescription]);
}


-(void)testVerifyPrice
{
    //verify false returned when non-number set in price
    [testAddViewController.itemPrice setText:@"t"];
    STAssertFalse([testAddViewController verifyPrice], @"Expected verifyPrice to return false with price set to non-integer, instead got %@", [testAddViewController verifyPrice]);
    
    //verify true when price set to a double
    [testAddViewController.itemPrice setText:@"2.99"];
    STAssertTrue([testAddViewController verifyPrice], @"Expected verifyPrice to return true with a double, instaed got %@", [testAddViewController verifyPrice]);
    
    //verify true when integer set in price
    [testAddViewController.itemPrice setText:@"2"];
    STAssertTrue([testAddViewController verifyPrice], @"Expected verifyPrice to return true with price set to int, instead got %@", [testAddViewController verifyPrice]);
    
    //verify false when not set
    [testAddViewController.itemPrice setText:nil];
    STAssertFalse([testAddViewController verifyPrice], @"Expected verifyPrice to return false with itemPrice set to nil, instead got %@", [testAddViewController verifyPrice]);
}

-(void)testVerifyEmail
{
    //verify false with nil value
    [testAddViewController.userEmail setText:nil];
    STAssertFalse([testAddViewController verifyEmail], @"Expected verifyEmail to return false with nil value, instead got %@", [testAddViewController verifyEmail]);
    
    //verify false with empty string
    [testAddViewController.userEmail setText:@""];
    STAssertFalse([testAddViewController verifyEmail], @"Expected verifyEmail to return false with empty string, instead got %@", [testAddViewController verifyEmail]);
    
    //verify false with format "@xxxx.xxx" (nothing preceeding '@')
    [testAddViewController.userEmail setText:@"@hotmail.com"];
    STAssertFalse([testAddViewController verifyEmail], @"Expected verifyEmail to return false with incorrect format, instead got %@", [testAddViewController verifyEmail]);
    
    //verify false with format "xxxx@xxxx@xxx.com"
    [testAddViewController.userEmail setText:@"test@test@test.com"];
    STAssertFalse([testAddViewController verifyEmail], @"Expected verifyEmail to return false with incorrect format, instead got %@", [testAddViewController verifyEmail]);
    
    //verify false with format "xxxxxxxxx.com" (no '@')
    [testAddViewController.userEmail setText:@"testing.com"];
    STAssertFalse([testAddViewController verifyEmail], @"Expected verifyEmail to return false with incorrect formation, instead got %@", [testAddViewController verifyEmail]);
    
    //verify false with illegal charaters
    [testAddViewController.userEmail setText:@"testing!@test.com"];
    STAssertFalse([testAddViewController verifyEmail], @"Expected verifyEmail to return false with illegal character in string, instead got %@", [testAddViewController verifyEmail]);
    
    //verify true with valid email
    [testAddViewController.userEmail setText:@"matt@testing.com"];
    STAssertTrue([testAddViewController verifyEmail], @"Expected verifyEmail to return true with valid email address, instead got %@", [testAddViewController verifyEmail]);
    
    //verify true with valid (but less common) email format
    [testAddViewController.userEmail setText:@"matthew.shine@uqconnect.edu.au"];
    STAssertTrue([testAddViewController verifyEmail], @"Expected verifyEmail to return true with valid email address, instead got %@", [testAddViewController verifyEmail]);
}

-(void)testVerifyPhone
{
    //verify false with phone value nil
    [testAddViewController.userPhone setText:nil];
    STAssertFalse([testAddViewController verifyPhone], @"Expected verifyPhone to return false with nil value set, instead got %@", [testAddViewController verifyPhone]);
    
    //verify false with non-digits in field
    [testAddViewController.userPhone setText:@"3823t421"];
    STAssertFalse([testAddViewController verifyPhone], @"Expected verifyPhone to return false with non-digit character, instead got %@", [testAddViewController verifyPhone]);
    
    //verify false with invalid phone number (Australian number formats)
    [testAddViewController.userPhone setText:@"12222222"];
    STAssertFalse([testAddViewController verifyPhone], @"Expected verifyPhone to return false with invalid number, instead got %@",[testAddViewController verifyPhone]);
    
    //verify true with valid local phone number (area codes currently not supported)
    [testAddViewController.userPhone setText:@"38000000"];
    STAssertTrue([testAddViewController verifyPhone], @"Expected verifyPhone to return true with valid local phone number, instead got %@", [testAddViewController verifyPhone]);
    
    //verify true with valid mobile phone number
    [testAddViewController.userPhone setText:@"0400000000"];
    STAssertTrue([testAddViewController verifyPhone], @"Expected verifyPhone to return true with valid mobile phone number, instead got %@", [testAddViewController verifyPhone]);
}

-(void)testPresentLoadingSpinner
{
    //verify spinner displayed after method call - to do this we need to check the last object in the testAddViewController's subviews
    [testAddViewController presentLoadSpinner];
    STAssertEqualObjects([testAddViewController.view.subviews.lastObject class], [UIActivityIndicatorView class], @"Expected last object to be of type %@, instead was %@", [UIActivityIndicatorView class],[testAddViewController.view.subviews.lastObject class]);
}

-(void)testDismissLoadSpinner
{
    //verify spinner removed after method call (last object in subviews not spinner)
    [testAddViewController dismissLoadSpinner];
    STAssertFalse([testAddViewController.view.subviews.lastObject isKindOfClass:[UIActivityIndicatorView class]], @"Expected last object to not be a UIActivityIndicatorView but was");
}

-(void)testIsIntegerNumber;
{
    //verify false with non-integer string
    STAssertFalse([testAddViewController isIntegerNumber:@"notanumber"], @"Expected false with invalid string, got true");
    
    //verify true with integer
    STAssertTrue([testAddViewController isIntegerNumber:@"2"], @"Expected true with valid integer, got false");
    
    //verify true with double
    STAssertTrue([testAddViewController isIntegerNumber:@"2.22"], @"Expected true with valid double, got false");
}



@end
