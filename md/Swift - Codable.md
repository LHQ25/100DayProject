## 前言

Codable 是随 Swift 4.0 推出的，旨在取代现有的 NSCoding 协议，支持结构体、枚举和类，能够将 JSON 这种弱数据类型转换成代码中使用的强数据类型。

Codable 是一个协议，同时兼顾了 Decodable 和 Encodable 两个协议，如果你定义了一个数据类型遵循了 Codable 协议，其实是遵循了 Decodable 和 Encodable：

```swift
typealias Codable = Decodable & Encodable
复制代码
```

说白了就是一套转换协议，可以让数据和 Swift 中的数据类型依据某种映射关系进行转换，比如 JSON 转成你 Swift 中自定义的数据类型。

![transfer.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/b27dcbb753b34962a36ecc92265dd706~tplv-k3u1fbpfcp-zoom-in-crop-mark:3024:0:0:0.awebp?)

[HandyJSON](https://link.juejin.cn?target=https%3A%2F%2Fgithub.com%2Falibaba%2FHandyJSON) 在 Codable 推出后已经不再进行维护了，而我们的项目就是依赖于 HandyJSON 来处理 JSON 的序列化和反序列化，所以我们也需要逐步迁移到 Codable 以避免一些错误。

## 使用技巧

### 1.基本使用

```swift
struct Person: Codable {
    let name: String
    let age: Int
}

// 解码
let json = #" {"name":"Tom", "age": 2} "#
let person = try JSONDecoder().decode(Person.self, from: json.data(using: .utf8)!)
print(person) //Person(name: "Tom", age: 2

// 编码
let data0 = try? JSONEncoder().encode(person) 
let dataObject = try? JSONSerialization.jsonObject(with: data0!, options: []) 
print(dataObject ?? "nil") //{ age = 2; name = Tom; }

let data1 = try? JSONSerialization.data(withJSONObject: ["name": person.name, "age": person.age], options: []) 
print(String(data: data1!, encoding: .utf8)!) //{"name":"Tom","age":2}
复制代码
```

### 2.字段映射

```swift
struct Person: Codable {
    let name: String
    let age: Int
    let countryName: String

    private enum CodingKeys: String, CodingKey {
        case countryName = "country"
        case name
        case age
    }
}

let json = #" {"name":"Tom", "age": 2, "country": "China"} "#
let person = try JSONDecoder().decode(Person.self, from: json.data(using: .utf8)!)
print(person) //Person(name: "Tom", age: 2, countryName: "China")

复制代码
```

在 Swift 4.1 后，`JSONDecoder`  添加了 `keyDecodingStrategy`  属性，如果后端使用带下划线的，蛇形命名法，通过将 `keyDecodingStrategy`  属性的值设置为 `convertFromSnakeCase`，这样就不需要写额外的代码来处理映射了：

```swift
var decoder = JSONDecoder() 
decoder.keyDecodingStrategy = .convertFromSnakeCase

// 后端 person_name
// 映射为 personName
复制代码
```

### 3.解析枚举值

解析枚举值有个坑就是本来比如你只有三个 `case`：

```swift
enum TestEnum: String {
	case a
	case b
	case c
}
复制代码
```

然后服务端某天多加了几个你没有处理的 `case`，比如加了个 `case d`，那这样去解析就直接崩掉了，所以我们需要想办法给未知的 `case`  设置一个默认值。 具体的实现是这样，添加一个协议：

```swift
protocol CodableEnumeration: RawRepresentable, Codable where RawValue: Codable {
    static var defaultCase: Self { get }
}

extension CodableEnumeration {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            let decoded = try container.decode(RawValue.self)
            self = Self.init(rawValue: decoded) ?? Self.defaultCase
        } catch {
            self = Self.defaultCase
        }
    }
}
复制代码
```

然后在遇到未知的 `case` 时就可以通过让 `Enum`  遵守 `CodableEnumeration` ，然后实现 `defaultCase`  方法来指定一个 `case`  即可。

```swift
/**
{
	"test_enum" : "d"
}
*/

enum TestEnum: String, CodableEnumeration {
    static var defaultCase: TestEnum {
        .a
    }
    case a
    case b
    case c
}

struct Test: Codable {
    var testEnum: TestEnum
    private enum CodingKeys: String, CodingKey {
        case testEnum = "test_enum"
    }
}

let testJson = #" {"test_enum":"d"} "#
let test = try JSONDecoder().decode(Test.self, from: testJson.data(using: .utf8)!)
print(test.testEnum) // a
复制代码
```

### 4.解析嵌套类型

Swift4 支持条件一致性，所以当数组中的每个元素都遵从 Codable 协议，字典中对应的 `key`  和 `value`  遵从 Codable 协议，整体对象就遵从 Codable 协议，就是保证你嵌套的类型都遵从 Codable 协议即可。

```swift
struct Student: Codable {
    var id: String
    var name: String
    var grade: Int
}
  
struct Class: Codable {
    var classNumber: String
    var students: [Student]
}

/**
{
	"classNumber": "111",
	"students": [{
		"id": "1",
		"name": "studentA",
		"grade": 1
	}, {
		"id": "2",
		"name": "studentB",
		"grade": 2
	}]
}
*/
let classJson = #"{"classNumber":"111","students":[{"id":"1","name":"studentA","grade":1},{"id":"2","name":"studentB","grade":2}]}"#
let classModel = try JSONDecoder().decode(Class.self, from: classJson.data(using: .utf8)!)
print(classModel)

/** 输出
▿ Class
  - classNumber : "111"
  ▿ students : 2 elements
    ▿ 0 : Student
      - id : "1"
      - name : "studentA"
      - grade : 1
    ▿ 1 : Student
      - id : "2"
      - name : "studentB"
      - grade : 2
*/
复制代码
```

### 5.解析空值，为null时指定默认值

后端的接口返回的数据可能有值也可能是为空的，这个时候可以将属性设置为可选类型：

```swift
/**
{
	"name": "xiaoming",
	"age": 18,
	"partner": null
}
*/

struct Person: Codable {
    let name: String
    let age: Int
    let partner: String?
}

let personJson = #"{"name":"xiaoming","age":18,"partner":null}"#
let person = try JSONDecoder().decode(Person.self, from: personJson.data(using: .utf8)!)
print(person) // Person(name: "xiaoming", age: 18, partner: nil)
复制代码
```

如果不想使用可选类型，可以重写 `init(from decoder: Decoder) throws` 方法，来指定一个默认的值：

```swift
struct Person: Codable {
    var name: String
    var age: Int
    var partner: String

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        age = try container.decode(Int.self, forKey: .age)
        name = try container.decode(String.self, forKey: .name)
        partner = try container.decodeIfPresent(String.self, forKey: .partner) ?? ""
    }
}

let personJson = #"{"name":"xiaoming","age":18,"partner":null}"#
let person = try JSONDecoder().decode(Person.self, from: personJson.data(using: .utf8)!)
print(person) // Person(name: "xiaoming", age: 18, partner: "")
复制代码
```

现在只有三个属性，如果属性很多，那写起来就非常麻烦，好在我们有更好的方案： [Annotating properties with default decoding values](https://link.juejin.cn?target=https%3A%2F%2Fwww.swiftbysundell.com%2Ftips%2Fdefault-decoding-values%2F) 简单来说就是通过 `@propertyWrapper` 来进行优化，在需要默认值的属性上对这个属性进行声明，编译器就可以自动帮助我们完成赋默认值的操作，当然，这个属性包裹的实现要我们自己去实现，代码我就直接贴出来，新建个类放到项目中即可：

```swift
protocol DecodableDefaultSource {
    associatedtype Value: Decodable
    static var defaultValue: Value { get }
} 

enum DecodableDefault {}

extension DecodableDefault {
    @propertyWrapper
    struct Wrapper<Source: DecodableDefaultSource> {
        typealias Value = Source.Value
        var wrappedValue = Source.defaultValue
    }
}

extension DecodableDefault.Wrapper: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = try container.decode(Value.self)
    }
}

extension KeyedDecodingContainer {
    func decode<T>(_ type: DecodableDefault.Wrapper<T>.Type,
                   forKey key: Key) throws -> DecodableDefault.Wrapper<T> {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
}

extension DecodableDefault {
    typealias Source = DecodableDefaultSource
    typealias List = Decodable & ExpressibleByArrayLiteral
    typealias Map = Decodable & ExpressibleByDictionaryLiteral

    enum Sources {
        enum True: Source { static var defaultValue: Bool { true } }
        enum False: Source { static var defaultValue: Bool { false } }
        enum EmptyString: Source { static var defaultValue: String { "" } }
        enum EmptyList<T: List>: Source { static var defaultValue: T { [] } }
        enum EmptyMap<T: Map>: Source { static var defaultValue: T { [:] } }
        enum Zero: Source { static var defaultValue: Int { 0 } }
    }
} 

extension DecodableDefault {
    typealias True = Wrapper<Sources.True>
    typealias False = Wrapper<Sources.False>
    typealias EmptyString = Wrapper<Sources.EmptyString>
    typealias EmptyList<T: List> = Wrapper<Sources.EmptyList<T>>
    typealias EmptyMap<T: Map> = Wrapper<Sources.EmptyMap<T>>
    typealias Zero = Wrapper<Sources.Zero>
}

extension DecodableDefault.Wrapper: Equatable where Value: Equatable {}
extension DecodableDefault.Wrapper: Hashable where Value: Hashable {}

extension DecodableDefault.Wrapper: Encodable where Value: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}
复制代码
```

如果需要添加更多的默认值，在 Sources 中添加即可，上面的 `Zero` 就是额外加的，可以验证一下：

```swift
/**
{
	"name":null,
	"money":null,
	"skills":null,
	"teachers":null
}
*/

struct Person: Codable {
    @DecodableDefault.EmptyString var name: String
    @DecodableDefault.Zero var money: Int
    @DecodableDefault.EmptyList var skills: [String]
    @DecodableDefault.EmptyList var teachers: [Teacher]
} 

struct Teacher: Codable {
    @DecodableDefault.EmptyString var name: String
} 

let personJson = #"{"name":null,"money":null,"skills":null,"teachers":null}"#
let person = try JSONDecoder().decode(Person.self, from: personJson.data(using: .utf8)!)
print(person)

/** 输出
▿ Person
  ▿ _name : Wrapper<EmptyString>
    - wrappedValue : ""
  ▿ _money : Wrapper<Zero>
    - wrappedValue : 0
  ▿ _skills : Wrapper<EmptyList<Array<String>>>
    - wrappedValue : 0 elements
  ▿ _teachers : Wrapper<EmptyList<Array<Teacher>>>
    - wrappedValue : 0 elements
*/
复制代码
```

### 6.编码

取 5 中的 `person`，对它进行编码，并输出字符串或转成对应的数据格式：

```swift
// 字符串
do {
    let jsonData = try JSONEncoder().encode(person)
    let jsonString = String(decoding: jsonData, as: UTF8.self)
    print(jsonString) // {"money":0,"teachers":[],"name":"","skills":[]}
} catch {
    print(error.localizedDescription)
}

// 字典
do {
    let jsonData = try JSONEncoder().encode(person)
    let jsonObject = try JSONSerialization.jsonObject(with: jsonData) as? [String : Any]
    print(jsonObject ?? "null")
} catch {
    print(error.localizedDescription)
}
复制代码
```

## 小结

大概常用的操作就是这些，使用起来还是很方便的，HandyJSON 是依赖于 Swift 的 Runtime 源码推断内存规则，如果规则改变，那么 HandyJSON 就不管用了，而 HandyJSON 现在也不再进行维护，所以在规则没有改变之前，我们需要逐步弃用 HandyJSON 改用原生的 Codable。

## 参考

[Annotating properties with default decoding values](https://link.juejin.cn?target=https%3A%2F%2Fwww.swiftbysundell.com%2Ftips%2Fdefault-decoding-values%2F)

[Encoding and Decoding Custom Types](https://link.juejin.cn?target=https%3A%2F%2Fdeveloper.apple.com%2Fdocumentation%2Ffoundation%2Farchives_and_serialization%2Fencoding_and_decoding_custom_types)



作者：_Terry
链接：https://juejin.cn/post/7122667987902922789
来源：稀土掘金
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。