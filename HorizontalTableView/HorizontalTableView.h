#import <UIKit/UIKit.h>
#import "HorizontalTableViewCell.h"
@class HorizontalTableView;

@protocol HorizontalTableViewDatasource <NSObject>

@required

- (NSInteger)tableView:(HorizontalTableView *)tableView numberOfRowsInSection:(NSInteger)section;

- (HorizontalTableViewCell *)tableView:(HorizontalTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional

- (NSInteger)numberOfSectionsInTableView:(HorizontalTableView *)tableView;      

- (CGFloat) heightForSection:(HorizontalTableView *)tableView;

- (NSString *)tableView:(HorizontalTableView *)tableView titleForHeaderInSection:(NSInteger)section;
@end

@protocol HorizontalTableViewDelegate
@optional

- (CGFloat)tableView:(HorizontalTableView *)tableView widthForRowAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)showSectionAboveCell:(HorizontalTableView *)tableView;

@end

@interface HorizontalTableView : UIView{
    NSMutableDictionary*        reusableCells;
    NSMutableDictionary*        usingCells;
    NSInteger                   cacheNumber;
    
    id<HorizontalTableViewDatasource>    hDatasource_;
    id<HorizontalTableViewDelegate>  hDelegate_;
    NSMutableArray*             offsetArray;
    
    BOOL                        hasSectionTitle;
    
    UIScrollView*               cellsView;
    UIScrollView*               sectionView;
    
    CGFloat                     lastPoint;
    UIButton*                   selectedTab;
    
    NSMutableArray*             tabArray;
}
- (HorizontalTableViewCell*)dequeueReusableCellWithIdentifier:(NSString*)identifier;
- (id<HorizontalTableViewDatasource>)getTvDatasource;
- (void)setHDatasource:(id<HorizontalTableViewDatasource>)tvDatasource;
- (void)setHDelegate:(id<HorizontalTableViewDelegate>)delegate__;
- (id<HorizontalTableViewDelegate>)getHDelegate;
- (void)reloadData;
@end
