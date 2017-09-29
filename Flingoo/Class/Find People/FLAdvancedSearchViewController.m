//
//  FLAdvancedSearchViewController.m
//  Flingoo
//
//  Created by Thilina Hewagama on 11/19/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLAdvancedSearchViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "NMRangeSlider.h"
#import "FLAppDelegate.h"
#import "FLAdvancedSearchResultsViewController.h"

#define SELECTED_ROUND_BTN_IMAGE   [UIImage imageNamed:@"FP_rounded_square_selected.PNG"]
#define UNSELECTED_ROUND__BTN_IMAGE   [UIImage imageNamed:@"FP_rounded_square_unselected.PNG"]

@interface FLAdvancedSearchViewController ()<UISearchBarDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property(nonatomic, strong) NSArray *allLanguagesArray;

@property(nonatomic, assign) BOOL pickerVisible;
@property(nonatomic, strong) UIPickerView *pickerView;
@property(nonatomic, strong) UIActionSheet *actionSheet;

@property(weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic, strong) IBOutlet UIView *advancedSearchView;
@property(weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property(nonatomic, strong) IBOutlet NMRangeSlider *rangeSlider;
@property(weak, nonatomic) IBOutlet UILabel *upperLabel;
@property(weak, nonatomic) IBOutlet UILabel *lowerLabel;

@property(weak, nonatomic) IBOutlet UIButton *lookForMen;
@property(weak, nonatomic) IBOutlet UIButton *lookForWomen;
@property(weak, nonatomic) IBOutlet UIButton *lookForBoth;

@property(weak, nonatomic) IBOutlet UIButton *whoAreLookingForMen;
@property(weak, nonatomic) IBOutlet UIButton *whoAreLookingForWomen;
@property(weak, nonatomic) IBOutlet UIButton *whoAreLookingForBoth;

@property(weak, nonatomic) IBOutlet UIButton *lookingForChat;
@property(weak, nonatomic) IBOutlet UIButton *lookingForFlirtAndDate;
@property(weak, nonatomic) IBOutlet UIButton *lookingForMeetNewPeople;

@property(weak, nonatomic) IBOutlet UIButton *activityOnlyNewMembers;
@property(weak, nonatomic) IBOutlet UIButton *activityOnline;
@property(weak, nonatomic) IBOutlet UIButton *activityOnlyMembersWithPhoto;
@property(weak, nonatomic) IBOutlet UIButton *activityOnlyVerifiedMembers;

@property(weak, nonatomic) IBOutlet UIButton *findPeopleNowBtn;

//sliders
@property(weak, nonatomic) IBOutlet UISlider *searchRadiusSlider;



//data
@property(nonatomic, copy) NSString *lookFor;
@property(nonatomic, copy) NSString *whoArelookingFor;

@property(nonatomic, assign) BOOL isLookingForChat;
@property(nonatomic, assign) BOOL isLookingForFlirtAndDate;
@property(nonatomic, assign) BOOL isLookingForNewPeople;

@property(nonatomic, assign) CGFloat minAge;
@property(nonatomic, assign) CGFloat maxAge;

@property(nonatomic, assign) BOOL isActivityQualityOnlyNewMembers;
@property(nonatomic, assign) BOOL isActivityQualityOnline;
@property(nonatomic, assign) BOOL isActivityQualityOnlyMembersWithPhoto;
@property(nonatomic, assign) BOOL isActivityQualityVerifiedMembers;

@property(nonatomic, assign) float searchRadius;

@property(nonatomic, copy) NSString *selectedLanguage;

@end

@implementation FLAdvancedSearchViewController










#pragma mark - Initialize

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withType:(SearchType) type;{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        _searchType = type;
        // Custom initialization
        self.tabBarItem.title = @"Advanced Search";
        self.tabBarItem.image = [UIImage imageNamed:@"FP_tab_icon_magnify.PNG"];
    }
    
    return self;
}










#pragma mark - View Life Cycle

