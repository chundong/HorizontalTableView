#import "HorizontalTableView.h"

@implementation HorizontalTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        hasSectionTitle = NO;
        
        reusableCells = [[NSMutableDictionary alloc] initWithCapacity:10];
        usingCells = [[NSMutableDictionary alloc] initWithCapacity:10];
        
        
        cellsView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        cellsView.backgroundColor = [UIColor whiteColor];
        
        [cellsView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
        [self addSubview:cellsView];
        cellsView.pagingEnabled = YES;
        
        
        tabArray= [[NSMutableArray alloc] initWithCapacity:100];
    }
    return self;
}
- (NSInteger)getIndex{
    CGPoint p = cellsView.contentOffset;
    
    int index =  0;
    
    CGFloat btnFrameX = 0;
    
    NSInteger sectionCount =  1;
    
    if ([hDatasource_ respondsToSelector:NSSelectorFromString(@"numberOfSectionsInTableView:")]) {
         sectionCount = [hDatasource_ numberOfSectionsInTableView:self];
    }
   
    for (int i = 0; i < sectionCount; i++) {
        NSInteger cellCount = [hDatasource_ tableView:self numberOfRowsInSection:i];
        
        for (int j = 0; j < cellCount; j++) {
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            
            NSInteger width  = [hDelegate_ tableView:self widthForRowAtIndexPath:indexPath];
            
            if (p.x >= btnFrameX   && p.x < btnFrameX + width  ) {
                return i;
            }
            btnFrameX+=width;
        }
    }
    return index;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    [self updateDisplayCell];
    
    if ([keyPath isEqualToString:@"contentOffset"] && hasSectionTitle ) {

        UIScrollView* contentView =(UIScrollView*) object;
        
        CGPoint p = contentView.contentOffset;
        
     
        NSInteger index = [self getIndex];// floor(p.x / screenWidth );
        
        if (index >= 0) {
            
            if (p.x > lastPoint) {
                //查找下一个
                UIButton* nextBtn = NULL;
                if (index + 1 < [tabArray count]) {
                    nextBtn = tabArray[index+1];
                }
                
                if (nextBtn) {
                    BOOL focusChange = NO;
                    if( tabArray[index] != selectedTab ){
                        focusChange = YES;
                    }
                    
                    if (focusChange) {
                        [selectedTab setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                        selectedTab = tabArray[index];
                        [selectedTab setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                        [self updateTabLayout];
                    }
                    
                    
                }
            }else if(p.x < lastPoint){
                //查找上一个
                UIButton* preBtn = NULL;
                if (index >= 0) {
                    preBtn = tabArray[index ];
                }
                BOOL focusChange = NO;
                if( tabArray[index] != selectedTab){
                    focusChange = YES;
                }
                UIView* prePreBtn = NULL;
                if (index - 2 >=0) {
                    prePreBtn = tabArray[index - 2];
                }
                if (focusChange) {
                    [selectedTab setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                    selectedTab = tabArray[index];
                    [selectedTab setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                    [self updateTabLayout];
                    
                    
                }
                
            }
            lastPoint = p.x;
            
        }
    }
}
- (void)switchTab:(UIButton*)sender{
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(updateTabLayout)];
    [UIView setAnimationDuration:0.1];
//    NSInteger tag = sender.tag;
//    
//    NSInteger offset = tag - 1 - BG_BTN_TAG;
////    UIScrollView* contentView =(UIScrollView*) [self.view viewWithTag:CONTEXT_TAG];
//    cellsView.contentOffset = CGPointMake(offset* MttHD_ScreenWidth(), 0 );
//    
//    UIScrollView* sectionView = (UIScrollView*)[self.view viewWithTag:CATEGORY_TAG];
//    UIButton* bgBtn =(UIButton*)[sectionView viewWithTag:BG_BTN_TAG];
//    bgBtn.frame = sender.frame;
    [UIView commitAnimations];
    
    selectedTab = sender;
}
- (UIButton*)getNextBtn:(UIButton*)btn{
    if (selectedTab ) {
        NSInteger index = [tabArray indexOfObject:btn];
        if (index + 1 < tabArray.count) {
            return tabArray[index+1];
        }
    }
    return NULL;
}
- (UIButton*)getPreBtn:(UIButton*)btn{
    if (btn ) {
        NSInteger index = [tabArray indexOfObject:btn];
        if (index - 1 >=0 ) {
            return tabArray[index-1];
        }
    }
    
    return NULL;
}
- (BOOL)inDisplayRange:(UIButton*)btn{
    if (btn.frame.origin.x >= sectionView.contentOffset.x && btn.frame.origin.x+btn.frame.size.width < sectionView.contentOffset.x + sectionView.frame.size.width  ) {
        return YES;
    }
    return NO;
}
- (void)updateTabLayout{
    UIButton* preBtn = [self getPreBtn:selectedTab];
    UIButton* nextBtn = [self getNextBtn:selectedTab];
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:0.1];
    if (preBtn && [self inDisplayRange:preBtn]  == NO) {
        sectionView.contentOffset = CGPointMake(preBtn.frame.origin.x, 0);
    }
    if (nextBtn && [self inDisplayRange:nextBtn] == NO) {
        sectionView.contentOffset = CGPointMake(nextBtn.frame.origin.x + nextBtn.frame.size.width - self.frame.size.width, 0);
    }
    [UIView commitAnimations];
}

- (HorizontalTableViewCell*)dequeueReusableCellWithIdentifier:(NSString*)identifier{
    NSMutableArray* cells = reusableCells[identifier];
    
    if (cells && cells.count > 0) {
        HorizontalTableViewCell* cell = cells[0];
        [cells removeObject:cell];
        NSMutableArray* idCells = (NSMutableArray*)[usingCells objectForKey:identifier];
        [idCells addObject:cell];
        return cell;
    }
    return NULL;
}

#define isDisplayCell(cellOffset,cellWidth,tableOffset) (cellOffset+ cellWidth > tableOffset && cellOffset+cellWidth  <= tableOffset+self.frame.size.width) || ( cellOffset >= tableOffset && cellOffset < tableOffset+self.frame.size.width )
- (void)setHDatasource:(id<HorizontalTableViewDatasource>)tvDatasource{
    hDatasource_ = tvDatasource;
    
}
- (id<HorizontalTableViewDatasource>)getHDatasource{
    return hDatasource_;
}
- (void)setHDelegate:(id<HorizontalTableViewDelegate>)delegate__{
    hDelegate_ = delegate__;
    [self updateTableView];
}
- (id<HorizontalTableViewDelegate>)getHDelegate{
    return hDelegate_;
}

- (void)checkSectionView{
    if (hDatasource_) {
        if ([hDatasource_ respondsToSelector:@selector(tableView:titleForHeaderInSection:)]) {
            hasSectionTitle = YES;
            
            if (sectionView == NULL) {
                BOOL showSectionAboveCell = [hDelegate_ showSectionAboveCell:self];
                CGFloat sectionHeight = [self getSectionHeight];
                if (showSectionAboveCell == YES) {
                    sectionView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, sectionHeight)];
                    cellsView.frame = CGRectMake(0, sectionHeight, self.frame.size.width, self.frame.size.height - sectionHeight);
                }else{
                    sectionView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-sectionHeight, self.frame.size.width, sectionHeight)];
                    cellsView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - sectionHeight);
                }
                
                [self addSubview:sectionView];
                
                NSString* title  = NULL;
                
                UIButton* btn  = NULL;
                CGFloat btnOffset = 0;
                NSInteger sectionCount = [hDatasource_ numberOfSectionsInTableView:self];
                for (int sectionIndex = 0; sectionIndex < sectionCount; sectionIndex++) {
                    title = [hDatasource_ tableView:self titleForHeaderInSection:sectionIndex];
                    btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [btn setTitle:title forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                    btn.backgroundColor = [UIColor whiteColor];
                    [btn sizeToFit];
                    [btn addTarget:self action:@selector(sectionChange:) forControlEvents:UIControlEventTouchUpInside];
                    [tabArray addObject:btn];
                    btn.frame = CGRectMake(btnOffset, 0, btn.frame.size.width+20, btn.frame.size.height  );
                    btnOffset +=btn.frame.size.width+20;
                    [sectionView addSubview:btn];
                }
                if (tabArray.count > 0) {
                    selectedTab = tabArray[0];
                }
                sectionView.contentSize= CGSizeMake(btnOffset, sectionHeight);
                
                
                [self bringSubviewToFront:sectionView];
            }
            
        }else{
            hasSectionTitle = NO;
        }
    }else{
        hasSectionTitle = NO;
    }
    
    if (hasSectionTitle == NO) {
        sectionView.hidden = YES;
    }else{
        sectionView.hidden = NO;
    }
}
- (void)scrollToSection:(NSInteger)btnIndex{
    NSInteger sectionCount = [hDatasource_ numberOfSectionsInTableView:self];
    CGFloat cellWidth = 0;
    CGFloat contentOffset = 0;
    NSIndexPath* indexPath = NULL;
    for (int i = 0; i < sectionCount++ && i < btnIndex; i++) {
        NSInteger cellCount = [hDatasource_ tableView:self numberOfRowsInSection:i];
        for (int j = 0; j < cellCount; j++) {
            indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            cellWidth = [hDelegate_ tableView:self widthForRowAtIndexPath:indexPath ];
            contentOffset += cellWidth;
        }
        
        
    }
//    [UIView beginAnimations:NULL context:NULL];
//    [UIView setAnimationDuration:0.4];
    cellsView.contentOffset = CGPointMake(contentOffset, 0);
//    [UIView commitAnimations];
    
}
- (void)sectionChange:(UIButton*)sender{
    NSInteger btnOffset = [tabArray indexOfObject:sender];
    
    [self scrollToSection:btnOffset];
    
    [selectedTab setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    selectedTab = sender;
    [selectedTab setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self updateTabLayout];
    
    
    
}
- (CGFloat)getSectionHeight{
    CGFloat sectionHeight = 0;
    if (hDatasource_ && [hDatasource_ respondsToSelector:@selector(heightForSection:)]) {
        sectionHeight = [hDatasource_ heightForSection:self ];
    }
    return sectionHeight;
}
- (void)updateDisplayCell{
    if ( hDatasource_) {
        int cellOffset = 0;
        int tableOffset = cellsView.contentOffset.x;
        
        NSInteger sectionNumber = [hDatasource_ numberOfSectionsInTableView:self];
        
        [reusableCells setDictionary:usingCells];
        
        [usingCells removeAllObjects];
        
        for (int i = 0; i < sectionNumber  ;i++) {
            NSInteger cellNumber = [hDatasource_ tableView:self numberOfRowsInSection:i ];
            for (int j = 0 ; j < cellNumber; j++) {
                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                
                int cellWidth = 44;
                
                if (hDelegate_) {
                    cellWidth = [hDelegate_ tableView:self widthForRowAtIndexPath:indexPath];
                }
                
                if (isDisplayCell(cellOffset,cellWidth,tableOffset)) {
                    HorizontalTableViewCell* cell = [hDatasource_ tableView:self cellForRowAtIndexPath:indexPath];
                    
                    NSMutableArray* cells = [usingCells objectForKey:cell.identifier];
                    if (cells == NULL) {
                        cells = [[NSMutableArray alloc] initWithCapacity:10];
                        [cells addObject:cell];
                        [usingCells setObject:cells forKey:cell.identifier];
                    }
                    if (hasSectionTitle) {
                        CGFloat sectionHeight = [self getSectionHeight];
                        cell.frame = CGRectMake(cellOffset , 0 , cellWidth, self.frame.size.height - sectionHeight);
                    }else{
                        cell.frame = CGRectMake(cellOffset , 0, cellWidth, self.frame.size.height);
                    }
                    
                    [cellsView addSubview:cell];
                }
                cellOffset+=cellWidth;
            }
        }
        cellsView.contentSize = CGSizeMake(cellOffset, cellsView.frame.size.height);
        
    }
}

- (void)updateTableView{
    [self cleanAllCell];
    [self checkSectionView];
    [self updateDisplayCell];
    [self bringSubviewToFront:sectionView];
    
    dispatch_async(dispatch_get_main_queue(), ^(){
        [self setNeedsDisplay];
    });
}
- (void)cleanAllCell{
    for (NSArray* cells in [usingCells allValues]) {
        for (UIView * v in cells) {
            [v removeFromSuperview];
        }
    }
    for (NSArray* cells in [reusableCells allValues]) {
        for (UIView * v in cells) {
            [v removeFromSuperview];
        }
    }
    [reusableCells setDictionary:usingCells];
    [usingCells removeAllObjects];
}
- (void)didMoveToSuperview{
    [self updateTableView];
}
- (void)reloadData{
    [self updateTableView];
}

@end
