# AXSnapshot

Text Formatted Snapshot of Accessibility Experience 

## Usage 

Accessibility User Experience is the sweetest spot for unit testing. 
AXSnapshot makes it super easy to test just that.

```swift
func testMyViewController() throws {
    let viewController = MyViewController()
    
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


