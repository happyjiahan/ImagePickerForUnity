//
//  PTAvatarPicker.m
//  AvatarPicker
//
//  Created by Jiahan on 2018/4/4.
//  Copyright © 2018 Jiahan. All rights reserved.
//

#import "PTImagePicker.h"

@interface PTImagePicker()

@property (nonatomic, copy) void (^completionCallback)(NSString * imageDataBase64String);

@end

@implementation PTImagePicker

- (void)PickImageFromPhotoLibrary
{
    [self PickImageFromPhotoLibraryWithCompletion:^(NSString *imageDataBase64String) {
        if (imageDataBase64String == nil)
        {
            imageDataBase64String = @"";
        }
        
        UnitySendMessage("PTImagePicker", "OnImagePickerCompleted", [imageDataBase64String UTF8String]);
    }];
}

- (void)PickImageFromPhotoLibraryWithCompletion:(void (^)(NSString * imageDataBase64String))completion
{
    self.completionCallback = completion;
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self handleRequestAuthorization:status];
        });
    }];
}

- (void)handleRequestAuthorization:(PHAuthorizationStatus)status
{
    if (PHAuthorizationStatusAuthorized == status)
    {
        [self showImagePicker];
    }
    else
    {
        if (self.completionCallback)
        {
            self.completionCallback(nil);
        }
    }
}

- (void)showImagePicker
{
    UIImagePickerController * ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:ipc.sourceType];
    
    ipc.delegate = self;
    ipc.allowsEditing = YES;
    
    UIViewController * root = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [root presentViewController:ipc animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage * editedImage = [info valueForKey:@"UIImagePickerControllerEditedImage"];
    NSData * imageData = nil;
    
    NSString * ext = [self getImageExtFromInfo:info];
    if ([ext isEqualToString:@"jpeg"])
    {
        imageData = UIImageJPEGRepresentation(editedImage, 1);
    }
    else
    {
        imageData = UIImagePNGRepresentation(editedImage);
    }
    

    if (self.completionCallback)
    {
        NSString * dataString = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        self.completionCallback(dataString);
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if (self.completionCallback)
    {
        self.completionCallback(nil);
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (NSString *)getImageExtFromInfo:(NSDictionary<NSString *,id> *)info
{
    NSString * url = nil;
    if (@available(iOS 11, *))
    {
        // iOS 11 (or newer)
        url = [info valueForKey:@"UIImagePickerControllerImageURL"];
    }
    else
    {
        // iOS 10 or older code
        url = [info valueForKey:@"UIImagePickerControllerReferenceURL"];
    }
    
    NSString * ext = [[url pathExtension] lowercaseString];
    return ext;
}


@end


extern "C" {
    static PTImagePicker * s_picker;
    
    void PickImageFromPhotoLibrary()
    {
        if (s_picker == nil)
        {
            s_picker = [[PTImagePicker alloc] init];
        }
        
        [s_picker PickImageFromPhotoLibrary];
    }
}
