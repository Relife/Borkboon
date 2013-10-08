//
//  Sign-upViewController.m
//  Borkboon
//
//  Created by Relife on 9/5/56 BE.
//  Copyright (c) 2556 Relife. All rights reserved.
//

#import "Sign-upViewController.h"
#import "SBJson.h"
#import "Base64.h"

@interface Sign_upViewController ()

@end

@implementation Sign_upViewController
bool newMedia;

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
    _txtBirthday.delegate = self;
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker setDate:[NSDate date]];
    [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    [self.txtBirthday setInputView:datePicker];
}

-(void)updateTextField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)self.txtBirthday.inputView;
    NSDate *date = picker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"MM'/'dd'/'yyyy"];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
//    self.txtBirthday.text = [NSString stringWithFormat:@"%@",picker.date];
    self.txtBirthday.text = formattedDate;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void) alertStatus:(NSString *)msg :(NSString *)title
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    
    [alertView show];
}

- (IBAction)btAction:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: nil
                                                             delegate: self
                                                    cancelButtonTitle: @"Cancel"
                                               destructiveButtonTitle: nil
                                                    otherButtonTitles: @"Remove current picture",@"Take a new photo", @"Choose from existing", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self removeImage];
            break;
        case 1:
            [self takeNewPhotoFromCamera];
            break;
        case 2:
            [self choosePhotoFromExistingImages];
            break;
        default:
            break;
    }
}

- (void)takeNewPhotoFromCamera
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker
                           animated:YES
                         completion:nil];
        newMedia = YES;
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Camera not found" message:@"Camera is not avliable" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)removeImage
{
    _imageView.image = Nil;
}

-(void)choosePhotoFromExistingImages
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
        newMedia = NO;
    }
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info
                      objectForKey:UIImagePickerControllerOriginalImage];
    _imageView.image = image;
    NSData* data = UIImageJPEGRepresentation(image, 1.0f);
    [Base64 initialize];
    _byteArray = [Base64 encode:data];
    
    if (newMedia) {
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    }
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)Join:(id)sender {
    @try {
        
        if([[_txtName text] isEqualToString:@""] ||
           [[_txtLastname text] isEqualToString:@""] ||
           [[_txtemail text] isEqualToString:@""] ||
           [[_txtPassword text] isEqualToString:@""] ||
           [[_txtBirthday text] isEqualToString:@""] ||
           [_imageView isEqual:Nil]) {
            [self alertStatus:@"Please Fill out all fields" :@"Login Failed!"];
        } else {
            NSString *post =[[NSString alloc] initWithFormat:@"email=%@&password=%@&firstname=%@&lastname=%@&bod=%@&img=%@",[_txtemail text],[_txtPassword text],[_txtName text],[_txtLastname text],[_txtBirthday text],_byteArray];
            NSLog(@"PostData: %@",post);
            
            NSURL *url=[NSURL URLWithString:@"http://codegears.co.th/borkboon/signup.php"];
            
            NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            
            NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:url];
            [request setHTTPMethod:@"POST"];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:postData];
            
            //            [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
            
            NSError *error = [[NSError alloc] init];
            NSHTTPURLResponse *response = nil;
            NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            
            NSLog(@"Response code: %d", [response statusCode]);
            if ([response statusCode] >=200 && [response statusCode] <300)
            {
                NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
                NSLog(@"Response ==> %@", responseData);
                
                SBJsonParser *jsonParser = [SBJsonParser new];
                NSDictionary *jsonData = (NSDictionary *) [jsonParser objectWithString:responseData error:nil];
                NSLog(@"%@",jsonData);
                NSString *status = [jsonData objectForKey:@"status"];
                NSLog(@"%@",status);
                NSString *description = [jsonData objectForKey:@"description"];
                NSLog(@"%@",description);
                
                
                if([status isEqual:@"complete"])
                {
                    NSString *ss_msg = (NSString *) [jsonData objectForKey:@"description"];
                    [self alertStatus:ss_msg :@"Login Success!"];
                    
                } else {
                    
                    NSString *error_msg = (NSString *) [jsonData objectForKey:@"description"];
                    [self alertStatus:error_msg :@"Login Failed!"];
                }
                
            } else {
                if (error) NSLog(@"Error: %@", error);
                [self alertStatus:@"Connection Failed" :@"Login Failed!"];
            }
        }
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
        [self alertStatus:@"Login Failed." :@"Login Failed!"];
    }
}

- (IBAction)bgClick:(id)sender {
    [_txtName resignFirstResponder];
    [_txtLastname resignFirstResponder];
    [_txtemail resignFirstResponder];
    [_txtPassword resignFirstResponder];
    [_txtBirthday resignFirstResponder];
}

@end
