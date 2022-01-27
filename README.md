# 자산관리 앱 만들기

## 구현

### 1) 구현 기능
- swiftUI

### 2) 기본 개념

#### (1) SwiftUI

> 명령형(어떻게)_imperative 이 아닌 선언형(무엇을)_declarative
<https://docs.microsoft.com/en-us/answers/questions/211050/declarative-vs-imperative-language.html>

- view, layout, control 을 struct 로 제공
- event handler, app model (data flow) 관리 => 데이터 흐름의 일원화
- !== UIKit's View, *Views are a function of state*

##### Property Wrapper

| @state      | @ObservableObject |
| ----------- | ----------------- |
| View-local  | External          |
| Value type  | Reference type    |
| Framework   | Developer Manage  |

##### data flow

<img src="https://docs-assets.developer.apple.com/published/4fee13b0ffd4854249fa6d4740449865/13300/SwiftUI-SaDF-Overview@2x.png">

SwiftUI offers a declarative approach to user interface design. As you compose a hierarchy of views, you also indicate data dependencies for the views. When the data changes, either due to an external event of because of an action taken by the user, SwiftUI automativally updates the affected parts of the interface. As a result, the framework automarically performs most of the work traditionally done by view controllers.
<https://developer.apple.com/documentation/swiftui/state-and-data-flow>

##### begin

```swift
struct myView: View {
    var body: some View {  // protocol을 준수하고 있고 어떤 특정 뷰가 될지는 이하 body 속성에 의해 결정될 것
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}
```

1. ViewModifier
> A modifier that you apply to a view or another view modifier, producing a different version of the original value.

특정 view 에서 호출되는 메소드
view 계층에서 변경된 새로운 뷰를 반환한다.
SwiftUI는 다양한 메소드 세트를 제공하여 view protocol을 확장한다.
view protocol을 준수하는 객체는 이러한 메소드 세트에 access 할 수 있다.

2. Container View

- (Lazy)VStack
- (Lazy)HStack
- ZStack: A view that overlays its children, alighning them in both axes

<img src="https://docs-assets.developer.apple.com/published/5cda30e96043531837daece8016db51b/13300/Building-Layouts-with-Stack-Views-2~dark@2x.png">

A ZStack contains an Image view that displays a profile picture with a semi-transparent HStack overlaid on top. The HStack contains a VStack with a pair of Text views inside it, and a Spacer view pushes the VStack to the leading side.

LazyStack
A view that arranges its children in al ine that grows vertically/horizontally, creating items only as needed which doesn't create items until it needs to render them onscreen.

- LazyVGrid
- LazyHGrid : 스크롤링 필요할 경우 scroll view 위에 올려야 함 (stack 또한 마찬가지)

- List: Devider, picker control 자동 포함되기 때문에 stack과는 차이가 있고 수정/삭제에 적합한 메소드 지원 (lazy)
- Form: 기본 설정 화면 구축에 좋은 view (platform에 적합한 방식으로 표현된다.)

- Section
- Group

3. Spacer
4. Devider View

### 3) 새롭게 알게 된 것

- SwiftUI 는 기존의 애플 UI 프레임워크와 호환이 가능하다. 

- SwiftUI로 만든 View를 rootView로 지정하기

> SceneDelegate

```swift
func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    let contentView = ContentView() // SwiftUI struct
        if let windownScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windownScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
```

- backslash dot (\.)
> key-path-expression swift4.0+

Keypaths are designed to allow you to refer to properties without actually invoking them - you hold a reference to the property itself, rather than reading its value

<https://techblog.woowahan.com/2715/>
<https://www.hackingwithswift.com/articles/57/how-swift-keypaths-let-us-write-more-natural-code>

Keypaths allow us to use them as adapters for very different data types- i.e., allow them to be treated the same even though they aren't the same. 

swiftUI 에서 List를 init할 때, id가 KeyPath를 요구하길래, 궁금해져서 찾아보았다.
```swift
init<Data, ID, RowContent>(_ data: Data, id: KeyPath<Data.Element, ID>, selection: Binding<SelectionValue?>?, rowContent: @escaping (Data.Element) -> RowContent) where Content == ForEach<Data, ID, RowContent>, Data : RandomAccessCollection, ID : Hashable, RowContent : View
```

- image content mode fit vs fill
  - fit: stretch as large as but make sure while keeping its original aspect ratio
  - fill: stretch as large as it can go, cropping off any parts that don't fit (losing some edges)
<https://www.hackingwithswift.com/example-code/uikit/how-to-adjust-image-content-mode-using-aspect-fill-aspect-fit-and-scaling>

- swift UI 로 만든 view로 이동하기 위해 ViewController instantiate
  - *UIHostingController(rootView:)*
  - 
