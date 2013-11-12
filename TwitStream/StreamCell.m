//
//  StreamCell.m
//  TwitStream
//
//  Created by Devin Ozel on 9/3/13.
//  Copyright (c) 2013 Devin Ozel. All rights reserved.
//

#import "StreamCell.h"
#import "StreamManager.h"

@implementation StreamCell
@synthesize labelUser = _labelUser, labelUsername = _labelUsername,
            labelText = _labelText, labelTimestamp = _labelTimestamp;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self displayStreamCell];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) displayStreamCell {
    StreamManager *sharedManager = [StreamManager sharedManager];
    
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    self.contentView.backgroundColor = [UIColor clearColor];
    self.textLabel.text = @"";
    
    _labelUser = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 270, 20)];
    _labelUser.backgroundColor = [UIColor clearColor];
    _labelUser.font= [UIFont fontWithName:FONT_BOLD size:14];
    _labelUser.textColor = sharedManager.colorBlue;
    [self.contentView addSubview:_labelUser];
    
    _labelUsername = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 300, 20)];
    _labelUsername.backgroundColor = [UIColor clearColor];
    _labelUsername.font = [UIFont fontWithName:FONT_MEDIUM size:13];
    _labelUsername.textColor = sharedManager.colorBlue;
    [self.contentView addSubview:_labelUsername];
    
    _labelTimestamp = [[UILabel alloc] initWithFrame:CGRectMake(280, 10, 35, 25)];
    _labelTimestamp.font = [UIFont fontWithName:FONT_LIGHT size:12];
    _labelTimestamp.backgroundColor = [UIColor clearColor];
    _labelTimestamp.textColor = sharedManager.colorGray;
    _labelTimestamp.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_labelTimestamp];
    
    _labelText = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 300, 30)];
    _labelText.font = [UIFont fontWithName:FONT_NORMAL size:12];
    _labelText.backgroundColor = [UIColor clearColor];
    _labelText.textColor = sharedManager.colorGray;
    _labelText.numberOfLines = 0;
    [self.contentView addSubview:_labelText];
}

//Resize the uilabel to the tweet
- (void) resizeView {
    CGSize constraintSize;
    constraintSize.width = 300.0f;
    constraintSize.height = MAXFLOAT;
    
    CGSize textSizeTweet = [_labelText.text sizeWithFont:[UIFont fontWithName:FONT_NORMAL size:12]
                                        constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    
    [_labelText setFrame:CGRectMake(_labelText.frame.origin.x, _labelText.frame.origin.y, _labelText.frame.size.width, textSizeTweet.height)];
}


@end
