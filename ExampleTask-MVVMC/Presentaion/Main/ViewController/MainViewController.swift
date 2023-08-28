//
//  MainViewController.swift
//  LightningTask
//
//  Created by cschoi on 2023/07/10.
//

import UIKit
import RxCocoa
import RxSwift

class MainViewController: UIViewController, BaseController {
    @IBOutlet weak var maleTab_btn: UIButton!
    @IBOutlet weak var male_collectionView: UICollectionView!
    @IBOutlet weak var male_indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var femaleTab_btn: UIButton!
    @IBOutlet weak var female_collectionView: UICollectionView!
    @IBOutlet weak var female_indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var lineChange_btn: UIButton!
    @IBOutlet weak var delete_btn: UIButton!
    @IBOutlet weak var tab_scrollView: UIScrollView!
    @IBOutlet weak var underLine_leading_constraint: NSLayoutConstraint!
    let bag = DisposeBag()
    var viewModel: MainViewModel!
    let updateRequest = PublishRelay<UserGender>()
    let pullToRefresh = PublishRelay<UserGender>()
    let userTap = PublishRelay<UserProfile>()
    let deleteItems = PublishRelay<([String], [String])>()
    var selectedMales: [String] = [] {
        didSet { updateDelete() }
    }
    var selectedFemales: [String] = [] {
        didSet { updateDelete() }
    }
    var tapIndex: Int = 0 {
        didSet { updateTab() }
    }
    var splitCount: UInt = 1 {
        didSet { updateLineSplit() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bindTo()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        male_collectionView.reloadData()
        female_collectionView.reloadData()
    }
    
    func configure() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .dark
        }
        setNeedsStatusBarAppearanceUpdate()
        lineChange_btn.layer.cornerRadius = 12
        tab_scrollView.delegate = self
        male_collectionView.register(
            UINib(nibName: UserCell.name, bundle: nil),
            forCellWithReuseIdentifier: UserCell.name
        )
        female_collectionView.register(
            UINib(nibName: UserCell.name, bundle: nil),
            forCellWithReuseIdentifier: UserCell.name
        )
        male_collectionView.delegate = self
        female_collectionView.delegate = self
        let maleLayout = UICollectionViewFlowLayout()
        maleLayout.minimumInteritemSpacing = 0
        maleLayout.minimumLineSpacing = 0
        maleLayout.scrollDirection = .vertical
        male_collectionView.collectionViewLayout = maleLayout
        male_collectionView.contentInset = .zero
        male_collectionView.scrollIndicatorInsets = .zero
        
        let femaleLayout = UICollectionViewFlowLayout()
        femaleLayout.minimumInteritemSpacing = 0
        femaleLayout.minimumLineSpacing = 0
        femaleLayout.scrollDirection = .vertical
        female_collectionView.collectionViewLayout = femaleLayout
        female_collectionView.contentInset = .zero
        female_collectionView.scrollIndicatorInsets = .zero
    }
    
    func updateTab() {
        maleTab_btn.isSelected = tapIndex == 0
        femaleTab_btn.isSelected = tapIndex == 1
        let offsetX = tab_scrollView.frame.width * CGFloat(tapIndex)
        tab_scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
    
    func updateLineSplit() {
        lineChange_btn.isSelected = splitCount > 1
        male_collectionView.reloadData()
        female_collectionView.reloadData()
    }
    
    func updateDelete() {
        delete_btn.isEnabled = (selectedMales.isEmpty && selectedFemales.isEmpty) == false
    }
}

extension MainViewController {
    func bindTo() {
        let input = MainViewModel
            .Input(
                viewDidApear: rx.viewDidAppear.map{ _ in },
                updateRequest: updateRequest.asObservable(),
                pullToRefresh: pullToRefresh.asObservable(),
                userTap: userTap.asObservable(),
                deleteItem: deleteItems.asObservable()
            )
        
        let output = viewModel.transform(bag, input: input)
        output.maleList
            .bind(to: male_collectionView.rx.items) { [weak self] collectionView, index, item in
                guard let self = self else { fatalError() }
                let indexPath = IndexPath(item: index, section: 0)
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: UserCell.name,
                    for: indexPath
                ) as! UserCell
                cell.split = self.splitCount > 1
                cell.selection = self.selectedMales.contains(item.id)
                cell.model = item
                let thumbnailTap = UITapGestureRecognizer()
                cell.thumbnail_imageView.addGestureRecognizer(thumbnailTap)
                thumbnailTap.rx.event
                    .map{ _ in item }
                    .withUnretained(self)
                    .bind { this, item in
                        this.userTap.accept(item)
                    }
                    .disposed(by: cell.bag)
                
                let tap = UITapGestureRecognizer()
                cell.addGestureRecognizer(tap)
                tap.rx.event
                    .map{ _ in item.id }
                    .withUnretained(self)
                    .bind { this, id in
                        if this.selectedMales.contains(id) {
                            this.selectedMales = this.selectedMales.filter{ $0 != id}
                        } else {
                            this.selectedMales.append(id)
                        }
                        this.male_collectionView.reloadData()
                    }
                    .disposed(by: cell.bag)
                return cell
            }
            .disposed(by: bag)
        
