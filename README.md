# PrettyImageSlider

____
### 📄Описание 

PrettyImageSlider - слайдер с картинками.

![Пример работы библиотеки](/Assets/asset_0.gif?rawValue=true "Пример работы библиотеки")

____
### 🔨Подключение

1. В pod файл добавить PrettyImageSlider.
```
target 'app_name' do
  use_frameworks!
  pod 'PrettyImageSlider' -> 'last.version'
```

2. Далее устанавливаем библиотеку из корневой папки проекта.
```
pod install
```

3. Подключаем библиотеку в нужном ViewController’е.
```swift
import PrettyImageSlider
```

____
### 🤌🏼Свойства

| Property | getter, setter | Interface Builder |
|:----|:----|:----------|
| cornerRadius | ✅, ✅ | ✅ |
| imageSliderViewStyle | ✅, ✅ | ❌ |
| hidePageControlOnSinglePage | ✅, ✅ | ❌ |
| currentPage | ✅, ❌ | ❌ |
| isAutoScrollable | ✅, ✅ | ❌ |
| scrollTimeInterval | ✅, ✅ | ❌ |

> `imageSliderViewStyle` позволяет задать стиль встроенной UIView слайдера.

> При использовании `isAutoScrollable = true` пользователь так же может скроллить слайдер. Авто скролл возобновится автоматически через 5 секунд после последнего взаимодействия (свайп влево или вправо) со слайдером.

____
### 🤙🏼Методы

#### Bind
##### ImageSliderViews
```Swift
public func bind(with sliderObjects: [ImageSliderObject])
```

Пример использования:
```Swift
let sliderObjects = [
    ImageSliderObject(
        image: UIImage(),
        title: "Perfect title for image",
        description: "Amaizing description for image"
    )
]

sliderView.bind(with: sliderObjects)
```

##### CustomViews
```Swift
public func bind(with customViews: [UIView])
```

Пример использования:
```Swift
sliderView.bind(with: [MyCustomView()])
```

#### Auto scrolling

* Start:

```Swift
public func startAutoScrolling() 
```

Пример использования:
```Swift
override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    sliderView.startAutoScrolling()
}
```

* Stop:

```Swift
public func stopAutoScrolling() 
```

Пример использования:
```Swift
override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    sliderView.stopAutoScrolling()
}
```

____
### Автор

Kirill Kapis, Kkprokk07@gmail.com

____
## License

PrettyImageSlider is available under the MIT license. See the LICENSE file for more info.
