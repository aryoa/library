//
//  BookCell.swift
//  library
//
//  Created by arao on 2015/09/12.
//  Copyright (c) 2015年 arao. All rights reserved.
//

import UIKit

class BookCell : UITableViewCell{
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookAuthor: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // 画像のサイズにViewを合わせるよに設定
        self.bookImage.contentMode = UIViewContentMode.ScaleAspectFit
    }    
}
