# AXSnapshot [![.github/workflows/test.yml](https://github.com/e-sung/AXSnapshot/actions/workflows/test.yml/badge.svg)](https://github.com/e-sung/AXSnapshot/actions/workflows/test.yml) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fe-sung%2FAXSnapshot%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/e-sung/AXSnapshot) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fe-sung%2FAXSnapshot%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/e-sung/AXSnapshot)

Text Formatted Snapshot for Accessibility Experience Testing

> Language Switch: [한국어](https://github.com/e-sung/AXSnapshot/blob/main/README_KR.md).

## Requirements

- iOS 9.0+ 
- Swift 5.0

## Usage 

Accessibility User Experience is the [sweet spot](#why) for unit testing. 
`AXSnapshot` makes it super easy to do just that.

```swift
func testMyViewController() async throws {
    let viewController = MyViewController()
    await viewController.doSomeBusinessLogic()
    
    XCTAssert(
        viewController.axSnapshot() == """
        ------------------------------------------------------------
        Final Result
        button, header
        Double Tap to see detail result
        Actions: Retry
        ------------------------------------------------------------
        The question is, The answer to the Life, the Universe, and Everything
        button
        ------------------------------------------------------------
        The answer is, 42
        button
        ------------------------------------------------------------
        """
    )
}
```

## Installation 

### CocoaPods

If your project uses CocoaPods, add the pod to any applicable test targets in your Podfile:

```ruby
target 'MyAppTests' do
  pod 'AXSnapshot', '~> 1.0.0'
end
```

### SwiftPackageManager

If you want to use AXSnapshot in any other project that uses SwiftPM, add the package as a dependency in Package.swift:

```swift
dependencies: [
  .package(
    url: "https://github.com/banksalad/AXSnapshot.git",
    from: "1.0.0"
  ),
]
```

Next, add AXSnapshot as a dependency of your test target:

```swift
targets: [
  .target(name: "MyApp"),
  .testTarget(
    name: "MyAppTests",
    dependencies: [
      "MyApp",
      .product(name: "AXSnapshot", package: "AXSnapshot"),
    ]
  )
]
```

## Why

### Because it's easy to test

Many people think UI layer is hard to unit-test. 

For Example, if you have ViewController like below,

```swift
class MyViewController {
    private let headerView = MyHeaderView()
    private let contentView = MyContentView()
}
```

you _**cannot**_ test it like following

```swift
func testMyViewController() async throws {
    let viewController = MyViewController()
    let viewModel = MyViewModel()
    viewController.bind(with: viewModel)
    
    await viewModel.doSomeBusinessLogic()
    
    // This Test cannot be build, because `headerView` property is private 
    // To build this test, you have to give up some of encapsulation
    XCTAssert(viewController.headerView.headerText == "Final Result")
}
```
because most of the properties that can be tested are not accessible, even with `@testable import` annotation.

Moreover, even if you change the access level of the properties to `internal`, some problems remain.
For example, if you want to do the quick refactoring that changes the name of the properties, 
implementation of the _**test has to be changed too**_, even if there is no change to the spec that the end-user can perceive. How annoying!

But, if you test the `Accessibility Experience`, instead of implementation details of *visual* UI Layer, most of those problems can be solved.
Because regardless of the visual ui-layer implementation, any view/viewController ultimately can be represented as `One-dimensional list of accessibilityElements`. 
The best way to understand what this means is using `Item Chooser` in VoiceOver with "two-finger, three taps" gesture. 



https://user-images.githubusercontent.com/4796743/158012249-9d3d70cb-8f1d-4532-9cd1-2c2a3ffeecb4.mp4


### Because it can test most

Also, if you are using "MVVM" pattern like following


![View-ViewModel-Model](https://user-images.githubusercontent.com/4796743/158011596-9ccfd732-c4e7-4534-bf64-ebae22fec39f.png)

You are most likely testing `ViewModel`, because by testing `ViewModel`, you can not only test `ViewModel`, but also test `Model` and binding between Model-ViewModel like following diagram.


![Test covering ViewModel, Model, and binding between Model-ViewModel](https://user-images.githubusercontent.com/4796743/158013491-f0e72650-a7a3-492b-95ca-67534f0705cf.png)

This stratedgy works, but it still cannot cover `binding between View-ViewModel`, where many potential bugs can occur. 

But if you test `Accessibility Experience` of `UIView/UIViewController`, you can stretch the test-coverage to the `binding between View-ViewModel` and at least some of `View` logics.

![Test covering ViewModel, Model, binding between Model-ViewModel View-ViewModel and some part of View ](https://user-images.githubusercontent.com/4796743/158013511-d1029cec-cae4-4440-a5ee-6d05b86b03ec.png)

### Because it matters 

Last but not least, accessibility **matters**. Accessibility is not _good to have_. It's the bottom line. 
If your app is not accessble to anyone, your app is simply not production-ready. 
Because any of your user, regardless of her/his disability, matters just as much as any other user, because they are as much as human as anyone.

But still, accessibility is one of the easiest things to be neglected during manual testing. 
It's hard to expect all of your testers, co-workers are familiar with VoiceOver. 
It's even harder to expect your successor of the project is familiar with accessibility.

So, to ensure there's no regression in accessibility for a good period of time, it is very important to test it automatically. 

## How it Works 

An `UIView` can be exposed to AssitiveTechnology when it is the first [accessibilityElement](https://developer.apple.com/documentation/objectivec/nsobject/1615141-isaccessibilityelement) in whole [responder-chain](https://www.google.com/search?client=safari&rls=en&q=responder+chain&ie=UTF-8&oe=UTF-8)

![Diagram of UIView hierarchy](https://user-images.githubusercontent.com/4796743/158020789-42fd6873-258c-47cb-9929-9b3cd0fc12d6.png)

So, with this concept in mind, we can build `isExposedToAssistiveTech` logic like this 

```swift 
extension UIResponder {
    var isExposedToAssistiveTech: Bool {
        if isAccessibilityElement {
            if allItemsInResponderChain.contains(where: { $0.isExposedToAssistiveTech }) == true {
                return false
            } else {
                return true
            }
        } else {
            return false
        }
    }
}
```

That's the gist of it! 

The rest is just traversing all the UIView tree, and filtering views that are `exposedToAssistiveTech`, and formatting it's informations for assistiveTechnology such as [accessibilityLabel](https://www.google.com/search?client=safari&rls=en&q=accesbilitylabel&ie=UTF-8&oe=UTF-8)

```swift
public extension UIView {
    /// Generate text-formatted snapshot of accessibility experience
    func axSnapshot() -> String {
        let exposedAccessibleViews = allSubViews().filter { $0.isExposedToAssistiveTech } 
        let descriptions = exposedAccessibleViews.map { element in
            // Do some formatting on each element
            element.accessibilityDescription
        }
        // Do some formatting on whole `descriptions`
        return description
    }
```

The default formatting behavior for each item is declared in [generateAccessibilityDescription](https://github.com/e-sung/AXSnapshot/blob/main/Sources/AXSnapshot/AccessibilityDescription.swift) closure. To customize formatting behavior, you can replace this closure anyway you want! 




## License

```
MIT License

Copyright (c) 2022 Banksalad Co., Ltd.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```





