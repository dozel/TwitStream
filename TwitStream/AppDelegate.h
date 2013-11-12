//
//  AppDelegate.h
//  TwitStream
//
//  Created by Devin Ozel on 9/3/13.
//  Copyright (c) 2013 Devin Ozel. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "StreamViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) StreamViewController *streamController;

@end
