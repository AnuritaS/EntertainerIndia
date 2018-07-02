//
//  ClientTableCell.swift
//  Entertainer
//
//  Created by Anurita Srivastava on 27/12/17.
//  Copyright © 2017 Shubhankar Singh. All rights reserved.
//
import UIKit
import Kingfisher

class ClientTableCell: UITableViewCell {
    
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    var onCategoryTapped : (() -> Void)? = nil
     weak var delegate:CategoryRowDelegate?
    var result = [[Result]]()

    @IBAction func onCategoryPressed(_ sender: Any) {
        if let onCategoryTapped = self.onCategoryTapped {
            onCategoryTapped()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        var title = categoryBtn.title(for: .normal)
//        if title == nil{
//            title=""
//        }
//        let attributedTitle = NSAttributedString(string: title!, attributes: [NSAttributedStringKey.kern: 1.5])
//        categoryBtn.setAttributedTitle(attributedTitle, for: .normal)

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
    
extension ClientTableCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{

 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return result[tag].count
    } 
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
 
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exp_cell", for: indexPath) as! experienceCollectionViewCell

       cell.main_label.text = result[tag][indexPath.item].descriptionField
      cell.host_name.text = result[tag][indexPath.item].client?.establishmentName?.uppercased()
      

        if let logo = result[tag][indexPath.item].client?.logo {
            if logo == ""{
                cell.estd_image_view.addPlaceHolder()
            }else{
                let url = URL(string: logo)
                cell.estd_image_view.kf.setImage(with: url)
            }
        }
        if let bgImg = result[tag][indexPath.item].client?.imgUrl {
        if bgImg.count == 0{
        cell.image_view.addPlaceHolder()
        }else{
            let url = URL(string: bgImg[0])
           cell.image_view.kf.setImage(with: url)
            }
        }
       
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if delegate != nil {
           delegate?.cellTapped(result[tag][indexPath.item].client?.id ?? "", result[tag][indexPath.item].client?.establishmentName ?? "", result[tag][indexPath.item].client?.logo ?? "")
        }
        print(indexPath.item)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let itemsPerRow:CGFloat = 4
        let hardCodedPadding:CGFloat = 5
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
