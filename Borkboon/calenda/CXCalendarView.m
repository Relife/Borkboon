//
//  CXCalendarView.m
//  Calendar
//
//  Created by Vladimir Grichina on 13.07.11.
//  Copyright 2011 Componentix. All rights reserved.
//

#import "CXCalendarView.h"

#import <QuartzCore/QuartzCore.h>

#import "CXCalendarCellView.h"
#import "UIColor+CXCalendar.h"
#import "UILabel+CXCalendar.h"
#import "UIButton+CXCalendar.h"

#import <QuartzCore/QuartzCore.h>


static const CGFloat kGridMargin = 4;
static const CGFloat kDefaultMonthBarButtonWidth = 60;

@interface CXCalendarView ()
{
    NSString* currentTitle;
    NSString* currentElement;
    
    NSMutableDictionary* item;
    NSMutableArray* list;
    
    BOOL alreadyAdd;
    BOOL alreadyAdd2;
}
@end

@implementation CXCalendarView

@synthesize delegate;

- (id) initWithFrame: (CGRect) frame {
    if ((self = [super initWithFrame: frame])) {
        [self setDefaults];
    }

    return self;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    [self setDefaults];
}

- (void) setDefaults {
    
    alreadyAdd = NO;
    alreadyAdd2 = NO;
    
    [self loadMoonDayWithYear:@"2013"];
    
    
    self.backgroundColor = [UIColor clearColor];
    
    

    CGGradientRef gradient = CGGradientCreateWithColors(NULL,
        (CFArrayRef)CFBridgingRetain(@[
                      (id)[UIColor colorWithRed:188/255. green:200/255. blue:215/255. alpha:1].CGColor,
                      (id)[UIColor colorWithRed:125/255. green:150/255. blue:179/255. alpha:1].CGColor]), NULL);
    CGGradientRef cellGradient = CGGradientCreateWithColors(NULL,
                                (CFArrayRef)CFBridgingRetain(@[
         (id)[UIColor colorWithRed:188/255. green:200/255. blue:215/255. alpha:1].CGColor,
         (id)[UIColor colorWithRed:245/255. green:245/255. blue:245/255. alpha:1].CGColor]), NULL);

    self.monthBarBackgroundColor = [UIColor cx_colorWithGradient:gradient size:CGSizeMake(1, 48)];
    
    
    
    
    
    
    // TODO: Merge default text attributes when given custom ones!
    self.monthLabelTextAttributes = @{
        UITextAttributeTextColor : [UIColor whiteColor],
        UITextAttributeFont : [UIFont systemFontOfSize:[UIFont buttonFontSize]],
        UITextAttributeTextShadowColor : [UIColor grayColor],
        UITextAttributeTextShadowOffset : [NSValue valueWithCGSize:CGSizeMake(0, 1)]
    };
    self.weekdayLabelTextAttributes = @{
        UITextAttributeTextColor : [UIColor blackColor],
        UITextAttributeFont : [UIFont systemFontOfSize:[UIFont systemFontSize]],
        UITextAttributeTextShadowOffset : [NSValue valueWithCGSize:CGSizeMake(0, 1)]
        };
    self.cellLabelNormalTextAttributes = @{
        UITextAttributeTextColor : [UIColor blackColor]
    };
    self.cellLabelSelectedTextAttributes = @{
        UITextAttributeTextColor : [UIColor whiteColor]
    };
    self.cellSelectedBackgroundColor = [UIColor grayColor];
    self.cellNormalBackgroundColor = [UIColor cx_colorWithGradient:cellGradient size:CGSizeMake(1, 48)];//[UIColor whiteColor];

    _dateFormatter = [NSDateFormatter new];
    _dateFormatter.locale = [NSLocale autoupdatingCurrentLocale];
//    _calendar = [[NSCalendar currentCalendar] retain];
    _calendar = [NSCalendar currentCalendar];

    _monthBarHeight = 48;
    _weekBarHeight = 32;

    self.displayedDate = [NSDate date];
    self.selectedDate = [NSDate date];
    
    
}

