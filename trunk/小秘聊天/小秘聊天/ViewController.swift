//
//  ViewController.swift
//  小秘聊天
//
//  Created by LiWeijie on 2017/3/14.
//  Copyright © 2017年 WeijieLi. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate ,UIGestureRecognizerDelegate{

    @IBOutlet var sendText: UITextField!
    @IBOutlet var serviceTableview: UITableView!
    @IBOutlet var serviceTableBottomLine: NSLayoutConstraint!
    @IBOutlet var sendView: UIView!
    @IBOutlet var sendViewBottomLine: NSLayoutConstraint!
    /*
    var cellType:[String] = []
    创建一个空字典
    var emptyDictionary = [String:String]()
    var noStyleEmptyDic:NSMutableDictionary = [:] //定义一个空的可变字典
    */
    //定义空数组存储cell的类型
    var cellType = [String]()
    //三种type的cell
    let answerCell = "answerCell"
    let questionCell = "questionCell"
    let specialCell = "specialCell"
    //我们把cell中的信息存储到一个数组里，利于取数据和cell高度代码计算
    var messageCell = [String]()
    //label的输入宽度
    var widthS = UIScreen.main.bounds.size.width - 75 * 2 + 3
    var SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    var SCREEN_WIDTH  = UIScreen.main.bounds.size.width
    /**
     - Description: 基础语法
     - Grammar: 数组append insert
     - By: Wjli
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        serviceTableview.delegate = self
        serviceTableview.dataSource = self
        serviceTableview.allowsSelection = false
        serviceTableview.separatorStyle = UITableViewCellSeparatorStyle.none
        //一开始定义，左边类型的cell
        cellType = [answerCell]
        //数组追加元素--右边的元素和特殊的cell
        cellType.append(specialCell)
        cellType.append(questionCell)
        //print(cellType)  //["answerCell", "questionCell", "specialCell"]
        messageCell = ["你好，我是小秘。欢迎来到我的世界，我会竭诚为您服务，祝您开心每一天！","specialCell","goodDay"]
        //添加点击手势结束响应操作
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(self.tapClick(sender:)))
        serviceTableview.addGestureRecognizer(tapGesture)
    }
    
    func tapClick(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            sendText.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }
    //MARK: - 键盘操作
    /**
    -describe：做键盘监听
     */
    override func viewWillAppear(_ animated: Bool) {
        //键盘开启监听
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    //键盘的出现
    func keyBoardWillShow(_ notification: Notification){
        //获取userInfo
        let kbInfo = notification.userInfo
        //获取键盘的size
        let kbRect = (kbInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        //键盘的y偏移量
        //let changeY = kbRect.origin.y - SCREEN_HEIGHT
        //键盘的高度
        let kbHeight = kbRect.size.height
        //键盘弹出的时间
        let duration = kbInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        //界面偏移动画
        UIView.animate(withDuration: duration) {
            self.serviceTableview.frame = CGRect(x:0 , y:64 , width:self.SCREEN_WIDTH, height:self.SCREEN_HEIGHT - 55 - kbHeight - 64)
            self.sendView.frame = CGRect(x:0, y:kbRect.origin.y - 55, width: self.SCREEN_WIDTH, height: 55 )
            self.scrollToRow()
          //也有利用transform偏移量的方式
          // self.serviceTableview.transform = CGAffineTransform(translationX: 0, y: changeY)
        }
    }
    //键盘的隐藏
    func keyBoardWillHide(_ notification: Notification){
        let kbInfo = notification.userInfo
        let kbRect = (kbInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let changeY = kbRect.origin.y
        let duration = kbInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        UIView.animate(withDuration: duration) {
            self.serviceTableview.frame = CGRect(x:0 , y:64 , width:self.SCREEN_WIDTH, height:self.SCREEN_HEIGHT - 55 - 64 )
            self.sendView.frame = CGRect(x:0, y:changeY - 55, width: self.SCREEN_WIDTH, height: 55 )
        }
    }
    
    @IBAction func sendText(_ sender: UIButton) {
        let sendTextTl:NSString? = sendText.text as NSString?
        //向数组里传 数据和cellType
        messageCell.append(sendTextTl as! String)
        cellType.append(questionCell)
        //刷新tableview
        serviceTableview.reloadData()
        scrollToRow()
        //清空数据
        sendText.text = ""
        /*******      *******/
        //图灵api接口
        tuiLingApi(sendMessage:sendTextTl!)
    }
    //MARK - 私有函数
    /**
     - Description: tableview在底部从下往上显示内容
     - Grammar: scrollToRow
     - By: Wjli
     */
    private func scrollToRow()  {
        if self.messageCell.count > 0 {
            let indexPath = NSIndexPath.init(row: self.messageCell.count - 1, section: 0)
            self.serviceTableview.scrollToRow(at: indexPath as IndexPath, at: UITableViewScrollPosition.bottom, animated:true)
        }
    }
    private func tuiLingApi(sendMessage:NSString) {
        var answerText = "无论你跟我说什么，我都回答春暖花开，不信你在试试看~~~~~~~~"
        let tlParams = ["key":"3942ce7f92074d97b02efed31e37e487","info":sendMessage]
        let tlUrl = "http://www.tuling123.com/openapi/api"
        CommomMethodsInstance.postRequest(urlString: tlUrl, params:tlParams, success: { (value) in
            let valueDic = value;
            answerText = valueDic["text"] as! String
            self.messageCell.append(answerText )
            self.cellType.append(self.answerCell)
            self.serviceTableview.reloadData()
            self.scrollToRow()
        }) { (error) in
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK - tableview代理
    //显示cell多少行
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return cellType.count
    }
    //绘制cell
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //由测cellType判断类型
        let cellTypeNow = cellType[indexPath.row]
        //取出cell显示的数据
        let cellText = messageCell[indexPath.row]
        //获取文字size
        let textFont:UIFont = UIFont.systemFont(ofSize: 16)
        let recSize = CommomMethodsInstance.getLabSize(labelStr: cellText, font: textFont, width: widthS)        
        //图片
        var backImage:UIImage? = nil
        //比较字符串，
        if cellTypeNow.isEqual(answerCell as String) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerServiceTableViewCell", for: indexPath) as! CustomerServiceTableViewCell
            cell.answerLabel.text = cellText
            //处理图片size
            cell.abackWidth.constant = recSize.width + 15 + 9
            cell.abackHeight.constant = recSize.height + 16
            //图片剪切
            backImage = UIImage(named: "qipao01")
            backImage = backImage?.stretchableImage(withLeftCapWidth:Int((backImage?.size.width)!/2), topCapHeight:Int((backImage?.size.width)!/1.8))
            cell.answerBackImage.image = backImage
            return cell
        }else if cellTypeNow.isEqual(questionCell as String) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! UserTableViewCell
            cell.questionLabel.text = cellText
            backImage = UIImage(named: "qipao02")
            backImage = backImage?.stretchableImage(withLeftCapWidth:Int((backImage?.size.width)!/2), topCapHeight:Int((backImage?.size.width)!/1.8))
            //处理图片size
            cell.qbackWidth.constant = recSize.width + 15 + 8
            cell.qbackHeight.constant = recSize.height + 16
            cell.questionBackImage.image = backImage
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SpecialServiceTableViewCell", for: indexPath) as! SpecialServiceTableViewCell
            cell.setSelected(false, animated: false)
            return cell
        }

    }
    //选中cell
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("选中\(indexPath.row)")
    }
