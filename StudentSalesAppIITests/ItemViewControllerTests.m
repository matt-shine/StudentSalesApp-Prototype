//
//  ItemViewControllerTests.m
//  StudentSalesAppII
//
//  Created by matt on 17/05/13.
//  Copyright (c) 2013 UQ DECO3800. All rights reserved.
//

#import "ItemViewControllerTests.h"

@implementation ItemViewControllerTests

@synthesize testItemViewController;
@synthesize storyboard;

-(void)setUp
{
    storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    self.testItemViewController = [storyboard instantiateViewControllerWithIdentifier:@"ItemView"];
    [self.testItemViewController loadView];
}






@end
