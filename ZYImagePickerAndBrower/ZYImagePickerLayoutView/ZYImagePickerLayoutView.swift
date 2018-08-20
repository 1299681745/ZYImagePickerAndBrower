//
//  ZYImagePickerLayoutView.swift
//  ZYImagePickerAndBrower
//
//  Created by Nvr on 2018/8/20.
//  Copyright © 2018年 ZY. All rights reserved.
//

import UIKit

struct ItemSize {
    var width:CGFloat = 70
    var height:CGFloat = 70
    var minimumInteritemSpacing:CGFloat = 10
    var minimumLineSpacing:CGFloat = 10
}

class ZYImagePickerLayoutView: UIView {

    let cellIdentifier = "ImagePickerLayoutCollectionViewCellId"
    var itemSize:ItemSize!
    var space:CGFloat = 10
    var datasourceHeight:CGFloat = 0
    
    private lazy var imageCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        //  collectionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.isPagingEnabled = true
        //  添加协议方法
        collectionView.delegate = self
        collectionView.dataSource = self
        //  设置 cell
        collectionView.register(UINib.init(nibName: "ImagePickerLayoutCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        return collectionView
    }()
    
    //image个数
    var dataSource:[ZYPhotoModel]?
    
    //是否需要加号
    var hiddenPlus = false {
        didSet{
            
        }
    }
    //一行个数
    var numberOfLine = 4 {
        didSet{
            
        }
    }
    //最大几个数
    var maxNumber = 9
    var hiddenDelete = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
}

//MARK:- UI
extension ZYImagePickerLayoutView{
    
    
    override func layoutSubviews() {
       super.layoutSubviews()
        for constanst in  self.constraints {
            let lineNumber = ceilf(Float(CGFloat(dataSource?.count ?? 0)/CGFloat(numberOfLine)))
            print(lineNumber)
            constanst.constant = CGFloat(lineNumber) * (itemSize.width + 10.0)
            imageCollectionView.frame.size.width = self.frame.width
            imageCollectionView.frame.size.height = constanst.constant
        }
    }
    
    func setupView(){
        //初始化Collectview
        self.addSubview(imageCollectionView)
        itemSize = ItemSize()
    }
    
    func updateCollectionView(){
        
    }
    
    func reloadView(){
        let spaceNumber = CGFloat(numberOfLine) - 1
        let width =  (self.frame.size.width - (space * spaceNumber))/CGFloat(numberOfLine)
        itemSize = ItemSize.init(width:width , height: width, minimumInteritemSpacing: space, minimumLineSpacing: space)
        self.layoutSubviews()
        imageCollectionView.reloadData()
    }
}

//MARK:- UICollectionViewDelegate
extension ZYImagePickerLayoutView:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:cellIdentifier, for: indexPath) as? ImagePickerLayoutCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.imageView.image = dataSource![indexPath.row].thumbnailImage
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemSize.minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemSize.minimumInteritemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:itemSize.width, height: itemSize.height)
    }
}
