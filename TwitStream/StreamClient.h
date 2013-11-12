//
//  StreamClient.h
//  TwitStream
//
//  Created by Devin Ozel on 9/8/13.
//  Copyright (c) 2013 Devin Ozel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StreamClient : NSObject
@property (nonatomic, strong) NSString  *oauth, *params;
@property (nonatomic, strong) NSString  *oauth_consumer_key,
                                        *oauth_nonce,
                                        *oauth_signature,
                                        *oauth_signature_method,
                                        *oauth_timestamp,
                                        *oauth_token,
                                        *oauth_version;
@property (nonatomic, strong) NSMutableArray *streams, *track_params;

- (void) setFilter:(NSString *)inFilter;

@end
