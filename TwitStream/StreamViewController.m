//
//  StreamViewController.m
//  TwitStream
//
//  Created by Devin Ozel on 9/3/13.
//  Copyright (c) 2013 Devin Ozel. All rights reserved.
//
#define BASE_STREAM_STR @"https://stream.twitter.com/1.1/statuses/filter.json"

#import "StreamViewController.h"
#import "StreamManager.h"
#import "Stream.h"
#import "StreamCell.h"
#import "StreamClient.h"

@interface StreamViewController ()
@property (nonatomic, strong) UITableView *tableStreams;
@property (nonatomic, strong) UITextField *textfieldStreamInput;
@property (nonatomic, strong) NSURLConnection *urlConnection;
@property (nonatomic, strong) NSMutableArray *streams;
@property (nonatomic, strong) StreamClient *streamClient;
@end

@implementation StreamViewController
@synthesize tableStreams = _tableStreams, textfieldStreamInput = _textfieldStreamInput,
            urlConnection = _urlConnection, streams = _streams, streamClient = _streamClient;


#pragma mark - Setup Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)setupGlobals {
    StreamManager *sharedManager = [StreamManager sharedManager];
    
    _textfieldStreamInput = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
    [_textfieldStreamInput setDelegate:self];
    _textfieldStreamInput.backgroundColor = sharedManager.colorBlue;
    _textfieldStreamInput.keyboardType = UIKeyboardTypeDefault;
    _textfieldStreamInput.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _textfieldStreamInput.textAlignment = NSTextAlignmentCenter;
    _textfieldStreamInput.returnKeyType = UIReturnKeySearch;
    _textfieldStreamInput.placeholder = @"ENTER KEYWORDS AND/OR @USERS";
    [_textfieldStreamInput addTarget:self action:@selector(textFieldFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
    _textfieldStreamInput.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    _textfieldStreamInput.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textfieldStreamInput.textColor = [UIColor whiteColor];
    [self.view addSubview:_textfieldStreamInput];
    
    _tableStreams = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, 320, sharedManager.screenHeight - 60) style:UITableViewStylePlain];
    _tableStreams.dataSource = (id)self;
    _tableStreams.delegate = (id)self;
    _tableStreams.allowsSelection = FALSE;
    _tableStreams.backgroundColor = [UIColor whiteColor];
    _tableStreams.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableStreams];
    
    _streams = [[NSMutableArray alloc] initWithCapacity:0];
    _streamClient = [[StreamClient alloc] init];
}


#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupGlobals];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)textFieldFinished:(UITextField *)sender {
    [sender resignFirstResponder];
    if (sender.text.length > 0) {
        [_streamClient setFilter:_textfieldStreamInput.text];
        [self cleanData];
        [self searchKeywords];
    }
}

// Stop the stream, clean the stream and table
- (void) cleanData {
    [self stopConnection];
    [_streams removeAllObjects];
    [_tableStreams reloadData];
}


#pragma mark - URL Methods
// Create a http request, and start the stream
- (void) searchKeywords {
    NSMutableURLRequest *getRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:BASE_STREAM_STR]];
    [getRequest setHTTPMethod:@"POST"];
    [getRequest setValue:_streamClient.oauth  forHTTPHeaderField:@"Authorization"];
    NSString *tempParams = _streamClient.params;
    NSData *httpBody = [tempParams dataUsingEncoding:NSUTF8StringEncoding];
    [getRequest setHTTPBody:httpBody];
    
    _urlConnection  = [NSURLConnection connectionWithRequest:getRequest delegate:self];
    [_urlConnection start];
}

- (void)stopConnection {
    [_urlConnection cancel];
    _urlConnection = nil;
}

#pragma mark - URL Connection Methods
// Once new data comes in, insert the data into table (and the stream)
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSError *error;
    NSMutableDictionary * json = [NSJSONSerialization
                                  JSONObjectWithData:data options:kNilOptions error:&error];
    if (json && !error) {
        NSString *tweet = [json objectForKey:@"text"];
        if (tweet.length > 0) {
            Stream *tempStream = [[Stream alloc] initStreamWithJson:json];
            [_streams insertObject:tempStream atIndex:0];
            [_tableStreams insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]]
                                 withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Stream failed connection.");
}


#pragma mark - Tableview Data Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _streams.count;
}

//Resize the cell to the tweet
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Stream *tempStream = [_streams objectAtIndex:indexPath.row];
    
    CGSize constraintSize;
    constraintSize.width = 300.0f;
    constraintSize.height = MAXFLOAT;
    
    CGSize textSizeTweet = [tempStream.streamTweet sizeWithFont:[UIFont fontWithName:FONT_NORMAL size:12]
                                       constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
        
    int tempHeight = 50 + textSizeTweet.height;
    return MAX(80, tempHeight);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *StreamCellIdentifier = @"StreamCell";
    StreamCell *cell = [tableView dequeueReusableCellWithIdentifier:StreamCellIdentifier];
    
    if (cell == nil) {
        cell = [[StreamCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:StreamCellIdentifier];
    }
    
    Stream *tempStream = [_streams objectAtIndex:indexPath.row];
    cell.labelUser.text = tempStream.streamOwnerName;
    cell.labelUsername.text = [NSString stringWithFormat:@"%@%@", @"@", tempStream.streamOwnerUsername];
    cell.labelText.text = tempStream.streamTweet;
    cell.labelTimestamp.text = tempStream.streamTimeStamp;
  
    [cell resizeView];
    
    return cell;
}


@end
