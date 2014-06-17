//
//  ListViewController.m
//  yelpper
//
//  Created by Amie Kweon on 6/15/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "ListViewController.h"
#import "FilterViewController.h"
#import "YelpClient.h"
#import "MTLJSONAdapter.h"
#import "Place.h"
#import "PlaceCell.h"
#import "Utils.h"

NSString * const kYelpConsumerKey = @"U2QFU5uHJxGv-AJ5AETcZQ";
NSString * const kYelpConsumerSecret = @"dC0s_eZ9k8n4lL-HkIXf0s_6Yag";
NSString * const kYelpToken = @"83WWEIxzNfHFU6sEcdApE1uz_9T00-FR";
NSString * const kYelpTokenSecret = @"ntw6alKMfabeHK1k4sLhN9IkomU";

@interface ListViewController ()
@property (nonatomic, strong) YelpClient *client;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) PlaceCell *stubCell;

@property (strong, nonatomic) NSArray *places;
@property (nonatomic, strong) NSString *searchTerm;
@end

@implementation ListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.searchTerm = @"Thai";
        self.client = [[YelpClient alloc]
                       initWithConsumerKey:kYelpConsumerKey
                       consumerSecret:kYelpConsumerSecret
                       accessToken:kYelpToken
                       accessSecret:kYelpTokenSecret];
        [self search];
    }
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"list view viewDidLoad");
    [super viewDidLoad];
    [self setupUI];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PlaceCell" bundle:nil] forCellReuseIdentifier:@"PlaceCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidAppear:(BOOL)animated {
    NSLog(@"list view viewDidAppear");
   // [self viewDidLoad];
    if ([self.filterSelection count] > 0) {
        [self search];
    }
}

- (PlaceCell *)stubCell {
    if (!_stubCell) {
        _stubCell = [self.tableView dequeueReusableCellWithIdentifier:@"PlaceCell"];
    }
    return _stubCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.places.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlaceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlaceCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(PlaceCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.place = self.places[indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self configureCell:self.stubCell atIndexPath:indexPath];
    [self.stubCell layoutSubviews];
    
    CGSize size = [self.stubCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];

    return size.height+1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)showFilterScreen {
    FilterViewController *filterViewController = [[FilterViewController alloc] init];
    filterViewController.myDelegate = self;
    UINavigationController *navBar = [[UINavigationController alloc] initWithRootViewController:filterViewController];
    [self presentViewController:navBar animated:YES completion:nil];
}

- (void)search {
    [self.client
     searchWithTerm:self.searchTerm
     withFilters:self.filterSelection
     success:^(AFHTTPRequestOperation *operation, id response) {
        NSError *error;
        self.places = [MTLJSONAdapter modelsOfClass:[Place class] fromJSONArray:response[@"businesses"] error:&error];
        [self.tableView reloadData];
        if (error) {
            NSLog(@"> error: %@", [error description]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
}

- (void)filterSelectionDone:(NSDictionary *)filters {
    self.filterSelection = filters;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    self.searchTerm = textField.text;
    [self search];
    return YES;
}

- (void)setupUI {
    
//    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 310, 45.0)];
//    searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    UITextField *searchBar = [[UITextField alloc] initWithFrame:CGRectMake(5.0, 10.0, 200, 28.0)];
    UIView *searchBarView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 310.0, 45.0)];
    searchBarView.autoresizingMask = 0;
    searchBar.delegate = self;
    searchBar.keyboardType = UIKeyboardTypeWebSearch;
    // workaround to place search icon on the left
    searchBar.placeholder = @"Search";
    searchBar.text = self.searchTerm;
    searchBar.font = [UIFont systemFontOfSize:14];
    searchBar.backgroundColor = [UIColor whiteColor];
    searchBar.tintColor = [UIColor grayColor];
    searchBar.borderStyle = UITextBorderStyleRoundedRect;
    searchBar.clearButtonMode = UITextFieldViewModeWhileEditing;
    //CGFloat colors[3] ={196.0, 18.0, 0.0};
    //searchBar.barTintColor = [Utils getColorFrom:colors];
    [searchBarView addSubview:searchBar];
    self.navigationItem.titleView = searchBarView;
    
    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"Filter"
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(showFilterScreen)];
    self.navigationItem.leftBarButtonItem = filterButton;
}
@end
