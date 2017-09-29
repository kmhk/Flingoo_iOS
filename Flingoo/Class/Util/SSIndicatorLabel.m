//
//  SSIndicatorLabel.m
//  SSIndicatorLabel
//
//  Created by Sam Soffes on 7/13/10.
//  Copyright 2010-2011 Sam Soffes. All rights reserved.
//

#import "SSIndicatorLabel.h"

@interface SSIndicatorLabel (PrivateMethods)
+ (CGSize)indicatorSize;
+ (CGFloat)padding;
- (void)configureView;
@end

@implementation SSIndicatorLabel

#pragma mark - Accessors

@synthesize textLabel = _textLabel;
@synthesize completedImageView = _completedImageView;

@synthesize loading = _loading;
@synthesize completed = _completed;

- (void)setLoading:(BOOL)l {
	if (_loading == l) {
		return;
	}
	
	[UIView beginAnimations:@"loading" context:nil];
	_loading = l;
	[self layoutSubviews];
	[UIView commitAnimations];
}

- (void)setCompleted:(BOOL)l {
	if (_completed == l) {
		return;
	}
	
	[UIView beginAnimations:@"completed" context:nil];
	_completed = l;
	[self layoutSubviews];
	[UIView commitAnimations];
}


#pragma mark - Class Methods

+ (CGSize)indicatorSize {
	return CGSizeMake(20.0f, 20.0f);
}


+ (CGFloat)padding {
	return 6.0f;
}

#pragma mark - UIView

- (id)initWithFrame:(CGRect)rect {
	if ((self = [super initWithFrame:rect])) {
        [self configureView];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self configureView];
    }
    return self;
}

- (void)configureView {
    self.clipsToBounds = YES;

    _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:_textLabel];

    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
    [_activityIndicatorView startAnimating];
    [self addSubview:_activityIndicatorView];
    
    _completedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tick"]];
    [self addSubview:_completedImageView];

    _loading = NO;
    _completed = NO;
    [self layoutSubviews];
}

- (void)layoutSubviews {
	CGRect rect = self.frame;
	CGSize size = [[self class] indicatorSize];
	CGFloat x = size.width + [[self class] padding];
	NSLog(@"COMMING>>>");
    [_completedImageView setHidden:YES];
	// Loading
	if (_loading) {
		_textLabel.frame = CGRectMake(x, 0.0f, rect.size.width - x, size.height);
		_activityIndicatorView.frame = CGRectMake(0.0f, 0.0f, size.width, size.height);
        _completedImageView.frame = CGRectMake(0.0f, 0.0f, size.width, size.height);
        
	}
	
	// Not loading
	else {
		_textLabel.frame = CGRectMake(0.0f, 0.0f, rect.size.width, size.height);
		_activityIndicatorView.frame = CGRectMake(-x, 0.0f, size.width, size.height);
        _completedImageView.frame = CGRectMake(-x, 0.0f, size.width, size.height);
        [_completedImageView setHidden:YES];
	}
    
    if (_completed) {
        _textLabel.frame = CGRectMake(x, 0.0f, rect.size.width - x, size.height);
		_completedImageView.frame = CGRectMake(0.0f, 0.0f, size.width, size.height);
        [_completedImageView setHidden:NO];
    }
}


- (void)setBackgroundColor:(UIColor *)color {
	[super setBackgroundColor:color];
	_textLabel.backgroundColor = color;
	_activityIndicatorView.backgroundColor = color;
}


- (void)setOpaque:(BOOL)o {
	[super setOpaque:o];
	_textLabel.opaque = o;
	_activityIndicatorView.opaque = o;
}


#pragma mark - Status

- (void)startWithText:(NSString *)text {
    [_completedImageView setHidden:YES];
	self.loading = YES;
    self.completed = NO;
	_textLabel.text = text;
}

- (void)completeWithText:(NSString *)text {
	self.loading = NO;
    self.completed = YES;
	_textLabel.text = text;
}

@end
