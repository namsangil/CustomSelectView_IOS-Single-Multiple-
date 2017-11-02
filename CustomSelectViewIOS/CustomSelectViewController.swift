//
//  CustomSelectViewController.swift
//  CustomSelectViewIOS
//
//  Created by nam on 2017. 11. 2..
//  Copyright © 2017년 nam. All rights reserved.
//

import Foundation

import Foundation
import UIKit

protocol CustomSelectViewControllerMultiSelectDelegate{
    func onSelectItems(_ target:CustomSelectViewController, _ keys : [String])
}

protocol CustomSelectViewControllerSingleSelectDelegate{
    func onSelectItem(_ target:CustomSelectViewController, _ key : String)
}

class CustomSelectViewController : UIViewController{
    
    
    @IBOutlet weak var superView : UIView!
    
    @IBOutlet weak var container : UIView!
    @IBOutlet weak var cancelView : UIView!
    @IBOutlet weak var confirmView : UIView!
    @IBOutlet weak var confirmViewWidthConstraint : NSLayoutConstraint!
    @IBOutlet weak var confirmViewLeadingConstraint : NSLayoutConstraint!
    
    
    @IBOutlet weak var selectContainer : UIView!
    @IBOutlet weak var selectView : UIView!
    @IBOutlet weak var selectViewHeight : NSLayoutConstraint!
    @IBOutlet weak var titleLabel : UILabel!
    
    
    @IBOutlet weak var constraint : NSLayoutConstraint!
    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var scrollViewHeight : NSLayoutConstraint!
    
    enum SelectMode{
        case SINGLETYPE, MULTITYPE
    }
    var tag: Int = 0
    var multiSelectDelegate : CustomSelectViewControllerMultiSelectDelegate?
    var singleSelectDelegate : CustomSelectViewControllerSingleSelectDelegate?
    var list : [SelectViewItemVo] = []
    var keyList : [String] = [String]()
    var valueList : [String] = [String]()
    var titleName : String = "선택"
    var tintColor : UIColor = UIColor.brown
    var backgroundColor : UIColor = UIColor.white
    var selectMode : SelectMode = SelectMode.SINGLETYPE
    var singleSelectedKey: String?
    var multiSelectedKeyList : [String] = [String]()
    let buttonHeight  = 55
    
