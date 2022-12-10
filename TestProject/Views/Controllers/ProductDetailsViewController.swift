//
//  ProductDetailsViewController.swift
//  TestProject
//
//  Created by Alisher Orazbay on 11.11.2022.
//

import UIKit
import SnapKit
import Kingfisher
import Cosmos

class ProductDetailsViewController: UIViewController {
    
    // MARK: - View Items
    private var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        return collectionView
    }()
    private var sliderPageControl = UIPageControl()
    private var ratingView: CosmosView = {
        let view = CosmosView()
        view.settings.updateOnTouch = false
        view.settings.fillMode = .precise
        return view
    }()
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 1
        label.font = .boldSystemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var stockLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var brandLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.numberOfLines = 1
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 36)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var discountView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    private var discountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    public var details: ProductData.Product? {
        didSet {
            if let details = details {
                ratingView.rating = details.rating
                titleLabel.text = details.title
                brandLabel.text = "Brand: \(details.brand)"
                stockLabel.text = "Available in stock: \(details.stock)"
                descriptionLabel.text = details.description
                priceLabel.text = "$\(details.price)"
                discountLabel.text = "-\(details.discountPercentage)%"
            }
        }
    }
    
    var timer: Timer?
    var currentIndex = 0
    
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupPageControl()
        setupViews()
        startTimer()
    }
    
    func setupCollectionView() {        
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.register(SliderCell.self, forCellWithReuseIdentifier: SliderCell.identifier)
        imageCollectionView.showsHorizontalScrollIndicator = false
        imageCollectionView.isPagingEnabled = true
    }
    
    func setupPageControl() {
        sliderPageControl.numberOfPages = details?.images.count ?? 0
        sliderPageControl.currentPage = 0
    }
    
    func setupViews() {
        view.backgroundColor = .white
        navigationItem.title = details?.title
        
        view.addSubview(container)
        container.addSubview(imageCollectionView)
        container.addSubview(ratingView)
        container.addSubview(titleLabel)
        container.addSubview(brandLabel)
        container.addSubview(stockLabel)
        container.addSubview(descriptionLabel)
        container.addSubview(priceLabel)
        container.addSubview(discountView)
        discountView.addSubview(discountLabel)
        container.addSubview(sliderPageControl)
        
        
        container.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.trailing.leading.equalToSuperview()
        }
        
        imageCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(300)
        }
        
        ratingView.snp.makeConstraints { make in
            make.top.equalTo(imageCollectionView.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(ratingView.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        stockLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        brandLabel.snp.makeConstraints { make in
            make.top.equalTo(stockLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(brandLabel.snp.bottom)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(32)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
//            make.bottom.equalToSuperview().offset(-16)
        }
        
        discountView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16).priority(.high)
            make.bottom.equalTo(imageCollectionView.snp.bottom).offset(-16)
        }
        
        discountLabel.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview().inset(5)
        }
        
        sliderPageControl.snp.makeConstraints { make in
            make.bottom.equalTo(imageCollectionView.snp.bottom).offset(-16)
            make.centerX.equalTo(container)
        }
    }
}



// MARK: - Slide Timer
extension ProductDetailsViewController {
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(slide), userInfo: nil, repeats: true)
    }
    
    @objc func slide() {
        let scrollPosition = (currentIndex < (details?.images.count ?? 0) - 1) ? currentIndex + 1 : 0
        imageCollectionView.scrollToItem(at: IndexPath(item: scrollPosition, section: 0), at: .centeredHorizontally, animated: true)
    }
}



// MARK: - UICollectionViewDataSource
extension ProductDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return details?.images.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SliderCell.identifier, for: indexPath) as! SliderCell
        cell.url = details?.images[indexPath.row]
        return cell
    }
}



// MARK: - UICollectionViewDelegate
extension ProductDetailsViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentIndex = Int(scrollView.contentOffset.x / view.frame.width)
        sliderPageControl.currentPage = currentIndex
    }
}



// MARK: - UICollectionViewDelegateFlowLayout
extension ProductDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
