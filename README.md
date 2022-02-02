# PrettyImageSlider

____
### 📄Описание 

PrettyImageSlider - красивый слайдер с картинками.

![Пример работы библиотеки](/Assets/asset_0.gif?rawValue=true "Пример работы библиотеки")

____
### 🔨Подключение

1. Подключите SIFramework ([см. инструкцию](https://softomate.atlassian.net/wiki/spaces/MD/pages/1304330304/Work+with+sif)).

2. В pod файл добавить PrettyImageSlider.
```
target 'app_name' do
  use_frameworks!
  pod 'PrettyImageSlider' -> 'last.version'
```

3. Далее устанавливаем библиотеку из корневой папки проекта.
```
pod install
```

4. Подключаем библиотеку в нужном ViewController’е.
```swift
import PrettyImageSlider
```

____
### 🤌🏼Свойства

| Property | getter, setter | Interface Builder |
|:----|:----|:----------|
| cornerRadius | ✅, ✅ | ✅ |
| titleTextColor | ✅, ✅ | ✅ |
| titleFont | ✅, ✅ | ❌ |
| descriptionTextColor | ✅, ✅ | ✅ |
| descriptionFont| ✅, ✅ | ❌ | 
| hidePageControlOnSinglePage | ✅, ✅ | ❌ |
| currentPage | ✅, ❌ | ❌ |
| isAutoScrollable | ✅, ✅ | ❌ |
| scrollTimeInterval | ✅, ✅ | ❌ |

> При использовании `isAutoScrollable = true` пользователь так же может скроллить слайдер. Авто скролл возобновится автоматически через 5 секунд после последнего взаимодействия (свайп влево или вправо) со слайдером.

____
### 🤙🏼Методы

#### Bind
```Swift
public func bind(with sliderObjects: [ImageSliderObject])
```

Пример использования:
```Swift
sliderView.bind(
    with: ImageSliderObject(
        image: URL(string: "https://website.com/image.jpg"),
        title: "Perfect title for image",
        description: "Amaizing description for image"
    )
)
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