- (void) viewDidLoad{
    [super viewDidLoad];
   
    //hit test
    self.myView.sld = self.rangeSlider;
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Advanced Search";
    self.scrollView.contentSize = self.advancedSearchView.bounds.size;
    [self.scrollView addSubview:self.advancedSearchView];
    [self setUpGraphics];
    [self configureLabelSlider];
    [self setUpAllLanguagesArray];
    
    //initially selected
    [self initiallySelected];
    
    if(self.searchType==kMatchFilter){
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(donePressed)];
        self.navigationItem.rightBarButtonItem = barButton;
        self.findPeopleNowBtn.hidden = YES;
        self.navigationItem.title = @"Filter";
    }
    
    if(IS_IPAD){
        [CATransaction setDisableActions:YES];
        self.parentScrollView.layer.opacity = 0;
    }
    
}

- (void) donePressed{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void) viewDidAppear:(BOOL)animated{
    if(IS_IPAD){
        [self.parentScrollView.layer addAnimation:[FLUtil appearAnimation] forKey:@"opacity"];
    }
    
    FLAppDelegate *appDelegate = (FLAppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appDelegate.sliderController){
        appDelegate.sliderController.allowInteractiveSliding = NO;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    FLAppDelegate *appDelegate = (FLAppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appDelegate.sliderController){
        appDelegate.sliderController.allowInteractiveSliding = YES;
    }
}













#pragma mark - initial load

-(void) initiallySelected{
    
    self.lookFor = @"Men";
    self.whoArelookingFor = @"Women";
    
    self.isLookingForChat = YES;
    self.isLookingForFlirtAndDate = NO;
    self.isLookingForNewPeople = NO;
    
    self.isActivityQualityOnlyNewMembers = YES;
    self.isActivityQualityOnline = YES;
    self.isActivityQualityOnlyMembersWithPhoto = NO;
    self.isActivityQualityVerifiedMembers = NO;
    
    self.minAge = 17.0;
    self.maxAge = 60.0;
    
    self.searchRadius = 0;
    
    self.selectedLanguage = @"All Languages";
    
}





-(void) setUpAllLanguagesArray{
    self.allLanguagesArray = @[
                               @"Language 1",
                               @"Language 2",
                               @"Language 3",
                               @"Language 4",
                               @"Language 5",
                               @"Language 6",
                               @"Language 7",
                               @"Language 8",
                               @"Language 9",
                               @"Language 10",
                               @"Language 11",
                               @"Language 12",
                               ];
}










#pragma mark -
#pragma mark - Graphics

-(void) setUpGraphics{
    
    [self.searchRadiusSlider setMinimumTrackImage: [[UIImage imageNamed: @"FP_slider_bar.PNG"] stretchableImageWithLeftCapWidth: 9 topCapHeight: 0] forState: UIControlStateNormal];
    [self.searchRadiusSlider setThumbImage:[UIImage imageNamed:@"FP_slider_thumb.PNG"] forState:UIControlStateNormal];
    [self.searchRadiusSlider setThumbImage:[UIImage imageNamed:@"FP_slider_thumb.PNG"] forState:UIControlStateHighlighted];
  
}




#pragma mark - SearchBar Delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar; {
    NSLog(@"Search button pressed");
    [searchBar resignFirstResponder];
}



#pragma mark
#pragma mark - Button Press Events

