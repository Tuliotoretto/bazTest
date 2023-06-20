//
//  DetailViewController.swift
//  bazTest
//
//  Created by Julian Garcia  on 17/06/23.
//

import UIKit

class DetailViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView(arrangedSubviews: [])
    private let showImageView = UIImageView()
    private let summaryTextView = UITextView()
    
    private let moreButton = UIButton()
    
    public var show: Show?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(FavBarButtonPressed))
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16
        scrollView.addSubview(stackView)
                              
        showImageView.contentMode = .scaleAspectFit
        showImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(showImageView)
        
        summaryTextView.translatesAutoresizingMaskIntoConstraints = false
        summaryTextView.allowsEditingTextAttributes = false
        summaryTextView.isUserInteractionEnabled = false
        summaryTextView.font = .preferredFont(forTextStyle: .body)
        summaryTextView.adjustsFontForContentSizeCategory = true
        summaryTextView.isScrollEnabled = false
        stackView.addArrangedSubview(summaryTextView)
        
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        moreButton.setTitle("More info", for: .normal)
        moreButton.tintColor = .white
        moreButton.backgroundColor = .systemBlue
        moreButton.addTarget(self, action: #selector(showMoreButtonPressed), for: .touchUpInside)
        stackView.addArrangedSubview(moreButton)
        
        let space = UIView()
        stackView.addArrangedSubview(space)
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.contentLayoutGuide.heightAnchor),
            
            showImageView.widthAnchor.constraint(equalToConstant: 300),
            showImageView.heightAnchor.constraint(equalToConstant: 300),
            
            summaryTextView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16),
            summaryTextView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -16),
            
            moreButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.3),
            moreButton.heightAnchor.constraint(equalToConstant: 30),
            
            space.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            space.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = show?.name
        
        updateBarButtonTitle()
        
        summaryTextView.text = show?.summary
        
        if let imageURL = URL(string: show?.image.original ?? "") {
            NetworkManager.shared.loadImage(forURL: imageURL) { [weak self] image in
                self?.showImageView.image = image
            }
        }
        
        if let _ = show?.externals.imdb {
            moreButton.isHidden = false
        } else {
            moreButton.isHidden = true
        }
    }
    
    
    // MARK: - Methods
    @objc
    func showMoreButtonPressed() {
        guard let urlstr = show?.externals.imdb else { return }
        guard let url = URL(string: "https://www.imdb.com/title/" + urlstr) else { return }
        
        UIApplication.shared.open(url)
    }
    
    @objc
    func FavBarButtonPressed() {
        guard let show = show else { return }
        
        if DatabaseManager.shared.isFav(id: show.id) {
            DatabaseManager.shared.deleteFav(id: show.id)
        } else {
            DatabaseManager.shared.addFav(show: show)
        }
        
        updateBarButtonTitle()
    }
    
    func updateBarButtonTitle() {
        guard let show = show else { return }
        
        self.navigationItem.rightBarButtonItem?.title = DatabaseManager.shared.isFav(id: show.id) ? "Delete" : "Favorite"
    }
}
