//
//  IPFetcher.h
//  iPub
//
//  Created by Scott Andrus on 4/7/14.
//  Copyright (c) 2014 Tapatory, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IPFetcherDelegate <NSObject>

- (void)didFetchEntries:(NSArray *)entries;

@end

@interface IPFetcher : NSObject <NSStreamDelegate>

- (void)fetchEntries;
- (instancetype)initWithAddress:(NSString *)address andPort:(NSInteger)port;

@property (strong, nonatomic) NSString *fetchAddress;
@property (strong, nonatomic) NSString *lastFetchedEntries;

@property (assign, nonatomic) NSInteger port;
@property (assign, nonatomic) id<IPFetcherDelegate> delegate;

@end
