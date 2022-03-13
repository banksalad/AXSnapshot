# AXSnapshot [![.github/workflows/test.yml](https://github.com/e-sung/AXSnapshot/actions/workflows/test.yml/badge.svg)](https://github.com/e-sung/AXSnapshot/actions/workflows/test.yml) 

Text Formatted Snapshot for Accessibility Experience Testing

## Usage 

접근성 사용자 경험만큼, 유닛테스트를 하기 적절한 부분도 없습니다. 
그리고 `AXSnapshot`은, 그것을 아주 쉽게 만들어줍니다. 

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

## 설치 

### CocoaPods

Cocoapods을 사용하신다면, Podfile에서 원하시는 테스트 타겟 아래에, `AXSnapshot` pod을 다음과 같이 추가해주세요.

```ruby
target 'MyAppTests' do
  pod 'AXSnapshot', '~> 1.0.0'
end
```

### SwiftPackageManager

SwiftPM을 쓰고 계신다면, `AXSnapshot`을 Package.swift의 `dependencies`에 다음과 같이 추가해주세요.

```swift
dependencies: [
  .package(
    url: "https://github.com/e-sung/AXSnapshot.git",
    from: "1.0.0"
  ),
]
```

그리고 실제 Test Target의 dependencies에 `AXSnapshot`을 다음과 같이 추가해주세요.

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

### 쉬워요

많은 사람들이 UI 레이어는 테스트하기 힘들다고 생각합니다. 
예를 들어, 다음과 같은 ViewController가 있다고 해보죠.

```swift
class MyViewController {
    private let headerView = MyHeaderView()
    private let contentView = MyContentView()
}
```

이 ViewController에 우리가 원하는 정보가 기대한 형태대로 잘 표시되고 있는지를 어떻게 확인 하고 싶을 수 있습니다.
하지만 그런 로직은 다음과 같은 테스트로는 검증 할 수 _**없습니다**__. 

```swift
func testMyViewController() async throws {
    let viewController = MyViewController()
    let viewModel = MyViewModel()
    viewController.bind(with: viewModel)
    
    await viewModel.doSomeBusinessLogic()
    
    // `headerView` 가 `private`니까 테스트코드에서 접근 할 수 없습니다. 
    // 이 것을 테스트하려면, 은닉성의 일부를 포기해야만 합니다. 
    XCTAssert(viewController.headerView.headerText == "Final Result")
}
```
왜냐하면 테스트 코드에서는 ViewController의 속성 대부분에 접근 할 수 없기 떄문입니다. `@testable import` 를 사용하더라도 말이죠. 

심지어 은닉성의 일부를 포기하고, 접근제한자를 `private`에서 `internal`로 바꾼다고 해도, 많은 문제가 남습니다. 
예컨대, 해당 ViewController에 대해 간단한 리팩토링을 하면서 변수 이름만 수정한다고 해봅시다. 
테스트코드가 ViewController의 변수명에 의존하고 있기 떄문에, 그런 수정이 발생하면 **테스트코드도 수정해야 합니다**.
유저에게 실제로 영향이 가는 스펙 차원의 수정이 없는데도 테스트코드를 수정해야 한다니... 귀찮은 일이 아닐 수 없습니다!

하지만, 여러분이 만약 *비주얼* 한 UI 레이어 대신, `접근성 경험`을 테스트하신다면, 이런 많은 문제들로부터 해방되실 수 있습니다. 
왜냐하면, 여러분이 어떤 변수로 어떤 방식으로 UI를 구성했는지와 상관 없이, 모든 UIView/UIViewController는 결국 일차원의 "접근성 요소들의 배열"로 해석 될 수 있기 떄문입니다.
이게 무슨 소리인지 가장 잘 이해할 수 있는 방법은, 다음 동영상에서와 같이, VoiceOver에서 `Item Chooser` 기능을 사용해 보는 것입니다. 
(`Item Chooser`는 "두 손가락으로 세 번 탭" 하여 사용 할 수 있습니다.)


https://user-images.githubusercontent.com/4796743/158012249-9d3d70cb-8f1d-4532-9cd1-2c2a3ffeecb4.mp4


### 가장 많이 테스트 할 수 있어요

또한, 만약 여러분이 다음 그림과 같은, "MVVM" 패턴을 사용하고 있다고 한다면,


