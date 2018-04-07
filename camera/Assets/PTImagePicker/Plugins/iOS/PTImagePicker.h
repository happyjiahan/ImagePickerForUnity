//
//  PTAvatarPicker.h
//  AvatarPicker
//
//  Created by Jiahan on 2018/4/4.
//  Copyright © 2018 Jiahan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface PTImagePicker : NSObject <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

- (void)PickImageFromPhotoLibrary;

@end


