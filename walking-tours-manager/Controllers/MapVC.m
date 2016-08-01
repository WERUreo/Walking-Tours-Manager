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
@import GoogleMaps;

@interface MapVC ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSMutableArray *locations;
@property (nonatomic, strong) GMSMapView *mapView;
@property (nonatomic, strong) NSMutableArray<GMSMarker *> *markers;
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

- (GMSMapView *)mapView
{
    if (!_mapView)
    {
        _mapView = [[GMSMapView alloc] initWithFrame:self.view.frame];
    }

    return _mapView;
}

////////////////////////////////////////////////////////////

- (NSMutableArray<GMSMarker *> *)markers
{
    if (!_markers)
    {
        _markers = [NSMutableArray array];
    }

    return _markers;
}

////////////////////////////////////////////////////////////
#pragma mark - View Controller Life Cycle
////////////////////////////////////////////////////////////

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self updateMapView];
    self.view = self.mapView;
}

////////////////////////////////////////////////////////////
#pragma mark - IBActions
////////////////////////////////////////////////////////////

- (IBAction)citySelected:(id)sender
{
    if (_segmentedControl.selectedSegmentIndex == 0)
    {
        self.city = @"orlando";
    }
    else if (_segmentedControl.selectedSegmentIndex == 1)
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
    _startingLocation = [self getStartingLocation];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithTarget:_startingLocation
                                                               zoom:15];
    self.mapView.camera = camera;
    [self loadLocations];
}

////////////////////////////////////////////////////////////

- (void)loadLocations
{
    [self.mapView clear];
    [self.markers removeAllObjects];

    [[DataService sharedInstance] getLocationsFromCity:self.city withCompletion:^(NSArray *locations)
    {
        self.locations = [locations mutableCopy];

        for (HistoricLocation *location in self.locations)
        {
            GMSMarker *marker = [GMSMarker markerWithPosition:location.locationCoordinates];
            marker.title = location.locationName;
            marker.snippet = location.locationAddress;
            marker.map = self.mapView;
            [self.markers addObject:marker];
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

    if ([segue.identifier isEqualToString:@"AddLocationSegue"])
    {
        vc.startingCoordinates = [self getStartingLocation];
    }
}

@end