![View-ViewModel-Model](https://user-images.githubusercontent.com/4796743/158011596-9ccfd732-c4e7-4534-bf64-ebae22fec39f.png)

높은 확률로 여러분은 `ViewModel`을 테스트하고 있을 것입니다. 그래야 `ViewModel`뿐만이 아닌, `Model`레이어, 그리고 `ViewModel-Model`의 연결까지 테스트 할 수 있기 때문이죠. 다음 그림과 같이 말이에요.


![Test covering ViewModel, Model, and binding between Model-ViewModel](https://user-images.githubusercontent.com/4796743/158013491-f0e72650-a7a3-492b-95ca-67534f0705cf.png)

이런 전략은 유효하지만, 여전히 `View-ViewModel` 사이의 연결은 커버하지 못합니다. 그리고 이 연결 부분은 누락되거나 중복되어 많은 버그를 유발할 수 있는 곳이기도 합니다.

이 떄 만약 여러분이 `UIView/UIViewController`의 `접근성 경험`을 테스트하신다면, 여러분은 테스트의 커버리지를 `View-ViewModel`간의 연결, 그리고 나아가 최소한 View의 로직 일부분까지 확대 할 수 있습니다. 

![Test covering ViewModel, Model, binding between Model-ViewModel View-ViewModel and some part of View ](https://user-images.githubusercontent.com/4796743/158013511-d1029cec-cae4-4440-a5ee-6d05b86b03ec.png)

### 중요해요

무엇보다도, 접근성 지원은 **중요합니다**. 접근성은 시간이 남을 때 선심으로 지원하는 것이 아닙니다. 그것은 기본입니다. 
어떤 누구라도 그 앱에서 정보에 접근 할 수 없다면, 그 앱은 완성되었다고 볼 수 없습니다. 
왜냐하면, 당신의 앱을 쓰는 그 어떤 누구라도, 그의 장애나 환경을 막론하고, 다른 모든 사람들 만큼 중요하기 때문입니다.
당신이 존중받을 인간인 딱 그 만큼, 장애를 가진 어떤 누구도 딱 그 만큼 존중받아야 하기 때문입니다.   

하지만 현실적으로, 접근성 지원 여부는 수동 테스트에서 누락되기 가장 쉬운 것들 중 하나입니다.
당신의 모든 테스터들이, 동료들이 VoiceOver를 익숙하게 다룰 수 있을거라고 기대하기는 어렵습니다.
당신의 후임자가 접근성에 대해 잘 이해하고 있을 거라고 기대하기는 더욱 어렵습니다.

그렇기 때문에, 충분한 시간동안 접근성에 관한 문제가 회귀하지 않을 수 있도록 보장하기 위해서는, 자동화된 테스트가 필수적입니다.  

## How it Works 

UIView 객체는, 그 자신이 모든 [responder-chain](https://www.google.com/search?client=safari&rls=en&q=responder+chain&ie=UTF-8&oe=UTF-8) 에서 가장 첫번째인 [accessibilityElement](https://developer.apple.com/documentation/objectivec/nsobject/1615141-isaccessibilityelement) 일 때, VoiceOver와 같은 Assistive Technology(AT)에 노출됩니다.

![Diagram of UIView hierarchy](https://user-images.githubusercontent.com/4796743/158020789-42fd6873-258c-47cb-9929-9b3cd0fc12d6.png)

요런 컨셉을 바탕으로, 우리는 `isExposedToAssistiveTech` 로직을 다음과 같이 구성 할 수 있습니다. 

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

이게 핵십입니다!

나머지는 모든 UIView 트리를 순환하면서, AT에 노출된 UIView들을 필터링하고, [accessibilityLabel](https://www.google.com/search?client=safari&rls=en&q=accesbilitylabel&ie=UTF-8&oe=UTF-8)과 같이 각 UIView들이 AT에 노출하는 정보를 적절히 포매팅 하는 일 뿐입니다.

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

기본적인 각 요소별 포매팅 행동은  [generateAccessibilityDescription](https://github.com/e-sung/AXSnapshot/blob/main/Sources/AXSnapshot/AccessibilityDescription.swift) 클로저에 선언되어 있습니다. 원하는 포매팅 행동을 바꾸고자 할 떄는, 이 클로저를 바꾸면 됩니다! 




## License

```
MIT License

Copyright (c) 2022 SungdooYoo

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





