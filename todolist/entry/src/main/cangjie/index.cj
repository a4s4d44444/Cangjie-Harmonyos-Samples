package ohos_app_cangjie_entry

internal import ohos.base.LengthProp
internal import ohos.component.Column
internal import ohos.component.Row
internal import ohos.component.Button
internal import ohos.component.Text
internal import ohos.component.CustomView
internal import ohos.component.CJEntry
internal import ohos.component.loadNativeView
internal import ohos.state_manage.SubscriberManager
internal import ohos.state_manage.ObservedProperty
internal import ohos.state_manage.LocalStorage
import ohos.state_macro_manage.Entry
import ohos.state_macro_manage.Component
import ohos.state_macro_manage.State
import ohos.state_macro_manage.r
import ohos.state_manage.ObservedArrayList
import ohos.component.List
import ohos.component.ForEach
import ohos.component.ListItem

import ohos.component.Checkbox
import ohos.component.TextDecorationType
import ohos.base.Color

import ohos.system_date_time.*
import ohos.hilog.Hilog
import ohos.component.Toggle
import ohos.component.ToggleType
import ohos.component.FontWeight
import ohos.component.FlexAlign
import ohos.component.TextInput
import ohos.component.TextInputController
import ohos.component.Blank
import ohos.component.Divider
import ohos.component.TextAlign
import ohos.component.HorizontalAlign
import ohos.component.TextOverflow



// 在 EntryView 类的上方添加
public class TodoItem {
    let id: Int64          // 任务的唯一ID，创建后不再改变
    let title: String      // 任务的标题，创建后不再改变
    var isCompleted: Bool  // 任务的完成状态，可以改变

    // 这是 TodoItem 类的构造函数
    public init(id: Int64, title: String, isCompleted!: Bool = false) {
        this.id = id
        this.title = title
        this.isCompleted = isCompleted
    }
}


@Entry
@Component
class EntryView {

    @State
    var todoList: ObservedArrayList<TodoItem> = ObservedArrayList<TodoItem>([
            TodoItem(1, "学习仓颉编程语言"),
            TodoItem(2, "完成鸿蒙TodoList应用开发"),
            TodoItem(3, "给这个教程点赞", isCompleted: true)
        ])

    // 添加这个新的 @State 变量
    @State
    var newTodoTitle: String = ""
    var controller: TextInputController = TextInputController()
    // 根据完成状态返回对应的文本颜色
    func getTextColor(isCompleted: Bool): Color {
        if (isCompleted) {
            return Color.GRAY // 已完成，返回灰色
        } else {
            return Color.BLACK // 未完成，返回黑色
        }
    }

    // 根据完成状态返回对应的文本装饰
    func getTextDecoration(isCompleted: Bool): TextDecorationType {
        if (isCompleted) {
            return TextDecorationType.LineThrough // 已完成，返回删除线
        } else {
            return TextDecorationType.None // 未完成，无装饰
        }
    }

    func addTodo() {
        // 1. 检查输入内容是否为空（去除首尾空格后）
        let trimmedTitle = this.newTodoTitle.trimAscii()
        if (trimmedTitle.isEmpty()) {
            // 如果为空，则不执行任何操作
            return
        }
        // 2. 创建一个新的 TodoItem
        //    使用时间戳确保 ID 的唯一性
        let newId = SystemDateTime.getCurrentTime()
        let newItem = TodoItem(newId, trimmedTitle)

        // 3. 将新 item 添加到 todoList 的末尾
        this.todoList.append(newItem)

        // 4. 清空输入框
        this.newTodoTitle = ""
    }
    // 新增的辅助函数：根据ID查找TodoItem在列表中的索引
    func findTodoIndexById(id: Int64): Int64 {
        for (index in 0..this.todoList.size) {
            if (this.todoList[index].id == id) {
                return index // 找到了，返回索引
            }
        }
        return -1 // 没找到，返回-1
    }
    func deleteTodo(id:Int64) {
        // 找到要删除的 item 的索引
        let index = this.findTodoIndexById(id)
        if (index != -1) {
            this.todoList.remove(index)
        }
    }

