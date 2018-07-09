//
//  FeedViewController.m
//  OCLab
//
//  Created by Ruizhi Li on 7/6/18.
//  Copyright © 2018 Dante. All rights reserved.
//

#import "FeedViewController.h"
#import "UseRecord.h"
#import "DetailViewController.h"

static NSString * const Idenfiter = @"CellIdentifier";
@interface FeedViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSURL *datasourceURL;
@property (nonatomic, strong) NSMutableArray *users;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSCache *cache;

@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        // Do any additional setup after loading the view from its nib.
    _cache = [NSCache new];
    [self setupNavigationBar];
    [_tableView registerClass:[UITableViewCell self] forCellReuseIdentifier:Idenfiter];
    _datasourceURL = [NSURL URLWithString:@"https://www.raywenderlich.com/downloads/ClassicPhotosDictionary.plist"];
    [self fetchUsers];
}

- (void)setupNavigationBar{
    self.title = @"Feed";
    //    [self.navigationController.navigationBar setPrefersLargeTitles:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.users count];
}

#pragma mark - UITableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Idenfiter
                                                            forIndexPath:indexPath];
//    cell.imageView.image = nil;
    UseRecord *record = _users[indexPath.row];

//    if (record.image){
//        [cell.imageView setImage:record.image];
//    }else{
//        [self downloadImage:indexPath completion:^(NSData *data, NSError *e){
//            if (data){
//                UIImage *image = [UIImage imageWithData:data];
//                if (image){
//                    record.image = image;
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//                    });
//
//                }
//            }
//
//        }];
//    }
    cell.imageView.image = nil;
    [cell.textLabel setText:record.name];
    if ([_cache objectForKey:indexPath]){
        [cell.imageView setImage:[_cache objectForKey:indexPath]];
    }else{
        [self startDownloadImage:record forRowAtIndexPath:indexPath];
    }
    
//    if (record){
//        [cell.textLabel setText:record.name];
//        [cell.imageView setImage:record.image];
//    }
//
//        switch (record.state) {
//            case RecordStateNew:
//                [self startDownloadImage:record forRowAtIndexPath:indexPath];
//                break;
//            case RecordStateDownloaded:
//                [cell.imageView setImage:record.image];
//                break;
//            case RecordStateFailed:
//                [cell.textLabel setText:@"Download failed"];
//                break;
//            default:
//                break;
//        }

    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    UseRecord *record = _users[indexPath.row];
    if (record.image){
        DetailViewController *detailVC = [[DetailViewController alloc]initWithNibName:@"DetailViewController" bundle:nil];
        detailVC.m_image = record.image;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate){
        [self loadImagesForOnScreenCells];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self loadImagesForOnScreenCells];
}

#pragma mark - Web Calls
- (void)fetchUsers{
    if (!_datasourceURL) return;
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:_datasourceURL completionHandler:^(NSData *responseData, NSURLResponse *response, NSError *error){
        NSInteger statuscode = [(NSHTTPURLResponse *) response statusCode];
        if (statuscode == 200){
            NSError *e = nil;
//            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&e];
            NSDictionary *dict = [NSPropertyListSerialization propertyListWithData:responseData options: NSPropertyListImmutable format:nil error:&e];
            for (int i = 0; i < 5; i++){
                for (id key in [dict allKeys]){
                    UseRecord *record = [[UseRecord alloc]initWithName:(NSString *)key
                                                                   url:(NSString *)[dict objectForKey:key]];
                    //                if (self.users.count == 5) break;
                    [self.users addObject:record];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_tableView reloadData];
                });
            }

            
        }else{
            if (error){
                
            }else{
                
            }
        }
    }];
    [dataTask resume];
}

- (void)startDownloadImage:(UseRecord *)record forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!record) return;
    if (_tableView.decelerating && !_tableView.dragging) return;
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession]dataTaskWithURL:record.url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if ([(NSHTTPURLResponse *)response statusCode] == 200){
            if (data){
                UIImage *image = [UIImage imageWithData:data];
                [_cache setObject:image forKey:indexPath];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                });
            }
        }
    }];
    
//    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession]dataTaskWithURL:record.url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
//        if ([(NSHTTPURLResponse *)response statusCode] == 200){
//            UIImage *image = [UIImage imageWithData: data];
//            if (image){
//                record.image = image;
//                record.state = RecordStateDownloaded;
//            }else{
//                record.state = RecordStateFailed;
//            }
//        }else{
//           record.state = RecordStateFailed;
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        });
//    }];
    [dataTask resume];
}

- (void)loadImagesForOnScreenCells{
    if (_users.count > 0){
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths){
            [self startDownloadImage:_users[indexPath.row] forRowAtIndexPath:indexPath];
        }
    }
}

- (void)downloadImage:(NSIndexPath *)indexPath completion:(void(^)(NSData *data, NSError *e))completeBlock{
    UseRecord *record = self.users[indexPath.row];
    if (!record) return;
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession]dataTaskWithURL:record.url completionHandler:^(NSData *responseData, NSURLResponse *response, NSError *error){

        completeBlock(responseData, error);
    }];
    [dataTask resume];
}

#pragma mark - getter/setter
- (NSMutableArray *)users{
    if (!_users){
        _users = [NSMutableArray new];
    }
    return _users;
}

@end