- (void) dealloc {
//    [_calendar release];
//    [_selectedDate release];
//    [_displayedDate release];
//    [_dateFormatter release];
//
//    [super dealloc];
}

- (NSCalendar *) calendar {
    return _calendar;
}

- (void) setCalendar: (NSCalendar *) calendar {
    if (_calendar != calendar) {
//        [_calendar release];
//        _calendar = [calendar retain];
        _calendar = calendar;
        _dateFormatter.calendar = _calendar;

        [self setNeedsLayout];
    }
}

- (NSDate *) selectedDate {
    return _selectedDate;
}

- (void) updateSelectedDate {
    for (CXCalendarCellView *cellView in self.dayCells) {
        cellView.selected = NO;
    }

    [self cellForDate: self.selectedDate].selected = YES;
}

- (void) setSelectedDate: (NSDate *) selectedDate {
    if (![selectedDate isEqual: _selectedDate]) {
//        [_selectedDate release];
//        _selectedDate = [selectedDate retain];
        _selectedDate = selectedDate;

        [self updateSelectedDate];

        if ([self.delegate respondsToSelector:@selector(calendarView:didSelectDate:)]) {
            [self.delegate calendarView: self didSelectDate: _selectedDate];
        }
    }
}

- (NSDate *) displayedDate {
    return _displayedDate;
}

- (void) setDisplayedDate: (NSDate *) displayedDate {
    if (_displayedDate != displayedDate) {
//        [_displayedDate release];
//        _displayedDate = [displayedDate retain];
        _displayedDate = displayedDate;

        NSString *monthName = [[_dateFormatter standaloneMonthSymbols] objectAtIndex: self.displayedMonth - 1];
        self.monthLabel.text = [NSString stringWithFormat: @"%@ %d", monthName, self.displayedYear];

        [self updateSelectedDate];

        [self setNeedsLayout];
    }
}

- (NSUInteger) displayedYear {
    NSDateComponents *components = [self.calendar components: NSYearCalendarUnit
                                                    fromDate: self.displayedDate];
    return components.year;
}

- (NSUInteger) displayedMonth {
    NSDateComponents *components = [self.calendar components: NSMonthCalendarUnit
                                                    fromDate: self.displayedDate];
    return components.month;
}

- (CGFloat) monthBarHeight {
    return _monthBarHeight;
}

- (void) setMonthBarHeight: (CGFloat) monthBarHeight {
    if (_monthBarHeight != monthBarHeight) {
        _monthBarHeight = monthBarHeight;
        [self setNeedsLayout];
    }
}

- (CGFloat) weekBarHeight {
    return _weekBarHeight;
}

- (void) setWeekBarHeight: (CGFloat) weekBarHeight {
    if (_weekBarHeight != weekBarHeight) {
        _weekBarHeight = weekBarHeight;
        [self setNeedsLayout];
    }
}

- (void) touchedCellView: (CXCalendarCellView *) cellView {
    self.selectedDate = [cellView dateWithBaseDate: self.displayedDate withCalendar: self.calendar];
}

- (void) monthForward {
    NSDateComponents *monthStep = [NSDateComponents new];
    monthStep.month = 1;
    
    int currentYear = [self displayedYear];
    
    self.displayedDate = [self.calendar dateByAddingComponents: monthStep toDate: self.displayedDate options: 0];
    
    if (currentYear != [self displayedYear]) {
        [self loadMoonDayWithYear:[NSString stringWithFormat:@"%d", [self displayedYear]]];
    }
    
    for (NSUInteger i = 0; i < 31; ++i) {
        CXCalendarCellView *cell = [_dayCells objectAtIndex:i];
        
        //Add Pray icon
        UIImageView* image = (UIImageView*)[cell viewWithTag:999];
        
        [image setHidden:![self CheckPrayDay:cell.day Month:self.displayedMonth Year:self.displayedYear WithCell:cell]];
        if (cell.moonDay == 30 || cell.moonDay == 15) {
            [image setImage:[UIImage imageNamed:@"icon_fullmoon.png"]];
        }
        else{
            [image setImage:[UIImage imageNamed:@"icon_moon.png"]];
        }
    }
}

