//
//  IPViewController.h
//  iPub
//
//  Created by Scott Andrus on 4/7/14.
//  Copyright (c) 2014 Tapatory, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPFetcher.h"

@interface IPViewController : UIViewController <IPFetcherDelegate, UITableViewDelegate, UITableViewDataSource>

@end
