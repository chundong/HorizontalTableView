#import <UIKit/UIKit.h>

@interface HorizontalTableViewCell : UIView{
    NSString* identifier;
}
@property(nonatomic,strong)NSString* identifier;
- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier;
@end
