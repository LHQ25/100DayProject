# 诉求

- 美化控制台的内容输出，不要杂乱无章。
- 对不同的输出内容，有不同的区分标志。
- 执行打印的基础信息（文件名，行数，函数名）。
- 针对字典和数组的输出像OC一样直观一些。
- 针对网络请求（请求地址，参数，返回值）能一起打印。

# 使用

```vbscript
        BTPrint.printBeforeLine(content: "测试输出开始")

        let text = "哈哈哈123456"
        BTPrint.print(text)

        let arr = [["我是key": ["key1":"晚上去玩"]]]
        BTPrint.print(arr)

        let color = UIColor.red
        BTPrint.print(color)

        let url = "https://www.baidu.com"
        BTPrint.print(url)

        let error = NSError.init(domain: "qixin.com", code: 100, userInfo: ["a": "b"])
        BTPrint.print(error)

        let any: Any = 123
        BTPrint.print(any)

        BTPrint.printAfterLine(content: "测试输出结束")
复制代码
👇 ================测试输出开始================ 👇

【✏️ String】ViewController.swift[69]: tableView(_:didSelectRowAt:)

哈哈哈123456

【🎢 Array】ViewController.swift[73]: tableView(_:didSelectRowAt:)
(
      {
      "\U6211\U662fkey" =         {
          key1 = "\U665a\U4e0a\U53bb\U73a9";
      };
  }
)

【🎨 Color】ViewController.swift[77]: tableView(_:didSelectRowAt:)
UIExtendedSRGBColorSpace 1 0 0 1

【🌏 URL】ViewController.swift[81]: tableView(_:didSelectRowAt:)
https://www.baidu.com

【❌ Error】ViewController.swift[85]: tableView(_:didSelectRowAt:)
Error Domain=qixin.com Code=100 "(null)" UserInfo={a=b}


【🎲 Any】ViewController.swift[89]: tableView(_:didSelectRowAt:)
123

☝️ ================测试输出结束================ ☝️
复制代码
```

# 实现

