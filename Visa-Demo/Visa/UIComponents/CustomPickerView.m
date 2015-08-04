//
//  MMPickerView.m
//  MMPickerView
//
//  Created by Madjid Mahdjoubi on 6/5/13.
//  Copyright (c) 2013 GG. All rights reserved.
//

#import "CustomPickerView.h"

NSString * const MMbackgroundColor = @"backgroundColor";
NSString * const MMtextColor = @"textColor";
NSString * const MMtoolbarColor = @"toolbarColor";
NSString * const MMbuttonColor = @"buttonColor";
NSString * const MMfont = @"font";
NSString * const MMvalueY = @"yValueFromTop";
NSString * const MMselectedObject = @"selectedObject";
NSString * const MMtoolbarBackgroundImage = @"toolbarBackgroundImage";
NSString * const MMtextAlignment = @"textAlignment";
NSString * const MMshowsSelectionIndicator = @"showsSelectionIndicator";


@interface CustomPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UILabel *pickerViewLabel;
@property (nonatomic, strong) UIView *pickerViewLabelView;
@property (nonatomic, strong) UIView *pickerContainerView;
@property (nonatomic, strong) UIView *pickerViewContainerView;
@property (nonatomic, strong) UIView *pickerTopBarView;
@property (nonatomic, strong) UIImageView *pickerTopBarImageView;
@property (nonatomic, strong) UIToolbar *pickerViewToolBar;
@property (nonatomic, strong) UIBarButtonItem *pickerViewBarButtonItem;
@property (nonatomic, strong) UIButton *pickerDoneButton;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSArray *pickerViewArray;
@property (nonatomic, strong) UIColor *pickerViewTextColor;
@property (nonatomic, strong) UIFont *pickerViewFont;
@property (nonatomic, assign) CGFloat yValueFromTop;
@property (nonatomic, assign) NSInteger pickerViewTextAlignment;
@property (nonatomic, assign) BOOL pickerViewShowsSelectionIndicator;
@property (copy) void (^onDismissCompletion)(NSString *,NSString *,NSString *);

@property(nonatomic)NSInteger selectedRow;

@end

@implementation CustomPickerView

#pragma mark - Singleton

+ (CustomPickerView*)sharedView {
    
    static dispatch_once_t pred = 0;
    __strong static CustomPickerView* sharedView = nil;
    dispatch_once(&pred, ^{
        sharedView = [[self alloc] init];
    });
    return sharedView;
}

#pragma mark - Show Methods


+(void)showPickerViewInView:(UIView *)view
                withOptions:(NSDictionary *)options
                 completion:(void (^)(NSString *,NSString *,NSString *))completion{
  
  [[self sharedView] initializePickerViewInView:view
                                    withOptions:options];
  
  [[self sharedView] setPickerHidden:NO callBack:nil];
  [self sharedView].onDismissCompletion = completion;
  [view addSubview:[self sharedView]];
  
}


#pragma mark - Dismiss Methods

+(void)dismissWithCompletion:(void (^)(NSString *,NSString *,NSString *))completion{
  [[self sharedView] setPickerHidden:YES callBack:completion];
}

-(void)dismiss{
 [CustomPickerView dismissWithCompletion:self.onDismissCompletion];
}

+(void)removePickerView{
  [[self sharedView] removeFromSuperview];
}

+ (NSArray *)countryNames
{
    static NSArray *_countryNames = nil;
    if (!_countryNames)
    {
        _countryNames = [[[[self countryNamesByCode] allValues] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] copy];
    }
    return _countryNames;
}

+ (NSArray *)countryCodes
{
    static NSArray *_countryCodes = nil;
    if (!_countryCodes)
    {
        _countryCodes = [[[self countryCodesByName] objectsForKeys:[self countryNames] notFoundMarker:@""] copy];
    }
    return _countryCodes;
}

+ (NSDictionary *)countryNamesByCode
{
    static NSDictionary *_countryNamesByCode = nil;
    if (!_countryNamesByCode)
    {
        NSMutableDictionary *namesByCode = [NSMutableDictionary dictionary];
        for (NSString *code in [NSLocale ISOCountryCodes])
        {
            NSString *identifier = [NSLocale localeIdentifierFromComponents:@{NSLocaleCountryCode: code}];
            NSString *countryName = [[NSLocale currentLocale] displayNameForKey:NSLocaleIdentifier value:identifier];
            if (countryName) namesByCode[code] = countryName;
        }
        _countryNamesByCode = [namesByCode copy];
    }
    return _countryNamesByCode;
}

+ (NSDictionary *)countryCodesByName
{
    static NSDictionary *_countryCodesByName = nil;
    if (!_countryCodesByName)
    {
        NSDictionary *countryNamesByCode = [self countryNamesByCode];
        NSMutableDictionary *codesByName = [NSMutableDictionary dictionary];
        for (NSString *code in countryNamesByCode)
        {
            codesByName[countryNamesByCode[code]] = code;
        }
        _countryCodesByName = [codesByName copy];
    }
    return _countryCodesByName;
}


