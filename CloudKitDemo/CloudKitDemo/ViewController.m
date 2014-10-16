//
//  ViewController.m
//  CloudKitDemo
//
//  Created by SHIJIAN on 14-10-14.
//  Copyright (c) 2014年 SHIJIAN. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <CloudKit/CloudKit.h>
#import "SearchResultViewController.h"
#import "SJAnnotation.h"
#import "AddViewController.h"

#define EstablishmentType @"Establishment"
@interface ViewController () <MKMapViewDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIView *showView;

@property (nonatomic, strong) CLLocationManager * locationManager;
@property (nonatomic, strong) MKMapView * mapView;


@property (nonatomic, strong) NSArray * items;
@property (nonatomic, strong) CKContainer * container;
@property (nonatomic, strong) CKDatabase * publicDB;
@property (nonatomic, strong) CKDatabase * privateDB;

@property (nonatomic, strong) UISlider * slider;

@end

@implementation ViewController
//美国苹果总部坐标
//  latitude = 37.785834
//  longitude = -122.406417

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationBar];
    [self createLocationManager];
    [self createMapView];
    [self createCloudKit];
    [self createUISlider];
}

-(void) createNavigationBar{
    self.title = @"Map";
    
    UIBarButtonItem * item1 = [[UIBarButtonItem alloc] initWithTitle:@"查看详细" style:UIBarButtonItemStyleDone target:self action:@selector(clickRightButton)];
    UIBarButtonItem * item2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(clickAddButton)];
    self.navigationItem.rightBarButtonItems = @[item2, item1];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"附近餐厅" style:UIBarButtonItemStyleDone target:self action:@selector(clickLeftButton)];
}

-(void) createLocationManager{
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestAlwaysAuthorization];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 5.0f;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
}

-(void) createMapView{
    self.mapView = [[MKMapView alloc] initWithFrame:self.showView.bounds];
    self.mapView.delegate = self;
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.zoomEnabled = YES;
    
    CLLocationDegrees   latitude = [@"37.785834" doubleValue];
    CLLocationDegrees   longitude = [@"-122.406417" doubleValue];
    CLLocation * showLocation = [[CLLocation alloc] initWithLatitude:latitude
                                                           longitude:longitude];
    //  //根据经纬度范围显示
    self.mapView.region = MKCoordinateRegionMake(showLocation.coordinate, MKCoordinateSpanMake(0.5f, 0.5f));
    //  //根据距离范围显示
    ////  mapShowView.region = MKCoordinateRegionMakeWithDistance(showLocation.coordinate, 500, 500);
    //
    self.mapView.showsUserLocation = YES;
    
    [self.showView addSubview:self.mapView];
    self.showView.clipsToBounds = YES;
}

-(void) createCloudKit{
    // defaultContainer()代表的是你在iCloud功能栏里制定的那个容器
    self.container = [CKContainer defaultContainer];
    // publicCloudDatabase则是你应用上的所有用户共享的数据
    self.publicDB = self.container.publicCloudDatabase;
    // privateCloudDatabase仅仅是你个人的私密数据
    self.privateDB = self.container.privateCloudDatabase;
}

-(void) createUISlider{
    self.slider = [[UISlider alloc] init];
    _slider.frame = CGRectMake(10, 70, 100, 20);
    _slider.maximumValue = 1.0f;
    _slider.minimumValue = 0.00001;
    _slider.value = 0.5f;
    [_slider addTarget:self action:@selector(sliderChange) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.slider];
}

#pragma mark - private method
-(void) fetchEstablishments:(CLLocation *) location andDistance:(CLLocationDistance) radiusInMeters{
    NSPredicate * locationPredicate = [NSPredicate predicateWithFormat:@"distanceToLocation:fromLocation:(%K,%@) < %f", @"Location", location, radiusInMeters];
    CKQuery * query = [[CKQuery alloc] initWithRecordType:EstablishmentType predicate:locationPredicate];
    [self.publicDB performQuery:query inZoneWithID:nil completionHandler:^(NSArray * results, NSError * error){
        if(error){
            NSLog(@"error is %@", error);
            return;
        }
        if (results) {
            NSLog(@"fetch establishment success");
            self.items = results;
            [self addAnnotations];
        }
    }];
}

-(void) addAnnotations{
    for (CKRecord * record in self.items) {
        NSString * name = [record objectForKey:@"Name"];
        CLLocation * location = [record objectForKey:@"Location"];
        SJAnnotation * anno = [[SJAnnotation alloc] initAnnotationWithTitle:name andSubtitle:@"test" andCoordinate2D:location.coordinate];
        [self.mapView addAnnotation:anno];
    }
}

-(void) pushToSearchResultVC{
    SearchResultViewController * searchResult = [[SearchResultViewController alloc] init];
    searchResult.items = self.items;
    [self.navigationController pushViewController:searchResult animated:YES];
}

#pragma mark - Button Action
-(void) sliderChange{
    NSLog(@"slider change %f %f", _mapView.region.span.latitudeDelta, _mapView.region.span.longitudeDelta);
    CLLocationCoordinate2D coodinate = _mapView.region.center;
    MKCoordinateSpan cspan = {self.slider.value, self.slider.value};
    MKCoordinateRegion region = {coodinate, cspan};
    [_mapView setRegion:region animated:YES];
}

-(void) clickRightButton{
    NSLog(@"detail infomation");
    [self pushToSearchResultVC];
}

-(void) clickLeftButton{
    [self.locationManager startUpdatingLocation];
    [self.mapView removeAnnotations:self.mapView.annotations];
    SJAnnotation * annotation = [[SJAnnotation alloc] initAnnotationWithTitle:@"Apple" andSubtitle:@"Company" andCoordinate2D:CLLocationCoordinate2DMake(37.785834, -122.406417)];
    [self.mapView addAnnotation:annotation];
    CLLocation * location = [[CLLocation alloc] initWithLatitude:37.785834 longitude:-122.406417];
    [self fetchEstablishments:location andDistance:1000000];
}

-(void) clickAddButton {
    AddViewController * addVC = [[AddViewController alloc] init];
    addVC.publicDB = self.publicDB;
    [self.navigationController pushViewController:addVC animated:YES];
}

#pragma mark - MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    NSLog(@"viewForAnnotation");
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    return nil;
}

#pragma mark - CLLocationManagerDelegate
-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    NSLog(@"locations is  %lu %@", locations.count, locations);
}

-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"locationManager did Fial With Error %@", error);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
