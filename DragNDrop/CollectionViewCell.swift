//
//  CollectionViewCell.swift
//  DragNDrop
//
//  Created by hongjuyeon_dev on 29/08/2019.
//  Copyright © 2019 hongjuyeon_dev. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var imgString: String!{
        didSet{
            setUI()
        }
    }
    
    func setUI(){
        imgView.image = UIImage(named: imgString)
    }
}