- (void) monthBack {
    NSDateComponents *monthStep = [NSDateComponents new];
    monthStep.month = -1;
    int currentYear = [self displayedYear];
    
    self.displayedDate = [self.calendar dateByAddingComponents: monthStep toDate: self.displayedDate options: 0];
    
    if (currentYear != [self displayedYear]) {
        [self loadMoonDayWithYear:[NSString stringWithFormat:@"%d", [self displayedYear]]];
    }
    
    for (NSUInteger i = 0; i < 31; ++i) {
        CXCalendarCellView *cell = [_dayCells objectAtIndex:i];
        
        //Add Pray icon
        UIImageView* image = (UIImageView*)[cell viewWithTag:999];
        
        [image setHidden:![self CheckPrayDay:cell.day Month:self.displayedMonth Year:self.displayedYear WithCell:cell]];
        if (cell.moonDay == 30 || cell.moonDay == 15) {
            [image setImage:[UIImage imageNamed:@"icon_fullmoon.png"]];
        }
        else{
            [image setImage:[UIImage imageNamed:@"icon_moon.png"]];
        }
    }
}

- (void) reset {
    self.selectedDate = nil;
}

- (NSDate *) displayedMonthStartDate {
    NSDateComponents *components = [self.calendar components: NSMonthCalendarUnit|NSYearCalendarUnit
                                                    fromDate: self.displayedDate];
    components.day = 1;
    return [self.calendar dateFromComponents: components];
}

- (CXCalendarCellView *) cellForDate: (NSDate *) date {
    if (!date) {
        return nil;
    }

    NSDateComponents *components = [self.calendar components: NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit
                                                        fromDate: date];
    if (components.month == self.displayedMonth &&
            components.year == self.displayedYear &&
            [self.dayCells count] >= components.day) {

       
        return [self.dayCells objectAtIndex: components.day - 1];
    }
    
    return nil;
}

- (void) applyStyles {
    _monthBar.backgroundColor = self.monthBarBackgroundColor;
    [_monthLabel cx_setTextAttributes:self.monthLabelTextAttributes];
    [_monthLabel cx_setTextAttributes:self.monthLabelTextAttributes];
    [_monthLabel cx_setTextAttributes:self.monthLabelTextAttributes];
}

