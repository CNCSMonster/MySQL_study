## Getting Information About Databases and Tables 获取有关数据库和表的信息

What if you forget the name of a database or table, or what the structure of a given table is (for example, what its columns are called)? MySQL addresses this problem through several statements that provide information about the databases and tables it supports.

如果你忘记了数据库或者表的名字，或者指定表的结构(比如它的列叫什么)?MySQL 通过提供有关它支持的数据库和表的信息的几个语句来解决这个问题。

You have previously seen `SHOW DATABASES`, which lists the databases managed by the server. To find out which database is currently selected, use the `DATABASE()` function:

你之前已经见过`show databases` 语句了，该语句能够列举出当前服务器管理的数据库。为了查明当前选择使用的数据库，使用`database()` 函数:

```sql
mysql> SELECT DATABASE();
+------------+
| DATABASE() |
+------------+
| menagerie  |
+------------+
```

If you have not yet selected any database, the result is `NULL`.

如果你还没有选择任何数据库，结果为`null`

To find out what tables the default database contains (for example, when you are not sure about the name of a table), use this statement:

为了找出当前使用的数据库包含的表格(比如，当你不确定表格的名字的时候),使用如下语句:

```sql
mysql> SHOW TABLES;
+---------------------+
| Tables_in_menagerie |
+---------------------+
| event               |
| pet                 |
+---------------------+
```

