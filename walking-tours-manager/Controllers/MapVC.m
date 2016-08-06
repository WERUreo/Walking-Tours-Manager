//
//  MapVC.m
//  walking-tours-manager
//
//  Created by Keli'i Martin on 7/30/16.
//  Copyright © 2016 WERUreo. All rights reserved.
//

#import "MapVC.h"
#import "DataService.h"
#import "EditLocationVC.h"

@interface MapVC ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSMutableArray *locations;
@property (nonatomic) CLLocationCoordinate2D startingLocation;

@end

@implementation MapVC

////////////////////////////////////////////////////////////
#pragma mark - Getters/Setters
////////////////////////////////////////////////////////////

- (NSMutableArray *)locations
{
    if (!_locations)
    {
        _locations = [NSMutableArray array];
    }

    return _locations;
}

////////////////////////////////////////////////////////////

- (NSString *)city
{
    if (!_city)
    {
        _city = [NSString stringWithFormat:@"orlando"];
    }

    return _city;
}

////////////////////////////////////////////////////////////
#pragma mark - View Controller Life Cycle
////////////////////////////////////////////////////////////

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;

    [self updateMapView];
}

////////////////////////////////////////////////////////////
#pragma mark - IBActions
////////////////////////////////////////////////////////////

- (IBAction)citySelected:(id)sender
{
    if (self.segmentedControl.selectedSegmentIndex == 0)
    {
        self.city = @"orlando";
    }
    else if (self.segmentedControl.selectedSegmentIndex == 1)
    {
        self.city = @"ormond-beach";
    }

    [self updateMapView];
}

////////////////////////////////////////////////////////////

- (IBAction)addButtonTapped:(id)sender
{
    [self performSegueWithIdentifier:@"AddLocationSegue" sender:nil];
}

////////////////////////////////////////////////////////////
#pragma mark - Helper Functions
////////////////////////////////////////////////////////////

- (CLLocationCoordinate2D)getStartingLocation
{
    if ([self.city isEqualToString:@"orlando"])
    {
        return CLLocationCoordinate2DMake(28.540334, -81.381505); // Church Street Station, Orlando
    }
    else if ([self.city isEqualToString:@"ormond-beach"])
    {
        return CLLocationCoordinate2DMake(29.285004, -81.055893); // City of Ormond Beach City Hall
    }
    else
    {
        return CLLocationCoordinate2DMake(-33.868, 151.2086); // Sydney, Australia
    }
}

////////////////////////////////////////////////////////////

- (void)updateMapView
{
    [self centerMapOnLocation:[self getStartingLocation]];
    [self loadLocations];
}

////////////////////////////////////////////////////////////

- (void)centerMapOnLocation:(CLLocationCoordinate2D)location
{
    CLLocationDistance regionRadius = 1000;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, regionRadius * 2.0, regionRadius * 2.0);
    [self.mapView setRegion:region];
}

////////////////////////////////////////////////////////////

- (void)loadLocations
{
    // clear previously placed annotations first
    [self.mapView removeAnnotations:_mapView.annotations];
    [self.locations removeAllObjects];

    [[DataService sharedInstance] getLocationsFromCity:self.city withCompletion:^(NSArray *locations)
    {
        self.locations = [locations mutableCopy];

        for (HistoricLocation *location in self.locations)
        {
            [self.mapView addAnnotation:location];
        }
    }];
}

////////////////////////////////////////////////////////////
#pragma mark - Navigation
////////////////////////////////////////////////////////////

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
    EditLocationVC *vc = (EditLocationVC *)navController.topViewController;

    vc.startingCoordinates = [self getStartingLocation];
    vc.city = self.city;
    
    if ([segue.identifier isEqualToString:@"EditLocationSegue"])
    {
        vc.location = (HistoricLocation *)sender;
    }
}

////////////////////////////////////////////////////////////
#pragma mark - MKMapViewDelegate
////////////////////////////////////////////////////////////

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *identifier = @"LocationAnnotation";

    if ([annotation isKindOfClass:[HistoricLocation class]])
    {
        MKAnnotationView *annotationView = (MKAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil)
        {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.canShowCallout = YES;

            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"64x64"]];
            annotationView.leftCalloutAccessoryView = imageView;

            UIButton *calloutButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            annotationView.rightCalloutAccessoryView = calloutButton;

        }
        else
        {
            annotationView.annotation = annotation;
        }

        return annotationView;
    }

    return nil;
}

////////////////////////////////////////////////////////////

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    HistoricLocation *location = (HistoricLocation *)view.annotation;
    [self performSegueWithIdentifier:@"EditLocationSegue" sender:location];
}

@end
