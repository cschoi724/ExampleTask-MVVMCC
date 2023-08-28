//
//  UserCell.swift
//  LightningTask
//
//  Created by cschoi on 2023/07/14.
//

import UIKit
import RxCocoa
import RxSwift
import Kingfisher

class UserCell: UICollectionViewCell {
    @IBOutlet weak var thumbnail_imageView: UIImageView!
    @IBOutlet weak var name_label: UILabel!
    @IBOutlet weak var location_label: UILabel!
    @IBOutlet weak var email_label: UILabel!
    @IBOutlet weak var content_stackView: UIStackView!
    @IBOutlet weak var body_view: UIView!
    var bag = DisposeBag()
    var model: UserProfile? {
        didSet {
            if let model = model {
                configure(model)
            }
        }
    }
    var split: Bool = false
    var selection: Bool = false
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }

    func configure(_ model: UserProfile) {
        thumbnail_imageView.kf.setImage(with: URL(string: model.picture))
        name_label.text = model.name
        location_label.text = model.loaction
        email_label.text = model.email
        content_stackView.axis = split ? .vertical : .horizontal
        body_view.alpha = selection ? 0.8 : 1
        body_view.layer.borderWidth = selection ? 2 : 0
        body_view.layer.borderColor = UIColor.white.cgColor
        body_view.layer.masksToBounds = true
    }
}
