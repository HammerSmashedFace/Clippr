//
//  HSFCustomTableViewCell.m
//  ClipprApp
//
//  Created by Dmitry Antipenko on 5/14/17.
//  Copyright © 2017 HammerSmashedFace. All rights reserved.
//

#import "HSFCustomTableViewCell.h"

NSString *const kHSFCustomTableViewCellIdentifier = @"CustomTableViewCell";

@implementation HSFCustomTableViewCell

@synthesize textLabel;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
