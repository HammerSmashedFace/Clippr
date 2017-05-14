//
//  HSFCustomTableViewCell.h
//  ClipprApp
//
//  Created by Dmitry Antipenko on 5/14/17.
//  Copyright © 2017 HammerSmashedFace. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kHSFCustomTableViewCellIdentifier;

@interface HSFCustomTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end
