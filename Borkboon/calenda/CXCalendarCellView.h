//
//  CXCalendarCellView.h
//  Calendar
//
//  Created by Vladimir Grichina on 13.07.11.
//  Copyright 2011 Componentix. All rights reserved.
//


@interface CXCalendarCellView : UIButton

@property(nonatomic, assign) NSUInteger day;
@property(nonatomic, assign) NSUInteger month;
@property(nonatomic, assign) NSUInteger year;

@property(nonatomic, readwrite) Boolean isPrayDay;
@property(nonatomic, readwrite) int moonDay;
@property(nonatomic, readwrite) int moonMonth;


@property(nonatomic, assign) UIColor *normalBackgroundColor;
@property(nonatomic, assign) UIColor *selectedBackgroundColor;

- (NSDate *) dateWithBaseDate: (NSDate *) baseDate withCalendar: (NSCalendar *)calendar;

@end
