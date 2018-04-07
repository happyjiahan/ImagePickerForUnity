title: iOS Image Picker for Unity
date:2018-04-07 18:36:41
# iOS Image Picker for Unity
近日有朋友咨询我如何在 Unity 里面从 iOS 的相册里面获取图片，这个功能从 iOS Native 层面本身非常容易实现，网上也有一些类似的例子，但是，由于这些代码很多没有维护，使用了一些已经被废弃的 iOS API，也没有考虑 iOS 新引入的访问权限申请相关的事情。所以，我自己写了一个类似的插件[Image Picker for Unity](https://github.com/happyjiahan/ImagePickerForUnity)，给朋友们使用，GitHub 上有 Unity 工程的 Demo。

# 实现思路
我们需要实现一个 iOS Native Plugin，首先在 Unity 层面调用一个 C# Wrapper 的 API，这个 API 会转调 iOS Objective-C 代码，如果使用 iOS Native的功能获取图片，然后将获取的图片数据以 Base64 字符串的形式传递给 Unity 层面，然后 Unity 层面使用这些图片数据构建一个 Texture2D 的对象，到这一步，我们的工作就完成了。
特别需要注意的是，最新的 iOS 要求我们在使用相册 API 时必须首先申请权限，并且在 Info.plist 里面声明相关的 Privacy Usage Description。

# 如何使用
1. 把 PTImagePicker.prefab 拖拽到需要使用的场景里；
2. 使用类似于下面的方式调用该功能：
```
  public void openAlbum()
        {
            PTImagePicker picker = GameObject.Find("PTImagePicker").GetComponent<PTImagePicker>();
            picker.PickImage(imageBytes =>
            {
                Texture2D tex = new Texture2D(1, 1);
                tex.LoadImage(imageBytes);
                img.texture = tex;
            });
        }
```
3. done.

# 总结
iOS Image Picker for Unity 实现起来还是很容易的，只是太长时间没有写 iOS 代码了，有些手生。最后，以 Base64 字符串的形式把图片数据传递给 Unity 层面其实并不是一个最完美的方式，因为这种格式的转换在性能上不是最好的方式。但是，在通常情况下这都不会是性能瓶颈。一种性能上比较好的方式是使用 C# Marshal 来传递 Native 数据，但是这种方式需要额外的知识，我也不算熟悉，故没有采用这种方式。
