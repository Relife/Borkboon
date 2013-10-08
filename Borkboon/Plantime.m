//
//  Plantime.m
//  Borkboon
//
//  Created by Relife on 9/24/56 BE.
//  Copyright (c) 2556 Relife. All rights reserved.
//

#import "Plantime.h"

@interface Plantime ()

@end

@implementation Plantime

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
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    
    [datePicker setDate:[NSDate date]];
    [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    [_editStartDate setInputView:datePicker];
}

-(void)updateTextField:(id)sender
{
    if([_editStartDate isFirstResponder]){
        UIDatePicker *picker = (UIDatePicker*)_editStartDate.inputView;
        _editStartDate.text = [NSDateFormatter localizedStringFromDate:[picker date] dateStyle:kCFDateFormatterShortStyle timeStyle:kCFDateFormatterShortStyle];
    }
}

- (IBAction)bgClick:(id)sender {
    [_editStartDate resignFirstResponder];
}

- (IBAction)DoneBt:(id)sender {
    _Date = _editStartDate.text;
    NSLog(@"%@",_Date);
    
    NSDictionary *itemDetails = [[NSDictionary alloc] initWithObjectsAndKeys:_Date, @"Time", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SentTime" object:itemDetails];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