The name of the column in the output produced by this statement is always `Tables_in_db_name`, where `db_name` is the name of the database. See [Section 13.7.7.39, “SHOW TABLES Statement”](https://dev.mysql.com/doc/refman/8.0/en/show-tables.html), for more information.

输出表格中的列名总是`Tables_in_db_name` ,其中`db_name` 是当前选用的数据库的名字，详见 [Section 13.7.7.39, “SHOW TABLES Statement”](https://dev.mysql.com/doc/refman/8.0/en/show-tables.html)。

If you want to find out about the structure of a table, the `DESCRIBE` statement is useful; it displays information about each of a table's columns:

如果你想要知道表的结构，`describe` 语句能够帮助你。它展示表的每一列的信息。

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

`Field` indicates the column name, `Type` is the data type for the column, `NULL` indicates whether the column can contain `NULL` values, `Key` indicates whether the column is indexed, and `Default` specifies the column's default value. `Extra` displays special information about columns: If a column was created with the `AUTO_INCREMENT` option, the value is `auto_increment` rather than empty.

`Field` 表示列名，`Type` 是列的数据类型，`NULL` 说明这个列是否能够包含`NULL` 值(值得一提的是，`null` 值并不是值，`null` 值表示没有值)，`key` 表明这个列是否建立了索引，`default` 用来指定这个列的默认值。`Extra` 则是用来展示关于列的额外信息:比如如果这个列使用了`auto_increment` 选项创建，这个值会是`auto_increment` 而不是空的。

`DESC` is a short form of `DESCRIBE`. See [Section 13.8.1, “DESCRIBE Statement”](https://dev.mysql.com/doc/refman/8.0/en/describe.html), for more information.

`desc` 是`describe` 的缩写形式.详见[Section 13.8.1, “DESCRIBE Statement”。](https://dev.mysql.com/doc/refman/8.0/en/describe.html)

You can obtain the `CREATE TABLE` statement necessary to create an existing table using the `SHOW CREATE TABLE` statement. See [Section 13.7.7.10, “SHOW CREATE TABLE Statement”](https://dev.mysql.com/doc/refman/8.0/en/show-create-table.html).

你能够使用`show create table` 语句来获取能够创建某个已经存在的表的`create table` 语句。详情见[Section 13.7.7.10, “SHOW CREATE TABLE Statement”](https://dev.mysql.com/doc/refman/8.0/en/show-create-table.html).

If you have indexes on a table, `SHOW INDEX FROM tbl_name` produces information about them. See [Section 13.7.7.22, “SHOW INDEX Statement”](https://dev.mysql.com/doc/refman/8.0/en/show-index.html), for more about this statement.

如果你在表中创建了索引，`show index from tbl_name` 语句能够提供它们的信息。详情见 [Section 13.7.7.22, “SHOW INDEX Statement”](https://dev.mysql.com/doc/refman/8.0/en/show-index.html)。

## Using mysql in Batch Mode: mysql的批处理使用

In the previous sections, you used [**mysql**](https://dev.mysql.com/doc/refman/8.0/en/mysql.html) interactively to enter statements and view the results. You can also run [**mysql**](https://dev.mysql.com/doc/refman/8.0/en/mysql.html) in batch mode. To do this, put the statements you want to run in a file, then tell [**mysql**](https://dev.mysql.com/doc/refman/8.0/en/mysql.html) to read its input from the file:

在前面章节中，你已经交互式地使用mysql输入语句和查看结果了。你也能够在批处理模式下使用mysql。为了做到这一点，把你想要运行地sql语句放到一个文件中，然后告诉mysql从文件中读取输入:

```terminal
$> mysql < batch-file
```

If you are running [**mysql**](https://dev.mysql.com/doc/refman/8.0/en/mysql.html) under Windows and have some special characters in the file that cause problems, you can do this:

如果你是在Windows下使用mysql，并且文件中有些特殊字符造成了问题，你可以这样做:

```terminal
C:\> mysql -e "source batch-file"
```

If you need to specify connection parameters on the command line, the command might look like this:

如果你需要在命令行指定连接参数，命令如下:

```terminal
$> mysql -h host -u user -p < batch-file
Enter password: ********
```

When you use [**mysql**](https://dev.mysql.com/doc/refman/8.0/en/mysql.html) this way, you are creating a script file, then executing the script.

当你以这种方式使用mysql地时候，你实际是创建了一个脚本文件，然后执行这个脚本。

If you want the script to continue even if some of the statements in it produce errors, you should use the `--force` command-line option.

如果你想要一个脚本持续执行完成即使其中某些语句造成了错误，你应该启动`--force` 命令行选项:

Why use a script? Here are a few reasons:

为什么使用一个脚本?原因如下:

* If you run a query repeatedly (say, every day or every week), making it a script enables you to avoid retyping it each time you execute it.

  如果你要重复地执行一个查询(比如，每天或者每周),创建一个脚本避免每次你需要执行地时候都要重复地键入。

* You can generate new queries from existing ones that are similar by copying and editing script files.

  你可以通过赋值和编辑已有脚本文件地方式来生成新地查询语句。

* Batch mode can also be useful while you're developing a query, particularly for multiple-line statements or multiple-statement sequences. If you make a mistake, you don't have to retype everything. Just edit your script to correct the error, then tell [**mysql**](https://dev.mysql.com/doc/refman/8.0/en/mysql.html) to execute it again.

  批处理模式同时可以在你设计一个查询语句的时候提供帮助，尤其是设计那些多行语句或者使用到了多条语句序列的查询的时候。如果你犯了个错误，你不需要重新键入所有内容，而是只用修改脚本中错误的地方，然后让mysql再去执行它。

* If you have a query that produces a lot of output, you can run the output through a pager rather than watching it scroll off the top of your screen:

  如果你有一个提供了多个输出的查询，你可以通过一个分页器查看而不是看着它从你的屏幕顶部不断滚动下来:

  (下面例子用到的分页器是linux下的more命令)

  ```terminal
  $> mysql < batch-file | more
  ```

* You can catch the output in a file for further processing:

  你可以把输出保存到一个文件中以便后续处理

  ```terminal
  $> mysql < batch-file > mysql.out
  ```

* You can distribute your script to other people so that they can also run the statements.

  你可以把你的脚本分发给别人，从而使得他们也能够执行同样的语句

* Some situations do not allow for interactive use, for example, when you run a query from a **cron** job. In this case, you must use batch mode.

  一些不允许交互式使用的情况，比如，当你在cron作业中(cron是一种用来设计定时执行任务的工具)使用查询的时候。这种情况下，你一定要使用批处理模式。

The default output format is different (more concise) when you run [**mysql**](https://dev.mysql.com/doc/refman/8.0/en/mysql.html) in batch mode than when you use it interactively. For example, the output of `SELECT DISTINCT species FROM pet` looks like this when [**mysql**](https://dev.mysql.com/doc/refman/8.0/en/mysql.html) is run interactively:

批处理模式下和交互模式下默认的输出格式是不同的。比如`select distinct species from pet` 语句的在交互模式下的输出如下:

```none
+---------+
| species |
+---------+
| bird    |
| cat     |
| dog     |
| hamster |
| snake   |
+---------+
```

In batch mode, the output looks like this instead:

在批处理模式下，输出则是这样:

```none
species
bird
cat
dog
hamster
snake
```

If you want to get the interactive output format in batch mode, use [**mysql -t**](https://dev.mysql.com/doc/refman/8.0/en/mysql.html). To echo to the output the statements that are executed, use [**mysql -v**](https://dev.mysql.com/doc/refman/8.0/en/mysql.html).

如果你想要在批处理模式中获得交互模式下的输出格式，使用mysql -t。如果想要把执行的查询语句也打印到输出中，使用mysql -v.

You can also use scripts from the [**mysql**](https://dev.mysql.com/doc/refman/8.0/en/mysql.html) prompt by using the `source` command or `\.` command:

你也可以在mysql控制台中使用`source` 命令或者`\.` 命令来执行sql脚本:

```sql
mysql> source filename;
mysql> \. filename
```

See [Section 4.5.1.5, “Executing SQL Statements from a Text File”](https://dev.mysql.com/doc/refman/8.0/en/mysql-batch-commands.html), for more information.

详见[Section 4.5.1.5, “Executing SQL Statements from a Text File”。](https://dev.mysql.com/doc/refman/8.0/en/mysql-batch-commands.html)