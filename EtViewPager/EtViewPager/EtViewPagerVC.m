//  EtViewPager
/**
 * Copyright (C) <2013>  <Emil Todorov>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>
 */

#import "EtViewPagerVC.h"

@interface EtViewPagerVC ()
{
    NSLayoutConstraint *constraintWidthContent;
    CGFloat widthForPage;
    CGFloat heightForPage;
    CGPoint pointOffset;
    int mCurrentPage;
    NSMutableArray *arrayOfPages;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *viewContent;

@end

@implementation EtViewPagerVC

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
    [super viewDidLoad];
    NSUInteger numPages = self.numberOfPages;
    arrayOfPages = [[NSMutableArray alloc] initWithCapacity:numPages];
    for(int x = 0; x < numPages; x++) {
        [arrayOfPages insertObject:[NSNull null] atIndex:x];
    }
    
    pointOffset = CGPointMake(0, 0);
    mCurrentPage = 0;
    self.scrollView.delegate = self;
    
    constraintWidthContent = [NSLayoutConstraint constraintWithItem:self.viewContent attribute:NSLayoutAttributeWidth
        relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:2.0 constant:0.0];
    [self.view addConstraint:constraintWidthContent];
    self.viewContent.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.viewContent.frame.size.height);
    
    widthForPage = self.view.bounds.size.width;
    heightForPage = self.viewContent.frame.size.height;
    
    UIViewController *pageOne = [self.delegate viewControllerForPageAtIndex:0];
    pageOne.view.frame = CGRectMake(0, 0, widthForPage, heightForPage);
    [self addChildViewController:pageOne];
    [self.viewContent addSubview:pageOne.view];
    [pageOne didMoveToParentViewController:self];
    [arrayOfPages replaceObjectAtIndex:0 withObject:pageOne];
    
    UIViewController *pageTwo = [self.delegate viewControllerForPageAtIndex:1];
    pageTwo.view.frame = CGRectMake(widthForPage, 0, widthForPage, heightForPage);
    [self addChildViewController:pageTwo];
    [self.viewContent addSubview:pageTwo.view];
    [pageTwo didMoveToParentViewController:self];
    [arrayOfPages replaceObjectAtIndex:1 withObject:pageTwo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    CGFloat width = self.view.bounds.size.width;
    widthForPage = width;
    
    UIViewController *pageLeft = nil;
    UIViewController *pageRight = nil;
    if(mCurrentPage > 1) {pageLeft = [arrayOfPages objectAtIndex:(mCurrentPage - 1)];}
    UIViewController *pageCenter = [arrayOfPages objectAtIndex:mCurrentPage];
    if([arrayOfPages count] > (mCurrentPage + 1)) {pageRight = [arrayOfPages objectAtIndex:(mCurrentPage + 1)];}
    
    if(pageLeft != nil) {pageLeft.view.frame = CGRectMake(0, 0, width, heightForPage);}
    pageCenter.view.frame = CGRectMake(width, 0, width, heightForPage);
    if(pageRight != nil) {pageRight.view.frame = CGRectMake((width * 2), 0, width, heightForPage);}
        
    
    [self.scrollView scrollRectToVisible:pageCenter.view.frame animated:false];
}