    override func awakeFromNib() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.4)
        
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
            let dict: NSDictionary = NSDictionary(contentsOfFile: path),
            let color: Int = dict["mainColor"] as? Int {
            
            self.tintColor = UIColor(netHex: color)
        }
        
        list = [SelectViewItemVo]()
        for idx in 0..<self.keyList.count{
            list.append(SelectViewItemVo(self.keyList[idx],self.valueList[idx]))
        }
        
        titleLabel.text = self.titleName
        cancelView.layer.cornerRadius = 10
        cancelView.layer.masksToBounds = true
        confirmView.layer.cornerRadius = 10
        confirmView.layer.masksToBounds = true
        selectContainer.layer.cornerRadius = 10
        selectContainer.layer.masksToBounds = true
        
        
        
        
        switch(self.selectMode){
        case .SINGLETYPE :
            superView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancel)))
            confirmViewWidthConstraint.constant = 0
            confirmViewLeadingConstraint.constant = 0
            
            for (idx, item) in self.list.enumerated(){
                if idx < list.count-1{
                    addSingleItem(item.mValue, item.mKey, idx, false)
                }
                else{
                    addSingleItem(item.mValue, item.mKey, idx, true)
                    
                }
            }
            break
            
        case .MULTITYPE :
            superView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(checkNoneSelected)))
            for (idx, item) in self.list.enumerated(){
                if idx < list.count-1{
                    addMultiItem(item.mValue, item.mKey, idx, false)
                }
                else{
                    addMultiItem(item.mValue, item.mKey, idx, true)
                }
            }
            break
        }
    }
    
    func addMultiItem(_ value : String, _ key : String, _ idx : Int, _ isEnd : Bool){
        let button = SelectButton()
        
        button.mKey = key
        button.mValue = value
        button.tint = self.tintColor
        button.bgColor = self.backgroundColor
        button.isSetBottomBorder = !isEnd
        if multiSelectedKeyList.contains(key){
            button.setChangeState(tintColor: self.tintColor, bgColor: self.backgroundColor, onAdd: nil, onRemove: nil)
        }
        button.initial()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(touchUpMultiItem), for: .touchUpInside)
        
        self.selectView.addSubview(button)
        let topConstraint = NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: self.selectView, attribute: .top, multiplier: 1, constant: CGFloat(buttonHeight * idx))
        let leftConstraint = NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal, toItem: self.selectView, attribute: .left, multiplier: 1, constant: 0 )
        let rightConstraint = NSLayoutConstraint(item: button, attribute: .right, relatedBy: .equal, toItem: self.selectView, attribute: .right, multiplier: 1, constant: 0 )
        let widthConstraint = NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: self.selectView, attribute: .width, multiplier: 1, constant: 0 )
        let heightConstraint = NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: CGFloat(buttonHeight) )
        self.selectView.addConstraints([topConstraint, leftConstraint, rightConstraint, widthConstraint, heightConstraint])
        
        self.selectViewHeight.constant = CGFloat(buttonHeight * (idx+1))
        self.scrollViewHeight.constant = CGFloat(buttonHeight * (idx+1))
    }
    
    @objc func touchUpMultiItem(_ sender: UIButton){
        let button = sender as! SelectButton
        button.setChangeState(tintColor: self.tintColor, bgColor: self.backgroundColor, onAdd: {
            (key) in
            self.multiSelectedKeyList.append(key)
        }, onRemove: {
            (key) in
            if let idx = self.multiSelectedKeyList.index(of: key){
                self.multiSelectedKeyList.remove(at: idx)
            }
        })
    }
    
    func addSingleItem(_ value : String, _ key : String,  _ idx : Int, _ isEnd : Bool){
        let button = SelectButton()
        
        button.mKey = key
        button.mValue = value
        button.tint = self.tintColor
        button.bgColor = self.backgroundColor
        button.isSetBottomBorder = !isEnd
        button.initial()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(touchUpSingleItem), for: .touchUpInside)
        //        if singleSelectedKey == key {
        //            button.setChangeState(tintColor: self.tintColor, bgColor: self.backgroundColor, onAdd: nil, onRemove: nil)
        //        }
        //        if multiSelectedKeyList.contains(key){
        //            button.setChangeState(tintColor: self.tintColor, bgColor: self.backgroundColor, onAdd: nil, onRemove: nil)
        //        }
        
        self.selectView.addSubview(button)
        let topConstraint = NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: self.selectView, attribute: .top, multiplier: 1, constant: CGFloat(buttonHeight * idx))
        let leftConstraint = NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal, toItem: self.selectView, attribute: .left, multiplier: 1, constant: 0 )
        let rightConstraint = NSLayoutConstraint(item: button, attribute: .right, relatedBy: .equal, toItem: self.selectView, attribute: .right, multiplier: 1, constant: 0 )
        let widthConstraint = NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: self.selectView, attribute: .width, multiplier: 1, constant: 0 )
        let heightConstraint = NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: CGFloat(buttonHeight) )
        self.selectView.addConstraints([topConstraint, leftConstraint, rightConstraint, widthConstraint, heightConstraint])
        
        
        self.selectViewHeight.constant = CGFloat(buttonHeight * (idx+1))
        self.scrollViewHeight.constant = CGFloat(buttonHeight * (idx+1))
        
    }
    
    @IBAction func cancel(){
        
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func checkNoneSelected(){
        if multiSelectedKeyList.count == 0{
            let alert = UIAlertController(title: "선택되지 않음", message: "선택을 하지 않았습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            self.multiSelectDelegate?.onSelectItems(self, self.multiSelectedKeyList)
            
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func confirm(){
        self.checkNoneSelected()
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @objc func touchUpSingleItem(_ sender:UIButton){
        let button = sender as! SelectButton
        button.setChangeState(tintColor: self.tintColor, bgColor: self.backgroundColor, onAdd: {
            (key) in
            
            self.singleSelectDelegate?.onSelectItem(self, key)
            self.dismiss(animated: true, completion: nil)
        }, onRemove: {
            (key) in
            // nothing
        })
    }
    
}

class SelectViewItemVo{
    var mKey : String!
    var mValue : String!
    init(_ key : String, _ value : String){
        self.mKey = key
        self.mValue = value
    }
}

class SelectButton : UIButton{
    
    
    var isSetBottomBorder : Bool = false
    var tint : UIColor!
    var bgColor : UIColor!
    var mValue : String!
    var mKey : String!
    var isSelectedButton : Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func initial(){
        setTitle(self.mValue, for: .normal)
        
    }
    
    func setChangeState(tintColor c1 : UIColor, bgColor c2 : UIColor, onAdd add : ((_ key:String)->Void)?, onRemove remove : ((_ key:String)->Void)? ){
        isSelectedButton = !isSelectedButton
        if isSelectedButton{
            self.tint = c2
            self.bgColor = c1
            add?(self.mKey)
        }
        else{
            self.tint = c1
            self.bgColor = c2
            remove?(self.mKey)
            
        }
        draw(frame)
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if self.isSetBottomBorder{
            addBorderBottom(height: 0.5, color: self.tint)
        }
        setTitleColor(self.tint, for: .normal)
        backgroundColor = self.bgColor
        
    }
}

extension UIButton {
    func addBorderBottom(height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height-height, width: self.frame.width, height: height)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
}
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    convenience init(rgba:String) {
        self.init(netHex:Int.init(rgba)!)
        //        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}


