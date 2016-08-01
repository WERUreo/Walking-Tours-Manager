//
//  EditLocationVC.m
//  walking-tours-manager
//
//  Created by Keli'i Martin on 7/31/16.
//  Copyright © 2016 WERUreo. All rights reserved.
//

#import "EditLocationVC.h"
@import GoogleMaps;
@import GooglePlaces;

@interface EditLocationVC () <GMSAutocompleteViewControllerDelegate>

////////////////////////////////////////////////////////////
#pragma mark - IBOutlets
////////////////////////////////////////////////////////////

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegmentedControl;
@property (weak, nonatomic) IBOutlet UITextField *latitudeTextField;
@property (weak, nonatomic) IBOutlet UITextField *longitudeTextField;
@property (weak, nonatomic) IBOutlet UIView *mapViewContainer;

////////////////////////////////////////////////////////////
#pragma mark - Properties
////////////////////////////////////////////////////////////

@property (strong, nonatomic) GMSMapView *mapView;
@property (strong, nonatomic) GMSCameraPosition *camera;

@end

@implementation EditLocationVC

////////////////////////////////////////////////////////////
#pragma mark - Getters/Setters
////////////////////////////////////////////////////////////

- (HistoricLocation *)location
{
    if (!_location)
    {
        _location = [[HistoricLocation alloc] init];
    }

    return _location;
}

////////////////////////////////////////////////////////////

- (GMSMapView *)mapView
{
    if (!_mapView)
    {
        _mapView = [[GMSMapView alloc] initWithFrame:self.mapViewContainer.bounds];
    }

    return _mapView;
}

////////////////////////////////////////////////////////////
#pragma mark - View Controller Life Cycle
////////////////////////////////////////////////////////////

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.camera = [GMSCameraPosition cameraWithTarget:self.startingCoordinates zoom:15];
}

////////////////////////////////////////////////////////////

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self.mapViewContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.mapView.camera = self.camera;
    [self.mapViewContainer addSubview:self.mapView];
}

////////////////////////////////////////////////////////////
#pragma mark - IBActions
////////////////////////////////////////////////////////////

- (IBAction)saveLocationTapped:(id)sender
{
    
}

////////////////////////////////////////////////////////////

- (IBAction)cancelButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

////////////////////////////////////////////////////////////

- (IBAction)searchButtonTapped:(id)sender
{
    GMSAutocompleteViewController *acViewController = [[GMSAutocompleteViewController alloc] init];
    acViewController.delegate = self;
    [self presentViewController:acViewController animated:YES completion:nil];
}

////////////////////////////////////////////////////////////
#pragma mark - GMSAutocompleteViewControllerDelegate
////////////////////////////////////////////////////////////

- (void)viewController:(GMSAutocompleteViewController *)viewController didAutocompleteWithPlace:(GMSPlace *)place
{
    self.nameTextField.text = place.name;
    self.addressTextField.text = place.formattedAddress;
    self.latitudeTextField.text = [NSString stringWithFormat:@"%f", place.coordinate.latitude];
    self.longitudeTextField.text = [NSString stringWithFormat:@"%f", place.coordinate.longitude];

    GMSMarker *marker = [GMSMarker markerWithPosition:place.coordinate];
    marker.map = self.mapView;
    self.camera = [GMSCameraPosition cameraWithTarget:place.coordinate zoom:15];

    [self dismissViewControllerAnimated:YES completion:nil];
}

////////////////////////////////////////////////////////////

- (void)viewController:(GMSAutocompleteViewController *)viewController didFailAutocompleteWithError:(NSError *)error
{
    NSLog(@"Error: %@", error.localizedDescription);
    [self dismissViewControllerAnimated:YES completion:nil];
}

////////////////////////////////////////////////////////////

- (void)wasCancelled:(GMSAutocompleteViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
