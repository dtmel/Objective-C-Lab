//
//  UseRecord.m
//  OCLab
//
//  Created by Ruizhi Li on 7/6/18.
//  Copyright © 2018 Dante. All rights reserved.
//

#import "UseRecord.h"
@interface UseRecord()
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSURL *url;
@end

@implementation UseRecord
@synthesize imageData = _imageData;
@synthesize image = _image;
@synthesize state = _state;

- (instancetype)initWithName:(NSString *)namestr
                         url:(NSString *)urlstr{
    self = [super init];
    if (self){
        _name = namestr;
        _url = [NSURL URLWithString:urlstr];
        _imageData = nil;
        _image = nil;
        _state = RecordStateNew;
    }
    return self;
}


@end
