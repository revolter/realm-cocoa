////////////////////////////////////////////////////////////////////////////
//
// Copyright 2016 Realm Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
////////////////////////////////////////////////////////////////////////////

#import "RLMStartView.h"

@interface RLMStartView () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *topCellBackgroundView;
@property (nonatomic, strong) UIImageView *bottomCellBackgroundView;

@property (nonatomic, strong) UITextField *hostNameField;
@property (nonatomic, strong) UITextField *userNameField;
@property (nonatomic, strong) UITextField *passwordField;

@property (nonatomic, strong) UIButton *connectButton;

@property (nonatomic, strong) UIActivityIndicatorView *activityindicator;

- (void)buttonTapped:(id)sender;
- (UITextField *)newTextField;

+ (UIImage *)cellBackgroundImageBottom:(BOOL)bottom;

@end

@implementation RLMStartView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]]) {
        self.frame = frame;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    return self;
}

- (void)didMoveToSuperview
{
    if (self.tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:(CGRect){CGPointZero, (CGSize){520.0f, 64.0f*3.0f}} style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin
                                            | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.tableFooterView = [[UIView alloc] init]; // suppress bottom separator
        self.tableView.scrollEnabled = NO;
        self.tableView.rowHeight = 64.0f;
        self.tableView.layer.shadowRadius = 20.0f;
        self.tableView.layer.shadowOpacity = 0.1f;
        self.tableView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.tableView.frame cornerRadius:20.0f].CGPath;
        self.tableView.clipsToBounds = NO;
        [self.contentView addSubview:self.tableView];
    }
    
    if (self.topCellBackgroundView == nil) {
        self.topCellBackgroundView = [[UIImageView alloc] initWithImage:[RLMStartView cellBackgroundImageBottom:NO]];
        self.topCellBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    if (self.bottomCellBackgroundView == nil) {
        self.bottomCellBackgroundView = [[UIImageView alloc] initWithImage:[RLMStartView cellBackgroundImageBottom:YES]];
        self.bottomCellBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    if (self.hostNameField == nil) {
        self.hostNameField = [self newTextField];
        self.hostNameField.placeholder = @"localhost";
    }
    
    if (self.userNameField == nil) {
        self.userNameField = [self newTextField];
        self.userNameField.placeholder = @"demo@realm.io";
    }
    
    if (self.passwordField == nil) {
        self.passwordField = [self newTextField];
        self.passwordField.placeholder = @"password";
        self.passwordField.secureTextEntry = YES;
    }
    
    if (self.connectButton == nil) {
        self.connectButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.connectButton.frame = (CGRect){0, 0, 520.0f, 64.0f};
        self.connectButton.tintColor = [UIColor whiteColor];
        self.connectButton.titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
        self.connectButton.backgroundColor = [UIColor colorWithRed:242.0f/255.0f green:81.0f/255.0f blue:146.0f/255.0f alpha:1.0f];
        self.connectButton.clipsToBounds = YES;
        self.connectButton.layer.cornerRadius = 20.0f;
        [self.connectButton setTitle:@"Connect" forState:UIControlStateNormal];
        [self.connectButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.connectButton];
    }
    
    if (self.activityindicator == nil) {
        self.activityindicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.activityindicator.hidden = YES;
        [self addSubview:self.activityindicator];
    }
}

- (UITextField *)newTextField
{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
    textField.delegate = self;
    textField.font = [UIFont systemFontOfSize:20.0f];
    textField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    return textField;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.tableView.center = self.center;
    
    CGRect frame = self.connectButton.frame;
    frame.origin.x = self.tableView.frame.origin.x;
    frame.origin.y = CGRectGetMaxY(self.tableView.frame) + 40;
    self.connectButton.frame = frame;
    
    self.activityindicator.center = self.connectButton.center;
}

#pragma mark - Table View Delegate/Data Source -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellidentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:20.0f];
        cell.textLabel.textColor = [UIColor colorWithWhite:0.5f alpha:1.0f];
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    if (indexPath.row == 0 || indexPath.row == 2) {
        cell.backgroundColor = [UIColor clearColor];
        UIView *background = (indexPath.row == 0) ? self.topCellBackgroundView : self.bottomCellBackgroundView;
        [cell insertSubview:background atIndex:0];
        background.frame = cell.bounds;
    }
    
    CGRect textFieldframe = cell.bounds;
    textFieldframe.origin.x = 150.0f;
    textFieldframe.size.height = cell.contentView.frame.size.height;
    textFieldframe.size.width -= 15.0f;
    textFieldframe.origin.y = (cell.contentView.frame.size.height - textFieldframe.size.height) * 0.5f;
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Host Name:";
            self.hostNameField.frame = textFieldframe;
            [cell.contentView addSubview:self.hostNameField];
            break;
        case 1:
            cell.textLabel.text = @"User Name:";
            self.userNameField.frame = textFieldframe;
            [cell.contentView addSubview:self.userNameField];
            break;
        case 2:
            cell.textLabel.text = @"Password:";
            self.passwordField.frame = textFieldframe;
            [cell.contentView addSubview:self.passwordField];
            break;
    }
    
    return cell;
}

- (void)buttonTapped:(id)sender
{
    if (self.connectButtonTapped) {
        self.connectButtonTapped();
    }
}

#pragma mark - Accessors -
- (void)setLoading:(BOOL)loading
{
    _loading = loading;
    
    if (_loading) {
        [self.connectButton setTitle:@"" forState:UIControlStateNormal];
        self.activityindicator.hidden = NO;
        [self.activityindicator startAnimating];
    }
    else {
        [self.connectButton setTitle:@"Connect" forState:UIControlStateNormal];
        self.activityindicator.hidden = YES;
        [self.activityindicator stopAnimating];
    }
}

- (NSString *)hostName
{
    return self.hostNameField.text.length > 0 ? self.hostNameField.text : self.hostNameField.placeholder;
}

- (NSString *)userName
{
    return self.userNameField.text.length > 0 ? self.userNameField.text : self.userNameField.placeholder;
}

- (NSString *)password
{
    return self.passwordField.text.length > 0 ? self.passwordField.text : self.passwordField.placeholder;
}

#pragma mark - Image Creation -

+ (UIImage *)cellBackgroundImageBottom:(BOOL)bottom
{
    CGRect rect = CGRectMake(0, 0, 42, 16);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    
    NSUInteger cornerMask = bottom ? (UIRectCornerBottomLeft|UIRectCornerBottomRight) : (UIRectCornerTopLeft|UIRectCornerTopRight);
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:cornerMask cornerRadii:CGSizeMake(20.0f, 20.0f)];
    [[UIColor whiteColor] set];
    [bezierPath fill];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(bottom ? 1.0f : 20.0f, 20.0f, bottom ? 20.0f : 1.0f, 20.0f)];
    return image;
}

@end
