//
//  IPFetcher.m
//  iPub
//
//  Created by Scott Andrus on 4/7/14.
//  Copyright (c) 2014 Tapatory, LLC. All rights reserved.
//

#import "IPFetcher.h"

@interface IPFetcher ()

@property (strong, nonatomic) NSInputStream *inputStream;
@property (strong, nonatomic) NSOutputStream *outputStream;

@end

@implementation IPFetcher

- (instancetype)initWithAddress:(NSString *)address andPort:(NSInteger)port
{
    self = [super init];
    if (self) {
        _fetchAddress = address;
        _port = port;
    }
    return self;
}

- (void)initNetworkConnection
{
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL,
                                       (__bridge CFStringRef)self.fetchAddress,
                                       self.port,
                                       &readStream,
                                       &writeStream);
    self.inputStream = (__bridge NSInputStream *)readStream;
    self.outputStream = (__bridge NSOutputStream *)writeStream;
    
    [self.inputStream setDelegate:self];
    [self.outputStream setDelegate:self];
    
    [self.inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop]
                                forMode:NSDefaultRunLoopMode];
    [self.outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop]
                                 forMode:NSDefaultRunLoopMode];
    
    [self.inputStream open];
    [self.outputStream open];
}

- (void)fetchEntries
{
    [self initNetworkConnection];
    
    NSString *command = @"read\n";
	NSData *data = [[NSData alloc] initWithData:[command dataUsingEncoding:NSASCIIStringEncoding]];
	[self.outputStream write:[data bytes] maxLength:[data length]];
}

#pragma mark - NSStreamDelegate

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    switch (eventCode) {
		case NSStreamEventOpenCompleted:
			NSLog(@"Stream opened");
			break;
            
		case NSStreamEventHasBytesAvailable:
            if ([aStream isEqual:self.inputStream]) {
                
                uint8_t buffer[1024];
                int len;
                
                while ([self.inputStream hasBytesAvailable]) {
                    len = [self.inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                        NSLog(@"Output: %@", output);
                        self.lastFetchedEntries = output;
                        [self.delegate didFetchEntries:[output componentsSeparatedByString:@","]];
                        if (nil != output) {
                            NSLog(@"server said: %@", output);
                        }
                    }
                }
            }
			break;
            
		case NSStreamEventErrorOccurred:
			NSLog(@"Can not connect to the host!");
			break;
            
		case NSStreamEventEndEncountered:
			break;
            
		default:
			NSLog(@"Unknown event");
	}
}

@end
