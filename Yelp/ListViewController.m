//
//  ListViewController.m
//  yelpper
//
//  Created by Amie Kweon on 6/15/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "ListViewController.h"
#import "FilterViewController.h"
#import "MapViewController.h"
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

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *noResultView;
@property (weak, nonatomic) IBOutlet UILabel *noResultLabel;
@property (nonatomic, strong) PlaceCell *stubCell;

@property (nonatomic, strong) NSMutableArray *places;
@property (nonatomic, strong) NSString *searchTerm;
@property (nonatomic, strong) CLLocation *location;
@property NSInteger offset;
@end

@implementation ListViewController
{
    BOOL isLoading;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.offset = 0;
        self.searchTerm = @"";
        self.places = [[NSMutableArray alloc] init];
        self.client = [[YelpClient alloc]
                       initWithConsumerKey:kYelpConsumerKey
                       consumerSecret:kYelpConsumerSecret
                       accessToken:kYelpToken
                       accessSecret:kYelpTokenSecret];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PlaceCell" bundle:nil] forCellReuseIdentifier:@"PlaceCell"];

    if (self.locationManager == nil) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        self.locationManager.delegate = self;
    }
    [self.locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidAppear:(BOOL)animated {
    NSString *model = [[UIDevice currentDevice] model];
    if ([model isEqualToString:@"iPhone Simulator"]) {
        // Use San Francisco for simulator
        self.location = [[CLLocation alloc] initWithLatitude:37.7873589 longitude:-122.408227];
    } else {
        self.location = self.locationManager.location;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.locationManager stopUpdatingLocation];
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
    if (indexPath.row == self.places.count - 1) {
        isLoading = NO; // finishes loading
    }
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

- (void) locationManager:(CLLocationManager *)manager
     didUpdateToLocation:(CLLocation *)newLocation
            fromLocation:(CLLocation *)oldLocation {
    self.location = newLocation;
}

- (void)showFilterScreen {
    FilterViewController *filterViewController = [[FilterViewController alloc] init];
    filterViewController.myDelegate = self;
    UINavigationController *navBar = [[UINavigationController alloc] initWithRootViewController:filterViewController];
    [self presentViewController:navBar animated:YES completion:nil];
}

- (void)showMapScreen {
    MapViewController *mapViewController = [[MapViewController alloc] init];
    mapViewController.location = self.location;
    mapViewController.places = self.places;
    UINavigationController *navBar = [[UINavigationController alloc] initWithRootViewController:mapViewController];
    [self presentViewController:navBar animated:YES completion:nil];
}

- (void)search {
    [self.client
     searchWithTerm:self.searchTerm
     withFilters:self.filterSelection
     atLocation:self.location
     withOffset:self.offset
     success:^(AFHTTPRequestOperation *operation, id response) {
        NSError *error;
        [self.places addObjectsFromArray:[MTLJSONAdapter
                                          modelsOfClass:[Place class]
                                          fromJSONArray:response[@"businesses"]
                                          error:&error]];
         self.offset = self.places.count;
         [self displayNoResultsIfNecessary];
         [self.tableView reloadData];
        if (error) {
            NSLog(@"error: %@", [error description]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
}

- (void)filterSelectionDone:(NSDictionary *)filters {
    self.offset = 0;
    self.filterSelection = filters;
    [self.places removeAllObjects];
    [self search];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    self.offset = 0;
    [self.places removeAllObjects];
    self.searchTerm = textField.text;
    [self search];
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isLoading) {
        return;
    }
    CGFloat actualPosition = scrollView.contentOffset.y;
    CGFloat contentHeight = scrollView.contentSize.height;
    // Start fetching data before it gets to the end of the screen
    if (contentHeight - actualPosition < 1000) {
        isLoading = YES;
        [self search];
    }
}

- (void)setupUI {
    UITextField *searchField = [[UITextField alloc] initWithFrame:CGRectMake(5.0, 10.0, 200, 28.0)];
    UIView *searchBarView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 310.0, 45.0)];
    searchBarView.autoresizingMask = 0;

    searchField.delegate = self;
    searchField.keyboardType = UIKeyboardTypeWebSearch;
    searchField.placeholder = @"Search";
    searchField.text = self.searchTerm;
    searchField.font = [UIFont systemFontOfSize:14];
    searchField.backgroundColor = [UIColor whiteColor];
    searchField.tintColor = [UIColor grayColor];
    searchField.borderStyle = UITextBorderStyleRoundedRect;
    searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchField.autocorrectionType = UITextAutocorrectionTypeNo;

    [searchBarView addSubview:searchField];
    self.navigationItem.titleView = searchBarView;
    
    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"Filter"
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(showFilterScreen)];

    UIBarButtonItem *mapButton = [[UIBarButtonItem alloc]
                                  initWithTitle:@"Map"
                                  style:UIBarButtonItemStylePlain
                                  target:self
                                  action:@selector(showMapScreen)];
    self.navigationItem.leftBarButtonItem = filterButton;
    self.navigationItem.rightBarButtonItem = mapButton;
}

- (void)displayNoResultsIfNecessary {
    if (self.places.count == 0) {
        self.noResultView.hidden = NO;
        self.tableView.hidden = YES;
        if ([self.searchTerm length] > 0) {
            self.noResultLabel.text = [NSString stringWithFormat:@"No results for %@", self.searchTerm];
        } else {
            self.noResultLabel.text = @"No results";
        }
    } else {
        self.noResultView.hidden = YES;
        self.tableView.hidden = NO;
    }
}
@end
