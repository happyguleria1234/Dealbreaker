//
//  IntroScreensVC.swift
//  DealBreakers
//
//  Created by Vivek Dharmani on 02/12/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class IntroScreensVC: UIViewController {

    @IBOutlet weak var IntroScreenCollectionView: UICollectionView!
    var imgArray = ["content-1","content-9","content-3","content-4","content-5","content-6","content-7","content-8"]
    var currentIndex = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        IntroScreenCollectionView.reloadData()
        // Do any additional setup after loading the view.
    }
}

class IntroScreenCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var showImages: UIImageView!
    @IBOutlet weak var getStartedButton: UIButton!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension IntroScreensVC : UICollisionBehaviorDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
//        pageControl.numberOfPages = imgArray.count
        return imgArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IntroScreenCollectionViewCell", for: indexPath) as! IntroScreenCollectionViewCell
        currentIndex = indexPath.row
        cell.getStartedButton.tag = indexPath.row
        if indexPath.row <= 6{
            cell.getStartedButton.setBackgroundImage(UIImage(named: "next-btn"), for: .normal)
            cell.getStartedButton.addTarget(self, action: #selector(getStartedButton), for: .touchUpInside)
        }else if indexPath.row == 7{
            cell.getStartedButton.setBackgroundImage(UIImage(named: "get-started"), for: .normal)
           
        }
        cell.getStartedButton.addTarget(self, action: #selector(getStartedButton), for: .touchUpInside)
        cell.showImages.image = UIImage(named: imgArray[indexPath.item])
        cell.pageControl.numberOfPages = imgArray.count
        cell.pageControl.currentPage = indexPath.row
        return cell
    }
    
    @objc func getStartedButton(sender: UIButton) {
        if sender.tag < 7 {
            IntroScreenCollectionView.scrollToNextItem()
        }else if sender.tag == 7 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpWithVC") as! SignUpWithVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        self.pageControl.currentPage = indexPath.section
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        return CGSize(width: size.width
            , height: size.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//
//        pageControl?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
//    }

//    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//
//        pageControl?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
//    }
//
}

extension UICollectionView {
    func scrollToNextItem() {
        let contentOffset = CGFloat(floor(self.contentOffset.x + self.bounds.size.width))
        self.moveToFrame(contentOffset: contentOffset)
    }
    func moveToFrame(contentOffset : CGFloat) {
            self.setContentOffset(CGPoint(x: contentOffset, y: self.contentOffset.y), animated: true)
        }
}
