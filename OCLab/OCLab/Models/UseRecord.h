//
//  UseRecord.h
//  OCLab
//
//  Created by Ruizhi Li on 7/6/18.
//  Copyright © 2018 Dante. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, RecordState){
    RecordStateNew,
    RecordStateDownloaded,
    RecordStateFailed
};

@interface UseRecord : NSObject
@property (nonatomic, assign) RecordState state;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSURL *url;
@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, strong) UIImage *image;

- (instancetype)initWithName:(NSString *)namestr
                         url:(NSString *)urlstr;
@end
