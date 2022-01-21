#!/usr/bin/ruby -w

# -------------------------------------------------------
# 在 Ruby 中定义类
# 类总是以关键字 class 开始，后跟类的名称。类名的首字母应该大写。类 Customer 如下所示
class Customer
end

# -------------------------------------------------------
# Ruby 类中的变量
# Ruby 提供了四种类型的变量：
# 局部变量：局部变量是在方法中定义的变量。局部变量在方法外是不可用的。在后续的章节中，您将看到有关方法的更多细节。局部变量以小写字母或 _ 开始。
# 实例变量：实例变量可以跨任何特定的实例或对象中的方法使用。这意味着，实例变量可以从对象到对象的改变。实例变量在变量名之前放置符号（@）。
# 类变量：类变量可以跨不同的对象使用。类变量属于类，且是类的一个属性。类变量在变量名之前放置符号（@@）。
# 全局变量：类变量不能跨类使用。如果您想要有一个可以跨类使用的变量，您需要定义全局变量。全局变量总是以美元符号（$）开始

class Customer2
    @@no_of_customers=0            # 类变量
end

# -------------------------------------------------------
# 在 Ruby 中使用 new 方法创建对象
# 对象是类的实例。现在您将学习如何在 Ruby 中创建类的对象。在 Ruby 中，您可以使用类的方法 new 创建对象。
# 方法 new 是一种独特的方法，在 Ruby 库中预定义。new 方法属于类方法。
cust1 = Customer2.new
cust2 = Customer2.new

# -------------------------------------------------------
# 自定义方法来创建 Ruby 对象
# 您可以给方法 new 传递参数，这些参数可用于初始化类变量。
# 当您想要声明带参数的 new 方法时，您需要在创建类的同时声明方法 initialize。
# initialize 方法是一种特殊类型的方法，将在调用带参数的类的 new 方法时执行。
# 下面的实例创建了 initialize 方法：

# 声明带有 id、name、addr 作为局部变量的 initialize方法。在这里，def 和 end 用于定义 Ruby 方法 initialize
class Customer3
    @@no_of_customers=0
    def initialize(id, name, addr)# (id, name, addr)局部变量
       @cust_id=id                # 实例变量
       @cust_name=name            # 实例变量
       @cust_addr=addr            # 实例变量
    end
end
# 创建对象
cust3=Customer3.new("1", "John", "Wisdom Apartments, Ludhiya")
cust4=Customer3.new("2", "Poul", "New Empire road, Khandala")


# -------------------------------------------------------
# Ruby 类中的成员函数
# 在 Ruby 中，函数被称为方法。类中的每个方法是以关键字 def 开始，后跟方法名。
# 方法名总是以小写字母开头。在 Ruby 中，您可以使用关键字 end 来结束一个方法。
class Sample
    def hello
        puts "Hello Ruby!"
    end
end
# 使用上面的类来创建对象
object = Sample.new
object.hello