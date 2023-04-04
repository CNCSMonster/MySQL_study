# Data Types

MySQl支持SQL数据类型，有一下几个大分类:数学类型，日期和时间类型，字符串(字符和字节)类型,空间类型(spatial types),还有json数据类型。这个章节提供一个关于每个大类的这些数据类型的一个概述以及更多细节的描述，还有关于这些数据类型的存储要求的一个总结。最开始的概述故意做的简短，要获取关于特定数据类型的更多信息的细致描述，比如你可以用来区分值的许可的格式

数据类型描述使用以下这些规定:

* 对于正实数类型，M表示最大的可以表达宽度(注意这个与类型值的取值范围无关)

  对于浮点类型和定点小数类型，M表示可以保存的数字的位数，对于字符串类型，M表示该类型是数据的最大长度。M的最大值取决于对应的数据类型

* D用在浮点数和定点小数中表示小数点(scale)后面允许的数字位数，最大的可能的值是30，但是不应该超过M-2

* fsp用于time,datetime和timestamp类型中，代表秒时间的精度，也就是在时间数据中秒属性的小数点后面的数字的位数。fsp的值如果给出，一定要在0-6的范围内。如果值为0，那么就没有小数点后面部分。如果没有给出，则默认的精度是0（这个不同于标准SQL，那里默认值是6）

* 方括号(\[\])括起来关于数据库类型的可选部分

### Numerical类型

#### 关于Numerical类型的语法

MySQL支持所有标准SQL的数学数据类型。这些类型包括精确的数学数据类型(integer(整数),smallint(小整数),decimal(小鼠),以及numeric),还包括不精准的数学数据类型（float,real,还有double precision).关键字int是integer的同义词，关键字dec还有fixed是decimal的同义词。

MySQL吧double看作是double precision的同义词(这不是在标准中规定的扩展).

MySQL还把real当作double precision的同义词(非标准扩展),除非real_as_float SQL模式被允许

bit数据类型保存比特数据，并且被MyISAM,MEMORY,InnoDB还有NDB数据库引擎迟迟

对于MySQL如何通过表达式评估来处理超过类型范围或者类型允许的大小限制并进行处理，

观看“Out-of-Range and Overflow Handling"

关于数学数据类型的存储要求和用于数学值上的函数运算的内容，观看其他..

