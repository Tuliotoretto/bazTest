//
//  ShowTableViewCell.swift
//  bazTest
//
//  Created by Julian Garcia  on 16/06/23.
//

import UIKit

public class ShowTableViewCell: UITableViewCell {
    public static let reuseIdentifier = "ShowTableViewCell"
    
    private let stackView = UIStackView()
    
    private let nameLabel = UILabel()

    private let previewImageView = UIImageView()
    
    private var imageFetchingTask: URLSessionTask? {
        didSet {
            guard imageFetchingTask != oldValue else { return }
            
            oldValue?.cancel()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        self.accessoryType = .disclosureIndicator
        
        stackView.alignment = .center
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        previewImageView.contentMode = .scaleAspectFit
        previewImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(previewImageView)
        
        nameLabel.font = .preferredFont(forTextStyle: .headline)
        nameLabel.adjustsFontForContentSizeCategory = true
        nameLabel.numberOfLines = 0
        stackView.addArrangedSubview(nameLabel)
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            
            previewImageView.widthAnchor.constraint(equalToConstant: 80),
            previewImageView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateWith(show: Show) {
        nameLabel.text = show.name
        
        // TODO: Fetch Image Here
        guard let url = URL(string: show.image.medium) else { return }
        
        imageFetchingTask = NetworkManager.shared.loadImage(forURL: url, callback: { [weak self] image in
            self?.previewImageView.image = image
        })
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        previewImageView.image = nil
        imageFetchingTask = nil
    }
}