- (void) layoutSubviews {
    [super layoutSubviews];

    [self applyStyles];

    CGFloat top = 0;
    CGRect bound;
    if (self.parent != nil) {
        bound = self.parent.bounds;
    }else{
        bound = self.bounds;
    }

    if (self.monthBarHeight) {
        self.monthBar.frame = CGRectMake(0, top, bound.size.width, self.monthBarHeight);
        self.monthLabel.frame = CGRectMake(0, top, bound.size.width, self.monthBar.bounds.size.height);
        self.monthForwardButton.frame = CGRectMake(self.monthBar.bounds.size.width - kDefaultMonthBarButtonWidth, top,
                                                   kDefaultMonthBarButtonWidth, self.monthBar.bounds.size.height);
        self.monthBackButton.frame = CGRectMake(0, top, kDefaultMonthBarButtonWidth, self.monthBar.bounds.size.height);
        top = self.monthBar.frame.origin.y + self.monthBar.frame.size.height;
    } else {
        self.monthBar.frame = CGRectZero;
    }

    
    if (self.weekBarHeight) {
        
        if (!alreadyAdd) {
            CGGradientRef gradient = CGGradientCreateWithColors(NULL,
                                                                (CFArrayRef)CFBridgingRetain(@[
                                                                                             (id)[UIColor colorWithRed:188/255. green:200/255. blue:215/255. alpha:1].CGColor,
                                                                                             (id)[UIColor colorWithRed:125/255. green:150/255. blue:179/255. alpha:1].CGColor]), NULL);
            
            UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, top-1, bound.size.width, self.weekBarHeight+2)];
            [view setBackgroundColor:[UIColor cx_colorWithGradient:gradient size:CGSizeMake(1, 48)]];
            
            [self addSubview:view];
            alreadyAdd = YES;
        }
        
        
        self.weekdayBar.frame = CGRectMake(0, top, bound.size.width, self.weekBarHeight);
        CGRect contentRect = CGRectInset(self.weekdayBar.bounds, kGridMargin, 0);
        for (NSUInteger i = 0; i < [self.weekdayNameLabels count]; ++i) {
            UILabel *label = [self.weekdayNameLabels objectAtIndex:i];
            label.frame = CGRectMake( kGridMargin + (contentRect.size.width / 7) * (i % 7), 0,
                                     contentRect.size.width / 7, contentRect.size.height);
            [label setBackgroundColor:[UIColor clearColor]];
            
        }
        top = self.weekdayBar.frame.origin.y + self.weekdayBar.frame.size.height;
    } else {
        self.weekdayBar.frame = CGRectZero;
    }

    // Calculate shift
    NSDateComponents *components = [self.calendar components: NSWeekdayCalendarUnit
                                                    fromDate: [self displayedMonthStartDate]];
    NSInteger shift = components.weekday - self.calendar.firstWeekday;
    if (shift < 0) {
        shift = 7 + shift;
    }

    // Calculate range
    NSRange range = [self.calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit
                                       forDate:self.displayedDate];

    self.gridView.frame = CGRectMake(kGridMargin, top,
                                     bound.size.width - kGridMargin * 2,
                                     bound.size.height - top);
    
    
    
    
    //[self.gridView.layer setBorderWidth:1];
    //[self.gridView.layer setBorderColor:[UIColor blackColor].CGColor];
    
    CGFloat cellHeight = self.gridView.bounds.size.height / 6.0;
    CGFloat cellWidth = (bound.size.width - kGridMargin * 2) / 7.0;
    
    if (!alreadyAdd2) {
        CGGradientRef gradient = CGGradientCreateWithColors(NULL,
                                                            (CFArrayRef)CFBridgingRetain(@[
                                                                                         (id)[UIColor colorWithRed:188/255. green:200/255. blue:215/255. alpha:1].CGColor,
                                                                                         (id)[UIColor colorWithRed:125/255. green:150/255. blue:179/255. alpha:1].CGColor]), NULL);
        
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, top-1, bound.size.width, cellHeight*6 + 2)];
        [view setBackgroundColor:[UIColor cx_colorWithGradient:gradient size:CGSizeMake(1, view.bounds.size.height)]];
        
        [self addSubview:view];
        [self bringSubviewToFront:self.gridView];
        alreadyAdd2 = YES;
    }
    
    for (NSUInteger i = 0; i < [self.dayCells count]; ++i) {
        CXCalendarCellView *cellView = [self.dayCells objectAtIndex:i];
        cellView.frame = CGRectMake(cellWidth * ((shift + i) % 7), cellHeight * ((shift + i) / 7),
                                    cellWidth, cellHeight);
        cellView.hidden = i >= range.length;
        
        
        UIImageView* image = (UIImageView*)[cellView viewWithTag:999];
        [image setHidden:!cellView.isPrayDay];
        
        if (cellView.isPrayDay) {
            NSLog(@"cell:%d Day:%d Moon:%d Month:%d",i, cellView.day,cellView.moonDay, cellView.moonMonth);
        }
        
    }
    
    
    
    
}

- (UIView *) monthBar {
    if (!_monthBar) {
        _monthBar = [[UIView alloc] init];
        _monthBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview: _monthBar];
    }
    return _monthBar;
}

- (UILabel *) monthLabel {
    if (!_monthLabel) {
        _monthLabel = [[UILabel alloc] init];
        _monthLabel.textAlignment = NSTextAlignmentCenter;
        _monthLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        _monthLabel.backgroundColor = [UIColor clearColor];
        [self.monthBar addSubview: _monthLabel];
    }
    return _monthLabel;
}

