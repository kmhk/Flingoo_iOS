//
//  AHDescriptionViewController.m
//  AHIMS
//
//  Created by Prasad De Zoysa on 8/24/12.
//  Copyright (c) 2012 JBMDigital. All rights reserved.
//

#import "AHDescriptionViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface AHDescriptionViewController ()

@end

@implementation AHDescriptionViewController
//@synthesize imgButton;
//@synthesize siteContentView;

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
    
    NSLog(@"did");
    txtImageComment = [[UITextView alloc] initWithFrame:CGRectMake(6,50, 309, 188)];
    txtImageComment.text = _txtField.text;
    txtImageComment.contentInset = UIEdgeInsetsMake(6,8,0,0);
    txtImageComment.delegate = self;
    txtImageComment.layer.cornerRadius = 12;
    [self.view addSubview:txtImageComment];
    
    if([txtImageComment.text length] > 0){
        btnDone.enabled = YES;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"Will");
    txtImageComment.text = _txtField.text;
    txtImageComment.transform = CGAffineTransformMakeScale(0.1,0.1);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    txtImageComment.transform = CGAffineTransformMakeScale(1,1);
    txtImageComment.alpha = 1.0;
    [UIView commitAnimations];
    [txtImageComment becomeFirstResponder];
}

- (void)viewDidUnload
{
    btnDone = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

- (IBAction)dismiss:(id)sender {
//    NSLog(@"imgButton %@", imgButton);
    
//        imgButton.description = txtImageComment.text;
    [_txtField setText:txtImageComment.text];
        txtImageComment.text = @"";
        [self dismissViewControllerAnimated:YES completion:^{
            
            
            
        }];
    
    
}

-(void)textViewDidChange:(UITextView *)textView{
    if([txtImageComment.text length] > 0){
        btnDone.enabled = YES;
    }else {
        btnDone.enabled = NO;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    
    if([text isEqualToString:@"\b"]){
        return YES;
    }else if([[textView text] length] - range.length + text.length > 100){
        
        return NO;
    }
    
    return YES;
}


@end
