//
//  StreamCell.h
//  TwitStream
//
//  Created by Devin Ozel on 9/3/13.
//  Copyright (c) 2013 Devin Ozel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StreamCell : UITableViewCell

@property (nonatomic, strong) UILabel *labelUser, *labelUsername, *labelText, *labelTimestamp;

- (void) resizeView;

@end
