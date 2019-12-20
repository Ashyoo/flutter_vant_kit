import 'package:flutter/material.dart';
import 'package:flutter_kit/widgets/tag.dart';
import 'package:flutter_kit/widgets/button.dart';

class AddressList extends StatefulWidget {
  // 当前选中地址的 id	
  int id;
  // 地址列表	
  List<AddressInfo> list;
  // 不可配送地址列表	
  List<AddressInfo> disabledList;
  // 不可配送提示文案	
  final String disabledText;
  // 是否允许切换地址	
  final bool switchable;
  // 底部按钮文字	
  final String addButtonText;
  // 默认地址标签文字	
  final String defaultTagText;
  // 点击新增按钮时触发	
  final Function() onAdd;
  // 点击编辑按钮时触发	
  final Function(AddressInfo info, int i) onEdit;
  // 切换选中的地址时触发	
  final Function(AddressInfo info, int i) onSelect;
  // 在顶部插入内容
  final Widget top;
  // 在列表下方插入内容
  final Widget children;

  AddressList({
    Key key,
    this.id,
    this.list,
    this.disabledList,
    this.disabledText: "以下地址超出配送范围",
    this.switchable: true,
    this.addButtonText: "新增地址",
    this.defaultTagText: "默认",
    this.onAdd,
    this.onEdit,
    this.onSelect,
    this.top,
    this.children
  }) : super(key: key);
  
  @override
  _AddressList createState() => _AddressList();
}

class _AddressList extends State<AddressList>{
  List<Widget> buildItem (List<AddressInfo> list, bool disabled) {
    List<Widget> widgets = [];
    for(int i = 0; i < list.length; i++) {
      AddressInfo item = list[i];
      widgets.add(
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              focusColor: disabled ? Colors.transparent : Theme.of(context).focusColor,
              highlightColor: disabled ? Colors.transparent : Theme.of(context).highlightColor,
              hoverColor: disabled ? Colors.transparent : Theme.of(context).hoverColor,
              splashColor: disabled ? Colors.transparent : Theme.of(context).splashColor,
              onTap: () {
                if (disabled || widget.id == i || !widget.switchable) return;
                setState(() {
                  widget.id = i;
                });
                if (widget.onSelect != null) widget.onSelect(item, i);
              },
              child: Container(
                padding: EdgeInsets.all(12.0),
                child: Row(
                  children: <Widget>[
                    disabled ? Container() : Icon(Icons.check_circle, color: i == widget.id && !disabled ? Colors.red : Colors.transparent, size: 20),
                    Expanded(
                      child: Padding(
                        padding: disabled ? EdgeInsets.only(right: 12) : EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text("${item.name} ${item.tel}", style: TextStyle(fontSize: 16, color: disabled ? Color(0xffc8c9cc) : Colors.black)),
                                item.isDefault && !disabled ? SizedBox(width: 6) : Container(),
                                item.isDefault && !disabled ? Tag(text: "${widget.defaultTagText}", round: true, color: Colors.red) : Container()
                              ],
                            ),
                            SizedBox(height: 8),
                            Text("${item.province}${item.city}${item.county}${item.addressDetail}", style: TextStyle(fontSize: 12, color: disabled ? Color(0xffc8c9cc) : Colors.black))
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      focusColor: disabled ? Colors.transparent : Theme.of(context).focusColor,
                      highlightColor: disabled ? Colors.transparent : Theme.of(context).highlightColor,
                      hoverColor: disabled ? Colors.transparent : Theme.of(context).hoverColor,
                      splashColor: disabled ? Colors.transparent : Theme.of(context).splashColor,
                      icon: Icon(Icons.create, color: Colors.grey, size: 16),
                      onPressed: () {
                        if (disabled) return;
                        if (widget.onEdit != null) widget.onEdit(item, i);
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      if (i < list.length - 1) widgets.add(SizedBox(height: 12));
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: App,
      bottomNavigationBar: Container(
        height: 65,
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        child: NButton(
          text: "新增地址",
          block: true,
          type: "danger",
          round: true,
          onClick: () {
            if (widget.onAdd != null) widget.onAdd();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            widget.top??Container(),
            ...buildItem(widget.list??[], false),
            (widget.disabledList != null) ? Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Text(widget.disabledText, style: TextStyle(color: Color(0xffc8c9cc))),
            ) : Container(),
            ...buildItem(widget.disabledList??[], true),
            widget.children??Container(),
          ],
        ),
      ),
    );
  }
}

class AddressInfo {
  final String name;
  final String tel;
  final String province;
  final String city;
  final String county;
  final String addressDetail;
  final String postalCode;
  final bool isDefault;

  AddressInfo({
    this.name,
    this.tel,
    this.province,
    this.city,
    this.county,
    this.addressDetail,
    this.postalCode,
    this.isDefault
  });
}