        output.femaleList
            .bind(to: female_collectionView.rx.items) { [weak self] collectionView, index, item in
                guard let self = self else { fatalError() }
                let indexPath = IndexPath(item: index, section: 0)
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: UserCell.name,
                    for: indexPath
                ) as! UserCell
                cell.split = self.splitCount > 1
                cell.selection = self.selectedFemales.contains(item.id)
                cell.model = item
                let thumbnailTap = UITapGestureRecognizer()
                cell.thumbnail_imageView.addGestureRecognizer(thumbnailTap)
                thumbnailTap.rx.event
                    .map{ _ in item }
                    .withUnretained(self)
                    .bind { this, item in
                        this.userTap.accept(item)
                    }
                    .disposed(by: cell.bag)
                
                let tap = UITapGestureRecognizer()
                cell.addGestureRecognizer(tap)
                tap.rx.event
                    .map{ _ in item.id }
                    .withUnretained(self)
                    .bind { this, id in
                        if this.selectedFemales.contains(id) {
                            this.selectedFemales = this.selectedFemales.filter{ $0 != id}
                        } else {
                            this.selectedFemales.append(id)
                        }
                        this.female_collectionView.reloadData()
                    }
                    .disposed(by: cell.bag)
                return cell
            }
            .disposed(by: bag)
        
        maleTab_btn.rx.tap
            .map{ _ in 0}
            .withUnretained(self)
            .bind{ this, index in
                this.tapIndex = index
            }
            .disposed(by: bag)
        
        femaleTab_btn.rx.tap
            .map{ _ in 1}
            .withUnretained(self)
            .bind{ this, index in
                this.tapIndex = index
            }
            .disposed(by: bag)
        
        lineChange_btn.rx.tap
            .withUnretained(self)
            .bind{ this, _ in
                this.splitCount = (this.splitCount % 2) + 1
            }
            .disposed(by: bag)
        
        delete_btn.rx.tap
            .withUnretained(self)
            .bind{ this, _ in
                this.deleteItems.accept((this.selectedMales, this.selectedFemales))
                this.selectedMales.removeAll()
                this.selectedFemales.removeAll()
            }
            .disposed(by: bag)
    }
}

extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tab_scrollView {
            let ratio = self.view.frame.width / scrollView.contentSize.width
            underLine_leading_constraint.constant = scrollView.contentOffset.x * ratio
        } else if scrollView == male_collectionView {
            let max = max((scrollView.contentSize.height - scrollView.frame.height*2), 0)
            if scrollView.contentOffset.y >= max{
                updateRequest.accept(.male)
            }else if scrollView.contentOffset.y < -70 {
                if male_indicatorView.isAnimating == false {
                    male_indicatorView.startAnimating()
                    male_indicatorView.isHidden = false
                    selectedMales.removeAll()
                    female_collectionView.reloadData()
                    pullToRefresh.accept(.male)
                }
            } else if scrollView.contentOffset.y >= -30 {
                if male_indicatorView.isAnimating {
                    male_indicatorView.stopAnimating()
                    male_indicatorView.isHidden = true
                }
            }
        } else if scrollView == female_collectionView {
            let max = max((scrollView.contentSize.height - scrollView.frame.height*2), 0)
            if scrollView.contentOffset.y >= max{
                updateRequest.accept(.female)
            }else if scrollView.contentOffset.y < -70 {
                if female_indicatorView.isAnimating == false {
                    female_indicatorView.startAnimating()
                    female_indicatorView.isHidden = false
                    selectedFemales.removeAll()
                    male_collectionView.reloadData()
                    pullToRefresh.accept(.female)
                }
            } else if scrollView.contentOffset.y >= -30 {
                if female_indicatorView.isAnimating {
                    female_indicatorView.stopAnimating()
                    female_indicatorView.isHidden = true
                }
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == tab_scrollView {
            let pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
            if tapIndex != pageIndex {
                tapIndex = pageIndex
            }
        }
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if splitCount > 1 {
            let width = collectionView.frame.width/2
            let height = collectionView.frame.width > collectionView.frame.height ?
            collectionView.frame.width/2 :
            collectionView.frame.height/3
            return CGSize(
                width: width,
                height: height
            )
        } else {
            return CGSize(
                width: collectionView.frame.width,
                height: 110
            )
        }
    }
}