[MySQL :: MySQL 8.0 Reference Manual :: 11.1 Numeric Data Types](https://dev.mysql.com/doc/refman/8.0/en/numeric-types.html)

对于整数数据类型，M表示最大的展示宽度。最大的展示宽度是255，与类类型值的存储范围无关

对于浮点类型和定点类型，M表示值里面的可以被保存的数字的位数

将来对于整数的展示宽度属性的支持应该会被移除

如果你对数学类型的字段增阿吉zerofill属性，MySQL自动给这个字段增加unsigned属性

对于MySQL9。0.17，对于数学数据类型的zerofill属性支持将可能移除。当使用这个属性的时候考虑使用等价的方式。例如，应用可以使用lpad()函数来将0填充数填充到合适的宽度，或者把他们用合适的数字字符串格式存储在char字段中。

数学数据类型允许unsigned(无符号)属性的同时允许signed(有符号)属性。然而，这些数据类型都默认为有符号属性，所以signed属性没有作用

对于MySQL9.0.17,unsigned属性对于float,double,decimal的支持将会被移除，你应该考虑使用更简单的check约束而不是依赖于定义了这个属性的字段。

serial是BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE的别名

serial default value 在整数列的定义中是not null auto_increment unique的别名。

**警告**!

```
当你对两个整数值使用减法的时候，如果其中一个是
unsigned的，则结果会是unsigned的除非你设定了
no_unsigned_subtraction SQL模式
```

##### 关于M使用的例子

* bit\[(M)\]

  一个比特值类型，M表示每个值的比特得数量，从1到64。默认是1

* tinyint\[(M)\] \[unsigned\] \[zerofill\]

  一个非常小的整数。默认的取值范围是-128到127，也就是对应这8位有符号整数的取值。

  无符号取值范围i是0-255

* bool,boolean

  这些数据类型是tynyint(1)的别名，0值被认为是false,非0值被认为是true

  然而值true仅仅是1，值false仅仅是0，

  所以使用if函数

  ```
  select if(1=true,'true','false');
  #的结果是true
  select if(2=true,'true','false');
  #的结果是false
  ```

* smallint\[(M)\] \[unsigned\] \[zerofill\]

  一个小整数。有符号范围欸位-32768到32767.

  无符号对应范围0-65535.

* mediumint\[(M)} \[unsigned\] \[zerofill\]

  中等大小整数，取值范围-8388608到8388607.无符号范围位0-16777215

* int\[(M)\] \[unsigned\] \[zerofill\]

  普通大小整数，The signed range is `-2147483648` to `2147483647`. The unsigned range is `0` to `4294967295`.

* integer\[(M)\] \[unsigned\] \[zerofill\]

  这个类型是int类型的别名

* bigint\[(M)\] \[unsigned\] \[zerofill\]

  大整数类型。有符号范围`-9223372036854775808` to `9223372036854775807`.无符号范围`0` to `18446744073709551615`.

  serial是bigint unsigned not null auto_increment unique的别名

  需要注意的细节:

  * 注意在有符号bigint和double的值运算中，强转bigint为double会发生信息丢失，如果你使用了超过`9223372036854775807` (63 bits)的有符号整数值

  * 适合使用bigint的地方：

    * 使用整数保存无符号大整数的时候

    * 列名指向大战术列的时候

    * 使用+,-,\*,/等运算符号而且两个运算数都是整数的时候

  * 你一般情况下应该使用一个字符串来保存精确的bigint值，这意味着，如果你通过返回整数结果的函数来进行两个整数的乘法运算，你可能得到不准确的结果如果结果超过`9223372036854775807`.

* decimal\[(m\[,D\])\] \[unsigned\] \[zerofill\]

  一个包装的精确的定点数.M表示所有数字的精确位数，D表示小数点后数字的位数，对于负数来说，负号并不统计在位数M里面。如果D是0，值没有小数点以及小数点后面部分。decimal最大的M值为65.最大的D值为30。如果D没有给出，默认值为0.如果M没有给出，默认值为10(同时有个限制D<=M-2)

  无符号的状态，不允许负数值(这个性质以后将被移除)

  基础的四则运算，对于decimal数据来说精度到65位(或者说中间值使用65位)

* dec\[M(,D)\] \[unsigned\] \[zerofill\] numeric\[M,(,D)\] \[unsigned\] \[zerofill\]

  这些类型是decimal的别名。像这样的别名是为了和其他数据库系统的兼容而提供的

* float\[(M,D)\] \[unsigned\] \[zerofill\]

  单精度浮点数。取值范围`-3.402823466E+38` to `-1.175494351E-38`, `0`, and `1.175494351E-38` to `3.402823466E+38`.这些是根据IEEE标准的理论限制。实际上的取值范围可能轻微地受到你的硬件或者操作系统影响

  M是值中所有数字的位数，D是小鼠点后的为位数。如果M和D没有给出，值会按照硬件允许的限制储存。一个单精度浮点型数的精度可以达到7位小鼠

  float(M,D)是非标准的SQL扩展。对于MySQL8.0.17来说，这个语法预告会被移除，你不应该期待后续版本继续支持它。

  unsigned，如果特别指定，不允许负数值。对于float的unsigned属性支持将会被移除。你应该考虑用简单的check约束而不是使用用unsigned修饰的这样的列。

  使用float可能给你一些预料不到的难题因为所有MySQL中的计算是用double的精度来完成的

* float(p)

  一个浮点数。p代表它的比特精确度，但mySQL使用这个值取决定是使用float还是double来作为运算时保存中间运算结果的类型，如果p取0-24，那么数据类型就成为不附加(M,D)的float.如果p取25-53，数据类变成没有附加(M,D)的double.。结果列的取值范围欸于单精度float或者双精度double在前面节描述的一样

  unsigned属性如果指定了，则不允许出现负数值。这是声明将要放弃的支持，你应该考虑使用简单的check约束来代替使用unsigned修饰的float(p)字段

  float(p)是为了兼容ODBC提供的

* double\[(M,D)\] \[unsigned\] \[zerofill\]

  普通大小小数（双精度浮点型）。取值范围

  `-1.7976931348623157E+308` to `-2.2250738585072014E-308`, `0`, and `2.2250738585072014E-308` to `1.7976931348623157E+308`.这是理论限制，实际的取值范围可能轻微受到硬件和操作系统的影响

  M是数字的总位数，D是小数点后数的位数。

  M,D默认情况下，值将按照硬件给出的限制存储。

  一个双精度浮点型数字精度可达到15位。

  unsigned修饰的作用。同float,该支持将被抛弃

* double precision\[(M,D)\] \[unsigned\] \[zzerofill\],

  real\[(M,D)\] \[unsigned\] \[zerofill\]

  这两个是double的别名。

  例外:如果在`real_as_float SQL`模式下,real将被看作是float而不是double

#### Integer Types(Exact Value)

对于整数类型,M用来表示展示宽度(display width)

|Type|存储字节数|
|-|-|
|tinyint|1|
|smallint|2|
|mediumint|3|
|int|4|
|bigint|8|

#### Fixed-Point Tyspes(Exact Value)

decimal和numeric类型保存具体的确切的数学数据值。当需要保存数据确切精度，比如包含商业精度数据的例子的时候，需要使用这些类型。

MySQL用二进制格式保存decimal值

在一个decimal的字段声明中，有效数字数和小数部分位数可以(且一般)给出，如

```
salary decimal(5,2)
```

在这个例子中，5是有效数字个数，并且2是小数位数。这个精度代表了这个decimal类型的数字，有效数字能够达到5个，而且小数点后面能保存2个

标准的SQL要求decimal(5,2)能够保存任何有5个有效数字和两位小鼠的数据，因此它的取值范围为

`-999.99` 到 `999.99`

`decimal(M)`等价于`decimal(M,0)`

用`decimal(M,D)`指定总数位M和小数点后数位D

对decimal来说最大的数位数为65，对于给出M,D的具体decimal字段来说，实际保存的值要具体分析.

当一个decimal字段被赋一个小数位数超过声明允许的位数的值的时候，这个值会被强转为这个位数(

具体的行为是操作系统相关的，但通常是截断到允许的小数位数

#### FloatingPointTypes(ApproximateValue) -FLOAT,DOUBLE

float类型和double类型代表着模糊数据类型。MySQL使用四个字节存储单精度，使用八个字节存储双精度值

对于单精度浮点数float，SQL标准允许可选的精度，通过跟谁在关键字float后面的圆括号中，比如`float(p)`.MySQL同样支持可选的有效数字声明，但是float(p)仅仅用来决定存储空间。有效数字处于0-23则使用4个字节存储，24-53则使用8个字节存储为8字节双精度。

MySQL允许非标准的语法:

```sql
float(M,D) 或者real(M,D)或者double precision(M,D)
```

在这里，（M，D)以为着值可以保存总共M位有效数字，小数点后可以跟随D位有效数字。例如，一个定义为float(7,4)的字段，能够显示为-999.9999.MySQL在保存值的时候会进行四舍五入，所以如果你插入999.0009到float(7,4)字段中，则最终结果会保存为999.0001.

对于MySQL 8.0.17来说，float(M,D)和double(M,D)的语法将会在将来的版本中移除。所以你最好使用其他方法来替换他们的使用。

因为浮点类型的数是模糊的且总不会被精确地保存，为了能够让他们精确地比较可能造成麻烦。

为了最大化可移植性，代码需要保存模糊数学值的时候应该使用不声明有效数字和小数位数的float或者double precison。

#### Bit-Vaalue Type-BIT

bit数据类型被用来保存比特值，一个bit(M)类星星允许保存M位比特的值。M取值范围为1-64.

为了表达一串bit值，可以使用b'value‘的表达。value是一个0-1二进制数。例如，b'111’和

`b'100'` 分别表示7和4.

如果你赋值给一个bit(M)类型列少于Mbit的值，这个值会左填充0，比如赋值b'101'给bit(6)列，结果相当于赋值b'000101'

如果使用NDB Cluster存储引擎（MySQL提供的分布式存储引擎)，在使用该存储引擎的表中所有bit列的最大总大小一定不能超过4096比特

