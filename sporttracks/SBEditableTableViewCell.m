//
//  SBEditableTableViewCell.m
//  sporttracks
//
//  Created by Michael on 2/4/14.
//  Copyright (c) 2014 SixBe. All rights reserved.
//

#import "SBEditableTableViewCell.h"

@interface SBEditableTableViewCell () <UITextFieldDelegate, UITextViewDelegate>
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITextView *textView;
@end

@implementation SBEditableTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupEditingViews];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    [self setupEditingViews];
}

- (void)setupEditingViews
{
    // Initialization code
    self.textField = [[UITextField alloc] initWithFrame:self.detailTextLabel.bounds];
    self.textField.enabled = NO;
    self.textField.hidden = YES;
    self.textField.font = self.detailTextLabel.font;
    self.textField.textColor = self.detailTextLabel.textColor;
    self.textField.textAlignment = self.detailTextLabel.textAlignment;
    self.textField.placeholder = @"Type your text";
    self.textField.delegate = self;
    [self.contentView addSubview:self.textField];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    self.textField.hidden = !editing;
    self.textField.enabled = editing;
    self.detailTextLabel.hidden = editing;
    self.detailTextLabel.enabled = !editing;
    if (editing) {
        self.textField.placeholder = self.detailTextLabel.text;
    }
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textField.frame = CGRectMake(CGRectGetMinX(self.detailTextLabel.frame),
                                      CGRectGetMinY(self.detailTextLabel.frame),
                                      CGRectGetWidth(self.contentView.frame) - CGRectGetMinX(self.detailTextLabel.frame),
                                      CGRectGetHeight(self.detailTextLabel.frame));
}

#pragma mark - UITextFieldDelegate protocol implementation
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"Now would be the time to do something");
    
    [self.delegate editableCell:self didEndEditingText:self.detailTextLabel.text newText:textField.text];
    
     BOOL textChanged = ![textField.text isEqualToString:self.detailTextLabel.text];
     self.detailTextLabel.text = textChanged ? textField.text : self.detailTextLabel.text;
}

@end
