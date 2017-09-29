//
//  FLVIPMembershipsViewController.m
//  Flingoo
//
//  Created by Thilina Hewagama on 11/23/13.
//  Copyright (c) 2013 Hemal. All rights reserved.
//

#import "FLVIPMembershipsViewController.h"
#import "FLVIPCollectionCell.h"

@interface FLVIPMembershipsViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>


@property(weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property(nonatomic, strong) NSArray *sourceData;

@end

@implementation FLVIPMembershipsViewController

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
 
    
    //register custom cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"FLVIPCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"FLVIPCollectionCell"];
    
    self.navigationItem.title =  @"VIP Memberships";

    
    self.sourceData = @[
                        @{@"itemId":@0,@"line1":@"1 Month - $ 4.99",@"line2":@"",@"image":@"vip_1.png"},
                        @{@"itemId":@1,@"line1":@"3 Months - $ 11.99",@"line2":@"$ 3.99 a month (Save 20%)",@"image":@"vip_2.png"},
                        @{@"itemId":@2,@"line1":@"6 Months - $ 17.99",@"line2":@"$ 2.99 a month (Save 40%)",@"image":@"vip_3.png"},
                        @{@"itemId":@3,@"line1":@"12 Months - $ 29.99",@"line2":@"$ 2.49 a month (Save 50%)",@"image":@"vip_4.png"}
                        ];

    
    //back button
    
    self.navigationItem.leftBarButtonItem = [FLUtil backBarButtonWithTarget:self action:@selector(goBack)];
    
    if(IS_IPAD){
        [CATransaction setDisableActions:YES];
        self.parentScrollView.layer.opacity = 0;
    }
}


-(void) viewDidAppear:(BOOL)animated{
    if(IS_IPAD){
        [self.parentScrollView.layer addAnimation:[FLUtil appearAnimation] forKey:@"opacity"];
    }
}


-(void) goBack{
    [self.navigationController popToRootViewControllerAnimated:YES];
}





#pragma mark
#pragma mark - UICollectionView Delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.sourceData.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FLVIPCollectionCell *cell = (FLVIPCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"FLVIPCollectionCell" forIndexPath:indexPath];
    
    NSDictionary *dict = [self.sourceData objectAtIndex:indexPath.row];
    if(dict){
        if([dict objectForKey:@"line1"]){
            cell.vipLine1.text = [dict objectForKey:@"line1"];
        }
        if([dict objectForKey:@"line2"]){
            cell.vipLine2.text = [dict objectForKey:@"line2"];
        }
        if([dict objectForKey:@"image"]){
            cell.vipImageView.image = [UIImage imageNamed:[dict objectForKey:@"image"]];
        }
        
    }
    
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [self.sourceData objectAtIndex:indexPath.row];
    
    switch (indexPath.row) {
        case 0:
        {
            //1 month
            NSLog(@"1 month");
        }
            break;
        case 1:
        {
            //3 months
            NSLog(@"2 month");
        }
            break;
        case 2:
        {
            //6 months
            NSLog(@"6 month");
        }
            break;
        case 3:
        {
            //12 months
            NSLog(@"12 month");
        }
            break;
            
        default:
            break;
    }
    
}




#pragma mark - FlowLayout Delegate

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(145, 172);
}

-(UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10,10,10,10);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
