HorizontalTableView
===================

一个横向的TableView。做这个的原因是想自己练练手：现在有很多新闻客户端，但是很多都不怎么样，比如说一些门户网站的新闻客户端，导航在点击到最后一个可见的频道时，不会自动往前滚动一下，显示下个频道出来，这样导致用户想看下个频道必须手动滚动一下，反而是非门户网站的「今日头条」在交互上做的比较好。

这个只是练手，所以很多东西没有细致去做了。如果未来有时间会把下面这些点完善好：

- cell的淘汰机制。现在的cell的缓存没有淘汰机制，导致cell的个数会越来越多，变相的内存泄露。
- section。现在的section只能返回string。但是完整的应该是可以返回UIView。或者整个section都有接口覆盖实现。


这个横向tableview不同的地方在于可以设置是否显示导航，导航显示的位置也可以调整。如下图。导航就是红色区域的section等按钮。界面是丑了点，讲究看吧

![Demo演示](https://raw.githubusercontent.com/chundong/HorizontalTableView/master/demo.gif)

导航先显示。

![导航在上面的](https://raw.githubusercontent.com/chundong/HorizontalTableView/master/demo.png)
