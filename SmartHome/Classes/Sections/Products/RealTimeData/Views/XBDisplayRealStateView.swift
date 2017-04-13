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
    var timer:DispatchSourceTimer?
    var xScale:CGFloat = 0
    
    var datas = [UIImage]()
    var dataWidth = [CGFloat]()
    var lastEvent = 0
    var offset:CGFloat = 0.0
    var now = Date()
    var halfHour = Date().add(components: [.minute:30])
    var motivateCounter = 0
    
    var event:Int = 0 {
    
        didSet {
            
            if event == 3 {  //motivate
                motivateCounter += 1
                if motivateCounter == 3 || motivateCounter == 4 {
                    event = 2  // modify data to onBed
                }
            }
            
            if let eventType = XBEventType(rawValue: event) {
                if dataWidth.count == 0 || (lastEvent != event)  {
                    dataWidth.append(xScale)
                    datas.append(XBRealData.image(eventType))
                } else if lastEvent == event {
                    dataWidth[dataWidth.count-1] = dataWidth[dataWidth.count-1]+xScale
                }
                
                lastEvent = event
            } else if (lastEvent != 0) {
                //对于非第一次的无效的信号则画上一次的信号
                dataWidth[dataWidth.count-1] = dataWidth[dataWidth.count-1]+xScale
            }
            collection.reloadData()
            
            print("\(event)")
        }
    }
    
    var collection:UICollectionView!
    var timeline:UIImageView!
    var begin:UILabel!
    var end:UILabel!
    
    deinit {
        
    }
    
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
        begin.font = UIFontSize(14)
        begin.text = "--:--"
        begin.sizeToFit()
        addSubview(begin)
        
        end = UILabel()
        end.font = UIFontSize(14)
        end.text = "--:--"
        end.sizeToFit()
        addSubview(end)
        
        setupTimer()
    }
    
    private func setupTimer()  {
        timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        timer?.setEventHandler( handler: {
            self.refreshTimeRange()
        })
        timer?.scheduleRepeating(deadline: .now(), interval: .seconds(30*60))
        timer?.resume()
    }
    
    private func refreshTimeRange() {
        
        now = Date()
        halfHour = Date().add(components: [.minute:30])
        datas.removeAll()
        dataWidth.removeAll()
        
        begin.text = String(format: "%.2zd:%.2zd", now.hour, now.minute)
        end.text = String(format: "%.2zd:%.2zd", halfHour.hour, halfHour.minute)
        begin.sizeToFit()
        end.sizeToFit()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        xScale = width / CGFloat(180) // 30 * 6
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
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
        let imageView = UIImageView(frame: cell.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.image = datas[indexPath.row]
        cell.contentView.addSubview(imageView)
        
        return cell
    }
    
}

extension XBDisplayRealStateView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: dataWidth[indexPath.row], height: collection.height)
    }

}
