#import "HorizontalTableViewCell.h"

@implementation HorizontalTableViewCell
@synthesize identifier;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithFrame:frame];
    if (self) {
        self.identifier = reuseIdentifier;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
