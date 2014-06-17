//
//  FilterViewController.m
//  yelpper
//
//  Created by Amie Kweon on 6/15/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "FilterViewController.h"
#import "ListViewController.h"
#import "Place.h"
#import "Utils.h"

@interface FilterViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
// a list of filters to display
@property (nonatomic, strong) NSArray *filters;

// map of section number to expanded state
@property (nonatomic, strong) NSMutableDictionary *expanded;

// result of filter values
@property (nonatomic, strong) NSMutableDictionary *filterSelection;

// keep track of category selection in a separate mutable array;
// converting an immutable array from NSUserDefaults to a mutable one
// was causing too many issues..
@property (nonatomic, strong) NSMutableArray *categorySelection;
@end

@implementation FilterViewController

@synthesize myDelegate;

NSInteger maxCountCollapsed = 5;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Filter";
        self.filters = @[@{@"title":@"Most Popular",
                           @"data": @[@{@"name":@"Offering a Deal", @"key": @"deals_filter"}],
                           @"type": @"toggle"
                           },
                         @{@"title": @"Distance",
                           @"data": [Place getDistanceOptions],
                           @"type": @"single",
                           @"key": @"radius_filter"
                           },
                         @{@"title": @"Sort by",
                           @"data": [Place getSortOptions],
                           @"type": @"single",
                           @"key": @"sort"
                           },
                         @{@"title": @"Categories",
                           @"data": [Place getCategories],
                           @"type": @"multiple",
                           @"key": @"category_filter"
                           }
                         ];
        self.expanded = [[NSMutableDictionary alloc] init];
        self.categorySelection = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

-(void)viewDidAppear:(BOOL)animated {
    NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
    self.filterSelection = [[store objectForKey:@"savedFilters"] mutableCopy];

    if (self.filterSelection == nil) {
        self.filterSelection = [NSMutableDictionary dictionary];
    }
    
    if ([self.filterSelection objectForKey:@"category_filter"] != nil) {
        NSString *commaSeparated = [self.filterSelection objectForKey:@"category_filter"];
        NSArray *array = [commaSeparated componentsSeparatedByString:@","];
        self.categorySelection = [NSMutableArray arrayWithArray:array];
    }

    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.filters.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *filterGroup = self.filters[section];
    if ([self.expanded[@(section)] boolValue]) {
        return ((NSArray *)self.filters[section][@"data"]).count;
    } else if ([filterGroup[@"type"] isEqual: @"multiple"]) {
        return maxCountCollapsed;
    } else {
        return 1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    // Display group text
    UILabel *sectionTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 300, 35)];
    sectionTitle.text = [self.filters[section][@"title"] uppercaseString];
    sectionTitle.font = [sectionTitle.font fontWithSize:13];
    sectionTitle.textColor = [UIColor darkGrayColor];
    UIView *view = [[UIView alloc] init];
    [view addSubview:sectionTitle];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]
                             initWithStyle:UITableViewCellStyleDefault
                             reuseIdentifier:nil];

    BOOL sectionExpanded = [self.expanded[@(indexPath.section)] boolValue];

    NSDictionary *filterGroup = self.filters[indexPath.section];
    NSArray *filterOptions = filterGroup[@"data"];
    NSDictionary *currentRowOption = filterOptions[indexPath.row];

    cell.textLabel.text = currentRowOption[@"name"];
    
    if ([filterGroup[@"type"] isEqual: @"toggle"]) {
        // Show toggle button
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        cell.accessoryView = switchView;
        BOOL selected = [self.filterSelection objectForKey:currentRowOption[@"key"]] != nil;
        [switchView setOn:selected animated:NO];
        [switchView addTarget:self
                    action:@selector(toggleChanged:)
                    forControlEvents:UIControlEventValueChanged];
    } else if ([filterGroup[@"type"] isEqual: @"multiple"]) {
        // Show checkbox; pretend category is the only multiple option
        if ([self.categorySelection containsObject:currentRowOption[@"value"]]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        if (!sectionExpanded && indexPath.row == (maxCountCollapsed - 1)) {
            cell.textLabel.text = @"See All";
        }
    } else if ([filterGroup[@"type"] isEqual: @"single"]) {
        NSString *selectedValue = [self.filterSelection objectForKey:filterGroup[@"key"]];
        if (sectionExpanded) {
            if ([selectedValue isEqual:currentRowOption[@"value"]]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        } else {
            cell.textLabel.text = [self findNameInDictionary:filterOptions withValue:selectedValue];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *filterGroup = self.filters[indexPath.section];
    NSArray *filterOptions = filterGroup[@"data"];
    NSDictionary *currentRowOption = filterOptions[indexPath.row];

    BOOL sectionExpanded = [self.expanded[@(indexPath.section)] boolValue];
    BOOL disableCollapse = sectionExpanded && [filterGroup[@"type"] isEqual: @"multiple"];
    
    // Record selection only when it's already expanded
    if (sectionExpanded) {
        if ([filterGroup[@"type"] isEqual: @"single"]) {
            self.filterSelection[filterGroup[@"key"]] = currentRowOption[@"value"];
        } else if ([filterGroup[@"type"] isEqual: @"multiple"]) {
            if ([self.categorySelection containsObject:currentRowOption[@"value"]]) {
                [self.categorySelection removeObject:currentRowOption[@"value"]];
            } else {
                [self.categorySelection addObject:currentRowOption[@"value"]];
            }
        }
    }

    if (!disableCollapse) {
        self.expanded[@(indexPath.section)] = @(!sectionExpanded);
    }

    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]
                  withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)search {
    [self.categorySelection removeObject:@""];
    self.filterSelection[@"category_filter"] = [self.categorySelection componentsJoinedByString:@","];

    NSUserDefaults *store = [NSUserDefaults standardUserDefaults];
    [store setObject:self.filterSelection forKey:@"savedFilters"];
    [store synchronize];

    if([self.myDelegate respondsToSelector:@selector(filterSelectionDone:)]) {
        [self.myDelegate filterSelectionDone:self.filterSelection];
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)toggleChanged:(id)sender {
    BOOL state = [sender isOn];
    if (state) {
        // This works only because there's only one toggle filter.
        // Generalize this later.
        self.filterSelection[@"deals_filter"] = @"true";
    } else {
        [self.filterSelection removeObjectForKey:@"deals_filter"];
    }
}

- (id)findNameInDictionary:(NSArray *)array withValue:(NSString *)value {
    id match = array[0][@"name"];
    for (NSDictionary *item in array) {
        if ([item[@"value"] isEqual:value]) {
            match = item[@"name"];
            break;
        }
    }
    return match;
}

- (void)setupUI {
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"Cancel"
                                     style:UIBarButtonItemStyleBordered
                                     target:self
                                     action:@selector(cancel)];
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"Search"
                                     style:UIBarButtonItemStyleBordered
                                     target:self
                                     action:@selector(search)];
    self.navigationController.navigationBar.barTintColor = [Utils getYelpRed];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = searchButton;
}
@end