#pragma mark ScrollViewDelegate protocol
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
   
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint pointOffsetNow = scrollView.contentOffset;
    
    int numberOfPages = self.numberOfPages;
    if(pointOffsetNow.x > pointOffset.x) {//scrolling to the right
        pointOffset = pointOffsetNow;
        if((mCurrentPage + 2) < numberOfPages) {
            
            static bool once = false;
            if(!once) {
                [self.view removeConstraint:constraintWidthContent];
                constraintWidthContent = [NSLayoutConstraint constraintWithItem:self.viewContent attribute:NSLayoutAttributeWidth
                    relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:3.0 constant:0.0];
                [self.view addConstraint:constraintWidthContent];
            }
            mCurrentPage++;
            UIViewController *page = [self.delegate viewControllerForPageAtIndex:mCurrentPage + 1];
            page.view.frame = CGRectMake(widthForPage * 2, 0, widthForPage, heightForPage);
            
            [arrayOfPages replaceObjectAtIndex:mCurrentPage + 1 withObject:page];
            
            [self addChildViewController:page];
            [self.viewContent addSubview:page.view];
            [page willMoveToParentViewController:self];
            
            if(mCurrentPage - 2 > numberOfPages) {
                UIViewController *pageRemove = [arrayOfPages objectAtIndex:(mCurrentPage - 2)];
                [pageRemove.view removeFromSuperview];
                [pageRemove removeFromParentViewController];
                [pageRemove didMoveToParentViewController:nil];
                
                [arrayOfPages replaceObjectAtIndex:mCurrentPage - 2 withObject:[NSNull null]];
            }
            
            UIViewController *left = nil;
            UIViewController *center = nil;
            UIViewController *right = nil;
            left = [arrayOfPages objectAtIndex:mCurrentPage - 1];
            center = [arrayOfPages objectAtIndex:mCurrentPage];
            right = [arrayOfPages objectAtIndex:mCurrentPage + 1];
                
            left.view.frame = CGRectMake(0, 0, widthForPage, heightForPage);
            center.view.frame = CGRectMake(widthForPage, 0, widthForPage, heightForPage);
            right.view.frame = CGRectMake(widthForPage * 2, 0, widthForPage, heightForPage);
            [self.scrollView scrollRectToVisible:center.view.frame animated:false];
            pointOffset = center.view.frame.origin;
        } else if(mCurrentPage + 1 < numberOfPages) {
            mCurrentPage++;
        }
            
    } else if(pointOffsetNow.x < pointOffset.x) {//scrolling to the left
        pointOffset = pointOffsetNow;
        if((mCurrentPage - 1) >= 0) {
            mCurrentPage--;
            UIViewController *page = [self.delegate viewControllerForPageAtIndex:mCurrentPage];
            page.view.frame = CGRectMake(0, 0, widthForPage, heightForPage);
            
            [arrayOfPages replaceObjectAtIndex:mCurrentPage withObject:page];
            
            [self addChildViewController:page];
            [self.viewContent addSubview:page.view];
            [page willMoveToParentViewController:self];
            
            if(mCurrentPage + 2 < numberOfPages) {
                UIViewController *pageRemove = [arrayOfPages objectAtIndex:(mCurrentPage + 2)];
                [pageRemove.view removeFromSuperview];
                [pageRemove removeFromParentViewController];
                [pageRemove didMoveToParentViewController:nil];
                
                [arrayOfPages replaceObjectAtIndex:mCurrentPage + 2 withObject:[NSNull null]];
            }
            
            UIViewController*left = nil;
            UIViewController *center = nil;
            UIViewController *right = nil;
            if(mCurrentPage - 1 >= 0) {left = [arrayOfPages objectAtIndex:mCurrentPage - 1];}
            center = [arrayOfPages objectAtIndex:mCurrentPage];
            if(mCurrentPage + 2 < numberOfPages) {right = [self.delegate viewControllerForPageAtIndex:mCurrentPage + 2];}
            if(left != nil) {
                left.view.frame = CGRectMake(0, 0, widthForPage, heightForPage);
                center.view.frame = CGRectMake(widthForPage, 0, widthForPage, heightForPage);
            } else {
                center.view.frame = CGRectMake(0, 0, widthForPage, heightForPage);
            }
            if(right != nil) {right.view.frame = CGRectMake(widthForPage * 2, 0, widthForPage, heightForPage);}
            [self.scrollView scrollRectToVisible:center.view.frame animated:false];
            pointOffset = center.view.frame.origin;
        }
    }
    //if pointOffsetNow.x == pointOffset.x means that the page was not changed,
    //there was scrolling but the scrollview snaped back to the current page (the scrollview is with paging enabled in IB)
}

@end