```swift
public class BTPrint: NSObject { }
extension BTPrint {
  /// 打印输出
  /// - Parameters:
  ///   - content: 输出内容
  ///   - identifier: 本次打印的标志符号 （可选值：体现在打印体里面方便查找）
  ///   - file: 执行所在文件
  ///   - method: 执行所在方法
  ///   - line: 执行所在行数
  public static func print<T>(_ content: T,
                            identifier: String = "",
                            file: String = #file,
                            method: String = #function,
                            line: Int = #line) {
#if DEBUG
      let type = transform(content)
      let sign = "((file as NSString).lastPathComponent)[(line)]: (method)"
      let emjio = type.getEmjio()
      let content = type.getContent()

      let ide = identifier.count == 0 ? "" : "[(identifier)] -> "
      let allStr = emjio + ide + sign + "\n" + content + "\n"
      Swift.print(allStr)
#endif
  }


  /// 打印输出 - 上分割线
  /// - Parameters:
  ///   - content: 分割线上带的内容
  ///   - identifier: 本次打印的标志符号 （可选值：体现在打印体里面方便查找）
  ///   - file: 执行所在文件
  ///   - method: 执行所在方法
  ///   - line: 执行所在行数
  public static func printBeforeLine(content: String,
                                identifier: String = "",
                                file: String = #file,
                                method: String = #function,
                                line: Int = #line) {
#if DEBUG
      let type = PrintContentType.beforeLine(content)
      let emjio = type.getEmjio()
      let content = type.getContent()
      let allStr = "\n" + emjio + content + emjio
      Swift.print(allStr)
#endif
  }


  /// 打印输出 - 下分割线
  /// - Parameters:
  ///   - content: 分割线上带的内容
  ///   - identifier: 本次打印的标志符号 （可选值：体现在打印体里面方便查找）
  ///   - file: 执行所在文件
  ///   - method: 执行所在方法
  ///   - line: 执行所在行数
  public static func printAfterLine(content: String,
                                identifier: String = "",
                                file: String = #file,
                                method: String = #function,
                                line: Int = #line) {
#if DEBUG
      let type = PrintContentType.afterLine(content)
      let emjio = type.getEmjio()
      let content = type.getContent()
      let allStr = emjio + content + emjio + "\n"
      Swift.print(allStr)
#endif
  }
}


extension BTPrint {

  private static func transform(_ content: Any) -> PrintContentType {

      if let string = content as? String {
          if let _ = URL.init(string: string) {
              return .url(string)
          } else {
              return .text(string)
          }
      }

       
      if let dict = content as? Dictionary<String, Any> {
          return .dictionary(dict)
      }
       

      if let arr = content as? [Any] {
          return .array(arr)
      }

      if let color = content as? UIColor {
          return .color(color)
      }

      if let error = content as? NSError {
          return .error(error)
      }

      
      if let date = content as? Date {
          return .date(date)
      }
      return .any(content)
  }
}


extension BTPrint {
  enum PrintContentType {
      /// 字符串✏️
      case text(String)
      /// 字典📖
      case dictionary([String: Any])
      /// 数组🎢
      case array([Any])
      /// 颜色 🎨
      case color(UIColor)
      /// URL🌏 是否可以转成URL
      case url(String)
      /// Error❌
      case error(NSError)
      /// Date🕒
      case date(Date)
      /// any 🎲
      case any(Any)
      /// 分割线👇
      case beforeLine(String)
      /// 分割线☝️
      case afterLine(String)
  }
}


extension BTPrint.PrintContentType {

  func getEmjio() -> String {
      switch self {
      case .text(_):
          return "【✏️ String】"
      case .dictionary(_):
          return "【📖 Dictionary】"
      case .array(_):
          return "【🎢 Array】"
      case .color(_):
          return "【🎨 Color】"
      case .url(_):
          return "【🌏 URL】"
      case .error(_):
          return "【❌ Error】"
      case .date(_):
          return "【🕒 Date】"
      case .any(_):
          return "【🎲 Any】"
      case .beforeLine(_):
          return "👇 "
      case .afterLine(_):
          return "☝️ "
      }
  }

   

  func getContent() -> String {
      func content<T>(_ object: T) -> String {
          let temp = "(object)"
          return temp
      }

      switch self {
      case .color(let color):
          return content(color)
      case .text(let line):
          return content(line)
      case .url(let url):
          return content(url)
      case .error(let error):
          return content(error)
      case .any(let any):
          return content(any)
      case .date(let date):
          return content(date)
      case .dictionary(let dict):
          return content("(String(describing: dict as AnyObject))")
      case .array(let arr):
          return content("(String(describing: arr as AnyObject))")
      case .beforeLine(let message):
          return content("================(message)================ ")
      case .afterLine(let message):
          return content("================(message)================ ")
      }
  }
}
复制代码
```

# 地址

[Github](https://link.juejin.cn?target=https%3A%2F%2Fgithub.com%2Fintsig171%2FBTPrint.git)

# 其他

#### 在 macOS上快速打开表情包 **Ctrl + Command + Space** 。 [官方介绍](https://link.juejin.cn?target=https%3A%2F%2Fsupport.apple.com%2Fzh-cn%2Fguide%2Fmac-help%2Fmchlp1560%2Fmac)

![企业微信截图_f26fc101-da7c-4fdb-8bea-8096cea501ff.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/d430625fa4bf42b484e541aa3463227a~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp)

#### 设置debug下才print

![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/c1dbab29d76b4425819d4a9e9b3123c3~tplv-k3u1fbpfcp-zoom-in-crop-mark:4536:0:0:0.awebp)

- 选中Target
- 选择你的项目名称
- 选择 build Settings
- 搜索 Compiler Flag
- 展开 Other C Flags
- 双击Debug， 点击 +
- 输入 -D DEBUG

```arduino
#if DEBUG
  Swift.print(allStr)
#endif
```



作者：移动端小伙伴
链接：https://juejin.cn/post/6984299935667748872
来源：稀土掘金
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。