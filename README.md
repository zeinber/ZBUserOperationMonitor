# ZBUserOperationMonitor
## 原理
通过研究用户点击之后，整个响应链的执行过程，找到一个合适的节点方法进行 hook，从中将 Touch 事件分离出来，根据需求进行过滤（复制、剪切、粘贴以及键盘事件），从而达到监听的目的。

## 监控范围
### 剪切板
+ copy
+ paste
+ cut

### 键盘
+ keyboard click

