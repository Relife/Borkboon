//
//  CalendaViewController.m
//  Borkboon
//
//  Created by MacbookPro on 9/30/56 BE.
//  Copyright (c) 2556 Relife. All rights reserved.
//

#import "CalendaViewController.h"

@interface CalendaViewController ()

@end

@implementation CalendaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) loadView {
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.calendarView = [[CXCalendarView alloc] initWithFrame: self.view.bounds];
    [viewCal addSubview: self.calendarView];
    self.calendarView.frame = self.view.bounds;
    self.calendarView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.calendarView.selectedDate = [NSDate date];
    
    self.calendarView.delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void) viewDidDisappear:(BOOL)animated{
    self.calendarView = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark CXCalendarViewDelegate

- (void) calendarView: (CXCalendarView *) calendarView
        didSelectDate: (NSDate *) date {
    
    NSLog(@"Selected date: %@", date);
    /*TTAlert([NSString stringWithFormat: @"Selected date: %@", date]);*/
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMMM yyyy"];
    NSString* dateTxt = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];
    [txtPrayDay setText:dateTxt];
}

- (IBAction)notiSwitchChange:(id)sender {
    
}
@end
