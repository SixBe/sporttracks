//
//  SBEditableTableViewCell.h
//  sporttracks
//
//  Created by Michael on 2/4/14.
//  Copyright (c) 2014 SixBe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SBEditableTableViewCellDelegate;
@interface SBEditableTableViewCell : UITableViewCell
@property (nonatomic, weak) id<SBEditableTableViewCellDelegate> delegate;
@end

@protocol SBEditableTableViewCellDelegate <NSObject>
- (void)editableCell:(SBEditableTableViewCell *)cell didEndEditingText:(NSString *)oldText newText:(NSString *)newText;
@end