    func getIncompleteCount(): Int64 {
        var count: Int64 = 0
        for (index in 0..this.todoList.size) {
            let item = this.todoList[index]
            if (!item.isCompleted) {
                count++
            }
        }
        return count
    }

    func build() {
        // 使用一个 Column 作为页面的根布局容器
        // 它会让所有子组件在垂直方向上排列TodoItem(id: 1, title: "学习仓颉编程语言")
        Column(){
            // 添加应用标题
            Text("我的待办清单")
                .fontSize(32.fp)
                .fontWeight(FontWeight.Bold)
                .margin(top: 30.vp, bottom: 20.vp)
            // 步骤 5.2: 添加输入区域
            Row(10.vp) {
                TextInput(placeholder:"准备做什么",text:this.newTodoTitle,controller:this.controller)
                    .onChange({value: String =>
                        //当输入框内容变化时，更新 newTodoTitle 状态
                        this.newTodoTitle = value
                    })
                    .layoutWeight(1) // 让输入框占据Row中剩余的所有空间

                Button("添加")
                    .onClick({ evt =>
                        // 点击按钮时，执行添加任务的逻辑
                        this.addTodo()
                    })
                    .height(40.vp)
            }
            .width(90.percent)
            .margin(top: 20.vp)

            // 添加任务计数器和分割线
            Divider().width(90.percent) //分割线
            Text("剩余 ${this.getIncompleteCount()} 项待办")
                .fontSize(14.fp)
                .fontColor(Color.GRAY)
                .width(90.percent)
                .textAlign(TextAlign.Start)
                .margin(top: 10.vp)
            //这里将是我们放置标题、输入框、任务列表等UI组件的地方
            // 在这里添加 List
            List() {
                // ForEach 遍历我们的 todoList 状态变量
                ForEach(this.todoList, itemGeneratorFunc: { item: TodoItem, index: Int64 =>
                    // 为每一个 'item' 创建一个 ListItem
                    ListItem() {
                        // 每一行的具体UI将在这里定义
                        Row(15.vp) {

                            Checkbox(name: "todoCheckbox", group: "todoGroup")
                                .select(item.isCompleted)
                                .size(width: 25.vp, height:25.vp)
                                .margin(right: 10.vp) // 给 Checkbox 和 Text 之间加点间距
                                .onChange({ isSelected =>

                                    // 1. 获取一个需要修改的 item 的【可变副本】
                                    var itemToUpdate = this.todoList[index]

                                    // 2. 修改这个【可变副本】的属性
                                    itemToUpdate.isCompleted = isSelected

                                    // 3. 将修改后的副本重新赋值回数组的那个位置
                                    //    这个操作会触发 @State 的刷新
                                    this.todoList[index] = itemToUpdate

                                    Hilog.error(0xFF00, "LogExample", "This is an info log message3."+isSelected.toString())
                                 })

                            Text(this.todoList[index].title)
                                .fontSize(20.fp)
                                .fontColor(this.getTextColor(this.todoList[index].isCompleted))
                                .decoration(decorationType: this.getTextDecoration(this.todoList[index].isCompleted),color: this.getTextColor(this.todoList[index].isCompleted))
                                .layoutWeight(1)       // 允许 Text 填充剩余空间，但优先级低于 Blank
                                .maxLines(2)           // 最多显示两行
                                .textOverflow(TextOverflow.Ellipsis) // 超出部分用省略号表示
                                .textAlign(TextAlign.Start) // 文本左对齐
                            // 添加 Blank 组件来占据所有可用空间，将删除按钮推向右侧
                            Blank()

                            // 添加删除按钮
                            Button("删除")
                                .fontColor(Color.RED)
                                .backgroundColor(Color.TRANSPARENT) //透明背景
                                .height(30.vp)
                                .onClick({ evt =>
                                    //点击时调用删除函数
                                    this.deleteTodo(item.id)
                                })
                        }
                        .width(100.percent) // 给列表一些左右边距，更好看
                        .padding(10.vp)

                    }
                })
            }
            .width(90.percent) // 给列表一些左右边距，更好看
            .margin(top: 20.vp)
        }
        .width(100.percent)
        .height(100.percent)
        .backgroundColor(0xF1F3F5) // 添加背景色
        .alignItems(HorizontalAlign.Center) // 让所有子项水平居中
    }
}
