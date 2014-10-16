//
//  AddViewController.h
//  CloudKitDemo
//
//  Created by SHIJIAN on 14-10-16.
//  Copyright (c) 2014年 SHIJIAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CloudKit/CloudKit.h>
@interface AddViewController : UIViewController
@property (strong, nonatomic) CKDatabase * publicDB;
@end
