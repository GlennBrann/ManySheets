# ManySheets
> A list of SwiftUI Bottom Sheet components

[![SwiftPM compatible](https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![Swift Version][swift-image]][swift-url]
[![License][license-image]][license-url]

ManySheets has a list of custom SwiftUI Bottom Sheet components.

1. **DefaultBottomSheet:** A dynamic bottom sheet that scales based on content height inside.
2. **ScaffoldBottomSheet:** A scaffolding bottom sheet with three positions (top, middle, bottom).

See below for examples and customization.

## Installation

### Requirements
* iOS 14.0+
* Xcode 13+
* Swift 5+

# Swift Package Manager

In Xcode, select: `File > Swift Packages > Add Package Dependency`.

Paste the package github url in the search bar `https://github.com/GlennBrann/ManySheets` and press next and follow instructions given via Xcode to complete installation.

You can then add ManySheets to your file by adding `import ManySheets`.

**Or**

Add this project on your `Package.swift`

```swift
import PackageDescription

let package = Package(
    dependencies: [
        .Package(url: "https://https://github.com/GlennBrann/ManySheets.git", from: "1.2.0")
    ]
)
```

## DefaultBottomSheet
The DefaultBottomSheet is a basic bottom sheet that scales automatically depending on the content size within. You can add it directly into your view like so

```swift
DefaultBottomSheet(isOpen: style: options: content:)
```
or via the modifier
```swift
View().defaultBottomSheet(isOpen: style: options: content:)
```
### Parameters:
* `isOpen` - A binding used to display the bottom sheet.
* `style` - A property containing all bottom sheet styling `DefaultBottomSheetStyle`
* `options` - An array that contains the bottom sheet options `DefaultBottomSheetOptions.Options`
* `content` - A ViewBuilder used to set the content of the bottom sheet.

## DefaultBottomSheet - Example

![Simulator Screen Recording - iPhone 12 mini - 2021-09-19 at 17 08 30](https://user-images.githubusercontent.com/5156285/133943094-5dfb5e71-80e5-4872-8496-daa28412e3a7.gif)

```swift
import SwiftUI
import ManySheets

struct DefaultBottomSheetExample: View {
    
    @State var showSheet: Bool = false
    
    let bottomSheetStyle = DefaultBottomSheetStyle(backgroundColor: .white)
    
    var body: some View {
        ZStack {
            VStack {
                Button(action: { showSheet.toggle() },
                       label: { Text("Show Default Sheet") })
            }
            DefaultBottomSheet(
                isOpen: $showSheet,
                style: bottomSheetStyle,
                options: [.enableHandleBar, .tapAwayToDismiss, .swipeToDismiss]
            ) {
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        Image(systemName: "info.circle")
                        Text("Photos attached must be of cats and cats only")
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.bottom, 4)
                    Button(
                        action: { },
                        label: {
                            HStack {
                                Image(systemName: "camera")
                                    .foregroundColor(Color.blue)
                                Text("Take a photo")
                            }
                        }
                    )
                    .frame(height: 44)
                    Button(
                        action: { },
                        label: {
                            HStack {
                                Image(systemName: "photo.on.rectangle")
                                    .foregroundColor(Color.blue)
                                Text("Choose a photo")
                            }
                        }
                    )
                    .frame(height: 44)
                }
                .padding()
                .padding(.bottom, 16)
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}
```

## ScaffoldBottomSheet
The ScaffoldBottomSheet is a bottom sheet that has three positions `top`, `middle`, and `bottom`. This bottom sheet can scroll content when fully open. This can be disabled by adding the `.disableScroll` option.

```swift
ScaffoldBottomSheet(isOpen: style: options: positions: defaultPosition: headerContent: bodyContent:)
```
or via the modifier
```swift
View().scaffoldBottomSheet(isOpen: style: options: positions: defaultPosition: headerContent: bodyContent:)
```
### Parameters:
* `isOpen` - A binding used to display the scaffold bottom sheet.
* `style` - A property containing all scaffold bottom sheet styling `ScaffoldBottomSheetStyle`
* `options` - An array that contains the bottom sheet options `ScaffoldBottomSheet.Options`
* `positions` - A `ScaffoldBottomSheetPositions`struct containing the `top`, `middle`, and `bottom` height percentages. **Note: these values must be decimal representations of percentages** i.e ((middle: 0.5) = 50% height)
* `defaultPosition` - The default position the scaffold bottom sheet will be in when isOpen from a closed state.
* `headerContent` - An optional header content view builder
* `bodyContent` - A ViewBuilder used to set the body content of the scaffold bottom sheet.

## ScaffoldBottomSheet - Example

![Simulator Screen Recording - iPhone 12 mini - 2021-09-19 at 18 07 20](https://user-images.githubusercontent.com/5156285/133944541-ff4d1e45-f592-400e-b2e9-7a564f785626.gif)


```swift
import SwiftUI
import ManySheets

struct ContentView: View {
    
    @State var showSheet: Bool = false
    
    let bottomSheetStyle = ScaffoldBottomSheetStyle(backgroundColor: .white)
    let positions = ScaffoldBottomSheetPositions(top: 1, middle: 0.5, bottom: 0.13)
    
    var body: some View {
        ZStack {
            VStack {
                Button(action: { showSheet.toggle() },
                       label: { Text("Show Scaffold Sheet") })
            }
            ScaffoldBottomSheet(
                isOpen: $showSheet,
                style: bottomSheetStyle,
                options: [.enableHandleBar, .tapAwayToDismiss, .swipeToDismiss],
                positions: positions,
                defaultPosition: .bottom,
                headerContent: {
                    VStack(alignment: .leading) {
                        HStack {
                            Image("image")
                                .resizable()
                                .frame(width: 32, height: 32)
                            VStack(alignment: .leading) {
                                Text("Hello world")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                Text("4:20pm")
                                    .font(.caption2)
                            }
                            Spacer()
                            Button(action: { },
                                   label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(Color.gray.opacity(0.5))
                                   })
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 4)
                        Divider()
                    }
                    .buttonStyle(PlainButtonStyle())
                },
                bodyContent: {
                    HStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.12))
                            .frame(width: 64, height: 64)
                            .overlay(Image(systemName: "camera").foregroundColor(Color.blue))
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.12))
                            .frame(width: 64, height: 64)
                            .overlay(Image(systemName: "sun.max.fill").foregroundColor(Color.yellow))
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.12))
                            .frame(width: 64, height: 64)
                            .overlay(Image(systemName: "photo").foregroundColor(Color.red))
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.12))
                            .frame(width: 64, height: 64)
                            .overlay(Image(systemName: "trash").foregroundColor(Color.green))
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.12))
                            .frame(width: 64, height: 64)
                            .overlay(Image(systemName: "snow").foregroundColor(Color.orange))
                        Spacer()
                    }
                    .padding()
                    
                    ForEach(["Hello", "World", "Nice", "Bottom", "Sheet", "Many", "Sheets"], id: \.self) { text in
                        VStack {
                            HStack {
                                Text(text)
                                Spacer()
                                Image(systemName: "camera")
                            }
                            .frame(height: 32)
                            .padding(.horizontal, 24)
                            Divider()
                        }
                    }
                    
                    Text("This is a description with a lot of text that should wrap and fill properly repeating.This is a description with a lot of text that should wrap and fill properly repeating.This is a description with a lot of text that should wrap and fill properly repeating.This is a description with a lot of text that should wrap and fill properly repeating.")
                        .padding()
                })
        }
    }
}
```


## Release History
(No major rhyme or reason to these releases)
* 1.0.0
    * CHANGE: Added DefaultBottomSheet and ScaffoldBottomSheet
* 1.0.1
    * CHANGE: Setting minimum iOS version to iOS 14. More stable
* 1.0.2
    * CHANGE: Bug fix for compiler error and Color.black.opacity()
* 1.1.0
    * CHANGE: XC 13 minimum + other things
* 1.2.1
    * CHANGE: Compiles against iOS 14 + ExampleApp workspace  


## License

ManySheets is available under the MIT license. See the LICENSE file for more info.

[swift-image]:https://img.shields.io/badge/swift-5.3-orange.svg
[swift-url]: https://swift.org/
[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: LICENSE
