//
//  TabViewController.swift
//  Browser
//
//  Created by Sun liang on 3/21/16.
//  Copyright © 2016 Liam. All rights reserved.
//

import UIKit
import WebKit


class TabData
{
    var webView: WKWebView!
    var image: UIImage!
    
    deinit {
        webView = nil
        image = nil
    }
}

class TabViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var collectionView: UICollectionView!
    var tabDataList: [TabData] = []
    var tabIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // CollectionView
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(self.view.frame.width/2,(self.view.frame.height-64)/2)
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 0.0
        collectionView = UICollectionView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height), collectionViewLayout: layout)
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.pagingEnabled = true
        collectionView.clipsToBounds = true
        
        self.view.addSubview(collectionView)
        
        let addBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(TabViewController.onClickAdd(_:)))
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(TabViewController.onClickDone(_:)))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        self.toolbarItems = [addBarButton, flexibleSpace, doneBarButton]
        self.navigationController?.setToolbarHidden(false, animated: true)
        
        tabDataList = [TabData(), TabData(), TabData(),TabData()]
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        collectionView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: TableViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        return
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tabDataList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("UICollectionViewCell", forIndexPath: indexPath) as UICollectionViewCell
        
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        
        
        // Add textView
        let textView = UITextView(frame: CGRectMake(0,10,cell.frame.width,50))
        if(tabDataList[indexPath.row].webView != nil) {
            textView.text = tabDataList[indexPath.row].webView.title
        }
        textView.font = UIFont.systemFontOfSize(CGFloat(10))
        textView.backgroundColor = UIColor.clearColor()
        textView.textAlignment = NSTextAlignment.Center
        textView.editable = false
        cell.contentView.addSubview(textView)
        
        // Add UIImageView
        let thumbNailImage = UIImageView(frame: CGRectMake((cell.frame.width-cell.frame.width*0.75)/2, 55, cell.frame.width*0.75, cell.frame.height*0.75))
        thumbNailImage.image = tabDataList[indexPath.row].image
        thumbNailImage.backgroundColor = UIColor.whiteColor()
        cell.contentView.addSubview(thumbNailImage)

        // Add delete Button
        let btnDeleteImage: UIImage!
        btnDeleteImage = UIImage(named: "closeTab")! as UIImage
        
        let btnDelete = UIButton()
        btnDelete.frame = CGRectMake(0, 0, 25, 25)
        btnDelete.layer.position = CGPoint(x: (cell.frame.width - cell.frame.width*0.75)/2, y: 55)
        btnDelete.setImage(btnDeleteImage, forState: .Normal)
        btnDelete.addTarget(self, action: #selector(TabViewController.onClickDelete(_:)), forControlEvents: .TouchUpInside)
        btnDelete.tag = indexPath.row
        cell.contentView.addSubview(btnDelete)
        
        return cell
    }

    func onClickAdd(sender: UIButton) {
        
        
    }
    
    func onClickDone(sender: UIButton) {
        navigationController?.popToViewController(navigationController!.viewControllers[0], animated: true)
    }
    
    func onClickDelete(sender: UIButton) {
        
        
    }
    
    func createNewTab(url: String! = nil) {
        self.tabIndex = self.tabDataList.count
        self.tabDataList.append(TabData())
        navigationController?.popToViewController(navigationController!.viewControllers[0], animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
