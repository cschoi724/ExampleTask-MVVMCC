//
//  DetailViewController.swift
//  LightningTask
//
//  Created by cschoi on 2023/07/10.
//

import UIKit
import RxCocoa
import RxSwift
import Kingfisher

class DetailViewController: UIViewController, BaseController {
    @IBOutlet weak var close_btn: UIButton!
    @IBOutlet weak var content_scrollView: UIScrollView!
    @IBOutlet weak var contnet_imageView: UIImageView!
    let bag = DisposeBag()
    var viewModel: DetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bindTo()
    }
    
    func configure() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .dark
        }
        setNeedsStatusBarAppearanceUpdate()
        content_scrollView.maximumZoomScale = 2
        content_scrollView.minimumZoomScale = 1
        content_scrollView.delegate = self
    }
}

extension DetailViewController {
    func bindTo() {
        let swipe = UISwipeGestureRecognizer()
        swipe.direction = .right
        view.addGestureRecognizer(swipe)
        
        let inputs = DetailViewModel
            .Inputs(
                viewWillApear: rx.viewWillAppear.map{_ in},
                closeTap: close_btn.rx.tap.map{_ in},
                closeSwipe: swipe.rx.event.map{_ in}
            )
        
        let output = viewModel.transform(bag, inputs: inputs)
        output.userProfile
            .compactMap{ $0 }
            .withUnretained(self)
            .bind{ this, userProfile in
                this.contnet_imageView.kf.setImage(
                    with: URL(string: userProfile.picture)
                )
            }
            .disposed(by: bag)
    }
}

extension DetailViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contnet_imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale > 1 {
            if let image = contnet_imageView.image {
                let ratioW = contnet_imageView.frame.width / image.size.width
                let ratioH = contnet_imageView.frame.height / image.size.height
                
                let ratio = ratioW < ratioH ? ratioW : ratioH
                let newWidth = image.size.width * ratio
                let newHeight = image.size.height * ratio
                let conditionLeft = newWidth*scrollView.zoomScale > contnet_imageView.frame.width
                let left = 0.5 * (conditionLeft ? newWidth - contnet_imageView.frame.width : (scrollView.frame.width - scrollView.contentSize.width))
                let conditioTop = newHeight*scrollView.zoomScale > contnet_imageView.frame.height
                let top = 0.5 * (conditioTop ? newHeight - contnet_imageView.frame.height : (scrollView.frame.height - scrollView.contentSize.height))
                
                scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
            }
        } else {
            scrollView.contentInset = .zero
        }
    }
}
