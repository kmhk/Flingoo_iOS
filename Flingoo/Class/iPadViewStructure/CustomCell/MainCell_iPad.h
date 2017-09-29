
#import <UIKit/UIKit.h>

@interface MainCell_iPad : UITableViewCell


@property (nonatomic,retain)IBOutlet UILabel *titleLabel;
@property (nonatomic,retain)IBOutlet UIImageView *arrowImageView;
@property (strong, nonatomic) IBOutlet UIImageView *imgIcon;

- (void)changeArrowWithUp:(BOOL)up;
@end
