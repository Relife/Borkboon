//
//  CalendaViewController.h
//  Borkboon
//
//  Created by MacbookPro on 9/30/56 BE.
//  Copyright (c) 2556 Relife. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CXCalendarView.h"

@interface CalendaViewController : UIViewController<CXCalendarViewDelegate>
{
    __weak IBOutlet UIView *viewCal;
    __weak IBOutlet UIImageView *icon_prayday;
    __weak IBOutlet UILabel *txtPrayDay;
    
    __weak IBOutlet UISwitch *notiSwitch;
}

@property(retain, nonatomic) CXCalendarView *calendarView;

- (IBAction)notiSwitchChange:(id)sender;

@end
