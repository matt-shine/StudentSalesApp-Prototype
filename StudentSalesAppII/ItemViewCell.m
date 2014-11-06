//
//  ItemViewCell.m
//  StudentSalesAppII
//
//  Created by Design on 8/05/13.
//  Copyright (c) 2013 UQ DECO3800. All rights reserved.
//

#import "ItemViewCell.h"

@interface ItemViewCell ()

@end

@implementation ItemViewCell

@synthesize itemTitle = _itemTitle;
@synthesize itemDesc = _itemDesc;
@synthesize itemPrice = _itemPrice;
@synthesize imageThumb = _imageThumb;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
