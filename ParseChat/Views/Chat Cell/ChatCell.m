//
//  ChatCell.m
//  ParseChat
//
//  Created by meganyu on 7/6/20.
//  Copyright © 2020 meganyu. All rights reserved.
//

#import "ChatCell.h"

@interface ChatCell ()

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end

@implementation ChatCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setMessage:(NSString *)message {
    self.messageLabel.text = message;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
