//
//  AddViewController.m
//  CloudKitDemo
//
//  Created by SHIJIAN on 14-10-16.
//  Copyright (c) 2014年 SHIJIAN. All rights reserved.
//

#import "AddViewController.h"

@interface AddViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *latitudeTF;
@property (weak, nonatomic) IBOutlet UITextField *longtitudeTF;
@property (weak, nonatomic) IBOutlet UISwitch *kidsMenuSwitch;

@property (strong, nonatomic) UIAlertView * alertView;
@end


#define EstablishmentType @"Establishment"
@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Add";
    
    self.alertView = [[UIAlertView alloc] initWithTitle:@"Info" message:@"" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:nil, nil];
}

- (IBAction)clickAddButton:(id)sender {
    CKRecord * record = [[CKRecord alloc] initWithRecordType:EstablishmentType];
    [record setObject:self.nameTF.text forKey:@"Name"];
    CLLocation * testLocation = [[CLLocation alloc] initWithLatitude:[self.latitudeTF.text floatValue] longitude:[self.longtitudeTF.text floatValue]];
    [record setObject:testLocation forKey:@"Location"];
    if (self.kidsMenuSwitch.on) {
        [record setObject:[NSNumber numberWithInt:1] forKey:@"KidsMenu"];
    }
    else{
        [record setObject:[NSNumber numberWithInt:0] forKey:@"KidsMenu"];
    }
    [self.publicDB saveRecord:record completionHandler:^(CKRecord * record, NSError * error){
        if (error) {
            self.alertView.message = [NSString stringWithFormat:@"%@", error];
            [self.alertView show];
        }
        else{
            self.alertView.message = @"success";
            [self.alertView show];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
