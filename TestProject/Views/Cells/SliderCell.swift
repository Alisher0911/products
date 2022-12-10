//
//  SliderCell.swift
//  TestProject
//
//  Created by Alisher Orazbay on 11.11.2022.
//

import UIKit
import Kingfisher
import SnapKit

class SliderCell: UICollectionViewCell {
    public static let identifier: String = "SliderCell"
    
    private var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        return image
    }()
    
    public var url: String? {
        didSet {
            if let url = url {
                let imageURL = URL(string: url)
                imageView.kf.setImage(with: imageURL)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.bottom.trailing.leading.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