+ (NSDictionary *)dialingCodesWithCountryCode{
    NSString * plistPath = [[NSBundle mainBundle] pathForResource:@"DialingCodes" ofType:@"plist"];
    return [NSDictionary dictionaryWithContentsOfFile:plistPath];
}

+(NSString *)findDialingCode:(NSString *)countryCode{
    // loop through the dictionary and get the code
    for (NSString* key in [[self class] dialingCodesWithCountryCode]) {
        // get the value for a key
        id value = [[[self class] dialingCodesWithCountryCode] objectForKey:key];
        // check if the key equals the selected Country Code
        if ( [key isEqualToString:countryCode]){
            // found the key, return from it.
            return value;
            break;
        }
    }
    return nil;
}

+(NSString *)findCountry:(NSInteger )index{
    // loop through the dictionary and get the code
    for (NSString* key in [[self class] countryNames]) {
        // get the value for a key
        id value = [[[self class] countryNames] objectAtIndex:index];
        // check if we got the index
        if ( [key isEqualToString:value]){
            // found the key, return from it.
            return value;
            break;
        }
    }
    return nil;
}


#pragma mark - Show/hide PickerView methods

-(void)setPickerHidden: (BOOL)hidden
              callBack: (void(^)(NSString *,NSString *,NSString *))callBack; {
  
  [UIView animateWithDuration:0.3
                        delay:0.0
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     
                     if (hidden) {
                       [_pickerViewContainerView setAlpha:0.0];
                       [_pickerContainerView setTransform:CGAffineTransformMakeTranslation(0.0, CGRectGetHeight(_pickerContainerView.frame))];
                     } else {
                       [_pickerViewContainerView setAlpha:1.0];
                       [_pickerContainerView setTransform:CGAffineTransformIdentity];
                     }
                   } completion:^(BOOL completed) {
                     if(completed && hidden){
                       [CustomPickerView removePickerView];
                       callBack([self selectedDialingCode],[self selectedCountry],[_pickerViewArray objectAtIndex:self.selectedRow]);
                     }
                   }];
  
}




-(void)initializePickerViewInView: (UIView *)view
                      withOptions: (NSDictionary *)options {
  
    _pickerViewArray = [[self class] countryCodes];
    self.selectedRow = 0;
    NSNumber *textAlignment = [[NSNumber alloc] init];
    //textAlignment = options[MMtextAlignment];
    //Default value is NSTextAlignmentCenter
    _pickerViewTextAlignment = 1;
    view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    if (textAlignment != nil) {
        _pickerViewTextAlignment = [options[MMtextAlignment] integerValue];
    }
  
    BOOL showSelectionIndicator = [options[MMshowsSelectionIndicator] boolValue];
  
    if (!showSelectionIndicator) {
        _pickerViewShowsSelectionIndicator = 1;
    }
    _pickerViewShowsSelectionIndicator = showSelectionIndicator;
  
    UIColor *pickerViewBackgroundColor = [[UIColor alloc] initWithCGColor:[options[MMbackgroundColor] CGColor]];
    UIColor *pickerViewTextColor = [[UIColor alloc] initWithCGColor:[options[MMtextColor] CGColor]];
    UIColor *toolbarBackgroundColor = [[UIColor alloc] initWithCGColor:[options[MMtoolbarColor] CGColor]];
    UIColor *buttonTextColor = [[UIColor alloc] initWithCGColor:[options[MMbuttonColor] CGColor]];
//    UIFont *pickerViewFont = [[UIFont alloc] init];
//    pickerViewFont = options[MMfont];
    _yValueFromTop = [options[MMvalueY] floatValue];
  
    [self setFrame: view.bounds];
    [self setBackgroundColor:[UIColor clearColor]];
  
    UIImage * toolbarImage = options[MMtoolbarBackgroundImage];
  
    //Whole screen with PickerView and a dimmed background
    _pickerViewContainerView = [[UIView alloc] initWithFrame:view.bounds];
    _pickerContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_pickerViewContainerView setBackgroundColor: [UIColor colorWithRed:0.412 green:0.412 blue:0.412 alpha:0.7]];
    [self addSubview:_pickerViewContainerView];
  
    //PickerView Container with top bar
    _pickerContainerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, _pickerViewContainerView.bounds.size.height - 260.0, view.frame.size.width, 260.0)];
    //Default Color Values (if colors == nil)
  
    //PickerViewBackgroundColor - White
    if (pickerViewBackgroundColor==nil) {
        pickerViewBackgroundColor = [UIColor whiteColor];
    }
  
    //PickerViewTextColor - Black
    if (pickerViewTextColor==nil) {
        pickerViewTextColor = [UIColor blackColor];
    }
    _pickerViewTextColor = pickerViewTextColor;
  
    //ToolbarBackgroundColor - Black
    if (toolbarBackgroundColor==nil) {
        toolbarBackgroundColor = [UIColor colorWithRed:0.969 green:0.969 blue:0.969 alpha:0.8];
    }
  
    //ButtonTextColor - Blue
    if (buttonTextColor==nil) {
        buttonTextColor = [UIColor colorWithRed:0.000 green:0.486 blue:0.976 alpha:1];
    }
  