- (UIButton *) monthBackButton {
    if (!_monthBackButton) {
        _monthBackButton = [[UIButton alloc] init];
        [_monthBackButton setTitle: @"<" forState:UIControlStateNormal];
        [_monthBackButton addTarget: self
                             action: @selector(monthBack)
                   forControlEvents: UIControlEventTouchUpInside];
        [self.monthBar addSubview: _monthBackButton];
    }
    return _monthBackButton;
}

- (UIButton *) monthForwardButton {
    if (!_monthForwardButton) {
        _monthForwardButton = [[UIButton alloc] init];
        [_monthForwardButton setTitle: @">" forState:UIControlStateNormal];
        [_monthForwardButton addTarget: self
                                action: @selector(monthForward)
                      forControlEvents: UIControlEventTouchUpInside];
        [self.monthBar addSubview: _monthForwardButton];
    }
    return _monthForwardButton;
}

- (UIView *) weekdayBar {
    if (!_weekdayBar) {
        _weekdayBar = [[UIView alloc] init];
        _weekdayBar.backgroundColor = [UIColor clearColor];
    }
    return _weekdayBar;
}

- (NSArray *) weekdayNameLabels {
    if (!_weekdayNameLabels) {
        NSMutableArray *labels = [NSMutableArray array];

        for (NSUInteger i = self.calendar.firstWeekday; i < self.calendar.firstWeekday + 7; ++i) {
            NSUInteger index = (i - 1) < 7 ? (i - 1) : ((i - 1) - 7);

            UILabel *label = [[UILabel alloc] initWithFrame: CGRectZero];
            label.tag = i;
            [label cx_setTextAttributes:self.weekdayLabelTextAttributes];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = [[_dateFormatter shortWeekdaySymbols] objectAtIndex: index];

            [labels addObject:label];
            [_weekdayBar addSubview: label];
        }

        [self addSubview:_weekdayBar];
        _weekdayNameLabels = [[NSArray alloc] initWithArray:labels];
    }
    return _weekdayNameLabels;
}

- (UIView *) gridView {
    if (!_gridView) {
        _gridView = [[UIView alloc] init];
        _gridView.backgroundColor = [UIColor clearColor];
        _gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview: _gridView];
    }
    return _gridView;
}

- (NSArray *) dayCells {
    if (!_dayCells) {
        NSMutableArray *cells = [NSMutableArray array];
        for (NSUInteger i = 1; i <= 31; ++i) {
            CXCalendarCellView *cell = [CXCalendarCellView new];
            [cell.layer setBorderWidth:1];
            [cell.layer setBorderColor:[UIColor grayColor].CGColor];
            cell.tag = i;
            cell.day = i;
            [cell addTarget: self
                     action: @selector(touchedCellView:)
           forControlEvents: UIControlEventTouchUpInside];
            
            //Add Pray icon
            UIImageView* image = [[UIImageView alloc] initWithFrame:CGRectMake(cell.bounds.size.width+ 0, 0, 12, 12)];
            [image setImage:[UIImage imageNamed:@"icon_fullmoon.png"]];
            [image setTag:999];
            [cell addSubview:image];
            
            [image setHidden:![self CheckPrayDay:i Month:self.displayedMonth Year:self.displayedYear WithCell:cell]];
            if (cell.moonDay == 30 || cell.moonDay == 15) {
                [image setImage:[UIImage imageNamed:@"icon_fullmoon.png"]];
            }
            else{
                [image setImage:[UIImage imageNamed:@"icon_moon.png"]];
            }
            
            cell.normalBackgroundColor = self.cellNormalBackgroundColor;
            cell.selectedBackgroundColor = self.cellSelectedBackgroundColor;
            
            [cell cx_setTitleTextAttributes:self.cellLabelNormalTextAttributes forState:UIControlStateNormal];
            [cell cx_setTitleTextAttributes:self.cellLabelSelectedTextAttributes forState:UIControlStateSelected];

            //Find today cell
            NSDateComponents *components = [self.calendar components: NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit
                                                            fromDate: [NSDate date]];
            if (self.displayedYear == components.year &&
                self.displayedMonth == components.month &&
                i == components.day) {
                cell.normalBackgroundColor = [UIColor lightGrayColor];
            }
            
            
            [cells addObject:cell];
            [self.gridView addSubview: cell];
        }
        _dayCells = [[NSArray alloc] initWithArray:cells];
    }
    return _dayCells;
}


