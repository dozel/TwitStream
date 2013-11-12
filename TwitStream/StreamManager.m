//
//  StreamManager.m
//  TwitStream
//
//  Created by Devin Ozel on 9/4/13.
//  Copyright (c) 2013 Devin Ozel. All rights reserved.
//

#import "StreamManager.h"

@implementation StreamManager
@synthesize colorBlue = _colorBlue, colorGray = _colorGray;
@synthesize screenHeight = _screenHeight, screenWidth = _screenWidth;

+ (id)sharedManager {
    static StreamManager *sharedStreamManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStreamManager = [[self alloc] init];
    });
    return sharedStreamManager;
}

- (id)init {
    if (self = [super init]) {
        _colorBlue = [UIColor colorWithRed:0.122 green:0.333 blue:0.678 alpha:1.0]; //1f55ad
        _colorGray = [UIColor colorWithRed:0.263 green:0.263 blue:0.263 alpha:1.0]; //434343
        
        CGRect screenBound = [[UIScreen mainScreen] bounds];
        CGSize screenSize = screenBound.size;
        int tempHeight = screenSize.height - 20 - 44; //Status bar and nav bar height subtracted
        _screenHeight = tempHeight;
        _screenWidth = screenSize.width;
    }
    return self;
}

@end
