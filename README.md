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

##### 기본 용어 설명

```swift
struct myView: View {
    var body: some View {  // protocol을 준수하고 있고 어떤 특정 뷰가 될지는 이하 body 속성에 의해 결정될 것
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}
```

1. ViewModifier

> A modifier that you apply to a view or another view modifier, producing a different version of the original value.

특정 view 에서 메소드 처럼 호출하여
view 계층에서 변경된 새로운 뷰를 반환할 수 있게 한다.
view protocol을 확장시킨다.

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

- TabView
```swift
 var body: some View {
        TabView(selection: .constant(1),
                content:  {
                    Text("Tab Content 1").tabItem { /*@START_MENU_TOKEN@*/Text("Tab Label 1")/*@END_MENU_TOKEN@*/ }.tag(1)
                    Text("Tab Content 2").tabItem { /*@START_MENU_TOKEN@*/Text("Tab Label 2")/*@END_MENU_TOKEN@*/ }.tag(2)
                })
    }
```

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

#### @State, @Binding, @Published, @ObservedObject, @EnvironmentObject

> SwiftUI는 데이터 주도 방식으로 앱 개발을 하는데, 사용자 인터페이스 내의 뷰들은 기본 데이터 변경에 따른 처리 코드를 작성하지 않아도 뷰가 업데이트된다. 이것은 데이터와 사용자 인터페이스 내의 뷰 사이에 publisher & subscriber 를 구축하여 할 수 있다.

- @State
A property wrapper type that can read and write a value managed by SwiftUI
*SwiftUI manages the storage of any property you declare as a state.*
*When the state value changes, the view invalidates its appearance and recomptes the body.*
User the state as the single source of truth for a given view.

You should only access a state property from inside the view's body, or from methods called by it.
For this reason, declare your state properties as private, to prevent clients of your view from accessing them. 

To pass a state property to another view in the view hierarchy, use the variable name with the $ prifix operator. This retrieves a binding of the state property from its projectedValue property.

```swift
struct ContentView: View {
    @State private var wifiEnabled = true
    @State private var userName = ""

    var body: some View {
        VStack {
            Toggle(isOn: $wifiEnabled) {
                Text("Enable Wi-Fi")
            }
            TextField("Enter user name", text: $userName)
            Text(userName)  // 상태 프로퍼티에 할당된 값을 참조하려 사용하므로 $가 없다
            //Image(systemName: wifiEnabled ? "wifi" : "wifi.slash")
        }
    }
}
```

상태에 대한 가장 기본적인 형태
뷰 레이아웃의 현재 상태 (토글 버튼 활성화 여부/텍스트 필드의 텍스트, 피커 뷰의 현재 선택 등)
String, Int 같은 간단한 데이터 타입을 저장한다.
뷰 내부에서만 사용하기 때문에 *private*으로 선언하고 해당 변수 값이 변경되면 view를 rerender
뷰 전체가 다시 렌더링되는 것을 막기위해 하위 뷰로 데이터 변동 뷰만 빼낸다.
하위 뷰나 다른 뷰에서 참조하기 위해선 @Binding 해야 한다

```swift
struct PlayerView: View {
    var episode: Episode
    @State private var isPlaying: Bool = false

    var body: some View {
        VStack {
            Text(episode.title)
            Text(episode.showTitle)
            PlayButton(isPlaying: $isPlaying)
        }
    }
}

```

- @Binding
A property wrapper type that can read and write a value owned by a source of truth. Use a binding to create a two-way connection between a property that stores data, and a view that displays and changes the data. A binding connects a property to a source of truth stored elsewhere, instead of storing data directly. 

```swift
struct PlayButton: View {
    @Binding var isPlaying: Bool

    var body: some View {
        Button(action: {
            self.isPlaying.toggle()
        }) {
            Image(systemName: isPlaying ? "pause.circle" : "play.circle")
        }
    }
}
```

상태 프로퍼티는 선언된 뷰와 그 하위 뷰에 대한 현재 값이다. 하지만, 어떤 뷰가 하나 이상의 하위 뷰를 가지고 있으며 동일한 상태 프로퍼티에 대해 접근해야 하는 경우가 발생한다. WifiImageView 하위 뷰는 여전히 wifiEnabled 상태 프로퍼티에 접근해야 한다. 하지만, 분리된 하위 뷰의 요소인 Image 뷰는 이제 메인 뷰의 범위 밖이다. WifiImageView 입장에서 보면 wifiEnabled 프로퍼티는 저장되지 않은 변수 인 것이다. 

```swift
WifiImageView(wifiEnabled: $wifiEnabled)

...
struct WifiImageView: View {
    @Binding var wifienabled: Bool
    var body: Some View {
        Image(systemName: wifiEnabled ? "wifi" : "wifi.slash")
    }
}

```

<https://developer.apple.com/documentation/swiftui/binding>
<https://huniroom.tistory.com/entry/SwiftUI-state-property>

- @Published