-(IBAction) checkBoxTap:(UIButton *)sender{
    int tag = sender.tag;
    
    //lookFor
    if(tag==100 || tag==101 || tag == 102){
        
        if(tag!=100) [self setImageSelected:NO forViewTag:100];
        if(tag!=101) [self setImageSelected:NO forViewTag:101];
        if(tag!=102) [self setImageSelected:NO forViewTag:102];
        
        UIButton *btn = (UIButton *)[self.advancedSearchView viewWithTag:tag];
        if(btn.imageView.image==SELECTED_ROUND_BTN_IMAGE){
            [self setImageSelected:NO forViewTag:tag];
        }else{
            [self setImageSelected:YES forViewTag:tag];
        }
        
    }else
        
        //lookFor
        if(tag==103 || tag==104 || tag == 105){
            
            if(tag!=103)[self setImageSelected:NO forViewTag:103];
            if(tag!=104)[self setImageSelected:NO forViewTag:104];
            if(tag!=105)[self setImageSelected:NO forViewTag:105];
            
            UIButton *btn = (UIButton *)[self.advancedSearchView viewWithTag:tag];
            
            if(btn.imageView.image==SELECTED_ROUND_BTN_IMAGE){
                [self setImageSelected:NO forViewTag:tag];
            }else{
                [self setImageSelected:YES forViewTag:tag];
            }
            
        }else
            
            //lookFor
            if(tag==106 || tag==107 || tag == 108){
                
                if(tag!=106)[self setImageSelected:NO forViewTag:106];
                if(tag!=107)[self setImageSelected:NO forViewTag:107];
                if(tag!=108)[self setImageSelected:NO forViewTag:108];
                
                UIButton *btn = (UIButton *)[self.advancedSearchView viewWithTag:tag];
                
                if(btn.imageView.image==SELECTED_ROUND_BTN_IMAGE){
                    [self setImageSelected:NO forViewTag:tag];
                }else{
                    [self setImageSelected:YES forViewTag:tag];
                }
            }
            else
                //lookFor
                if(tag==109 || tag==110 || tag == 111 || tag == 112){
                    
                    UIButton *btn = (UIButton *)[self.advancedSearchView viewWithTag:tag];
                    
                    if(btn.imageView.image==SELECTED_ROUND_BTN_IMAGE){
                        [self setImageSelected:NO forViewTag:tag];
                    }else{
                        [self setImageSelected:YES forViewTag:tag];
                    }
                    
                }
    
}

-(void) setImageSelected:(BOOL) selected forViewTag:(int) tag{
    if(selected){
        [(UIButton *)[self.advancedSearchView viewWithTag:tag] setImage:SELECTED_ROUND_BTN_IMAGE forState:UIControlStateNormal];
        [(UIButton *)[self.advancedSearchView viewWithTag:tag] setImage:SELECTED_ROUND_BTN_IMAGE forState:UIControlStateHighlighted];
    }else{
        [(UIButton *)[self.advancedSearchView viewWithTag:tag] setImage:UNSELECTED_ROUND__BTN_IMAGE forState:UIControlStateNormal];
        [(UIButton *)[self.advancedSearchView viewWithTag:tag] setImage:UNSELECTED_ROUND__BTN_IMAGE forState:UIControlStateHighlighted];
    }
}