//    if (pickerViewFont==nil) {
//        _pickerViewFont = [UIFont systemFontOfSize:22];
//    }
//    _pickerViewFont = pickerViewFont;
  
    /*
   //ToolbackBackgroundImage - Clear Color
   if (toolbarBackgroundImage!=nil) {
   //Top bar imageView
   _pickerTopBarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, _pickerContainerView.frame.size.width, 44.0)];
   //[_pickerContainerView addSubview:_pickerTopBarImageView];
   _pickerTopBarImageView.image = toolbarBackgroundImage;
   [_pickerViewToolBar setHidden:YES];
   
   }
   */
  
  _pickerContainerView.backgroundColor = pickerViewBackgroundColor;
  [_pickerViewContainerView addSubview:_pickerContainerView];
  
  
  //Content of pickerContainerView
  
  //Top bar view
  _pickerTopBarView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, _pickerContainerView.frame.size.width, 44.0)];
  [_pickerContainerView addSubview:_pickerTopBarView];
  [_pickerTopBarView setBackgroundColor:[UIColor whiteColor]];
  
    _pickerViewToolBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  _pickerViewToolBar = [[UIToolbar alloc] initWithFrame:_pickerTopBarView.frame];
  [_pickerContainerView addSubview:_pickerViewToolBar];
  
  CGFloat iOSVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
  //NSLog(@"%f",iOSVersion);
  
  if (iOSVersion < 7.0) {
    _pickerViewToolBar.tintColor = toolbarBackgroundColor;
    //[_pickerViewToolBar setBackgroundColor:toolbarBackgroundColor];
  }else{
     [_pickerViewToolBar setBackgroundColor:toolbarBackgroundColor];

     //_pickerViewToolBar.tintColor = toolbarBackgroundColor;
  
    #if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
    _pickerViewToolBar.barTintColor = toolbarBackgroundColor;
    #endif
  }
  
  if (toolbarImage!=nil) {
    [_pickerViewToolBar setBackgroundImage:toolbarImage forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
  }
  
  UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
  
  _pickerViewBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismiss)];
  _pickerViewToolBar.items = @[flexibleSpace, _pickerViewBarButtonItem];
  [_pickerViewBarButtonItem setTintColor:buttonTextColor];
  
  //[_pickerViewBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"Helvetica-Neue" size:23.0], UITextAttributeFont,nil] forState:UIControlStateNormal];
  
  /*
   _pickerDoneButton = [[UIButton alloc] initWithFrame:CGRectMake(_pickerContainerView.frame.size.width - 80.0, 10.0, 60.0, 24.0)];
   [_pickerDoneButton setTitle:@"Done" forState:UIControlStateNormal];
   [_pickerContainerView addSubview:_pickerDoneButton];
   [_pickerDoneButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
  */
  
  //Add pickerView
  _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 44.0, view.frame.size.width, 216.0)];
  _pickerView.autoresizingMask  = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  [_pickerView setDelegate:self];
  [_pickerView setDataSource:self];
  [_pickerView setShowsSelectionIndicator: _pickerViewShowsSelectionIndicator];//YES];
  [_pickerContainerView addSubview:_pickerView];
  
  //[self.pickerViewContainerView setAlpha:0.0];
  [_pickerContainerView setTransform:CGAffineTransformMakeTranslation(0.0, CGRectGetHeight(_pickerContainerView.frame))];
  
  //Set selected row
  //[_pickerView selectRow:selectedRow inComponent:0 animated:YES];
}






#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView: (UIPickerView *)pickerView {
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component {
  return [_pickerViewArray count];
}

- (NSString *)pickerView: (UIPickerView *)pickerView
             titleForRow: (NSInteger)row
            forComponent: (NSInteger)component {
    return [_pickerViewArray objectAtIndex:row];
}

#pragma mark - UIPickerViewDelegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedRow = row;
    self.onDismissCompletion ([[self class] findDialingCode:[_pickerViewArray objectAtIndex:row]],[[self class] findCountry:self.selectedRow],[_pickerViewArray objectAtIndex:row]);
}

- (id)selectedDialingCode {
    NSString *selectedCode = [[self class] findDialingCode:[_pickerViewArray objectAtIndex:[self.pickerView selectedRowInComponent:0]]];
    return selectedCode;
}


-(id)selectedCountry{
    NSString *selectedCountry = [[self class] findCountry:self.selectedRow];
    return selectedCountry;
}




- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view {
    if (!view)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 44)];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(55, 10, pickerView.frame.size.width, 24)];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        label.backgroundColor = [UIColor clearColor];
        label.tag = 1;
        [view addSubview:label];
        
        UIImageView *flagView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 24, 24)];
        flagView.contentMode = UIViewContentModeScaleAspectFit;
        flagView.tag = 2;
        [view addSubview:flagView];
    }

    ((UILabel *)[view viewWithTag:1]).text = [[self class] countryNames][row];
    ((UIImageView *)[view viewWithTag:2]).image = [UIImage imageNamed:[[self class]countryCodes][row]];
    
    return view;
}


@end
