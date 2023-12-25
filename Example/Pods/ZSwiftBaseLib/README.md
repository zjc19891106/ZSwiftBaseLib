# ZSwiftBaseLib

[![CI Status](https://img.shields.io/travis/zjc19891106/ZSwiftBaseLib.svg?style=flat)](https://travis-ci.org/zjc19891106/ZSwiftBaseLib)
[![Version](https://img.shields.io/cocoapods/v/ZSwiftBaseLib.svg?style=flat)](https://cocoapods.org/pods/ZSwiftBaseLib)
[![License](https://img.shields.io/cocoapods/l/ZSwiftBaseLib.svg?style=flat)](https://cocoapods.org/pods/ZSwiftBaseLib)
[![Platform](https://img.shields.io/cocoapods/p/ZSwiftBaseLib.svg?style=flat)](https://cocoapods.org/pods/ZSwiftBaseLib)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## FunctionList

UIKitSDL, UIView and children class can use.CALayerDSL same as.

    ```
        Swift
        
        private lazy var logo: UIImageView = {
            UIImageView(frame: CGRect(x: ScreenWidth/3.0, y: ZNavgationHeight+20, width: ScreenWidth/3.0, height: ScreenWidth/3.0)).image(UIImage(named: "login_logo")!).contentMode(.scaleAspectFit)
        }()
    
        private lazy var userNameField: UITextField = {
            UITextField(frame: CGRect(x: 20, y: self.logo.frame.maxY+20, width: ScreenWidth - 40, height: 40)).cornerRadius(5).placeholder("UserName").delegate(self).tag(111).layerProperties(UIColor(0xf5f7f9), 1).leftView(UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 40)), .always)
        }()
    
        private lazy var login: UIButton = {
            UIButton(type: .custom).frame(CGRect(x: 20, y: self.passWordField.frame.maxY+40, width: ScreenWidth - 40, height: 45)).backgroundColor(UIColor(0x0066ff)).cornerRadius(10).title("Login", .normal).font(UIFont.systemFont(ofSize: 18, weight: .semibold)).addTargetFor(self, action: #selector(loginAction), for: .touchUpInside)
        }()
    
    
        private lazy var logRecord: UITextView = {
            UITextView(frame: CGRect(x: 20, y: self.register.frame.maxY+20, width: ScreenWidth - 40, height: ScreenHeight - self.register.frame.maxY - 40)).layerProperties(UIColor(0xf5f7f9), 1).cornerRadius(5).font(UIFont.systemFont(ofSize: 18, weight: .semibold)).isEditable(false)
        }()
        
        private lazy var functionList: UITableView = {
            UITableView(frame: CGRect(x: 0, y: ZNavgationHeight, width: ScreenWidth, height: ScreenHeight-ZNavgationHeight), style: .plain).delegate(self).dataSource(self).tableFooterView(UIView()).rowHeight(50)
        }()

    ```
UIColorExtension,color hex and random color

    ```
        Swift
        
        UIColor(0xaaaaaa)
        
        UIColor.randomColor
    ```
ArrayExtension,using safe subscript

    ```
        Swift
        
        [1,2,3][safe: 3] //prevent crash
        
        [1,2,3][safe: 0...3] //prevent crash
    ```
    
DataExtension,fast to dic

    ```
        Swift
        
        Data().z.toDictionary()
    ```

DateExtension,convenience to operation date

PropertyWrapper,convenience for doing something,such as

    ```
        Swift
        
        @UserDefault("AgoraChatUserName", defaultValue: "") var userName
        
        @Default(0) var idx
        
        @CopyingProperty(NSObject()) var model// NSObject confirm NSCopying
        
        @Expirable(wrappedValue: "test", expirationDate: date, duration: 60)//60s
    ```
PlaceHolderTextView,can set placeHolder

NSAttributedStringFunctionBuilder,can using NSAttributedString such as

    ```
         self.attributeTextView.attributedText = NSAttributedString {
            AttributedText("一二三四五，上山打老虎，老虎不吃人，老虎屁股摸不得").font(.systemFont(ofSize: 14)).foregroundColor(.orange).lineSpacing(5)
            LineBreak()
            LineBreak()
            AttributedText("太阳当空照，花儿对我笑").font(.systemFont(ofSize: 16)).foregroundColor(.gray)
            LineBreak()
            Link("百度一下，你就知道", url: URL(string: "https://www.baidu.com")!)
        }
        
        func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
            if URL.absoluteString == "https://www.baidu.com" {
         return true
            } else {
                return false
            }
        }
    ```
    
StringExtension,convenience for operation string.such as

    ```
        Swift
        
        "123"[safe:4],"123"[safe:0...3],"1232"-="1"
        
        String.documentsPath or temp and cache
        
        "123".z.numCount
        
        "https://xxx.xxx.xxx".z.urlEncoded or urlDecoded
        
        "123".z.containEmoji
        
        "123".z.verticalText
        
        .z.rangOfSting
        
        .z.jsonToDictionary()
        
        .z.isMatchRegular("\a[0~9]")
        
        .z.toDate()
        
        .z.convertToTextImage
        
        .z.generateQRCode
        
        .z.md5
        
        .z.hexColor
    ```

DispatchExtension,convenice for using.such as

    ```
        Swift
        
        DispatchQueue.once ("xxx") {
        
        }
        
        DispatchQueue.asyncTaskBackMainQueue(.global()) {
            <#code#>
        } mainSuccess: { <#_#> in
            <#code#>
        } mainError: { <#Error#> in
            <#code#>
        }
    ```
    
UIViewFunctionBuilder

    ```
        Swift
        
        let v = UIView {
            UIView()//must fill
            UIButton()
            UILabel()
        }
    ```
    
URLExtension,convenice for operation URL

ViewMemoryStorage,look to pointer or value

UIImageExtension,compress or scale

CircularMenuLayout,a circleMenu layout inherited from UICollectionFlowLayout


## Requirements

iOS 10.0 

## Installation

ZSwiftBaseLib is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ZSwiftBaseLib'
```

## Author

zjc19891106, 984065974@qq.com

## License

ZSwiftBaseLib is available under the MIT license. See the LICENSE file for more info.
