//
//  BookCell.swift
//  booklog
//
//  Created by arao on 2015/07/22.
//  Copyright (c) 2015年 arao. All rights reserved.
//

import UIKit

class BookCell : UITableViewCell{
    
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookAuthor: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func setCell(book :Book){
        
        self.bookTitle.text = book.name
        
        // 画像をUIImageViewに設定する.
        let myImage = UIImage(named: "camera.jpg")
        self.bookImage.image = myImage
        
        
    }
}
