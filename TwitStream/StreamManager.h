//
//  StreamManager.h
//  TwitStream
//
//  Created by Devin Ozel on 9/4/13.
//  Copyright (c) 2013 Devin Ozel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StreamManager : NSObject

@property (nonatomic, strong) UIColor *colorBlue;
@property (nonatomic, strong) UIColor *colorGray;

@property (nonatomic) CGFloat screenWidth;
@property (nonatomic) CGFloat screenHeight;

+ (id)sharedManager;

@end