- (void) loadMoonDayWithYear:(NSString*)year{
    NSString* filename = [NSString stringWithFormat:@"calendar%@", year];
    NSString *xmlPath = [[NSBundle mainBundle] pathForResource:filename ofType:@"xml"];
    NSData *xmlData = [NSData dataWithContentsOfFile:xmlPath];
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:xmlData];
    
    if (xmlParser == nil) {
        NSLog(@"ERROR");
        return;
    }
    
    if (list != nil) {
        [list removeAllObjects];
        list = nil;
    }
    
    list = [[NSMutableArray alloc] init];
    
    [xmlParser setDelegate:self];
    [xmlParser parse];
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    currentElement = [elementName copy];
    if([elementName isEqualToString:@"date"])
    {
        [list addObject:[attributeDict copy]];
    }
}


-(void) parser:(NSXMLParser *)parser foundCharacters:(NSString *) string
{
//    if([currentElement isEqualToString:@"date"])
//    {
//        currentTitle = string;
//    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
//    if([elementName isEqualToString:@"date"])
//    {
//        [item setObject:currentTitle forKey:@"date"];
//        [list addObject:[item copy]];
//    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"List:%d",list.count);
}


- (Boolean) CheckPrayDay:(int)d Month:(int)m Year:(int)y WithCell:(CXCalendarCellView*)cell{
    
    Boolean isPrayDay = NO;
    
    //Check year
    // Hard code but affective
    if (y >= 2500) {
        y -= 543;
        
        //2556 - 2013
    }
    
    //Check PrayDay
    //Moonday = 8,15,23, 29 และไม่ใช่วันสุดท้ายของเดือน และ วันถัดไปต้องเป็น 1, 30
    for (NSDictionary* dic in list) {
        //    <date
        //    day="1"
        //    day_of_week="3"
        //    month="1"
        //    moon_day="19"
        //    moon_month="1"
        //    year="2013"
        //    />
        int day = ((NSString*)[dic objectForKey:@"day"]).intValue;
        int month = ((NSString*)[dic objectForKey:@"month"]).intValue;
        int moon_day = ((NSString*)[dic objectForKey:@"moon_day"]).intValue;
        int moon_month = ((NSString*)[dic objectForKey:@"moon_month"]).intValue;
        int year =  ((NSString*)[dic objectForKey:@"year"]).intValue;
        
        if (month == m && day == d && year == y) {
            
            [cell setMoonDay:moon_day];
            [cell setMoonMonth:moon_month];
            [cell setMonth:month];
            [cell setYear:year];
            
            if (moon_day == 8 || moon_day == 15 || moon_day == 23 || moon_day == 30) {
                isPrayDay = YES;
                [cell setIsPrayDay:YES];
                return isPrayDay;
            }
            else if(moon_day == 29){
                
                //Finding Next MoonDay Value
                int nextday = day+1;
                
                //also find next year
                if (month == 12) {
                    year = year+1;
                    month = 1;
                    if (nextday > 31) {
                        nextday = 1;
                    }
                }
                
                for (NSDictionary* nextDay in list) {
                        int day2 = ((NSString*)[nextDay objectForKey:@"day"]).intValue;
                        int month2 = ((NSString*)[nextDay objectForKey:@"month"]).intValue;
                        int year2 =  ((NSString*)[nextDay objectForKey:@"year"]).intValue;
                        int moon_day2 = ((NSString*)[nextDay objectForKey:@"moon_day"]).intValue;
                    
                        if (month2 == month && day2 == nextday && year2 == year ) {
                            if (moon_day2 == 1) {
                                isPrayDay = YES;
                                [cell setIsPrayDay:YES];
                                return isPrayDay;
                            }
                        }
                }
            }
            
        }
    }
    
    [cell setIsPrayDay:NO];
    return isPrayDay;
}

- (NSArray *)AllCell{
    return _dayCells;
}
@end
