//
//  XBDisplayRealStateView.swift
//  ProductTest
//
//  Created by 赖霄冰 on 2017/3/24.
//  Copyright © 2017年 helloworld.com. All rights reserved.
//

import UIKit

class XBDisplayRealStateView: UIView {
    
    let cellId = "cell"
    var datas = [#imageLiteral(resourceName: "onBedR"),#imageLiteral(resourceName: "motivateR"),#imageLiteral(resourceName: "nobodyR"),#imageLiteral(resourceName: "motivateR"),#imageLiteral(resourceName: "onBedR"),#imageLiteral(resourceName: "motivateR")]
    var dataWidth:[CGFloat] = [10.0,40,50,15,110,30]
    var collection:UICollectionView!
    var timeline:UIImageView!
    var begin:UILabel!
    var end:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        self.backgroundColor = UIColor.white
    
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets.zero
        
        collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.backgroundColor = UIColor.white
        collection.showsHorizontalScrollIndicator = false
        collection.isUserInteractionEnabled = false
        collection.dataSource = self
        collection.delegate = self
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier:cellId )
        addSubview(collection)
        
        timeline = UIImageView(image: #imageLiteral(resourceName: "dashLine"))
        addSubview(timeline)
        
        begin = UILabel()
        begin.font = UIFontSize(size: 14)
        begin.text = "21:00"
        begin.sizeToFit()
        addSubview(begin)
        
        end = UILabel()
        end.font = UIFontSize(size: 14)
        end.text = "22:00"
        end.sizeToFit()
        addSubview(end)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collection.frame = CGRect(x: 0, y: 0, width: width, height: height * 2/3)
        timeline.frame = CGRect(x: 0, y: collection.bottom + 12, width: width, height: timeline.height)
        begin.left = timeline.left
        begin.top = timeline.bottom + 10
        end.right = timeline.right
        end.top = timeline.bottom + 10
    }

}

extension XBDisplayRealStateView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        let imageView = UIImageView(frame: cell.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.image = datas[indexPath.row]
        cell.addSubview(imageView)
        return cell
    }
    
}

extension XBDisplayRealStateView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: dataWidth[indexPath.row], height: collection.height)
    }

}
