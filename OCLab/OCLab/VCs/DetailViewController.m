//
//  DetailViewController.m
//  OCLab
//
//  Created by Ruizhi Li on 7/9/18.
//  Copyright © 2018 Dante. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (nonatomic, weak) IBOutlet UIImageView *imagePresenter;
@end

@implementation DetailViewController
@synthesize m_image = _m_image;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Detail";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_m_image){
        [_imagePresenter setImage:_m_image];
        [_imagePresenter setContentMode:UIViewContentModeScaleAspectFill];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - IBActions
- (IBAction)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
