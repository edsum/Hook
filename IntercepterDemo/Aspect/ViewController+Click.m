//
//  ViewController+Click.m
//  IntercepterDemo
//
//  Created by Iean on 2017/5/30.
//  Copyright © 2017年 teacher. All rights reserved.
//

#import "ViewController+Click.h"
#import "Aspects.h"


@implementation ViewController (Click)

- (void)clickAction;
{
    UIViewController *testController = [[UIImagePickerController alloc] init];
    
    // We are interested in being notified when the controller is being dismissed.
    NSError *error1 = NULL;
    [testController aspect_hookSelector:@selector(viewWillDisappear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info, BOOL animated){
        UIViewController *controller = [info instance];
        if (controller.isBeingDismissed || controller.isMovingFromParentViewController) {
            [[[UIAlertView alloc] initWithTitle:@"Poped" message:@"Hello from Aspects" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
        }
    } error:&error1];
    
    // Hooking dealloc is delicate, only AspectPositionBefore will work here.
    NSError *error2 = NULL;
    [testController aspect_hookSelector:NSSelectorFromString(@"dealloc") withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> info ){
        NSLog(@"Controller is about to be deallocated: %@", [info instance]);
    } error:&error2];
}

@end
