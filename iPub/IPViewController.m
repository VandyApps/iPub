//
//  IPViewController.m
//  iPub
//
//  Created by Scott Andrus on 4/7/14.
//  Copyright (c) 2014 Tapatory, LLC. All rights reserved.
//

#import "IPViewController.h"

@interface IPViewController ()

@property (strong, nonatomic) IPFetcher *fetcher;
@property (strong, nonatomic) NSArray *pubEntries;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation IPViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _fetcher = [[IPFetcher alloc] initWithAddress:@"54.186.61.49"
                                          andPort:20050];
    self.fetcher.delegate = self;
    
    [NSTimer scheduledTimerWithTimeInterval:15.0
                                     target:self
                                   selector:@selector(timerFired:)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)fetchPressed:(UIButton *)sender
{
    [self.fetcher fetchEntries];
}

#pragma mark - NSTimer

- (void)timerFired:(NSTimer *)timer
{
    [self.fetcher fetchEntries];
}

#pragma mark - IPFetcherDelegate

- (void)didFetchEntries:(NSArray *)entries
{
    self.pubEntries = [[entries reverseObjectEnumerator] allObjects];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.pubEntries count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [self.pubEntries objectAtIndex:indexPath.row];
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
