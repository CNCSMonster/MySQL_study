# MySQL使用指南

#### 原文链接

[MySQL :: MySQL 8.0 Reference Manual :: 3 Tutorial](https://dev.mysql.com/doc/refman/8.0/en/tutorial.html)

## 一.连接远程服务器与断开连接

#### 1\.连接远程MySQL

```
mysql -h <host> -u <user> -p
```

使用该命令指定了连接远程地址为的主机上的名为的用户，-p指定使用密码。

使用该命令enter后就会出现密码输入口，输入密码且正确即可登录

#### 2\.连接本地MySQL

```
mysql -u <user> -p
```

#### 3\. 常见的登录失败原因

1. 远程地址错误

2. 本地或者远程的MySQL服务未启动

3. 账号密码错误

4. 账号没有远程访问权限:

   账号开始都是默认是只有本地访问权限的，也就是说只有服务器上才能够连接服务器上的MySQL服务。

   下载MySQL的时候一般会自动生成一个超级权限的root账号

#### 4\.特殊情况，无名用户登录

有的MySQL的下载版本允许用户直接使用`mysql` 来在本地连接数据库

#### 5\.断开连接

```
quit
```

如果是在unix系统上，你也可以用`ctrl+d` 来退出登录

## 二.输入查询 Entering Quieries

Make sure that you are connected to the server, as discussed in the previous section. Doing so does not in itself select any database to work with, but that is okay. At this point, it is more important to find out a little about how to issue queries than to jump right in creating tables, loading data into them, and retrieving data from them. This section describes the basic principles of entering queries, using several queries you can try out to familiarize yourself with how [**mysql**](https://dev.mysql.com/doc/refman/8.0/en/mysql.html) works.

```
确保你如前面小节讨论的那样已经连接上了服务。
连接上服务本身并不会指定要使用的数据库，这是正常现象。
这种情况下，更重要的事情是了解更多关于如何查询的知识，而不是关于
如何创建表，如何网表中插入数据，或者是如何从表中检索记录(这里检索偏指是底层实现)
这一节描述了基础的输入查询的原则,并且使用了几个你可以尝试的能帮助你熟悉mysql如何工作
的例子
```

#### Query 和 Retrieve有什么区别?

A query is a synonym for a `select`  statement

An `SQL SELECT` statement retrieves records from a database table

Queries,which retrieve the data based on specific criteria

阅读了大量StackOverflow关于这个问题的讨论以及结合MySQL文档中的上下文，笔者给出如下定义:

1. 对于使用者来说，很多时候这两个词都是可以互换的，两个词都有查询的意思。但是实际上它们关注查询的不同方向。

2. 当我们使用Query的时候，表示我们更关心查询语句如何表达，query的过程包括写出查询语法规定的查询语句，以及查询语句如何被解析器解析成底层的查询程序，最多我们关心到如何解析的过程，因为我们要写出合法的查询语句

3. 当我们讲到Retrieve的时候，我们更关心的是底层，使用了什么样的算法去检索表中的记录，使用了什么标准，进行了哪些实际操作，我们关心的是实际检索过程。

Here is a simple query that asks the server to tell you its version number and the current date. Type it in as shown here following the `mysql>` prompt and press Enter:

下面是一个询问服务器让它告诉你版本号以及当前日期的简单查询。

在`mysql>` 后面输入`SELECT VERSION(), CURRENT_DATE;` 并查看结果

```
mysql> SELECT VERSION(), CURRENT_DATE;
+-----------+--------------+
| VERSION() | CURRENT_DATE |
+-----------+--------------+
| 5.8.0-m17 | 2015-12-21   |
+-----------+--------------+
1 row in set (0.02 sec)
mysql>
```

This query illustrates several things about [**mysql**](https://dev.mysql.com/doc/refman/8.0/en/mysql.html):

这个查询说明了关于mysql的几件事情

* A query normally consists of an SQL statement followed by a semicolon. (There are some exceptions where a semicolon may be omitted. `QUIT`, mentioned earlier, is one of them. We'll get to others later.)

  一个查询一般包括一个用分号结尾的SQL语句。(有些例外的语句可能可以忽略分号，比如之前讲到的`quit` 就是其中之一。我们稍后讲看到其他例子)

* When you issue a query, [**mysql**](https://dev.mysql.com/doc/refman/8.0/en/mysql.html) sends it to the server for execution and displays the results, then prints another `mysql>` prompt to indicate that it is ready for another query.

  当你提出一个查询的时候,mysql把它发送给服务器执行，并且显示结果，然后打印下一个`mysql>` 提示来说明它已经准备号接受下一个查询了

* [**mysql**](https://dev.mysql.com/doc/refman/8.0/en/mysql.html) displays query output in tabular form (rows and columns). The first row contains labels for the columns. The rows following are the query results. Normally, column labels are the names of the columns you fetch from database tables. If you're retrieving the value of an expression rather than a table column (as in the example just shown), [**mysql**](https://dev.mysql.com/doc/refman/8.0/en/mysql.html) labels the column using the expression itself.

  mysql通过一种(行列)表格的形式展示查询结果。第一行包括所有列的标志。下面的其他行则是查询结果。一般的，列标志是你从表中获取的列名。如果你从一个表达式中检索值而不是从一个表列项(就像上述例子演示的),mysql标志就是这个列使用的表达式。

* [**mysql**](https://dev.mysql.com/doc/refman/8.0/en/mysql.html) shows how many rows were returned and how long the query took to execute, which gives you a rough idea of server performance. These values are imprecise because they represent wall clock time (not CPU or machine time), and because they are affected by factors such as server load and network latency. (For brevity, the “rows in set” line is sometimes not shown in the remaining examples in this chapter.)

  mysql会展示返回了多少列，以及查询花费了多长时间，这些能够让你对服务器的表现有个大概的认识。返回的列数和查询时间开销并不是精确的，因为采用的是墙时钟(而不是CPU时间或者机器时间),也因为它们还受到服务器载入和网络延迟的影响。(ps，这里的墙时间是区别于时钟脉冲时钟，cpu时钟的一种时间，比如手表计时和挂钟计时都属于墙时间,没有时钟脉冲时间或者说cpu时钟精确）。(为了文本简洁，`<n> rows in set` 行有时候在本章的例子中展示)

Keywords may be entered in any lettercase. The following queries are equivalent:

关键字可能用任何的大小写形式输入。下面的查询是等价的

```sql
mysql> SELECT VERSION(), CURRENT_DATE;
mysql> select version(), current_date;
mysql> SeLeCt vErSiOn(), current_DATE;
```

Here is another query. It demonstrates that you can use [**mysql**](https://dev.mysql.com/doc/refman/8.0/en/mysql.html) as a simple calculator:

这是另一个查询的例子。它演示了你可以使用mysql作为简单计算器使用

```sql
mysql> SELECT SIN(PI()/4), (4+1)*5;
+------------------+---------+
| SIN(PI()/4)      | (4+1)*5 |
+------------------+---------+
| 0.70710678118655 |      25 |
+------------------+---------+
1 row in set (0.02 sec)
```

The queries shown thus far have been relatively short, single-line statements. You can even enter multiple statements on a single line. Just end each one with a semicolon:

到目前为止已经展示了相对短的单行的查询语句。你也可以在同一行输入多个查询语句，只要在每个查询语句的末尾用分号结束就行

```sql
mysql> SELECT VERSION(); SELECT NOW();
+-----------+
| VERSION() |
+-----------+
| 8.0.13    |
+-----------+
1 row in set (0.00 sec)

+---------------------+
| NOW()               |
+---------------------+
| 2018-08-24 00:56:40 |
+---------------------+
1 row in set (0.00 sec)
```

A query need not be given all on a single line, so lengthy queries that require several lines are not a problem. [**mysql**](https://dev.mysql.com/doc/refman/8.0/en/mysql.html) determines where your statement ends by looking for the terminating semicolon, not by looking for the end of the input line. (In other words, [**mysql**](https://dev.mysql.com/doc/refman/8.0/en/mysql.html) accepts free-format input: it collects input lines but does not execute them until it sees the semicolon.)

一个查询不必在一行全部给出，因此需要多行的长查询不成问题。mysql通过搜索结束符来判断你的语句什么时候结束,而不是通过输入行的结尾标志(换句话说，mysql接受自由格式的输入。它收集输入行但是直到它发现了分号才执行它们)

```
笔者:
mysql默认使用分号来作为sql语句的结尾，
它会收集分号前的所有行的输入作为来作为一个整体sql语句。
mysql中可以使用delimiter <end>语句来修改结束符号为<end>
```

Here is a simple multiple-line statement:

下面是一个简单的多行描述的例子

```sql
mysql> SELECT
    -> USER()
    -> ,
    -> CURRENT_DATE;
+---------------+--------------+
| USER()        | CURRENT_DATE |
+---------------+--------------+
| jon@localhost | 2018-08-24   |
+---------------+--------------+
```

In this example, notice how the prompt changes from `mysql>` to `->` after you enter the first line of a multiple-line query. This is how [**mysql**](https://dev.mysql.com/doc/refman/8.0/en/mysql.html) indicates that it has not yet seen a complete statement and is waiting for the rest. The prompt is your friend, because it provides valuable feedback. If you use that feedback, you can always be aware of what [**mysql**](https://dev.mysql.com/doc/refman/8.0/en/mysql.html) is waiting for.

在这个例子里，注意当你输入多行查询的第一行后输入提示从`mysql>` 变为了`->` 。这是mysql表明它还没有读取完一个语句的标志，并且表示它还在等待后续输入。这个标志是你的朋友，因为它提供了有价值的反馈。如果你利用好了这个反馈，你能够总是认识到mysql在等待什么。

If you decide you do not want to execute a query that you are in the process of entering, cancel it by typing `\c`:

如果你决定你不想要执行你正在输入的语句，可以打下`\c` 字符串来取消

```sql
mysql> SELECT
    -> USER()
    -> \c
mysql>
```

Here, too, notice the prompt. It switches back to `mysql>` after you type `\c`, providing feedback to indicate that [**mysql**](https://dev.mysql.com/doc/refman/8.0/en/mysql.html) is ready for a new query.

这里同样需要注意提示串。当你输入`\c` 后(提示这里的输入`\c` 后指的是打下这两个字符然后enter后)它又变回了`mysql>` ,提供了一个mysql已经准备好接受新的查询的反馈。

The following table shows each of the prompts you may see and summarizes what they mean about the state that [**mysql**](https://dev.mysql.com/doc/refman/8.0/en/mysql.html) is in.

下表展示了你可能会遇到的每种输入提示，并且总结了它们意味着什么。

|**Prompt**|**Meaning**|
|-|-|
|`mysql>`|Ready for new query|
|`->`|Waiting for next line of multiple-line query|
|`'>`|Waiting for next line, waiting for completion of a string that began with a single quote (`'`)|
|`">`|Waiting for next line, waiting for completion of a string that began with a double quote (`"`)|
|`` `> ``|Waiting for next line, waiting for completion of an identifier that began with a backtick (`` ` ``)|
|`/*>`|Waiting for next line, waiting for completion of a comment that began with `/*`|

```
说明:
1.backtick(`)(撇号)在mysql中的作用:
用来包裹一个使用了特殊字符或者保留字的标识符
例如，如果你有一个名叫order的表(order是mysql中的保留字)，你能够
用`来包裹住它来避免使用表名的时候表名被当成order保留字
如
select * from `order`;
又比如有个表的名字是my name，因为表名里面有空格，所以使用时要用撇号:
select * from `my name`;
对于没有使用特殊字符或者保留字的标识符来说，是否使用撇号包裹是可选的。
```

Multiple-line statements commonly occur by accident when you intend to issue a query on a single line, but forget the terminating semicolon. In this case, [**mysql**](https://dev.mysql.com/doc/refman/8.0/en/mysql.html) waits for more input:

当你想要在单行输入一个查询的时候，往往因为忘记加上结尾的分号，导致变成多行查询。在这种情况下，mysql会等待更多的输入:

```sql
mysql> SELECT USER()
    ->
```

If this happens to you (you think you've entered a statement but the only response is a `->` prompt), most likely [**mysql**](https://dev.mysql.com/doc/refman/8.0/en/mysql.html) is waiting for the semicolon. If you don't notice what the prompt is telling you, you might sit there for a while before realizing what you need to do. Enter a semicolon to complete the statement, and [**mysql**](https://dev.mysql.com/doc/refman/8.0/en/mysql.html) executes it:

如果你遇到了这种情况(你认为你已经输入了一个语句但是唯一的反馈只是一个`->` 提示),往往时mysql在等待一个分号。

如果你没有注意到这个提示想要告诉你的事情，你可能会坐在那儿等一会才意识到你需要做什么。输入一个分号来结束一个语句，然后mysql才会执行它:

```sql
mysql> SELECT USER()
    -> ;
+---------------+
| USER()        |
+---------------+
| jon@localhost |
+---------------+
```

The `'>` and `">` prompts occur during string collection (another way of saying that MySQL is waiting for completion of a string). In MySQL, you can write strings surrounded by either `'` or `"` characters (for example, `'hello'` or `"goodbye"`), and [**mysql**](https://dev.mysql.com/doc/refman/8.0/en/mysql.html) lets you enter strings that span multiple lines. When you see a `'>` or `">` prompt, it means that you have entered a line containing a string that begins with a `'` or `"` quote character, but have not yet entered the matching quote that terminates the string. This often indicates that you have inadvertently left out a quote character. For example:

`'>` 和`">` 提示当且仅当收集字符串的时候发生(换句话说，MySQL在等待正在读入的字符串输入结束)。在MySQL中，你能够通过`'` 或者`"` 包围的方式输入字符串(比如`'hello'` 或者`"goodbye"` ),并且mysql允许你输入跨越多行行的字符串。当你看到`'>` 或者`">` 提示的时候，它意味着你已经输入了一个用一个`'` 或者`"` 开头的字符串，并且还没有用一个`'` 或者`"` 结束输入。这通常表明你无意中遗漏了一个结束时的引号。例如:

```sql
mysql> SELECT * FROM my_table WHERE name = 'Smith AND age < 30;
    '>
```

If you enter this `SELECT` statement, then press **Enter** and wait for the result, nothing happens. Instead of wondering why this query takes so long, notice the clue provided by the `'>` prompt. It tells you that [**mysql**](https://dev.mysql.com/doc/refman/8.0/en/mysql.html) expects to see the rest of an unterminated string. (Do you see the error in the statement? The string `'Smith` is missing the second single quotation mark.)

如果输入了这样一个`select` 语句，然后按下enter键并且等待结果，那么什么都不会发生。别疑惑为什么这个查询花了这么长时间，而是要领悟到到`'>` 提示串提供的线索。它告诉你mysql期望遇到这个未结束字符串的剩余部分。（你发现这个语句中的错误了吗?字符串`'Smith` 遗漏了第二个单引号)

At this point, what do you do? The simplest thing is to cancel the query. However, you cannot just type `\c` in this case, because [**mysql**](https://dev.mysql.com/doc/refman/8.0/en/mysql.html) interprets it as part of the string that it is collecting. Instead, enter the closing quote character (so [**mysql**](https://dev.mysql.com/doc/refman/8.0/en/mysql.html) knows you've finished the string), then type `\c`:

这种情况下，你会怎么做?最简单的做法是取消这个查询。然而，这种情况下你不能只是键入`\c` ,因为mysql会把它解释成正在收集的字符串的一部分。所以相反地，要输入末引号(这样mysql才直到你已经结束了字符的输入),然后再键入`\c` :

```sql
mysql> SELECT * FROM my_table WHERE name = 'Smith AND age < 30;
    '> '\c
mysql>
```

The prompt changes back to `mysql>`, indicating that [**mysql**](https://dev.mysql.com/doc/refman/8.0/en/mysql.html) is ready for a new query.

提示变回了`mysql>` ，表明mysql已经准备好接受新的查询了。

The `` `> `` prompt is similar to the `'>` and `">` prompts, but indicates that you have begun but not completed a backtick-quoted identifier.

`` `> `` 提示串跟   `'>` and`">` 提示串很像，但表示你已经输入了一个还没有用配好结束的标识符。(标识符包括表名，列名，数据库名等）

It is important to know what the `'>`, `">`, and `` `> `` prompts signify, because if you mistakenly enter an unterminated string, any further lines you type appear to be ignored by [**mysql**](https://dev.mysql.com/doc/refman/8.0/en/mysql.html)—including a line containing `QUIT`. This can be quite confusing, especially if you do not know that you need to supply the terminating quote before you can cancel the current query.

你需要知道到 `'>`, `">`, 和 `` `> `` 都表达什么意思，尤其是你错误地输入了一个未结束字符串地时候，你后面输入的无论多少行都会被myusql忽略，包括含有quit的行。这可能很让人困惑，特别是当你想要取消当前查询却不知道你需要提供结束引号(译者注:这里的引号为未完成字符串的后引号，包括我们说的撇号，单引号，双引号，具体是什么取决于开始字符串所用的前引号类型)的时候。

**Note**

Multiline statements from this point on are written without the secondary (`->` or other) prompts, to make it easier to copy and paste the statements to try for yourself.

注意!

从此处开始的多行语句不再附上(`->` 或者其他)提示串文本，为了让你能够更好地自己去复制和黏贴这些语句来体会。

## 三.创建和使用数据库

Once you know how to enter SQL statements, you are ready to access a database.

在准备创建数据库之前，你需要知道如何输入SQL语句。

Suppose that you have several pets in your home (your menagerie) and you would like to keep track of various types of information about them. You can do so by creating tables to hold your data and loading them with the desired information. Then you can answer different sorts of questions about your animals by retrieving data from the tables. This section shows you how to perform the following operations:

假设你在家里养了一些宠物，并且你想要记录它们的各种信息。你可以通过创建表格来保存数据以及往表格中载入数据的方式来做到。然后你能过够通过检索表格的方式回答关于你的动物的各种问题。这一节的内容会告诉你怎样进行这些操作:

* Create a database 创建数据库

* Create a table 创建表格

* Load data into the table 往表格中载入数据

* Retrieve data from the table in various ways

  通过多种方式检索表格中的数据

* Use multiple tables 使用多个表格

The menagerie database is simple (deliberately), but it is not difficult to think of real-world situations in which a similar type of database might be used. For example, a database like this could be used by a farmer to keep track of livestock, or by a veterinarian to keep track of patient records. A menagerie distribution containing some of the queries and sample data used in the following sections can be obtained from the MySQL website. It is available in both compressed **tar** file and Zip formats at <https://dev.mysql.com/doc/>.

动物园数据库被故意设计的简单，但是已经不难体现真实世界中这样的数据库的可能使用方式。例如，一个像这样的数据库可能被一个农民用来监测作物，或者被一个兽医用来记录病情。一个动物园数据库包括在下面章节中用到的查询和样例数据，它能够通过MySQL 的网站获得。你可以在<https://dev.mysql.com/doc/>获得它的tar或者Zip格式资源。

Use the `SHOW` statement to find out what databases currently exist on the server:

使用`show` 语句来查看当前服务器存在的数据库

```sql
mysql> SHOW DATABASES;
+----------+
| Database |
+----------+
| mysql    |
| test     |
| tmp      |
+----------+
```

The `mysql` database describes user access privileges. The `test` database often is available as a workspace for users to try things out.

`mysql` 数据库描述了用户访问权限。`test` 数据库总是能够作为一个允许用户尝试各种事情的工作空间

(笔者注释:你下载了MySQL后默认是没有test数据库的，默认是数据库是MySQL工作要用到的几个数据库，所以你同样命令输入获得的结果和上图不一样很正常)

The list of databases displayed by the statement may be different on your machine; `SHOW DATABASES` does not show databases that you have no privileges for if you do not have the `SHOW DATABASES` privilege. See [Section 13.7.7.14, “SHOW DATABASES Statement”](https://dev.mysql.com/doc/refman/8.0/en/show-databases.html).

该SQL于展示的数据库列表可能与你机器上展示的不同;`show databases` 并不展示你没有`show databases` 类型权限的数据库。详情见[Section 13.7.7.14, “SHOW DATABASES Statement”](https://dev.mysql.com/doc/refman/8.0/en/show-databases.html).

If the `test` database exists, try to access it:

如果`test` 数据库存在，试着进入它

```sql
mysql> USE test
Database changed
```

`USE`, like `QUIT`, does not require a semicolon. (You can terminate such statements with a semicolon if you like; it does no harm.) The `USE` statement is special in another way, too: it must be given on a single line.

像`quit` 命令一样，`use` 命令不需要分号作结束。（如果你喜欢的话，你也可以用一个分号结束；那并不会造成什么影响。）`use` 语句还有一个特别之处：它一定要在单行给出。

You can use the `test` database (if you have access to it) for the examples that follow, but anything you create in that database can be removed by anyone else with access to it. For this reason, you should probably ask your MySQL administrator for permission to use a database of your own. Suppose that you want to call yours `menagerie`. The administrator needs to execute a statement like this:

(当你进入它后）你就能够像下面例子那样使用`test` 数据库了，但是任何

你在这个数据库中创建的内容能够被任何同样进入数据库的人移除。所以，你很可能需要让你的MySQL管理员给予你单独使用这个数据库的权限。假设你想要访问你的`menagerie` 数据库，管理员需要执行像下面这样的语句:

```sql
mysql> GRANT ALL ON menagerie.* TO 'your_mysql_name'@'your_client_host';
```

where `your_mysql_name` is the MySQL user name assigned to you and `your_client_host` is the host from which you connect to the server.

这里`your_mysql_name` 是你的MySQL用户名字，`your_client_host` 则是你想要连接的服务器所在的主机名

### 1\.单个数据库的创建与查询

If the administrator creates your database for you when setting up your permissions, you can begin using it. Otherwise, you need to create it yourself:

如果管理员为你创建了数据库并且赋予了你了访问权限，你就能够开始使用它。不然，你需要自己去创建它

```sql
mysql> CREATE DATABASE menagerie;
```

Under Unix, database names are case-sensitive (unlike SQL keywords), so you must always refer to your database as `menagerie`, not as `Menagerie`, `MENAGERIE`, or some other variant. This is also true for table names. (Under Windows, this restriction does not apply, although you must refer to databases and tables using the same lettercase throughout a given query. However, for a variety of reasons, the recommended best practice is always to use the same lettercase that was used when the database was created.)

在Unix系统中，数据库的名字是大小写敏感的(不像SQL关键字)，因此你应该总是使用`menagerie` 来指向你的数据库，而不是`Menagerie` ,`MANAGERIE` 或者其他什么变体。对表名同样如此（在Windows下,这种限制并不适用,尽管在给出同一个查询的时候你必须参照数据库和表使用相同的大小写。然而，出于多种原因，最佳的实践是当数据库创建后总是使用相同的大小写)

**Note**

If you get an error such as ERROR 1044 (42000): Access denied for user 'micah'@'[localhost](http://localhost)' to database 'menagerie' when attempting to create a database, this means that your user account does not have the necessary privileges to do so. Discuss this with the administrator or see [Section 6.2, “Access Control and Account Management”](https://dev.mysql.com/doc/refman/8.0/en/access-control.html).

如果你在试图创建一个数据库的时候遇到了一个像` ERROR 1044 (42000): Access denied for user 'micah'@'localhost' to database 'menagerie'` 这样的错误提示，这意味着你的用户账号没有建库必须的权限。与数据库管理员工讨论这个问题或者参考 [Section 6.2, “Access Control and Account Management”](https://dev.mysql.com/doc/refman/8.0/en/access-control.html).

Creating a database does not select it for use; you must do that explicitly. To make `menagerie` the current database, use this statement:

创建一个数据库后并不会默认选择它来使用；你一定要显式地发出命令。

为了将当前使用数据库设置为`menagerie` ,使用这个语句:

```sql
mysql> USE menagerie
Database changed
```

Your database needs to be created only once, but you must select it for use each time you begin a [**mysql**](https://dev.mysql.com/doc/refman/8.0/en/mysql.html) session. You can do this by issuing a `USE` statement as shown in the example. Alternatively, you can select the database on the command line when you invoke [**mysql**](https://dev.mysql.com/doc/refman/8.0/en/mysql.html). Just specify its name after any connection parameters that you might need to provide. For example:

你的数据库只需要创建一次。但是每次新开启一个mysql对话你在使用前都一定要选择它一次。你一定要提出一个前例中那样的`use` 语句来选择。等价地，你也可以在控制台调用mysql地时候选择数据库。只要在连接参数中指定数据库的名字即可，例如:

```terminal
$> mysql -h host -u user -p menagerie
Enter password: ********
```

**Important 注意!**

`menagerie` in the command just shown is ***not*** your password. If you want to supply your password on the command line after the `-p` option, you must do so with no intervening space (for example, as `-ppassword`, not as `-p password`). However, putting your password on the command line is not recommended, because doing so exposes it to snooping by other users logged in on your machine.

命令中使用的`menagerie` 并不是你的密码。如果你想在在-p选项后面输入密码，你需要使用不插入空格的方式（例如，使用`-p<password>` ，而不是使用`-p password` .然而，在命令行中输入密码时一种不被建议的行为，因为这样做很容易暴露密码给其他登录了你机器窥看的人。

**Note**

You can see at any time which database is currently selected using `SELECT` `DATABASE()`.

你可以在任何时候通过使用`select database()` 语句来查看当前使用的数据库.

(ps,文档里面，比如这里，给出的示例语句中没有分号，实际上加上分号作为语句结尾才是一个完整的语句。

为什么不给出分号呢？为什么文档中不直接用`select database()` 呢？

一个原因可能是因为mysql中客户端的语句结束符号是可以通过`delimiter` 命令更改的。

所以语句结束符不一定总是`;` 

)

### 2\.创建表

Creating the database is the easy part, but at this point it is empty, as `SHOW TABLES` tells you:

创建数据库是一个容易的环节，但是到目前为止它里面还是空的，就像`show tables` 命令告诉你的一样:

```sql
mysql> SHOW TABLES;
Empty set (0.00 sec)
```

The harder part is deciding what the structure of your database should be: what tables you need and what columns should be in each of them.

决定你数据库的结构应该是怎样的是一个更困难的环节:你需要哪些表以及每个表应该有哪些列。

You want a table that contains a record for each of your pets. This can be called the `pet` table, and it should contain, as a bare minimum, each animal's name. Because the name by itself is not very interesting, the table should contain other information. For example, if more than one person in your family keeps pets, you might want to list each animal's owner. You might also want to record some basic descriptive information such as species and sex.

你一定想要一个表包含你的每个宠物的记录。这个表可以名为`pet` ,并且它至少应该包括每只宠物的名字。因为宠物的名字并不是很受关注，这个表格还应该包括其他信息。例如,如果超过一个家庭成员养宠物，你也许想要一个每个宠物的主人的清单。你可能还想要记录一些关于种类和性别的基础描述信息。

How about age? That might be of interest, but it is not a good thing to store in a database. Age changes as time passes, which means you'd have to update your records often. Instead, it is better to store a fixed value such as date of birth. Then, whenever you need age, you can calculate it as the difference between the current date and the birth date. MySQL provides functions for doing date arithmetic, so this is not difficult. Storing birth date rather than age has other advantages, too:

那年龄呢?那可能也是一个值得关注的信息，但是把它存在数据库里不是一个好主意。年龄随着实践流逝改变，这意味着你要经常更新你的表。然而，更好的做法是保存一个像是出生日期那样固定的值。然后，无论何时，当你需要年龄信息的时候，你可以通过计算当前日期和出生日期的差来得到。MySQL提供了用来做日期计算的函数，因此这不困难。保存出生日期而不是年龄还有其优点:

* You can use the database for tasks such as generating reminders for upcoming pet birthdays. (If you think this type of query is somewhat silly, note that it is the same question you might ask in the context of a business database to identify clients to whom you need to send out birthday greetings in the current week or month, for that computer-assisted personal touch.)

  你能够使用数据库来执行像是生成即将到来的宠物庆生日的日程提醒。(如果你认为这种查询有些愚蠢的话，需要注意到你可能需要在一个商业数据库里面标识近周或者近月你将要发送生日祝贺的客户，以便通过计算机支持实现个性化的问候)

* You can calculate age in relation to dates other than the current date. For example, if you store death date in the database, you can easily calculate how old a pet was when it died.

  你可以根据当前日期以外的日期来计算年龄。比如,如果你在数据库中保存了死亡日期，你能够轻松地算出宠物死亡的时候它的年龄。

You can probably think of other types of information that would be useful in the `pet` table, but the ones identified so far are sufficient: name, owner, species, sex, birth, and death.

你很可能想到对于`pet` 表有用的其他类型的信息。但是至今已经确认了足够的信息:名字，主人，种类，性别，生日，死期。

Use a `CREATE TABLE` statement to specify the layout of your table:

使用一条`create table` 语句来指定你的表的布局:

```sql
mysql> CREATE TABLE pet (name VARCHAR(20), owner VARCHAR(20),
       species VARCHAR(20), sex CHAR(1), birth DATE, death DATE);
```

`VARCHAR` is a good choice for the `name`, `owner`, and `species` columns because the column values vary in length. The lengths in those column definitions need not all be the same, and need not be `20`. You can normally pick any length from `1` to `65535`, whatever seems most reasonable to you. If you make a poor choice and it turns out later that you need a longer field, MySQL provides an `ALTER TABLE` statement.

`VARCHAR` 类型是名字，主人还有属性列的好选择，因为这些列的值长度会变化。那些列的定义时指定的长度不必相同，也并不必是20，你一般可以选择任何从1到65535之间的长度，完全取决于你自己。如果你做了个糟糕的选择，并且后面才发现你需要一个更大的范围，MySQL提供了`ALTER TABLE` 语句来修改。

Several types of values can be chosen to represent sex in animal records, such as `'m'` and `'f'`, or perhaps `'male'` and `'female'`. It is simplest to use the single characters `'m'` and `'f'`.

动物记录里面可以用一些类型的值来表达性别，比如`'m'` 和`'f'` ,或者

`'male'` 和`'female'` 。最简单的方法是用单个字符的`'m'` 和`'f'。`

The use of the `DATE` data type for the `birth` and `death` columns is a fairly obvious choice.

通常`birth` 和`death` 列使用日期类型的数据

Once you have created a table, `SHOW TABLES` should produce some output:

当你创建了一个表格后，`show tables` 会提供如下输出:

```sql
mysql> SHOW TABLES;
+---------------------+
| Tables in menagerie |
+---------------------+
| pet                 |
+---------------------+
```

To verify that your table was created the way you expected, use a `DESCRIBE` statement:

使用`describe` 命令来验证你的表格的创建是否符合你的期待(你也可以使用缩写命令`desc` )

```sql
mysql> DESCRIBE pet;
+---------+-------------+------+-----+---------+-------+
| Field   | Type        | Null | Key | Default | Extra |
+---------+-------------+------+-----+---------+-------+
| name    | varchar(20) | YES  |     | NULL    |       |
| owner   | varchar(20) | YES  |     | NULL    |       |
| species | varchar(20) | YES  |     | NULL    |       |
| sex     | char(1)     | YES  |     | NULL    |       |
| birth   | date        | YES  |     | NULL    |       |
| death   | date        | YES  |     | NULL    |       |
+---------+-------------+------+-----+---------+-------+
```

You can use `DESCRIBE` any time, for example, if you forget the names of the columns in your table or what types they have.

你可以在任何时候时使用`descibe` ，例如，当你忘记了表格的列名或者这些列的数据类型的时候

For more information about MySQL data types, see [Chapter 11, *Data Type*](https://dev.mysql.com/doc/refman/8.0/en/data-types.html)

更多关于MySQL数据类型的信息，参考 [Chapter 11, *Data Type*](https://dev.mysql.com/doc/refman/8.0/en/data-types.html)

### 3\.往表中载入数据

After creating your table, you need to populate it. The `LOAD DATA` and `INSERT` statements are useful for this.

创建了表后，你需要填充它。可以使用`load  data` 或者`insert` 语句来做这件事。

Suppose that your pet records can be described as shown here. (Observe that MySQL expects dates in `'YYYY-MM-DD'` format; this may differ from what you are used to.)

假设你的宠物记录描述如下。(注意MySQL的日期格式如`YYYY-MM-DD` ;这个可能与你习惯使用的日期不一样)

|**name**|**owner**|**species**|**sex**|**birth**|**death**|
|-|-|-|-|-|-|
|**Fluffy**|Harold|cat|f|1993-02-04||
|-|-|-|-|-|-|
|**Claws**|Gwen|cat|m|1994-03-17||
|-|-|-|-|-|-|
|**Buffy**|Harold|dog|f|1989-05-13||
|-|-|-|-|-|-|
|**Fang**|Benny|dog|m|1990-08-27||
|-|-|-|-|-|-|
|**Bowser**|Diane|dog|m|1979-08-31|1995-07-29|
|-|-|-|-|-|-|
|**Chirpy**|Gwen|bird|f|1998-09-11||
|-|-|-|-|-|-|
|**Whistler**|Gwen|bird||1997-12-09||
|-|-|-|-|-|-|
|**Slim**|Benny|snake|m|1996-04-29||
|-|-|-|-|-|-|

Because you are beginning with an empty table, an easy way to populate it is to create a text file containing a row for each of your animals, then load the contents of the file into the table with a single statement.

因为你开始使用的是一个空表，一个简单地填充表的方法是创建一个包含你的动物们的每行记录的一个文本文件，然后使用一个SQL语句来把文件的内容加载到表中。

You could create a text file `pet.txt` containing one record per line, with values separated by tabs, and given in the order in which the columns were listed in the `CREATE TABLE` statement. For missing values (such as unknown sexes or death dates for animals that are still living), you can use `NULL` values. To represent these in your text file, use `\N` (backslash, capital-N). For example, the record for Whistler the bird would look like this (where the whitespace between values is a single tab character):

你可以创建一个名为`pet.txt` 的文本文件，令它的每一行包括一个记录，每个记录的各项值使用过一个制表符隔开，并且个项值顺序符合`create table` 定义表时描述的列顺序。对于缺失的值(比如不知道的性别或者还活着的动物的死亡信息),你可以使用`NULL` 值.使用`\N` (反斜杠，大写N)来在文本文件中表达这个值。举个例子，关于Whistler这只鸟的记录如下所示(项值之间的空白类型字符时单单一个制表符)

```none
Whistler        Gwen    bird    \N      1997-12-09      \N
```

To load the text file `pet.txt` into the `pet` table, use this statement:

为了把`pet.txt` 文件加载到表`pet` 中，使用如下语句:

```sql
mysql> LOAD DATA LOCAL INFILE '/path/pet.txt' INTO TABLE pet;
```

If you created the file on Windows with an editor that uses `\r\n` as a line terminator, you should use this statement instead:

如果这个文件是你在Windows上用一个使用`\r\n`作为行结束符的文本编辑器创建的，你应该使用如下语句:

```sql
mysql> LOAD DATA LOCAL INFILE '/path/pet.txt' INTO TABLE pet
       LINES TERMINATED BY '\r\n';
```

(On an Apple machine running macOS, you would likely want to use `LINES TERMINATED BY '\r'`.)

(在一个运行macOS系统的苹果机器上，你最好使用`lines terminated by '\r'` 。)

You can specify the column value separator and end of line marker explicitly in the `LOAD DATA` statement if you wish, but the defaults are tab and linefeed. These are sufficient for the statement to read the file `pet.txt` properly.

如果你希望，在`load data` 语句中你可以显式地指定每行记录的项值之间的分隔符以及行结束标记，而两者默认使用的分别是制表符和换行符。这些使得该语句能够正确地加载`pet.txt` 语句

If the statement fails, it is likely that your MySQL installation does not have local file capability enabled by default. See [Section 6.1.6, “Security Considerations for LOAD DATA LOCAL”](https://dev.mysql.com/doc/refman/8.0/en/load-data-local-security.html), for information on how to change this.

如果`load data local`语句执行失败，很可能是你安装MySQL时默认没有启动本地文件功能。关于如何修改的信息可参考 [Section 6.1.6, “Security Considerations for LOAD DATA LOCAL”](https://dev.mysql.com/doc/refman/8.0/en/load-data-local-security.html)

When you want to add new records one at a time, the `INSERT` statement is useful. In its simplest form, you supply values for each column, in the order in which the columns were listed in the `CREATE TABLE` statement. Suppose that Diane gets a new hamster named “Puffball.” You could add a new record using an `INSERT` statement like this:

当你想要一次性往表中增加新记录，还可以使用`insert` 语句。使用它的最简单的形式时，你要按照`create table` 语句建表时指定的列顺序提供值。假设Diane获得了一只新的名为”Puffball"的仓鼠。你可以使用如下`insert` 语句来增加一条新的记录:

```sql
mysql> INSERT INTO pet
       VALUES ('Puffball','Diane','hamster','f','1999-03-30',NULL);
```

String and date values are specified as quoted strings here. Also, with `INSERT`, you can insert `NULL` directly to represent a missing value. You do not use `\N` like you do with `LOAD DATA`.

在这里，字符串和日期值要使用引号包围的形式给出。同时，使用`insert`,你也可以直接插入`NULL` 来代表一个缺失的值。你不能够像是在`load data` 语句中一样使用`\N` 了。

From this example, you should be able to see that there would be a lot more typing involved to load your records initially using several `INSERT` statements rather than a single `LOAD DATA` statement.

从这个例子，你应该可以意识到如果你使用多个`insert` 语句而不是一个`load data` 语句来在开始的时候加载记录，要键入更多相关字符。

(其实这段话是在表达一种倾向，载入数据的时候，如果可以，尽量使用`load data` 语句而不是多个`insert` 语句，后者需要打下下键盘，可能会造成很多时间的浪费而且会增加出错几率)