//
//  ItemViewController.h
//  StudentSalesAppII
//
//  Created by Lion User on 7/05/13.
//  Copyright (c) 2013 UQ DECO3800. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ItemViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *itemArray;
}

@property (weak, nonatomic) IBOutlet UITableView *itemTable;

- (void)retrieveFromParse;

@end
