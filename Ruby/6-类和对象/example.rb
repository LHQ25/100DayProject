#!/usr/bin/ruby -w


# 创建一个名为 Customer 的 Ruby 类，声明两个方法：
# display_details：该方法用于显示客户的详细信息。
# total_no_of_customers：该方法用于显示在系统中创建的客户总数量
class Customer

    @@no_of_customers=0
    def initialize(id, name, addr)
        @cust_id=id
        @cust_name=name
        @cust_addr=addr
    end

    # display_details 方法包含了三个 puts 语句，显示了客户 ID、客户名字和客户地址。其中，puts 语句：
    # puts "Customer id #@cust_id"
    # 将在一个单行上显示文本 Customer id 和变量 @cust_id 的值。
    # 当您想要在一个单行上显示实例变量的文本和值时，您需要在 puts 语句的变量名前面放置符号（#）。文本和带有符号（#）的实例变量应使用双引号标记。
    def display_details()
        puts "Customer id #@cust_id"
        puts "Customer name #@cust_name"
        puts "Customer address #@cust_addr"
    end

    def total_no_of_customers()
        @@no_of_customers += 1
        puts "Total number of customers: #@@no_of_customers"
    end
end

# 创建对象
cust1=Customer.new("1", "John", "Wisdom Apartments, Ludhiya")
cust2=Customer.new("2", "Poul", "New Empire road, Khandala")

# 调用方法
cust1.display_details()
cust1.total_no_of_customers()

cust2.display_details()
cust2.total_no_of_customers()