상태 프로퍼티는 뷰의 상태를 저장하는 방법을 제공하며 해당 뷰에만 사용할 수 있다. 즉 하위 뷰가 아니거나 상태 바인딩이 구현되어 있지 않은 다른 뷰는 접근할 수 없다. 상태 프로퍼티는 일시적인 것이어서 부모 뷰가 사라지면 그 상태도 사라진다. 

> 반면, ObservableObject 는 여러 다른 뷰들이 외부에서 접근할 수 있는 영구적인 데이터를 표현하기 위해 사용된다. 

일반적으로 시간에 따라 변경되는 하나 이상의 데이터 값을 모으고 관리하는 역할을 담당한다. 타이머나 알림 (notification) 과 같은 이벤트를 처리하기 위해 사용될 수도 있다. 

1) Observable Object는 published property로서 데이터 값을 published
*@Published is only available on properties of classes*

2) Observer Object는 subscribe 하여 published propery 변경 시 업데이트
구독자는 observable 객체를 구독하기 위하여 *@ObservedObject* 프로퍼티 래퍼를 사용한다. (구독하게 되면 그 뷰 및 모든 하위 뷰가 상태 프로퍼티에서 사용했던 것과 같은 방식으로 게시된 프로퍼티에 접근하게 된다.)

```swift
import Foundation
import Combine

class DemoData: ObservableObject {
    @Published ar userCount = 0  // 래퍼 프로퍼티 값이 변경될 때 마다 모든 구독자에게 업데이트를 알린다.
    @Published var currentUser = ""

    init(){
        // 데이터 초기화 코드
        updateData()
    }

    func updateData() {
        // 데이터를 최신 상태로 유지하기 위한 코드
    }
}
```

```swift

import swiftUI

struct ContentView: View {
    @ObservedObject var demoData: DemoData

    var body: some View {
        Text("\(demoData.currentUser), your user number is \(demoData.userCount)")
    }
}

```

A type of object with a publisher that emits before the object has changed. By default an ObservableObject synthesizes an *objectWillChange* (Required) publisher that emits the changed value before any of its @Published properties changes.
<https://developer.apple.com/documentation/combine/observableobject>

```swift
class Contact: ObservableObject {
    @Published var name: String
    @Published var age: Int

    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }

    func haveBirthday() -> Int {
        age += 1
        return age
    }
}

let john = Contact(name: "John Appleseed", age: 24)
cancellable = john.objectWillChange
    .sink { _ in
        print("\(john.age) will change")
}
print(john.haveBirthday())
// Prints "24 will change"
// Prints "25"
```

- @EnvironmentObject
  - 반드시 ObservableObject 프로토콜을 따라야 한다
  - 적절한 프로퍼티가 published 되어야 한다.
  - SwiftUI 환경에서 저장되며, 뷰에서 뷰로 전달할 필요 없이 모든 뷰가 접근할 수 있다.

A property wrapper type for an observable object supplied by a parent or ancestor view.
An environment object invalidates the current view whenever the observable object changes. If you declare a property as an environment object, be sure to set a corresponding model object on an ancestor view by calling its environmentObject modifier.

어떤 뷰에서 다른 뷰로 이동(navigation) 하는데 이동될 뷰에서도 동일한 구독 객체에 접근해야 한다면, 이동할 때 대상 뷰로 구독 객체에 대한 참조체를 전달해야 할 것이다.

```swift

@observedObject var demoData: DemoData = DemoData()

NavigationLink(destination: SecondView(demoData)) {
    Text("Next Screen")
}

// 위 방법은 여러 상황에 사용될 수 있지만, 앱 내의 여러 뷰가 동일한 구독 객체에 접근해야 하는 경우에는 복잡해질 수 있다. 

@EnvironmentObject var demoData: DemoData

...
 func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
     let contentView = ContentView()
     let domoData = DemoData()

     if let windowScene = scene as? UIWindowScene {
         let window = UIWindow(windowScene: windowScene)
         window.rootViewController = UIHostingController(rootView: contentView.environmentObject(demoData))
         self.window = window
         window.makeKeyAndVisible()
     }
 }
 ...

 struct ContentView_Previews: PreviewProvider {
     static var previews: some View {
         ContentView().environmentObject(DemoData())
     }
 }

```

Environment Object는 observer 내에서 초기화 될 수 없으므로 접근하는 뷰가 화면을 설정하는 동안 구성해야 한다. 따라서 SceneDelegate.swift 파일의 *willConnectTo* 메서드를 약간 수정하는 작업이 필요하다.


<https://developer.apple.com/documentation/swiftui/environmentobject>

-----------------

- NavigationBarItem custom
  - overlay(alignment:content:): return a view that uses the specified content as a foreground
  - onAppear(perform): return a view that triggers action when this view appears 
  - self.modifier(_:): applies a modifier to a view and returns a new view

```swift
struct NavigationBarWithButton: ViewModifier {
 var title: String = ""
    func body(content: Content) -> some View {
        return content
            .navigationBarItems(
                //custom을 위한 코드 작성
            ...
}

// 뷰 확장, 커스텀한 네비게이션 바를 적용하는 함수. 
extension View {
    func navigationBarWithButtonStyle(_ title: String) -> some View {
        return self.modifier(NavigationBarWithButton(title: title))
    }
}
```

