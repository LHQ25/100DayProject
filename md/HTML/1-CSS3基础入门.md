# 1. CSS入门

## 导入式

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <style>
        @import url(css/css.css);
    </style>
</head>
<body>
    <h1>主标题</h1>
</body>
</html>
```

## 内嵌式

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <style>
        h1 {
            color: red;
        }
    </style>
</head>
<body>
    <h1>我是一个主标题</h1>
</body>
</html>
```

## 外链式

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
  	<--- 外链式 --->
    <link rel="stylesheet" href="css/css.css">
</head>
<body>
    <h1>主标题</h1>
</body>
</html>
```

## 行内式

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <h1 style="color: red;">我是一个主标题</h1>
    <h1 style="color: red;">我是一个主标题</h1>
    <h1 style="color: red;">我是一个主标题</h1>
</body>
</html>
```

## 基本语法

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <style>
        h2 {
            color: red;
            /* 背景颜色 */
            background-color: blue
        }
          
        p {
            color: green;
            /* 背景颜色 */
            background-color: yellow
        }
        li { color: orange; background-color: red}
    </style>
</head>
<body>
    <h1>我是一级标题</h1>
    <h2>我是二级标题</h2>
    <h3>我是三级标题</h3>
    <p>我是段落</p>
    <ul>
        <li>我是列表项</li>
        <li>我是列表项</li>
    </ul>
</body>
</html>

```

# 选择器

