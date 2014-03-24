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

#import "ViewController.h"
#import "PageVC.h"
#import "EtViewPagerVC.h"

@interface ViewController ()

@property(nonatomic)NSMutableArray *arrayPages;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.arrayPages = [[NSMutableArray alloc] init];
//    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    PageVC *pageFirst = [story instantiateViewControllerWithIdentifier:@"page_screen"];
//    PageVC *pageSecond = [story instantiateViewControllerWithIdentifier:@"page_screen"];
//    PageVC *pageThird = [story instantiateViewControllerWithIdentifier:@"page_screen"];
//    PageVC *pageFourth = [story instantiateViewControllerWithIdentifier:@"page_screen"];
//    PageVC *pageFifth = [story instantiateViewControllerWithIdentifier:@"page_screen"];
//    PageVC *pageSixth = [story instantiateViewControllerWithIdentifier:@"page_screen"];
//    [pageFirst.view setBackgroundColor:[UIColor blueColor]];
//    [pageSecond.view setBackgroundColor:[UIColor greenColor]];
//    [pageThird.view setBackgroundColor:[UIColor redColor]];
//    [pageFourth.view setBackgroundColor:[UIColor yellowColor]];
//    [pageFifth.view setBackgroundColor:[UIColor purpleColor]];
//    pageFirst.labelPageNumber.text = @"Page One";
//    pageSecond.labelPageNumber.text = @"Page Two";
//    pageThird.labelPageNumber.text = @"Page Three";
//    pageFourth.labelPageNumber.text = @"Page Four";
//    pageFifth.labelPageNumber.text = @"Page Five";
//    pageSixth.view.frame = CGRectMake(0, 0, 320, 480);
//    pageSixth.labelPageNumber.text = @"Page Six";
//    self.arrayPages = [[NSMutableArray alloc] init];
//    [self.arrayPages addObject:pageFirst];
//    [self.arrayPages addObject:pageSecond];
//    [self.arrayPages addObject:pageThird];
//    [self.arrayPages addObject:pageFourth];
//    [self.arrayPages addObject:pageFifth];
//    [self.arrayPages addObject:pageSixth];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    EtViewPagerVC *viewPager = [[EtViewPagerVC alloc] initWithNibName:@"EtViewPager" bundle:nil];
    viewPager.delegate = self;
    viewPager.numberOfPages = [self.arrayPages count];
    [self presentViewController:viewPager animated:true completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark EtViewPagerDelegate protocol
- (UIViewController *)viewControllerForPageAtIndex:(NSUInteger)aPageIndex
{
    //We can create all the ViewControllers we need as is done in the viewDidLoad method above, and then just return
    //from the instance array containing the ViewControllers (with the line below
    
    //return [self.arrayPages objectAtIndex:aPageIndex];
    
    //But the main advantage we have with this ViewPage Controller is that we don't need to have all the ViewControllers
    //alive and in memory. Only three ViewControllers need to be created at a time.
    //This is what is done in the lines below. We create and initialize with what ever custom initialization we need and
    //then pass it to the ViewPager Controller. After that when there are more than three ViewControllers in the
    //ViewPage Controller it releases ViewControllers to keep the count low.
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PageVC *page = [story instantiateViewControllerWithIdentifier:@"page_screen"];
    if(aPageIndex == 0) {
        [page.view setBackgroundColor:[UIColor blueColor]];
        page.labelPageNumber.text = @"Page One";
    } else if(aPageIndex == 1) {
        [page.view setBackgroundColor:[UIColor greenColor]];
        page.labelPageNumber.text = @"Page Two";
    } else if(aPageIndex == 2) {
        [page.view setBackgroundColor:[UIColor redColor]];
        page.labelPageNumber.text = @"Page Three";
    } else if(aPageIndex == 3) {
        [page.view setBackgroundColor:[UIColor yellowColor]];
        page.labelPageNumber.text = @"Page Four";
    } else if(aPageIndex == 4) {
        [page.view setBackgroundColor:[UIColor purpleColor]];
        page.labelPageNumber.text = @"Page Five";
    } else if(aPageIndex == 5) {
        [page.view setBackgroundColor:[UIColor whiteColor]];
        page.labelPageNumber.text = @"Page Six";
    }
    return page;
}

@end
