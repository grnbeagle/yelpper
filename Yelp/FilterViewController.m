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

@interface FilterViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *filters;

// map of section number to expanded state
@property (nonatomic, strong) NSMutableDictionary *expanded;

// map of section number to row number to selected state
@property (nonatomic, strong) NSMutableDictionary *selected;

// result of filter values
@property (nonatomic, strong) NSMutableDictionary *filterSelection;

@end

@implementation FilterViewController

@synthesize myDelegate;

NSInteger maxCountCollapsed = 5;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
        self.expanded = [NSMutableDictionary dictionary];
        self.selected = [NSMutableDictionary dictionary];
        self.filterSelection = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    [self.tableView reloadData];
    
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
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = searchButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.filters.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
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
    UILabel *sectionTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 300, 40)];
    sectionTitle.text = [self.filters[section][@"title"] uppercaseString];
    sectionTitle.font = [sectionTitle.font fontWithSize:13];
    sectionTitle.textColor = [UIColor darkGrayColor];
    UIView *view = [[UIView alloc] init];
    [view addSubview:sectionTitle];
    
    if (self.selected[@(section)] == nil) {
        self.selected[@(section)] = [NSMutableDictionary dictionary];
    }
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]
                             initWithStyle:UITableViewCellStyleDefault
                             reuseIdentifier:nil];

    NSDictionary *filterGroup = self.filters[indexPath.section];
    NSArray *choices = filterGroup[@"data"];
    BOOL sectionExpanded = [self.expanded[@(indexPath.section)] boolValue];
    cell.textLabel.text = choices[indexPath.row][@"name"];
    
    if ([filterGroup[@"type"] isEqual: @"toggle"]) {
        // Show toggle button
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        cell.accessoryView = switchView;
        [switchView setOn:NO animated:NO];
        [switchView addTarget:self
                    action:@selector(toggleChanged:)
                    forControlEvents:UIControlEventValueChanged];
    } else if ([filterGroup[@"type"] isEqual: @"multiple"]) {
        // Show checkbox
        if ([self.selected[@(indexPath.section)][@(indexPath.row)] boolValue]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        if (!sectionExpanded && indexPath.row == (maxCountCollapsed - 1)) {
            cell.textLabel.text = @"See All";
        }
    } else if ([filterGroup[@"type"] isEqual: @"single"]) {
        if (sectionExpanded) {
            if ([self.selected[@(indexPath.section)][@(indexPath.row)] boolValue]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        } else {
            NSInteger selectedIndex = [self selectedIndexInSection:indexPath.section];
            cell.textLabel.text = choices[selectedIndex][@"name"];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *filterGroup = self.filters[indexPath.section];
    BOOL sectionExpanded = [self.expanded[@(indexPath.section)] boolValue];
    BOOL disableCollapse = sectionExpanded && [filterGroup[@"type"] isEqual: @"multiple"];
    // Record selection only when it's already expanded
    if (sectionExpanded) {
        if ([filterGroup[@"type"] isEqual: @"single"]) {
            self.filterSelection[filterGroup[@"key"]] = filterGroup[@"data"][indexPath.row][@"value"];
            // clear previous selection for single choice filters
            [self.selected[@(indexPath.section)] removeAllObjects];
        } else if ([filterGroup[@"type"] isEqual: @"multiple"]) {
            if (self.filterSelection[filterGroup[@"key"]] == nil) {
                self.filterSelection[filterGroup[@"key"]] = [[NSMutableArray alloc] init];
            }
            [self.filterSelection[filterGroup[@"key"]] addObject:filterGroup[@"data"][indexPath.row][@"value"]];
        }
        self.selected[@(indexPath.section)][@(indexPath.row)] = @(YES);
    }

    if (!disableCollapse) {
        self.expanded[@(indexPath.section)] = @(!sectionExpanded);
    }

    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]
                  withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)search {
    if (self.filterSelection[@"category_filter"] != nil) {
        self.filterSelection[@"category_filter"] = [self.filterSelection[@"category_filter"] componentsJoinedByString:@","];
    }

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

- (NSInteger)selectedIndexInSection:(NSInteger)section {
    NSInteger index = 0;
    for (id key in self.selected[@(section)]) {
        if ([self.selected[@(section)][key] boolValue]) {
            index = [key integerValue];
        }
    }
    return index;
}

@end