- button style custom

```swift
struct AssetMenuButtonStyle: ButtonStyle {
    let menu: AssetMenu
    
    func makeBody(configuration: Configuration) -> some View {
        return VStack {
            Image(systemName: menu.systemImageName)
                .resizable()
                .frame(width: 30, height: 30)
                .padding([.leading, .trailing], 10)
            Text(menu.title)
                .font(.system(size: 12, weight: .bold))
        }
        .padding()
        .foregroundColor(.blue)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))  // vs overay.stroke
    }
}
```

- RoundedRectangle(cornerRadius:)

- Generic
  - Generic Function
  - Generic Type
  - Type constraints
    - Protocol: <T: Equatable>
    - Class: <T: View>

(참고 자료)
<https://babbab2.tistory.com/136>

#### UIViewController => SwiftUI

- UIViewControllerRepresentable

> typealias: Context
UiKit의 컨트롤러를 swiftUI에서 사용할 때마다 봤던 것 같은데 이 녀석의 정체는?
<https://developer.apple.com/documentation/swiftui/uiviewcontrollerrepresentable>

A view that represents a UIKit view controller.
Use a UIViewControllerRepresentable instance to *create and manage a UIViewController object in your SwiftUI interface.*

To add your view controller into your SwiftUI interface, create your UIViewControllerRepresentable instance and add it to your SwiftUI interface. The system calls the methods of your custom instance at appropriate times.

The system doesn't automatically communicate changes occurring within your view controller to other parts of your SwiftUI interface. When you want your view controller to coordicate with other SwiftUI views, you must provide a *Coordinator* 

```swift
func makeUIViewController(context: Self.Context) -> Self.UIViewControllerType
func updateUIViewController(_ uiViewController: Self.UIViewControllerType, context: Self.Context)
func makeCoordinator() -> Self.Coordinator
```

coordinator?
An object you user to communicate your AppKit view controllers's behavior and state out to SwiftUI objects.

The coordicator is a custom object you define. When updating your view controller, communicate changes to SwiftUI by updating the properties of your coordinator, or by calling relevant methods to make those changes.

```swift
 class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
 }
```

SwiftUI calls *makeCoordinator* method before calling the makeUIViewController(context:) method. The system provides your coor

- UIPageViewController (by UIKit)

<https://developer.apple.com/documentation/uikit/uipageviewcontroller>
A container view controller that manages navigation between pages of content, where a child controller manages each page.

page view controller-navigation can be controlled programmatically by your app or directly by the user using gestures, When navigating from page to page, the page view controller uses the transition that you specify to animate the change

you can provide the content view controllers one at a time (or two at a time, depending upon the spind position and double-sided state) or as-needed using a data source. when providing content view controllers one at a time, you user the *setViewControllers* method to set the current content view controllers.

```swift
func setViewControllers(_ viewControllers: [UIViewController]?, 
              direction: UIPageViewController.NavigationDirection, 
               animated: Bool, 
             completion: ((Bool) -> Void)? = nil)
```

- Bundle.main.url(forResource:, withExtension:)
  - Bundle: A representation of the code and resources stored in a bundle directory on dist
    - By usding a bundle object, you can access a bundle's resources without knowing the structure of the bundle 
    - bundle object provides a single interface for locating items, taking into a ccount the bundle structure, user preferences, available localizations, and other relevant factors
  - main: Returns the bundle object that contains the current executable
    - it may also return nil if the bundle object could not be created, so always check the return nil
  - func url(forResource: String?, withExtension: String?, subdirectory: String?) -> URL?
    - Returns the file URL for the resouce identified by the specifed name and file extension

- Data(contentsOf: URL)

- Decoder.container(keyedBy:)
  - Returns a keyed decoding container view into this decoder.
  - keyedBy type: the key type to user for the container

```swift
struct Coordinate {
    var latitude: Double
    var longitude: Double
    var elevation: Double

    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
        case additionalInfo
    }
    
    enum AdditionalInfoKeys: String, CodingKey {
        case elevation
    }
}
```

*Because the encoded form of the Coordinate type contains a second level of nested information*, the type's adoption of the Encodable and Decodable protocols uses two enumerations that each list the complete set of coding keys used on a particular level.

In the example below, the Coordinate structure is extended to conform to the Decodable protocol by implementing its required initializer, init(from:):

```swift
extension Coordinate: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        latitude = try values.decode(Double.self, forKey: .latitude)
        longitude = try values.decode(Double.self, forKey: .longitude)
        
        let additionalInfo = try values.nestedContainer(keyedBy: AdditionalInfoKeys.self, forKey: .additionalInfo)
        elevation = try additionalInfo.decode(Double.self, forKey: .elevation)
    }
}

```

<https://developer.apple.com/documentation/foundation/archives_and_serialization/encoding_and_decoding_custom_types>