//    //预设行高
//    @objc(tableView:estimatedHeightForRowAtIndexPath:) public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 150
//    }
    //cell的高度
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //获取文字信息
        let cellText = messageCell[indexPath.row]
        if cellText.isEqual("specialCell")  {
            //这是特殊cell的行高
            return 135 + 40;
        }else {
            //let textFont:UIFont? = UIFont(name:"", size:17)//
            let textFont:UIFont = UIFont.systemFont(ofSize: 16)
            //let cellLabelHeight = getLabHeigh(labelStr: cellText, font:textFont, width: widthS)
            let cellLabelHeight = CommomMethodsInstance.getLabHeigh(labelStr: cellText, font: textFont, width: widthS)
            
            //判断文字高度是否大于最小值
            if cellLabelHeight + 45 / 2 + 20 <= 45 + 20 {
                return 65
            }else {
                return 45 / 2 + 20 + cellLabelHeight
            }
        }
    }
    /**
     - Description: 通知移除
     - Grammar: deinit属于析构函数，当对象结束其生命周期时，系统自动执行析构函数
                需要执行的有{
                对象销毁、KVO移除、通知移除、NSTimer销毁
                }
     - By: Wjli
     */
    deinit {
        //移除通知
        NotificationCenter.default.removeObserver(self)
    }
    

}