-(IBAction) allLanguagesButtonPressed:(id)sender;{
    
    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Done"]];
    
    CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
    self.pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
    
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                              delegate:nil
                                     cancelButtonTitle:nil
                                destructiveButtonTitle:nil
                                     otherButtonTitles:nil];
    
    [self.actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    
    self.pickerView.showsSelectionIndicator = YES;
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    
    
    [self.actionSheet addSubview:self.pickerView];
    
    
    closeButton.momentary = YES;
    closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
    closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
    closeButton.tintColor = [UIColor blueColor];
    [closeButton addTarget:self action:@selector(dismissActionSheet:) forControlEvents:UIControlEventValueChanged];
    [self.actionSheet addSubview:closeButton];
    [self.actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
    [self.actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
}

-(void)dismissActionSheet:(id)sender{
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES]; 
}


-(IBAction) findPeopleNowButtonPressed:(id)sender;{
    [self performSerach];
}







#pragma mark - Search

/*
 
 100 - look for men
 101 - look for women
 102 - both
 
 103 - who are looking Men
 104 - who are looking for women
 105 -  who are looking for both
 
 106 - looking for chat
 107 - looking for flirt & date
 108 - meet new people
 
 109 - only new members
 110 - online
 111 - only members with photo
 112 - only verified members
 
 search radius
 -> searchRadiusSlider
 
 ranger slider
 -> rangeSlider
 
 */

-(void) performSerach{
    
    //filters
    NSString *lookFor = @"";
    NSString *whoAreLookingFor = @"";
    NSString *lookingFor = @"";
    NSString *activityAndQuality = @"";
    
    //lookFor
    if(((UIButton *)[self.advancedSearchView viewWithTag:100]).imageView.image==SELECTED_ROUND_BTN_IMAGE){
        lookFor = @"men";
    }else if(((UIButton *)[self.advancedSearchView viewWithTag:101]).imageView.image==SELECTED_ROUND_BTN_IMAGE){
        lookFor = @"women";
    }else if(((UIButton *)[self.advancedSearchView viewWithTag:102]).imageView.image==SELECTED_ROUND_BTN_IMAGE){
        lookFor = @"both";
    }
    
    //who are looking for
    
    if(((UIButton *)[self.advancedSearchView viewWithTag:103]).imageView.image==SELECTED_ROUND_BTN_IMAGE){
        whoAreLookingFor = @"men";
    }else if(((UIButton *)[self.advancedSearchView viewWithTag:104]).imageView.image==SELECTED_ROUND_BTN_IMAGE){
        whoAreLookingFor = @"women";
    }else if(((UIButton *)[self.advancedSearchView viewWithTag:105]).imageView.image==SELECTED_ROUND_BTN_IMAGE){
        whoAreLookingFor = @"both";
    }
    
    //looking for chat
    
    if(((UIButton *)[self.advancedSearchView viewWithTag:106]).imageView.image==SELECTED_ROUND_BTN_IMAGE){
        lookingFor = @"chat";
    }else if(((UIButton *)[self.advancedSearchView viewWithTag:107]).imageView.image==SELECTED_ROUND_BTN_IMAGE){
        lookingFor = @"flirt and date";
    }else if(((UIButton *)[self.advancedSearchView viewWithTag:108]).imageView.image==SELECTED_ROUND_BTN_IMAGE){
        lookingFor = @"neet new people";
    }
    
    //Activity and Quality
    
    if(((UIButton *)[self.advancedSearchView viewWithTag:109]).imageView.image==SELECTED_ROUND_BTN_IMAGE){
        activityAndQuality = @"only new members";
    }else if(((UIButton *)[self.advancedSearchView viewWithTag:110]).imageView.image==SELECTED_ROUND_BTN_IMAGE){
        activityAndQuality = @"online";
    }else if(((UIButton *)[self.advancedSearchView viewWithTag:111]).imageView.image==SELECTED_ROUND_BTN_IMAGE){
        activityAndQuality = @"only members with photo";
    }else if(((UIButton *)[self.advancedSearchView viewWithTag:112]).imageView.image==SELECTED_ROUND_BTN_IMAGE){
        activityAndQuality = @"only verified members";
    }
    
    
    //    if([findPeopleArr count]==0)
    //    {
    HUD=[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
	HUD.dimBackground = YES;
	// Set the hud to display with a color
    //	HUD.color = [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];
	HUD.delegate = self;
    HUD.labelText = @"Connecting";
	HUD.square = YES;
    [HUD show:YES];
    
    //hemalasankas**
    FLWebServiceApi *webService=[[FLWebServiceApi alloc] init];
    FLProfileSearch *profleSearchObj=[[FLProfileSearch alloc] init];
    profleSearchObj.radius= @20;//[NSNumber numberWithFloat:self.searchRadiusSlider.value];
    //    profleSearchObj.age_gteq=[NSNumber numberWithInt:[FLUtilUserDefault getLookingAgeMin]];
    //    profleSearchObj.age_lteq=[NSNumber numberWithInt:[FLUtilUserDefault getLookingAgeMax]];
    //    profleSearchObj.gender_eq=[FLUtilUserDefault getLookingFor];
    profleSearchObj.age_gteq=@0;//[NSNumber numberWithInt:self.rangeSlider.lowerValue];
    profleSearchObj.age_lteq=@80;//[NSNumber numberWithInt:self.rangeSlider.upperValue];
    
    NSLog(@"Range Slider Lower: %f", self.rangeSlider.lowerValue);
    NSLog(@"Range Slider Upper: %f", self.rangeSlider.upperValue);
    
    //    profleSearchObj.gender_eq=[FLGlobalSettings sharedInstance].current_user_profile.looking_for;
    //    profleSearchObj.orientation_eq=[FLGlobalSettings sharedInstance].current_user_profile.orientation;
    
    profleSearchObj.gender_eq= @"";//lookFor;
    profleSearchObj.orientation_eq=@"";
    
    [webService profileSearch:self withUserData:profleSearchObj];
    //}
}











#pragma mark -
#pragma mark - Webservice api delegate method

-(void)profileSearchResult:(NSMutableArray *)profileObjArr
{
#pragma message "🎾 Handle Empty Records Alert"
    
    if(profileObjArr.count>0){
        FLAdvancedSearchResultsViewController *viewController = [[FLAdvancedSearchResultsViewController alloc] initWithSearchResultsArray:profileObjArr];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    /*
     
     diplay profileObjArr in a different view a& push
     
     */
    
    [HUD hide:YES];
}

-(void)userShowResult:(FLOtherProfile *)profileObj
{
    [HUD hide:YES];
    //    [self cellSelect:profileObj];
}











#pragma mark- FLWebServiceDelegate Fail
#pragma mark-

-(void)unknownFailureCall
{
    [HUD hide:YES];
    [self showValidationAlert:@"Unknown Error"];
}

-(void)requestFailCall:(NSString *)errorMsg
{
    [HUD hide:YES];
    [self showValidationAlert:errorMsg];
}

-(void)showValidationAlert:(NSString *)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"alert", nil) message:title delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil, nil];
    [alert show];
}