#### Numeric Type Attributes

MySQL支持整数可选展示宽度的扩展。通过在类型关键字后面用圆括号括起来展示宽度的方式。

例如int(4)给出了一个4位展示宽度的int类型。选择的这个展示宽度可能会被应用用来展示宽度(位数)少于这个列指定的宽度的值会被左填充空格展示

展示宽度(displaye width)并不会限制这个类型的列的取值范围。也不会防止列的值的宽度超过列设定的展示宽度。比如一个被设定位smallint(3)的列会有smallint的取值范围，而且超过三位数允许范围的值将用多于3位数的全部数字显示

当于可选(且非标准的)zerofill属性一起使用的时候，默认填充左部的空格将由0代替。比如对于声明位int(4) zerofill的列，值5将被检索为0005

```
声明，在有的时候，zerofill的使用可能被忽略。
比如跟expressiongs or union queries有关的时候
更多见官网
```

zerofill将要在后面版本被移除出数学数值类型的属性。你应该使用lpad()函数来进行0填充或者用格式化的数字字符串来存储。

所有的整数类型有非标准的可选属性unsigned。unsigned表示无符号。修饰之后该类型的范围会发生改变

浮点数和定点数同样能够被unsigned修饰。这样能够防止负数被加入到它们的列中，但是这种支持将会在后面的版本放弃，可以考虑用check来代替

