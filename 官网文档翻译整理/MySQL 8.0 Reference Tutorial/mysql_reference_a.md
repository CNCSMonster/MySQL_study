# MySQL使用指南

#### 原文链接

[MySQL :: MySQL 8.0 Reference Manual :: 3 Tutorial](https://dev.mysql.com/doc/refman/8.0/en/tutorial.html)

## **一.连接远程服务器与断开连接**

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
|\-|\-|\-|\-|\-|\-|
|**Claws**|Gwen|cat|m|1994-03-17||
|\-|\-|\-|\-|\-|\-|
|**Buffy**|Harold|dog|f|1989-05-13||
|\-|\-|\-|\-|\-|\-|
|**Fang**|Benny|dog|m|1990-08-27||
|\-|\-|\-|\-|\-|\-|
|**Bowser**|Diane|dog|m|1979-08-31|1995-07-29|
|\-|\-|\-|\-|\-|\-|
|**Chirpy**|Gwen|bird|f|1998-09-11||
|\-|\-|\-|\-|\-|\-|
|**Whistler**|Gwen|bird||1997-12-09||
|\-|\-|\-|\-|\-|\-|
|**Slim**|Benny|snake|m|1996-04-29||
|\-|\-|\-|\-|\-|\-|

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

(其实这段话是在表达一种倾向，载入数据的时候，如果可以，尽量使用`load data` 语句而不是多个`insert` 语句，后者需要更多的键入，可能会造成很多时间的浪费而且会增加出错的概率)

### 4\.从表中检索信息

The `SELECT` statement is used to pull information from a table. The general form of the statement is:

用来从表中拉取数据。一般使用格式如下：

```sql
  SELECT what_to_select
  FROM which_table
  WHERE conditions_to_satisfy;
```

`what_to_select` indicates what you want to see. This can be a list of columns, or `*` to indicate “all columns.” `which_table` indicates the table from which you want to retrieve data. The `WHERE` clause is optional. If it is present, `conditions_to_satisfy` specifies one or more conditions that rows must satisfy to qualify for retrieval.

`what_to_select` 为你想要看的内容。这可以是一个列名的列表，或者是使用`*` 来表达"所有列".`which_table` 为你想要从中检索数据的表。`where` 分句是可有可无的。如果存在该分句，`conditions_to_satisfy` 用来指明你想要检索的行需要满足的一个或者多个条件(用笔者的话说，其实就是一个简单的或者复合的逻辑表达式，值为真或者假)

#### a.选择所有记录

1. Selecting All Data 选择所有数据

   The simplest form of `SELECT` retrieves everything from a table:

   1. `select` 检索表格中所有信息的最简单格式如下:

      ```sql
      mysql> SELECT * FROM pet;
      +----------+--------+---------+------+------------+------------+
      | name     | owner  | species | sex  | birth      | death      |
      +----------+--------+---------+------+------------+------------+
      | Fluffy   | Harold | cat     | f    | 1993-02-04 | NULL       |
      | Claws    | Gwen   | cat     | m    | 1994-03-17 | NULL       |
      | Buffy    | Harold | dog     | f    | 1989-05-13 | NULL       |
      | Fang     | Benny  | dog     | m    | 1990-08-27 | NULL       |
      | Bowser   | Diane  | dog     | m    | 1979-08-31 | 1995-07-29 |
      | Chirpy   | Gwen   | bird    | f    | 1998-09-11 | NULL       |
      | Whistler | Gwen   | bird    | NULL | 1997-12-09 | NULL       |
      | Slim     | Benny  | snake   | m    | 1996-04-29 | NULL       |
      | Puffball | Diane  | hamster | f    | 1999-03-30 | NULL       |
      +----------+--------+---------+------+------------+------------+
      ```

      This form of `SELECT` uses `*`, which is shorthand for “select all columns.” This is useful if you want to review your entire table, for example, after you've just loaded it with your initial data set. *For example, you may happen to think that the birth date for Bowser doesn't seem quite right. Consulting your original pedigree papers, you find that the correct birth year should be 1989, not 1979.*

      `select` 的这种格式使用`*` 来作为”选择所有列“的简化表达。这有利于你浏览整个表，例如，在你刚从初始数据集中把数据加载进来。举个例子，你可能认为Bower的生日信息并不完全正确，通过咨询你最初的血统文件，你可能发现正确的生日年份应该是1989而不是1979.

      There are at least two ways to fix this:

      有两种方式去修复这个错误

      * Edit the file `pet.txt` to correct the error, then empty the table and reload it using `DELETE` and `LOAD DATA`:

        通过编辑`pet.txt` 文件来修复这个错误，然后用`delete` 语句清空表格，再用`load data` 语句重新载入数据:

        ```sql
        mysql> DELETE FROM pet;
        mysql> LOAD DATA LOCAL INFILE 'pet.txt' INTO TABLE pet;
        ```

        However, if you do this, you must also re-enter the record for Puffball.

        然而，如果你这样做，那你不得不总是都重新输入Puffball的记录(

        (提示，如果你只是单独看这一小节，可能不知道，Puffball是上一节我们load data后手动insert加入的新宠物记录)

      * Fix only the erroneous record with an `UPDATE` statement:

        使用`update` 语句单独修复错误的记录

        ```sql
        mysql> UPDATE pet SET birth = '1989-08-31' WHERE name = 'Bowser';
        ```

        The `UPDATE` changes only the record in question and does not require you to reload the table.

        `update` 仅仅改变有问题的记录，并且不需要你重新载入整个表的数据

      There is an exception to the principle that `SELECT *` selects all columns. If a table contains invisible columns, `*` does not include them. For more information, see [Section 13.1.20.10, “Invisible Columns”](https://dev.mysql.com/doc/refman/8.0/en/invisible-columns.html).

      使用`select ` *来选择所有列有个例外情况。如果一个表格有不可见的列，*`*` 不会包含那些列。查看 [Section 13.1.20.10, “Invisible Columns”](https://dev.mysql.com/doc/refman/8.0/en/invisible-columns.html)来了解更多情况。

#### b.选择指定行

1. Selecting Particular Rows 选择特定的行

   As shown in the preceding section, it is easy to retrieve an entire table. Just omit the `WHERE` clause from the `SELECT` statement. But typically you don't want to see the entire table, particularly when it becomes large. Instead, you're usually more interested in answering a particular question, in which case you specify some constraints on the information you want. Let's look at some selection queries in terms of questions about your pets that they answer.

   如前面小节所示，很容易检索整个个表。只要不给出`select` 语句中的`where` 子句即可。但是往往你不想要查看整个表，特别是这个表很庞大的时候。恰恰相反的是，你一般对回答某个特定问题感兴趣，这需要用到一些附加了一些限制的信息。

   You can select only particular rows from your table. For example, if you want to verify the change that you made to Bowser's birth date, select Bowser's record like this:

   你可以只在你的表格中挑选一些特别的列。例如，你想要验证你对Bower的生日的改变，可以像下面一样查询Bower的记录:

   ```sql
   mysql> SELECT * FROM pet WHERE name = 'Bowser';
   +--------+-------+---------+------+------------+------------+
   | name   | owner | species | sex  | birth      | death      |
   +--------+-------+---------+------+------------+------------+
   | Bowser | Diane | dog     | m    | 1989-08-31 | 1995-07-29 |
   +--------+-------+---------+------+------------+------------+
   ```

   The output confirms that the year is correctly recorded as 1989, not 1979.

   输出结果证实了年龄记录是正确的1989，而不是1979.

   String comparisons normally are case-insensitive, so you can specify the name as `'bowser'`, `'BOWSER'`, and so forth. The query result is the same.

   字符串比较总是大小写不敏感的，所以你能够用`bowser`,`BOWSER` 等等，查询结果都会是一样的

   You can specify conditions on any column, not just `name`. For example, if you want to know which animals were born during or after 1998, test the `birth` column:

   你能够指定附加到任何列上的条件，而不只是`name` 。例如，如果你想要知道那些动物是在1998或者之后出生的，检查`birth` 列:

   ```sql
   mysql> SELECT * FROM pet WHERE birth >= '1998-1-1';
   +----------+-------+---------+------+------------+-------+
   | name     | owner | species | sex  | birth      | death |
   +----------+-------+---------+------+------------+-------+
   | Chirpy   | Gwen  | bird    | f    | 1998-09-11 | NULL  |
   | Puffball | Diane | hamster | f    | 1999-03-30 | NULL  |
   +----------+-------+---------+------+------------+-------+
   ```

   You can combine conditions, for example, to locate female dogs:

   你也能使用复数个条件，如，定位母狗:

   ```sql
   mysql> SELECT * FROM pet WHERE species = 'dog' AND sex = 'f';
   +-------+--------+---------+------+------------+-------+
   | name  | owner  | species | sex  | birth      | death |
   +-------+--------+---------+------+------------+-------+
   | Buffy | Harold | dog     | f    | 1989-05-13 | NULL  |
   +-------+--------+---------+------+------------+-------+
   ```

   The preceding query uses the `AND` logical operator. There is also an `OR` operator:

   上述查询使用了`AND` 这个逻辑运算符。同样也可以使用`or` 运算符

   ```sql
   mysql> SELECT * FROM pet WHERE species = 'snake' OR species = 'bird';
   +----------+-------+---------+------+------------+-------+
   | name     | owner | species | sex  | birth      | death |
   +----------+-------+---------+------+------------+-------+
   | Chirpy   | Gwen  | bird    | f    | 1998-09-11 | NULL  |
   | Whistler | Gwen  | bird    | NULL | 1997-12-09 | NULL  |
   | Slim     | Benny | snake   | m    | 1996-04-29 | NULL  |
   +----------+-------+---------+------+------------+-------+
   ```

   `AND` and `OR` may be intermixed, although `AND` has higher precedence than `OR`. If you use both operators, it is a good idea to use parentheses to indicate explicitly how conditions should be grouped:

   `AND` 和`OR` 运算符也可以混合使用，需要注意`AND` 的优先级比`OR` 高。如果你同时使用两个运算符号，最好加上圆括号来显式地指定运算顺序:

   ```
   mysql> SELECT * FROM pet WHERE (species = 'cat' AND sex = 'm')
          OR (species = 'dog' AND sex = 'f');
   +-------+--------+---------+------+------------+-------+
   | name  | owner  | species | sex  | birth      | death |
   +-------+--------+---------+------+------------+-------+
   | Claws | Gwen   | cat     | m    | 1994-03-17 | NULL  |
   | Buffy | Harold | dog     | f    | 1989-05-13 | NULL  |
   +-------+--------+---------+------+------------+-------+
   ```

#### c.选择指定列

1. Selecting Particular Columns 选择特定的列

   If you do not want to see entire rows from your table, just name the columns in which you are interested, separated by commas. For example, if you want to know when your animals were born, select the `name` and `birth` columns:

   如果你不想要查看完整的表记录，只需要列出你感兴趣的列即可，如果有多个，彼此用逗号隔开。举个例子，如果你想要知道你的宠物什么时候出生的，选择`name` 列和`birth` 列:

   ```sql
   mysql> SELECT name, birth FROM pet;
   +----------+------------+
   | name     | birth      |
   +----------+------------+
   | Fluffy   | 1993-02-04 |
   | Claws    | 1994-03-17 |
   | Buffy    | 1989-05-13 |
   | Fang     | 1990-08-27 |
   | Bowser   | 1989-08-31 |
   | Chirpy   | 1998-09-11 |
   | Whistler | 1997-12-09 |
   | Slim     | 1996-04-29 |
   | Puffball | 1999-03-30 |
   +----------+------------+
   ```

   To find out who owns pets, use this query:

   为了找出拥有宠物的人，使用如下查询:

   ```sql
   mysql> SELECT owner FROM pet;
   +--------+
   | owner  |
   +--------+
   | Harold |
   | Gwen   |
   | Harold |
   | Benny  |
   | Diane  |
   | Gwen   |
   | Gwen   |
   | Benny  |
   | Diane  |
   +--------+
   ```

   Notice that the query simply retrieves the `owner` column from each record, and some of them appear more than once. To minimize the output, retrieve each unique output record just once by adding the keyword `DISTINCT`:

   注意该查询只是简单地检索了每个记录里面地`owner` 列的值，并且它们在结果中重复出现了。为了简化结果，可以使用关键字`distinct` 来指定检索不重复的记录:

   ```sql
   mysql> SELECT DISTINCT owner FROM pet;
   +--------+
   | owner  |
   +--------+
   | Benny  |
   | Diane  |
   | Gwen   |
   | Harold |
   +--------+
   ```

   You can use a `WHERE` clause to combine row selection with column selection. For example, to get birth dates for dogs and cats only, use this query:

   你能够在行选择的基础上结合一个`where` 分句来选择列。举个例子，为了仅仅获得狗和猫的生日，使用如下查询:

   ```
   mysql> SELECT name, species, birth FROM pet
          WHERE species = 'dog' OR species = 'cat';
   +--------+---------+------------+
   | name   | species | birth      |
   +--------+---------+------------+
   | Fluffy | cat     | 1993-02-04 |
   | Claws  | cat     | 1994-03-17 |
   | Buffy  | dog     | 1989-05-13 |
   | Fang   | dog     | 1990-08-27 |
   | Bowser | dog     | 1989-08-31 |
   +--------+---------+------------+
   ```

#### d.对行进行排序

1. Sorting Rows 对行进行排序

   You may have noticed in the preceding examples that the result rows are displayed in no particular order. It is often easier to examine query output when the rows are sorted in some meaningful way. To sort a result, use an `ORDER BY` clause.

   你可能注意到了前面例子中查询结果都是无序的。如果查询结果中的行能够有一种有意义的顺序，往往会更有利于我们检查查询结果。可以用`order by` 分句来对结果进行排序。

   Here are animal birthdays, sorted by date:

   下面查询按照日期排列的动物生日:

   ```sql
   mysql> SELECT name, birth FROM pet ORDER BY birth;
   +----------+------------+
   | name     | birth      |
   +----------+------------+
   | Buffy    | 1989-05-13 |
   | Bowser   | 1989-08-31 |
   | Fang     | 1990-08-27 |
   | Fluffy   | 1993-02-04 |
   | Claws    | 1994-03-17 |
   | Slim     | 1996-04-29 |
   | Whistler | 1997-12-09 |
   | Chirpy   | 1998-09-11 |
   | Puffball | 1999-03-30 |
   +----------+------------+
   ```

   On character type columns, sorting—like all other comparison operations—is normally performed in a case-insensitive fashion. This means that the order is undefined for columns that are identical except for their case. You can force a case-sensitive sort for a column by using `BINARY` like so: `ORDER BY BINARY col_name`.

   在字符类型的列的排序，就像是比较运算操作一样，总是大小写不敏感的。这意味着，对于那些除了大小写以外完全的值，它们的先后顺序是未定义的。你可以通过`BINARY`对某个列强行使用大小写敏感的排序，像这样:`order by binary col_name` .

   The default sort order is ascending, with smallest values first. To sort in reverse (descending) order, add the `DESC` keyword to the name of the column you are sorting by:

   默认的排序顺序是升序，最小的值放前面。为了使用降序排序，在要排序的列名后面加上`desc` 关键字:

   ```sql
   mysql> SELECT name, birth FROM pet ORDER BY birth DESC;
   +----------+------------+
   | name     | birth      |
   +----------+------------+
   | Puffball | 1999-03-30 |
   | Chirpy   | 1998-09-11 |
   | Whistler | 1997-12-09 |
   | Slim     | 1996-04-29 |
   | Claws    | 1994-03-17 |
   | Fluffy   | 1993-02-04 |
   | Fang     | 1990-08-27 |
   | Bowser   | 1989-08-31 |
   | Buffy    | 1989-05-13 |
   +----------+------------+
   ```

   You can sort on multiple columns, and you can sort different columns in different directions. For example, to sort by type of animal in ascending order, then by birth date within animal type in descending order (youngest animals first), use the following query:

   你能够对多个列进行排序，并且你可以对不同的列使用不同的排序倾向。比如，为了升序排序动物的类型，然后再在同类动物中按照动物生日降序排序，使用如下查询:

   ```sql
   mysql> SELECT name, species, birth FROM pet
          ORDER BY species, birth DESC;
   +----------+---------+------------+
   | name     | species | birth      |
   +----------+---------+------------+
   | Chirpy   | bird    | 1998-09-11 |
   | Whistler | bird    | 1997-12-09 |
   | Claws    | cat     | 1994-03-17 |
   | Fluffy   | cat     | 1993-02-04 |
   | Fang     | dog     | 1990-08-27 |
   | Bowser   | dog     | 1989-08-31 |
   | Buffy    | dog     | 1989-05-13 |
   | Puffball | hamster | 1999-03-30 |
   | Slim     | snake   | 1996-04-29 |
   +----------+---------+------------+
   ```

   The `DESC` keyword applies only to the column name immediately preceding it (`birth`); it does not affect the `species` column sort order.

   `desc` 关键字仅仅作用于紧紧在它前面的列(`birth`).它并不影响`species` 列的排序顺序

#### e.日期运算

1. Date Calculations 日期运算

   MySQL provides several functions that you can use to perform calculations on dates, for example, to calculate ages or extract parts of dates.

   MySQL提供了一些你可以用来进行日期计算的函数，比如，计算年龄或者截取日期的部分

   To determine how many years old each of your pets is, use the `TIMESTAMPDIFF()` function. Its arguments are the unit in which you want the result expressed, and the two dates for which to take the difference. The following query shows, for each pet, the birth date, the current date, and the age in years. An *alias* () is used to make the final output column label more meaningful. `age`

   使用`timestampdiff()` 函数来计算每只宠物的年龄。它的参数依次为结果的单位，以及用来作差的两个日期。下面的查询展示了，每只宠物的生日，当前日期，以及年份制的年龄。使用了别名`age` 来让结果看起来更好理解:

   ```sql
   mysql> SELECT name, birth, CURDATE(),
          TIMESTAMPDIFF(YEAR,birth,CURDATE()) AS age
          FROM pet;
   +----------+------------+------------+------+
   | name     | birth      | CURDATE()  | age  |
   +----------+------------+------------+------+
   | Fluffy   | 1993-02-04 | 2003-08-19 |   10 |
   | Claws    | 1994-03-17 | 2003-08-19 |    9 |
   | Buffy    | 1989-05-13 | 2003-08-19 |   14 |
   | Fang     | 1990-08-27 | 2003-08-19 |   12 |
   | Bowser   | 1989-08-31 | 2003-08-19 |   13 |
   | Chirpy   | 1998-09-11 | 2003-08-19 |    4 |
   | Whistler | 1997-12-09 | 2003-08-19 |    5 |
   | Slim     | 1996-04-29 | 2003-08-19 |    7 |
   | Puffball | 1999-03-30 | 2003-08-19 |    4 |
   +----------+------------+------------+------+
   ```

   The query works, but the result could be scanned more easily if the rows were presented in some order. This can be done by adding an clause to sort the output by name: `ORDER BY name`

   查询成功了，但是结果可以按照某种顺序排序，这样会更方便浏览。可以通过增加`order by name` 分句来把结果按照年龄排序。

   ```sql
   mysql> SELECT name, birth, CURDATE(),
          TIMESTAMPDIFF(YEAR,birth,CURDATE()) AS age
          FROM pet ORDER BY name;
   +----------+------------+------------+------+
   | name     | birth      | CURDATE()  | age  |
   +----------+------------+------------+------+
   | Bowser   | 1989-08-31 | 2003-08-19 |   13 |
   | Buffy    | 1989-05-13 | 2003-08-19 |   14 |
   | Chirpy   | 1998-09-11 | 2003-08-19 |    4 |
   | Claws    | 1994-03-17 | 2003-08-19 |    9 |
   | Fang     | 1990-08-27 | 2003-08-19 |   12 |
   | Fluffy   | 1993-02-04 | 2003-08-19 |   10 |
   | Puffball | 1999-03-30 | 2003-08-19 |    4 |
   | Slim     | 1996-04-29 | 2003-08-19 |    7 |
   | Whistler | 1997-12-09 | 2003-08-19 |    5 |
   +----------+------------+------------+------+
   ```

   To sort the output by `age` rather than `name`, just use a different `ORDER BY` clause:

   为了按照年龄排序而不是名字排序，使用另一种`order by` 分句

   ```sql
   mysql> SELECT name, birth, CURDATE(),
          TIMESTAMPDIFF(YEAR,birth,CURDATE()) AS age
          FROM pet ORDER BY age;
   +----------+------------+------------+------+
   | name     | birth      | CURDATE()  | age  |
   +----------+------------+------------+------+
   | Chirpy   | 1998-09-11 | 2003-08-19 |    4 |
   | Puffball | 1999-03-30 | 2003-08-19 |    4 |
   | Whistler | 1997-12-09 | 2003-08-19 |    5 |
   | Slim     | 1996-04-29 | 2003-08-19 |    7 |
   | Claws    | 1994-03-17 | 2003-08-19 |    9 |
   | Fluffy   | 1993-02-04 | 2003-08-19 |   10 |
   | Fang     | 1990-08-27 | 2003-08-19 |   12 |
   | Bowser   | 1989-08-31 | 2003-08-19 |   13 |
   | Buffy    | 1989-05-13 | 2003-08-19 |   14 |
   +----------+------------+------------+------+
   ```

   A similar query can be used to determine age at death for animals that have died. You determine which animals these are by checking whether the `death` value is `NULL`. Then, for those with non-`NULL` values, compute the difference between the `death` and `birth` values:

   可以使用一种相似的查询来死亡动物的寿命。你可以通过检查`death` 值是否为空来找出那些死亡的动物。然后对于那些`death` 值不为`null` 的动物，计算它们死亡日期和生日之间的差:

   ```sql
   mysql> SELECT name, birth, death,
          TIMESTAMPDIFF(YEAR,birth,death) AS age
          FROM pet WHERE death IS NOT NULL ORDER BY age;
   +--------+------------+------------+------+
   | name   | birth      | death      | age  |
   +--------+------------+------------+------+
   | Bowser | 1989-08-31 | 1995-07-29 |    5 |
   +--------+------------+------------+------+
   ```

   The query uses `death IS NOT NULL` rather than `death <> NULL` because `NULL` is a special value that cannot be compared using the usual comparison operators. This is discussed later. See [Section 3.3.4.6, “Working with NULL Values”](https://dev.mysql.com/doc/refman/8.0/en/working-with-null.html).

   查询使用了`death is not null` 而不是`death <> null` ，是因为`null` 是一个不能够使用一般的比较运算符来比较的特殊值。这个稍后讨论。可以查阅[节3.3.4.6,“使用NULL值”](https://dev.mysql.com/doc/refman/8.0/en/working-with-null.html)。

   What if you want to know which animals have birthdays next month? For this type of calculation, year and day are irrelevant; you simply want to extract the month part of the `birth` column. MySQL provides several functions for extracting parts of dates, such as `YEAR()`, `MONTH()`, and `DAYOFMONTH()`. `MONTH()` is the appropriate function here. To see how it works, run a simple query that displays the value of both `birth` and `MONTH(birth)`:

   如果你想知道哪个动物下个月过生日呢?对于这种类型的计算，年份和月内天数可以忽略；你仅仅想要从`birth` 列中提取出月份信息。MySQL提供了一些用来提取部分日期的函数，比如`year()` ,`month` 以及`dayofmonth()` 。`month()` 正好适用于这种情况。你可以执行下面这个同时展示了`birth` 以及`month(birth)` 的查询来观察这个函数起到什么效果:

   ```sql
   mysql> SELECT name, birth, MONTH(birth) FROM pet;
   +----------+------------+--------------+
   | name     | birth      | MONTH(birth) |
   +----------+------------+--------------+
   | Fluffy   | 1993-02-04 |            2 |
   | Claws    | 1994-03-17 |            3 |
   | Buffy    | 1989-05-13 |            5 |
   | Fang     | 1990-08-27 |            8 |
   | Bowser   | 1989-08-31 |            8 |
   | Chirpy   | 1998-09-11 |            9 |
   | Whistler | 1997-12-09 |           12 |
   | Slim     | 1996-04-29 |            4 |
   | Puffball | 1999-03-30 |            3 |
   +----------+------------+--------------+
   ```

   Finding animals with birthdays in the upcoming month is also simple. Suppose that the current month is April. Then the month value is `4` and you can look for animals born in May (month `5`) like this:

   寻找下个月生日的动物同样简单。假设当前月份是4月，那对应的月份就是`4` ，因此你可以像这样查找生日在五月(月份为`5` )的动物:

   ```sql
   mysql> SELECT name, birth FROM pet WHERE MONTH(birth) = 5;
   +-------+------------+
   | name  | birth      |
   +-------+------------+
   | Buffy | 1989-05-13 |
   +-------+------------+
   ```

   There is a small complication if the current month is December. You cannot merely add one to the month number (`12`) and look for animals born in month `13`, because there is no such month. Instead, you look for animals born in January (month `1`).

   有一点点复杂的情况是，如果当前月份是12月，你不能够仅仅简单地给12加1然后查询13月份出生地动物，而是应该查找出生在一月(月份1)的动物，因为月份13并不存在。

   You can write the query so that it works no matter what the current month is, so that you do not have to use the number for a particular month. `DATE_ADD()` enables you to add a time interval to a given date. If you add a month to the value of `CURDATE()`, then extract the month part with `MONTH()`, the result produces the month in which to look for birthdays:

   你可以写一个不管当前月份多少不都能够查询到正确结果的查询，不需要用到确定的月份。`date_add()` 允许你给一个给定日期加上一个时间间隔来获取一个新的日期。如果你把通过`curdate()` 得到的当前日期加上一个月，然后再从日期中使用`monthd()` 函数提取出月份，就能够得到寻找生日用到的下个月的月份了:

   ```sql
   mysql> SELECT name, birth FROM pet
          WHERE MONTH(birth) = MONTH(DATE_ADD(CURDATE(),INTERVAL 1 MONTH));
   ```

   A different way to accomplish the same task is to add `1` to get the next month after the current one after using the modulo function (`MOD`) to wrap the month value to `0` if it is currently `12`:

   可以通过先提取出当前日期的月份然后使用`mod()` 函数对12取余(如果它是12的话会把它变为0)，然后再加`1` 的方式来达成同样的效果:

   ```sql
   mysql> SELECT name, birth FROM pet
          WHERE MONTH(birth) = MOD(MONTH(CURDATE()), 12) + 1;
   ```

   `MONTH()` returns a number between `1` and `12`. And `MOD(something,12)` returns a number between `0` and `11`. So the addition has to be after the `MOD()`, otherwise we would go from November (`11`) to January (`1`).

   `month()` 返回一个`1` 和`12` 以及之间的数。同时`mod(something,12)` 返回一个`0`到`11` 以及之间的数。所以加1操作需要在`mod()` 后面进行，不然会出错(这里没有按照原文翻译,译者认为原文这里讲错了)

   ```
   译者:
   意思是说mod(curMonth,12)把当前
   月份curMonth从1-12映射到0-11，然后我们
   对映射的结果+1得到新的月份,
   如果我们直接对当前月份+1,然后再使用mod取余
   的话，我们得到的是一个0-11之间的数，12月份
   无法映射到。
   用curMonth=11为例，表示当前月份是11，那下一个月应该
   是12月，如果我们先加1再用12取余，（11+1）%12=0我们得到的结果是0
   (原文说的是1，它错了)
   实际上我们想要的结果是1
   ```

   If a calculation uses invalid dates, the calculation fails and produces warnings:

   如果一个运算使用了无效的日期，计算会失败并且生成一个警告信息:

   ```
   mysql> SELECT '2018-10-31' + INTERVAL 1 DAY;
   +-------------------------------+
   | '2018-10-31' + INTERVAL 1 DAY |
   +-------------------------------+
   | 2018-11-01                    |
   +-------------------------------+
   mysql> SELECT '2018-10-32' + INTERVAL 1 DAY;
   +-------------------------------+
   | '2018-10-32' + INTERVAL 1 DAY |
   +-------------------------------+
   | NULL                          |
   +-------------------------------+
   mysql> SHOW WARNINGS;
   +---------+------+----------------------------------------+
   | Level   | Code | Message                                |
   +---------+------+----------------------------------------+
   | Warning | 1292 | Incorrect datetime value: '2018-10-32' |
   +---------+------+----------------------------------------+
   ```

#### f.NULL值的使用

1. Working with NULL Values （NULL值的使用)

   The `NULL` value can be surprising until you get used to it. Conceptually, `NULL` means “a missing unknown value” and it is treated somewhat differently from other values.

   `NULL` 值可能让不熟悉的人感觉奇怪。在定义上，`NULL` 表示“一个不存在的未知的值"，并且它的使用方式和其他值有些不同。

   To test for `NULL`, use the `IS NULL` and `IS NOT NULL` operators, as shown here:

   为了测试`null` 值，这里我们使用了`is null` 和`is not null` 操作符

   ```sql
   mysql> SELECT 1 IS NULL, 1 IS NOT NULL;
   +-----------+---------------+
   | 1 IS NULL | 1 IS NOT NULL |
   +-----------+---------------+
   |         0 |             1 |
   +-----------+---------------+
   ```

   You cannot use arithmetic comparison operators such as `=`, `<`, or `<>` to test for `NULL`. To demonstrate this for yourself, try the following query:

   你可能不能够使用数值比较运算符像`=`,`<` 或者`<>` 来测试`null` .为了让你体会这点，试试下面的查询:

   ```sql
   mysql> SELECT 1 = NULL, 1 <> NULL, 1 < NULL, 1 > NULL;
   +----------+-----------+----------+----------+
   | 1 = NULL | 1 <> NULL | 1 < NULL | 1 > NULL |
   +----------+-----------+----------+----------+
   |     NULL |      NULL |     NULL |     NULL |
   +----------+-----------+----------+----------+
   ```

   Because the result of any arithmetic comparison with `NULL` is also `NULL`, you cannot obtain any meaningful results from such comparisons.

   因为使用`null` 进行的任何数值比较的结果都是`null`,你不可能通过这样的比较来获得任何有意义的结果。

   In MySQL, `0` or `NULL` means false and anything else means true. The default truth value from a boolean operation is `1`.

   在MySQL,`0` 或者`null` 被当作false,同时其他值被当作true.默认的布尔类型的真值则是`1` .

   This special treatment of `NULL` is why, in the previous section, it was necessary to determine which animals are no longer alive using `death IS NOT NULL` instead of `death <> NULL`.

   对`null` 的这种特别处理方式，就是为什么在前面的小节中，必须要使用`death is not null` 而不是`death <> null` 来判断动物是否还活着。

   Two `NULL` values are regarded as equal in a `GROUP BY`.

   在`group by` (分组)操作中，两个`null` 值被认为是等价的。

   When doing an `ORDER BY`, `NULL` values are presented first if you do `ORDER BY ... ASC` and last if you do `ORDER BY ... DESC`.

   当执行`order by` 分句的时候,如果你是使用`order by ... asc` 的方式`null` 值被当成序号第一位的值，如果你使用的是`order by ... dsc` 那`null` 值被当成最后一位的值。

   A common error when working with `NULL` is to assume that it is not possible to insert a zero or an empty string into a column defined as `NOT NULL`, but this is not the case. These are in fact values, whereas `NULL` means “not having a value.” You can test this easily enough by using `IS [NOT] NULL` as shown:

   使用`null` 的一个常见的误区是误以为不能够往一个被定义为`not null` 类型的列中插入0或者空字符串，但并非如此。这些其实是值，而`null` 意味着”并不存在这样的一个值"。你可以通过使用`is [not] null` 来测试这一点:

   ```sql
   mysql> SELECT 0 IS NULL, 0 IS NOT NULL, '' IS NULL, '' IS NOT NULL;
   +-----------+---------------+------------+----------------+
   | 0 IS NULL | 0 IS NOT NULL | '' IS NULL | '' IS NOT NULL |
   +-----------+---------------+------------+----------------+
   |         0 |             1 |          0 |              1 |
   +-----------+---------------+------------+----------------+
   ```

   Thus it is entirely possible to insert a zero or empty string into a `NOT NULL` column, as these are in fact `NOT NULL`. See [Section B.3.4.3, “Problems with NULL Values”](https://dev.mysql.com/doc/refman/8.0/en/problems-with-null.html).

   因此完全可以往一个`not null` 的列中插入0或者空串。详情见[节B.3.4.3, NULL值的问题](https://dev.mysql.com/doc/refman/8.0/en/problems-with-null.html)。

#### g.模式匹配

1. Pattern Matching 模式匹配

   MySQL provides standard SQL pattern matching as well as a form of pattern matching based on extended regular expressions similar to those used by Unix utilities such as **vi**, **grep**, and **sed**.

   MySQL提供标准的SQL模式匹配，以及一种类似于utinity工具(如vi,grep,sed)提供的模式的的基于扩展的正则表达式的模式匹配，

   SQL pattern matching enables you to use `_` to match any single character and `%` to match an arbitrary number of characters (including zero characters). In MySQL, SQL patterns are case-insensitive by default. Some examples are shown here. Do not use `=` or `<>` when you use SQL patterns. Use the `LIKE` or `NOT LIKE` comparison operators instead.

   SQL的模式匹配允许你使用`_` 来匹配任何单个字符以及使用`%` 来匹配一串任意长度的字符串(包括空字符串).在MySQL中，SQL模式下默认是大小写不敏感的。下面展示了一些例子。在使用SQL模式时不要使用`=` 或者`<>` ，而是使用`like` 或者`not like`比较运算符。

   To find names beginning with `b`:

   这样寻找`b` 开头的字符:

   ```sql
   mysql> SELECT * FROM pet WHERE name LIKE 'b%';
   +--------+--------+---------+------+------------+------------+
   | name   | owner  | species | sex  | birth      | death      |
   +--------+--------+---------+------+------------+------------+
   | Buffy  | Harold | dog     | f    | 1989-05-13 | NULL       |
   | Bowser | Diane  | dog     | m    | 1989-08-31 | 1995-07-29 |
   +--------+--------+---------+------+------------+------------+
   ```

   To find names ending with `fy`:

   这样寻找`fy` 开头的字符:

   ```sql
   mysql> SELECT * FROM pet WHERE name LIKE '%fy';
   +--------+--------+---------+------+------------+-------+
   | name   | owner  | species | sex  | birth      | death |
   +--------+--------+---------+------+------------+-------+
   | Fluffy | Harold | cat     | f    | 1993-02-04 | NULL  |
   | Buffy  | Harold | dog     | f    | 1989-05-13 | NULL  |
   +--------+--------+---------+------+------------+-------+
   ```

   To find names containing a `w`:

   这样寻找名字里面包含`w` 的字符:

   ```sql
   mysql> SELECT * FROM pet WHERE name LIKE '%w%';
   +----------+-------+---------+------+------------+------------+
   | name     | owner | species | sex  | birth      | death      |
   +----------+-------+---------+------+------------+------------+
   | Claws    | Gwen  | cat     | m    | 1994-03-17 | NULL       |
   | Bowser   | Diane | dog     | m    | 1989-08-31 | 1995-07-29 |
   | Whistler | Gwen  | bird    | NULL | 1997-12-09 | NULL       |
   +----------+-------+---------+------+------------+------------+
   ```

   To find names containing exactly five characters, use five instances of the `_` pattern character:

   为了寻找刚好包含5个字符的名字，可以使用5个连续的`_` 模式字符:

   ```sql
   bmysql> SELECT * FROM pet WHERE name LIKE '_____';
   +-------+--------+---------+------+------------+-------+
   | name  | owner  | species | sex  | birth      | death |
   +-------+--------+---------+------+------------+-------+
   | Claws | Gwen   | cat     | m    | 1994-03-17 | NULL  |
   | Buffy | Harold | dog     | f    | 1989-05-13 | NULL  |
   +-------+--------+---------+------+------------+-------+
   ```

   The other type of pattern matching provided by MySQL uses extended regular expressions. When you test for a match for this type of pattern, use the `REGEXP_LIKE()` function (or the `REGEXP` or `RLIKE` operators, which are synonyms for `REGEXP_LIKE()`).

   MySQL提供的其他模式匹配使用扩展MySQL表达式。当你测试这种模式匹配的时候，使用`regexp_like()` 函数(或者`regexp` 或者`rlike` 运算符，这些是`regexp_like()` 的等价表达)

   The following list describes some characteristics of extended regular expressions:

   下面的列表描述了一些扩展正则表达式的特点:

   * `.` matches any single character.

     `.` 匹配任何单个字符

   * A character class `[...]` matches any character within the brackets. For example, `[abc]` matches `a`, `b`, or `c`. To name a range of characters, use a dash. `[a-z]` matches any letter, whereas `[0-9]` matches any digit.

     一个字符类型`[...]` 匹配任何的方括号内的单个字符。例如，`[abc]` 匹配`a` ,`b` 或者`c` 。

     可以使用一个短破折号来表达一个字符范围。像`[a-z]` 匹配任何的字母，而`[0-9]` 匹配任何数字

   * `*` matches zero or more instances of the thing preceding it. For example, `x*` matches any number of `x` characters, `[0-9]*` matches any number of digits, and `.*` matches any number of anything.

     *匹配0个或者多个它之前的存在。比如*`x*` 匹配任意数量的`x` 字符，`[0-9]*` 匹配任意数量的数字，至于`.*` 则匹配任意长度的任意字符。

   * A regular expression pattern match succeeds if the pattern matches anywhere in the value being tested. (This differs from a `LIKE` pattern match, which succeeds only if the pattern matches the entire value.)

     使用正则表达式进行模式匹配时，无论从待匹配字符串值的哪个位置开始与模板串匹配，匹配成功则模式匹配成功。(这个与`like` 模式匹配不同，它仅当模式匹配了整个待匹配字符串才匹配成功)

   * To anchor a pattern so that it must match the beginning or end of the value being tested, use `^` at the beginning or `$` at the end of the pattern.

     因此为了瞄定一个模式，我们必须匹配待测字符串的开头或者结尾，通过在模式开头使用`^` 或者在结尾使用`$` 的方式。

   To demonstrate how extended regular expressions work, the `LIKE` queries shown previously are rewritten here to use `REGEXP_LIKE()`.

   为了演示扩展正则表达式式如何工作的，把前面展示过的使用`like` 查询语句改写为使用`regexp_like()` 的查询语句

   To find names beginning with `b`, use `^` to match the beginning of the name:

   为了寻找用`b` 开头的名字，使用`^` 来匹配名字的开头:

   ```sql
   mysql> SELECT * FROM pet WHERE REGEXP_LIKE(name, '^b');
   +--------+--------+---------+------+------------+------------+
   | name   | owner  | species | sex  | birth      | death      |
   +--------+--------+---------+------+------------+------------+
   | Buffy  | Harold | dog     | f    | 1989-05-13 | NULL       |
   | Bowser | Diane  | dog     | m    | 1979-08-31 | 1995-07-29 |
   +--------+--------+---------+------+------------+------------+
   ```

   To force a regular expression comparison to be case-sensitive, use a case-sensitive collation, or use the `BINARY` keyword to make one of the strings a binary string, or specify the `c` match-control character. Each of these queries matches only lowercase `b` at the beginning of a name:

   为了使得正则匹配大小写敏感，使用一个大小写敏感的核对方式，或者使用`binary`  关键字把其中一个字符串变为二进制字符串的格式，或者指定`c`匹配控制符。其中每个查询都能够仅仅匹配开头是小写`b` 的名字:

   ```sql
   SELECT * FROM pet WHERE REGEXP_LIKE(name, '^b' COLLATE utf8mb4_0900_as_cs);
   SELECT * FROM pet WHERE REGEXP_LIKE(name, BINARY '^b');
   SELECT * FROM pet WHERE REGEXP_LIKE(name, '^b', 'c');
   ```

   To find names ending with `fy`, use `$` to match the end of the name:

   为了查找用`fy` 结尾的名字，使用`$` 来匹配名字的结尾:

   ```sql
   mysql> SELECT * FROM pet WHERE REGEXP_LIKE(name, 'fy$');
   +--------+--------+---------+------+------------+-------+
   | name   | owner  | species | sex  | birth      | death |
   +--------+--------+---------+------+------------+-------+
   | Fluffy | Harold | cat     | f    | 1993-02-04 | NULL  |
   | Buffy  | Harold | dog     | f    | 1989-05-13 | NULL  |
   +--------+--------+---------+------+------------+-------+
   ```

   To find names containing a `w`, use this query:

   为了查找含有`w` 的名字，使用这种查询:

   ```sql
   mysql> SELECT * FROM pet WHERE REGEXP_LIKE(name, 'w');
   +----------+-------+---------+------+------------+------------+
   | name     | owner | species | sex  | birth      | death      |
   +----------+-------+---------+------+------------+------------+
   | Claws    | Gwen  | cat     | m    | 1994-03-17 | NULL       |
   | Bowser   | Diane | dog     | m    | 1989-08-31 | 1995-07-29 |
   | Whistler | Gwen  | bird    | NULL | 1997-12-09 | NULL       |
   +----------+-------+---------+------+------------+------------+
   ```

   Because a regular expression pattern matches if it occurs anywhere in the value, it is not necessary in the previous query to put a wildcard on either side of the pattern to get it to match the entire value as would be true with an SQL pattern.

   因为在正则表达式模式匹配中`w` 出现在待匹配值的任何位置都能匹配成功，所以在上述查询中并不需要在模式的两边加入通配符来让它像SQL模式匹配中做的那样匹配整个值。

   To find names containing exactly five characters, use `^` and `$` to match the beginning and end of the name, and five instances of `.` in between:

   为了查询刚好包含5个字符的名字，使用`^` 以及`$来`匹配名字的开头和结尾，并且使用5个连续的`.` 来匹配之间的任意5个字符:

   （笔者的话:这里的开头可以理解成待匹配字符串的实际字符串第一个字符前面的字符(一个实际不存在的字符)，同样这里的结尾可以理解成待匹配字符串的实际字符串的最后一个字符串的后面一个字符(也是一个实际不存在的字符))

   ```sql
   mysql> SELECT * FROM pet WHERE REGEXP_LIKE(name, '^.....$');
   +-------+--------+---------+------+------------+-------+
   | name  | owner  | species | sex  | birth      | death |
   +-------+--------+---------+------+------------+-------+
   | Claws | Gwen   | cat     | m    | 1994-03-17 | NULL  |
   | Buffy | Harold | dog     | f    | 1989-05-13 | NULL  |
   +-------+--------+---------+------+------------+-------+
   ```

   You could also write the previous query using the `{n}` (“repeat-`n`\-times”) operator:

   你也可以像是之前的查询一样使用`{n}` 表达("重复-n-次")

   ```sql
   mysql> SELECT * FROM pet WHERE REGEXP_LIKE(name, '^.{5}$');
   +-------+--------+---------+------+------------+-------+
   | name  | owner  | species | sex  | birth      | death |
   +-------+--------+---------+------+------------+-------+
   | Claws | Gwen   | cat     | m    | 1994-03-17 | NULL  |
   | Buffy | Harold | dog     | f    | 1989-05-13 | NULL  |
   +-------+--------+---------+------+------------+-------+
   ```

   For more information about the syntax for regular expressions, see [Section 12.8.2, “Regular Expressions”](https://dev.mysql.com/doc/refman/8.0/en/regexp.html).

   为了了解更多关于正则表达式语法的信息，见[第12.8.2节，"正则表达式"。](https://dev.mysql.com/doc/refman/8.0/en/regexp.html)

#### h.行运算

1. Counting Rows 行运算

   Databases are often used to answer the question, “How often does a certain type of data occur in a table?” For example, you might want to know how many pets you have, or how many pets each owner has, or you might want to perform various kinds of census operations on your animals.

   数据库经常被用来回答这些问题，“某种类型得数据在表中出现了多少次?"比如，你可能想知道你有多少只宠物，或者每个主人有多少只宠物，或者你可能想要做关于你得动物的多种统计操作。

   Counting the total number of animals you have is the same question as “How many rows are in the `pet` table?” because there is one record per pet. `COUNT(*)` counts the number of rows, so the query to count your animals looks like this:

   计算你拥有的动物的总数等价于这样的问题:宠物表里有多少行?因为每只动物只在表中有一条记录。`count(*)` 能够用来统计行数，因此用来统计你动物数量的查询如下:

   ```sql
   mysql> SELECT COUNT(*) FROM pet;
   +----------+
   | COUNT(*) |
   +----------+
   |        9 |
   +----------+
   ```

   Earlier, you retrieved the names of the people who owned pets. You can use `COUNT()` if you want to find out how many pets each owner has:

   开始，你想检索拥有宠物的人的名字.如果你还想要查明每个主人拥有多少只宠物，你可以使用 `count()` 来做到:

   ```sql
   mysql> SELECT owner, COUNT(*) FROM pet GROUP BY owner;
   +--------+----------+
   | owner  | COUNT(*) |
   +--------+----------+
   | Benny  |        2 |
   | Diane  |        2 |
   | Gwen   |        3 |
   | Harold |        2 |
   +--------+----------+
   ```

   The preceding query uses `GROUP BY` to group all records for each `owner`. The use of `COUNT()` in conjunction with `GROUP BY` is useful for characterizing your data under various groupings. The following examples show different ways to perform animal census operations.

   上述查询使用`group by` 来把属于每个`owner`的记录分组。使用`count()` 与`group by` 组合在一起有利于在不同分组下描述你的数据。下面的例子展现了多种进行动物统计操作的方式.

   Number of animals per species:

   统计每种动物的数量

   ```sql
   mysql> SELECT species, COUNT(*) FROM pet GROUP BY species;
   +---------+----------+
   | species | COUNT(*) |
   +---------+----------+
   | bird    |        2 |
   | cat     |        2 |
   | dog     |        3 |
   | hamster |        1 |
   | snake   |        1 |
   +---------+----------+
   ```

   Number of animals per sex:

   统计每个性别的动物的数量

   ```sql
   mysql> SELECT sex, COUNT(*) FROM pet GROUP BY sex;
   +------+----------+
   | sex  | COUNT(*) |
   +------+----------+
   | NULL |        1 |
   | f    |        4 |
   | m    |        4 |
   +------+----------+
   ```

   (In this output, `NULL` indicates that the sex is unknown.)

   在这个输出中在，`null` 表示性别未知的情况。

   Number of animals per combination of species and sex:

   统计每种类别中每种性别的动物的数量

   ```sql
   mysql> SELECT species, sex, COUNT(*) FROM pet GROUP BY species, sex;
   +---------+------+----------+
   | species | sex  | COUNT(*) |
   +---------+------+----------+
   | bird    | NULL |        1 |
   | bird    | f    |        1 |
   | cat     | f    |        1 |
   | cat     | m    |        1 |
   | dog     | f    |        1 |
   | dog     | m    |        2 |
   | hamster | f    |        1 |
   | snake   | m    |        1 |
   +---------+------+----------+
   ```

   You need not retrieve an entire table when you use `COUNT()`. For example, the previous query, when performed just on dogs and cats, looks like this:

   当你使用`count()` 聚集函数的时候你不需要检索整个表。如下例，相对于上述查询，仅仅做了在狗和猫上的部分:

   ```sql
   mysql> SELECT species, sex, COUNT(*) FROM pet
          WHERE species = 'dog' OR species = 'cat'
          GROUP BY species, sex;
   +---------+------+----------+
   | species | sex  | COUNT(*) |
   +---------+------+----------+
   | cat     | f    |        1 |
   | cat     | m    |        1 |
   | dog     | f    |        1 |
   | dog     | m    |        2 |
   +---------+------+----------+
   ```

   Or, if you wanted the number of animals per sex only for animals whose sex is known:

   或者，如果你静静仅仅想知道已知性别的动物的数量:

   ```sql
   mysql> SELECT species, sex, COUNT(*) FROM pet
          WHERE sex IS NOT NULL
          GROUP BY species, sex;
   +---------+------+----------+
   | species | sex  | COUNT(*) |
   +---------+------+----------+
   | bird    | f    |        1 |
   | cat     | f    |        1 |
   | cat     | m    |        1 |
   | dog     | f    |        1 |
   | dog     | m    |        2 |
   | hamster | f    |        1 |
   | snake   | m    |        1 |
   +---------+------+----------+
   ```

   If you name columns to select in addition to the `COUNT()` value, a `GROUP BY` clause should be present that names those same columns. Otherwise, the following occurs:

   如果你在查询语句中使用了`count()` 同时还罗列了其他列，那使用的`group by` 分句应该罗列那些罗列在查询选择里的列，不然，可能出现如下情况:

   * If the `ONLY_FULL_GROUP_BY` SQL mode is enabled, an error occurs:

     如果处于`only_full_group_by` 的SQL模式下，会发生一个错误:

     ```sql
     mysql> SET sql_mode = 'ONLY_FULL_GROUP_BY';
     Query OK, 0 rows affected (0.00 sec)
     
     mysql> SELECT owner, COUNT(*) FROM pet;
     ERROR 1140 (42000): In aggregated query without GROUP BY, expression
     #1 of SELECT list contains nonaggregated column 'menagerie.pet.owner';
     this is incompatible with sql_mode=only_full_group_by
     ```

   * If `ONLY_FULL_GROUP_BY` is not enabled, the query is processed by treating all rows as a single group, but the value selected for each named column is nondeterministic. The server is free to select the value from any row:

     如果没有启动`only_full_group_by` 模式，查询会把所有的行当作一个分组来处理，但是对于在查询语句中罗列出来的要查询列的取值是不确定的。服务器可能随意地从任何行去取值。

     ```sql
     mysql> SET sql_mode = '';
     Query OK, 0 rows affected (0.00 sec)
     
     mysql> SELECT owner, COUNT(*) FROM pet;
     +--------+----------+
     | owner  | COUNT(*) |
     +--------+----------+
     | Harold |        8 |
     +--------+----------+
     1 row in set (0.00 sec)
     ```

   See also [Section 12.20.3, “MySQL Handling of GROUP BY”](https://dev.mysql.com/doc/refman/8.0/en/group-by-handling.html). See [Section 12.20.1, “Aggregate Function Descriptions”](https://dev.mysql.com/doc/refman/8.0/en/aggregate-functions.html) for information about `COUNT(expr)` behavior and related optimizations.

   详情参考[部分12.20.3,“MySQL分组处理”](https://dev.mysql.com/doc/refman/8.0/en/group-by-handling.html)。关于`count(expr)` 地表现和相关优化，见[节 12.20.1，”关于聚集函数的描述"](https://dev.mysql.com/doc/refman/8.0/en/aggregate-functions.html)。

#### b.多表操作

1. Using More Than one Table 多表操作

   The `pet` table keeps track of which pets you have. If you want to record other information about them, such as events in their lives like visits to the vet or when litters are born, you need another table. What should this table look like? It needs to contain the following information:

   `pet` 记录了你们拥有的宠物。如果你想要记录其他关于关于它们的信息，比如它们生命中的重要事件,比如见兽医，比如幼崽的出生，你需要其他的表。这个表应该长什么样呢?它需要包含如下信息:

   * The pet name so that you know which animal each event pertains to.

     宠物的名字。因此你可以知道每个事件相关的宠物有哪些

   * A date so that you know when the event occurred.

     事件发生的日期

   * A field to describe the event.

     描述这个事件的属性

   * An event type field, if you want to be able to categorize events.

     事件类型属性，如果你需要能够对事件进行分类的话。

   Given these considerations, the `CREATE TABLE` statement for the `event` table might look like this:

   因为有这些考虑，`create table` 语句可能应该像这样来建立`event` 表:

   ```sql
   mysql> CREATE TABLE event (name VARCHAR(20), date DATE,
          type VARCHAR(15), remark VARCHAR(255));
   ```

   As with the `pet` table, it is easiest to load the initial records by creating a tab-delimited text file containing the following information.

   与宠物表相比，它更容易通过创建一个制表符分割的包含如下信息的文本文件来载入初始记录，

   |**name**|**date**|**type**|**remark**|
   |-|-|-|-|
   |**Fluffy**|1995-05-15|litter|4 kittens, 3 female, 1 male|
   |\-|\-|\-|\-|
   |**Buffy**|1993-06-23|litter|5 puppies, 2 female, 3 male|
   |\-|\-|\-|\-|
   |**Buffy**|1994-06-19|litter|3 puppies, 3 female|
   |\-|\-|\-|\-|
   |**Chirpy**|1999-03-21|vet|needed beak straightened|
   |\-|\-|\-|\-|
   |**Slim**|1997-08-03|vet|broken rib|
   |\-|\-|\-|\-|
   |**Bowser**|1991-10-12|kennel||
   |\-|\-|\-|\-|
   |**Fang**|1991-10-12|kennel||
   |\-|\-|\-|\-|
   |**Fang**|1998-08-28|birthday|Gave him a new chew toy|
   |\-|\-|\-|\-|
   |**Claws**|1998-03-17|birthday|Gave him a new flea collar|
   |\-|\-|\-|\-|
   |**Whistler**|1998-12-09|birthday|First birthday|
   |\-|\-|\-|\-|

   Load the records like this:

   加载记录语句如下:

   ```sql
   mysql> LOAD DATA LOCAL INFILE 'event.txt' INTO TABLE event;
   ```

   Based on what you have learned from the queries that you have run on the `pet` table, you should be able to perform retrievals on the records in the `event` table; the principles are the same. But when is the `event` table by itself insufficient to answer questions you might ask?

   根据你从在`pet` 表上执行查询操作时i学到的内容，你应该能够在`event` 表中检索记录；使用的原则是一样的。但是当`event` 表本身不足以满足你的检索要求的时候呢?

   Suppose that you want to find out the ages at which each pet had its litters. We saw earlier how to calculate ages from two dates. The litter date of the mother is in the `event` table, but to calculate her age on that date you need her birth date, which is stored in the `pet` table. This means the query requires both tables:

   设想以下你想要去查找每个动物生产幼崽时的年龄。我们之前了解了如何通过两个日期去计算年林。母亲的生崽日期存在`event` 表中，但是为了计算它生崽时候的年龄，你需要使用到`pet` 表中它的生日进行计算。这意味着这个查询同时需要两个表:

   ```sql
   mysql> SELECT pet.name,
          TIMESTAMPDIFF(YEAR,birth,date) AS age,
          remark
          FROM pet INNER JOIN event
            ON pet.name = event.name
          WHERE event.type = 'litter';
   +--------+------+-----------------------------+
   | name   | age  | remark                      |
   +--------+------+-----------------------------+
   | Fluffy |    2 | 4 kittens, 3 female, 1 male |
   | Buffy  |    4 | 5 puppies, 2 female, 3 male |
   | Buffy  |    5 | 3 puppies, 3 female         |
   +--------+------+-----------------------------+
   ```

   There are several things to note about this query:

   关于这个查询你需要了解如下事物:

   * The `FROM` clause joins two tables because the query needs to pull information from both of them.

     `from` 分句把两个表连接了起来，因为查询需要从两个表中拉取信息

   * When combining (joining) information from multiple tables, you need to specify how records in one table can be matched to records in the other. This is easy because they both have a `name` column. The query uses an `ON` clause to match up records in the two tables based on the `name` values.

     当连接多个表的时候，你应该指明一个表中的记录时如何匹配到另一个表中的记录的。在这里是简单的，因为它们都有一个`name` 字段。这个查询使用了一个`on` 分句来指定根据`name` 字段的值来匹配两个表中的记录。

     The query uses an `INNER JOIN` to combine the tables. An `INNER JOIN` permits rows from either table to appear in the result if and only if both tables meet the conditions specified in the `ON` clause. In this example, the `ON` clause specifies that the `name` column in the `pet` table must match the `name` column in the `event` table. If a name appears in one table but not the other, the row does not appear in the result because the condition in the `ON` clause fails.

     这个查询使用了一个`inner join` 来连接两个表。一个`inner join` 使得两个表中的行当且仅当满足`on`分句中定义的条件时才会出现在结果中。在这个例子中，`on` 分局指定了`pet` 表中的`name` 列的值一定要匹配`event` 表中的`name` 列的值。如果一个name出现在一个一个表中但是没有在另一个表中的话，那么这一行就不会出现在结果中，因为不满足`on` 分句中的条件

   * Because the `name` column occurs in both tables, you must be specific about which table you mean when referring to the column. This is done by prepending the table name to the column name.

     因为`name` 列在两个表中都出现了。所有你在使用他们的时候必须指明图它们属于哪个表。可以通过在列名前面加上表名+`.` 来实现

   You need not have two different tables to perform a join. Sometimes it is useful to join a table to itself, if you want to compare records in a table to other records in that same table. For example, to find breeding pairs among your pets, you can join the `pet` table with itself to produce candidate pairs of live males and females of like species:

   并不必是两个不同的表才能执行一个连接操作。有时候我们也可以把一个表与自身连接，如果你想要比较同一个表中的记录的话。比如，为了找到你的宠物中的繁殖搭档，你可以将`pet` 表与自身连接，产生相同种族不同年龄的候选对。

   ```sql
   mysql> SELECT p1.name, p1.sex, p2.name, p2.sex, p1.species
          FROM pet AS p1 INNER JOIN pet AS p2
            ON p1.species = p2.species
            AND p1.sex = 'f' AND p1.death IS NULL
            AND p2.sex = 'm' AND p2.death IS NULL;
   +--------+------+-------+------+---------+
   | name   | sex  | name  | sex  | species |
   +--------+------+-------+------+---------+
   | Fluffy | f    | Claws | m    | cat     |
   | Buffy  | f    | Fang  | m    | dog     |
   +--------+------+-------+------+---------+
   ```

   In this query, we specify aliases for the table name to refer to the columns and keep straight which instance of the table each column reference is associated with.

   在这个查询中，我们为表名指定别名以引用列，并明确每个列引用与表的哪个实例相关联