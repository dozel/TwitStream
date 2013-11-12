//
//  Stream.m
//  TwitStream
//
//  Created by Devin Ozel on 9/4/13.
//  Copyright (c) 2013 Devin Ozel. All rights reserved.
//

#import "Stream.h"
#import "NSDate+DateFromNow.h"

@implementation Stream
@synthesize streamTweet = _streamTweet, streamOwnerName = _streamOwnerName,
            streamOwnerUsername = _streamOwnerUsername, streamTimeStamp = _streamTimeStamp;

- (id) initStreamWithJson:(NSDictionary *)inJson {
    self = [super init];
    if (self) {
        [self setupStream:inJson];
    }
    return self;
}

- (void) setupStream:(NSDictionary *)inJson  {
    _streamTweet = [inJson objectForKey:@"text"];
    NSDictionary *tempUserDictionary = [inJson objectForKey:@"user"];
    _streamOwnerName = [tempUserDictionary objectForKey:@"name"];
    _streamOwnerUsername = [tempUserDictionary objectForKey:@"screen_name"];

    //This section will first format the string that is retrieved 
    // from the json, and then the difference between now and this date 
    // will be formatted in the simplest format possible
    NSString *tempDateString = [inJson objectForKey:@"created_at"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:usLocale];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setDateFormat: @"EEE MMM dd HH:mm:ss Z yyyy"];
    NSDate *date = [dateFormatter dateFromString:tempDateString];
    _streamTimeStamp = [date timeFromThisDate];
}

@end