如果你对一个数学类型列使用了zerofill修饰，MySQL会自动给该列增加unsigned属性

整数或者浮点数能够能够使用auto_increment属性，当你插入一个控制到auto_increment的列中的时候，这个列值会设置为下一个序列值，比如value+1,当value式这个列之前表中的最大值的时候(auto_increment序列从1开始)

把0保存进auto_increment列中的效果等价于保存NULL,除非处于`no_auto_value_on_zero` SQL模式中

插入如NULL来产生自增值需要这个列被声明为NOT NULL的。如果这个列被声明为NULL的(也就是可空的),插入NULL则保存一个NULL。当你插艾儒人恶化值到auto_increment的列中，这个列会被设置成那个值，并且序列值被重新设置，因此下一个增加的值会从你这次插入的值开始计算。

auto_increment 列不支持负数

check 约束不能够指向那些用auto_increment属性修饰的列，也不能够把auto_increment属性加到那些被check约束的列上。

auto_increment用来修饰float和double的支持将在后面的版本中被移除。你应该考虑从这样修饰的float和double列中移除auto_increment属性，或者把他们转为整数类类型

#### Out-of-Range and Overflow Handling

越过表示范围，和超过内存限制的处理

当MySQL保存一个超过允许范围的数学列的值的时候，结果依赖于当时的SQL模式

* 如果是严格的SQL模式。MySQL会拒绝所有的超过范围的值，根据SQL标准返回error且插入失败

* 如果是不严格的模式。MySQL会修改不合理的值为合理，并且把结果插入。该模式下out-of-range的插入能够成功，不会返回error,但是会warning，可以用`show warnings;` 查看warning

  当一个超出范围的值被分配给一个整数字段时，MySQL会存储代表该字段数据类型范围的对应端点的值。也就是说，如果一个整数字段的范围是从0到100，那么当给该字段分配一个超出这个范围的值（比如200），MySQL将会存储100作为该字段的值。

  当一个浮点数或定点数列被赋予一个超过其指定（或默认）精度和小数位数的值时，MySQL会存储代表该范围的终点的值。也就是说，如果一个数据的值超出了这个字段的精度和小数位数所允许的范围，MySQL会将其截断为范围内的一个值。

overflow（溢出）导致表达式运算中。例如

bigint最大值`9223372036854775807` 下面的表达式会产生overflow错误

```
SELECT 9223372036854775807 + 1;
```

为了能够让操作成功，把这个值转为unsigned(无符号的)

```
SELECT CAST(9223372036854775807 AS UNSIGNED) + 1;
```

overflow是否发生取决于运算符的范围，所以另一种处理移除的方式是使用更大范围的数值进行运算。因为