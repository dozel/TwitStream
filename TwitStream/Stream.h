//
//  Stream.h
//  TwitStream
//
//  Created by Devin Ozel on 9/4/13.
//  Copyright (c) 2013 Devin Ozel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Stream : NSObject

@property (nonatomic, retain) NSString *streamTweet, *streamOwnerName, *streamOwnerUsername, *streamTimeStamp;

- (id) initStreamWithJson:(NSDictionary *)inJson;

@end

