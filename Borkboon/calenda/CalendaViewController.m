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
    
    self.calendarView = [[CXCalendarView alloc] initWithFrame: viewCal.bounds];
    [viewCal addSubview: self.calendarView];
    self.calendarView.frame = self.view.bounds;
    self.calendarView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.calendarView.selectedDate = [NSDate date];
    
    self.calendarView.delegate = self;
    [self.calendarView setParent:viewCal];
    [viewCal setClipsToBounds:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [notiSwitch setOn: [[NSUserDefaults standardUserDefaults] boolForKey:@"SET_PRAYDAY_NOTI"]];
    
    [self calendarView:self.calendarView didSelectDate:[NSDate date]];
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
    
    CXCalendarCellView* cell = [calendarView cellForDate:date];

    [icon_prayday setHidden:!cell.isPrayDay];
    if (cell.moonDay > 15) {
        dateTxt = [NSString stringWithFormat:@"%@ วันแรม %d ค่ำเดือน %d",dateTxt, cell.moonDay-15, cell.moonMonth];
    }else{
        dateTxt = [NSString stringWithFormat:@"%@ วันขึ้น %d ค่ำเดือน %d",dateTxt, cell.moonDay, cell.moonMonth];
    }
    
    [txtPrayDay setText:dateTxt];
    
}

- (IBAction)notiSwitchChange:(id)sender {
    //TODO: Remove badge here
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    
    UISwitch* sw = (UISwitch*)sender;
    if (sw.isOn) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"SET_PRAYDAY_NOTI"];
        
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [self scheduleNotification];
        
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"SET_PRAYDAY_NOTI"];
        
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        
    }
}

- (void)scheduleNotification{
//    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
//    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
//    [dateComps setDay:item.day];
//    [dateComps setMonth:item.month];
//    [dateComps setYear:item.year];
//    [dateComps setHour:item.hour];
//    [dateComps setMinute:item.minute];
//    NSDate *itemDate = [calendar dateFromComponents:dateComps];
    
    
    NSArray* allcell = [self.calendarView AllCell];
    for (int i=0; i<allcell.count; i++) {
        CXCalendarCellView* cell = [allcell objectAtIndex:i];
        
        if (cell.isPrayDay) {
            
            
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *components = [[NSDateComponents alloc] init];
            
            [components setDay:cell.day];
            [components setMonth:cell.month];
            [components setYear:cell.year];
            [components setHour:6];
            [components setMinute:0];
            NSDate *itemDate = [calendar dateFromComponents:components];
            
            if ([itemDate timeIntervalSinceNow] <= 0 ) {
                NSLog(@"item %@ is deprecate", itemDate.description);
                break;
            }
            
            UILocalNotification *localNotif = [[UILocalNotification alloc] init];
            if (localNotif == nil)
                return;
            localNotif.fireDate = itemDate;
            localNotif.timeZone = [NSTimeZone defaultTimeZone];
            
            localNotif.alertBody = [NSString stringWithFormat:NSLocalizedString(@"%@ %@", nil),
                                    @"วันนี้วันพระ", txtPrayDay.text];
            localNotif.alertAction = NSLocalizedString(@"View Details", nil);
            
            localNotif.soundName = UILocalNotificationDefaultSoundName;
            localNotif.applicationIconBadgeNumber = 1;
            
            NSDictionary *infoDict = [NSDictionary dictionaryWithObject:itemDate.description forKey:@"key"];
            localNotif.userInfo = infoDict;
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
            
        }
    }
    
    
    
}
@end
