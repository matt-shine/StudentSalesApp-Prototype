//
//  ItemViewCell.h
//  StudentSalesAppII
//
//  Created by Design on 8/05/13.
//  Copyright (c) 2013 UQ DECO3800. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemViewCell : UITableViewCell
{
    IBOutlet UILabel *itemTitle;
    IBOutlet UILabel *itemDesc;
    IBOutlet UILabel *itemPrice;
    IBOutlet UIImageView *imageThumb;
}

@property (nonatomic,weak) IBOutlet UILabel *itemTitle;
@property (nonatomic,weak) IBOutlet UILabel *itemDesc;
@property (nonatomic,weak) IBOutlet UILabel *itemPrice;
@property (nonatomic,weak) IBOutlet UIImageView *imageThumb;

@end