#pragma mark - Picker View Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [self.allLanguagesArray count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.allLanguagesArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component  {
    NSLog(@"Selected language:%@ : %i", [self.allLanguagesArray objectAtIndex:row], row);
}









#pragma mark -
#pragma mark slider

- (IBAction)labelSliderChanged:(id)sender;{
    [self updateSliderLabels];
}

- (void) configureLabelSlider{
    self.rangeSlider.minimumValue = 0;
    self.rangeSlider.maximumValue = 43;
    
    self.rangeSlider.lowerValue = 0;
    self.rangeSlider.upperValue = 43;
    
    self.rangeSlider.minimumRange = 1;
}

- (void) updateSliderLabels{
    // You get get the center point of the slider handles and use this to arrange other subviews
    
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //
    //        CGPoint lowerCenter;
    //        lowerCenter.x = (self.rangeSlider.lowerCenter.x + self.rangeSlider.frame.origin.x);
    //        lowerCenter.y = (self.rangeSlider.center.y - 30.0f);
    //
    //        CGPoint upperCenter;
    //        upperCenter.x = (self.rangeSlider.upperCenter.x + self.rangeSlider.frame.origin.x);
    //        upperCenter.y = (self.rangeSlider.center.y - 30.0f);
    //
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //
    //            self.lowerLabel.text = [NSString stringWithFormat:@"%d", (int)self.rangeSlider.lowerValue+17];
    //            self.upperLabel.text = [NSString stringWithFormat:@"%d", (int)self.rangeSlider.upperValue+17];
    //
    //            [UIView animateWithDuration:0.2
    //                                  delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
    //                             animations:^{
    //
    //                                self.lowerLabel.center = lowerCenter;
    //                                self.upperLabel.center = upperCenter;
    //
    //                             }
    //
    //                             completion:^(BOOL finished){
    //
    //                                 
    //                                 
    //                             }];
    //            
    //        });
    //    });
    
}





#pragma mark -
#pragma mark parent view methods

-(void) enableDisableSliderView:(BOOL)enable{
    //disble all your touches
}






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
