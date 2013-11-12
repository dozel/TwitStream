//
//  StreamClient.m
//  TwitStream
//
//  Created by Devin Ozel on 9/8/13.
//  Copyright (c) 2013 Devin Ozel. All rights reserved.
//
#define BASE_STREAM_STR @"https://stream.twitter.com/1.1/statuses/filter.json"

#import "StreamClient.h"
#import <CommonCrypto/CommonHMAC.h>
#import "NSData+Base64.h"

@implementation StreamClient
@synthesize oauth_consumer_key = _oauth_consumer_key, oauth_nonce = _oauth_nonce,
            oauth_signature = _oauth_signature, oauth_signature_method = _oauth_signature_method,
            oauth_timestamp = _oauth_timestamp, oauth_token = _oauth_token, oauth_version = _oauth_version;
@synthesize oauth = _oauth, params = _params, track_params = _track_params;


- (id) init {
    self = [super init];
    if (self) {
        _oauth_consumer_key = @"OATH_KEY"; //Replace this with your app's oath_key
        _oauth_signature_method = @"HMAC-SHA1";
        _oauth_version = @"1.0";
        _oauth_token = @"OATH_TOKEN"; //Replace this with your app's oath_token
        _track_params = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}


- (void) setFilter:(NSString *)inFilter {
    [_track_params removeAllObjects];
    [self evaluateFilter:inFilter];
    _oauth = [self generateHeaderWithUrl:BASE_STREAM_STR];
    _params = [self parameterForData];
    NSLog(@"O:%@ P:%@", _oauth, _params);
}

#pragma mark - Twitter Auth Methods

- (NSString *) generateHeaderWithUrl:(NSString *)inUrl {
    _oauth_nonce = [self oauthNonce];
    _oauth_timestamp = [self oauthTimestamp];
    _oauth_signature = [self encodeUrl:[self oauthSignature:inUrl]];
    
    return [NSString stringWithFormat:@"OAuth oauth_consumer_key=\"%@\", oauth_nonce=\"%@\", oauth_signature=\"%@\", oauth_signature_method=\"%@\", oauth_timestamp=\"%@\", oauth_token=\"%@\", oauth_version=\"%@\"",
            _oauth_consumer_key, _oauth_nonce, _oauth_signature, _oauth_signature_method,
            _oauth_timestamp, _oauth_token, _oauth_version];
}

//Time since epoch
- (NSString *)oauthTimestamp {
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    return [NSString stringWithFormat:@"%d", (int)timeInterval];
}

//Create a random 32 character nonce 
- (NSString *)oauthNonce {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    int length = 32;
    NSMutableString *nonce = [NSMutableString stringWithCapacity: length];
    for (int i = 0; i < length; i++) {
        [nonce appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    return nonce;
}

- (NSString *)oauthSignature:(NSString *)inUrl {
    return [self signHmacSHA1WithSigningKey:[self signingKey] andBaseString:[self baseSignatureWithUrl:inUrl]];
}

- (NSString *)signHmacSHA1WithSigningKey:(NSString *)signingKey andBaseString:(NSString *)baseString  {
    unsigned char buf[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, [signingKey UTF8String], [signingKey length], [baseString UTF8String], [baseString length],  buf);
    NSData *data = [NSData dataWithBytes:buf length:CC_SHA1_DIGEST_LENGTH];
    return [data base64EncodedString];
}

- (NSString *) signingKey {
    return [NSString stringWithFormat:@"%@&%@", @"Consumer secret", @"Oath secret"]; //Replace these with your own secrets
}

- (NSString *) baseSignatureWithUrl:(NSString *)inUrl {
    NSString *tempBaseString = [NSString stringWithFormat:@"POST&%@&oauth_consumer_key%@oauth_nonce%@oauth_signature_method%@oauth_timestamp%@oauth_token%@oauth_version%@%@",
            [self encodeUrl:inUrl],
            [self encodeBaseStrings:_oauth_consumer_key],
            [self encodeBaseStrings:_oauth_nonce],
            [self encodeBaseStrings:_oauth_signature_method],
            [self encodeBaseStrings:_oauth_timestamp],
            [self encodeBaseStrings:_oauth_token],
            [self encodeBaseStrings:_oauth_version],
            [NSString stringWithFormat:@"%@", [self parametersForBaseString]]];
    return tempBaseString;
}

// Encode base signature strings with an equal sign and comma (hex)
- (NSString *) encodeBaseStrings:(NSString *)inString {
    return [NSString stringWithFormat:@"%@%@%@", @"%3D", inString, @"%26"];
}

- (NSString *)encodeUrl:(NSString *)inString {
    NSString *s = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                      kCFAllocatorDefault,
                                      (CFStringRef)inString,
                                      NULL,
                                      CFSTR("!*'();:@&=+$,/?%#[]"),
                                      kCFStringEncodingUTF8));
    return s;
}


- (void) evaluateFilter:(NSString *)filter {
    NSArray *tempFilters = [filter componentsSeparatedByString:@" "];
    if (tempFilters.count <= 400) {
        for (int i = 0; i < tempFilters.count; i++) {
            NSString *tempString = [tempFilters objectAtIndex:i];
            tempString = [tempString stringByReplacingOccurrencesOfString:@" " withString:@""];
            if (tempString.length > 0) {
                if ([[tempString substringToIndex:1] isEqualToString:@"@"]) {
                    tempString = [tempString substringFromIndex:1];
                }
                [_track_params addObject:tempString];
            }
        }
    }
    else {
        NSLog(@"Error: track keyword amount is limited to 400.");
    }
}

- (NSString *) parametersForBaseString {
    NSMutableString *track_params = [[NSMutableString alloc] init];
    [track_params appendString:@"track%3D"];
    for (int i = 0; i < _track_params.count; i++) {
        NSString *tempString = [_track_params objectAtIndex:i];
        if (i != _track_params.count - 1) {
            [track_params appendFormat:@"%@%@", tempString, @"%252C"];
        }
        else {
            [track_params appendFormat:@"%@", tempString];
        }
    }
    return track_params;
}

- (NSString *) parameterForData {
    NSMutableString *track_params = [[NSMutableString alloc] init];
    [track_params appendString:@"track="];
    for (int i = 0; i < _track_params.count; i++) {
        NSString *tempString = [_track_params objectAtIndex:i];
        if (i != _track_params.count - 1) {
            [track_params appendFormat:@"%@%@", tempString, @"%2C"];
        }
        else {
            [track_params appendFormat:@"%@", tempString];
        }
    }
    return track_params;
}



@end
