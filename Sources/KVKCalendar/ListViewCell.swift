//
//  ListViewCell.swift
//  KVKCalendar
//
//  Created by Sergei Kviatkovskii on 27.12.2020.
//

#if os(iOS)

import UIKit

final class ListViewCell: KVKTableViewCell {
    
    private let txtLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.numberOfLines = 0
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemBlue
        return imageView
    }()
    
    private let dotView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        return view
    }()
    
    var txt: String? {
        didSet {
            txtLabel.text = txt
        }
    }
    
    var timeText: String? {
        didSet {
            timeLabel.text = timeText
        }
    }
    
    var sfSymbol: String? {
        didSet {
            if let symbolName = sfSymbol {
                iconImageView.image = UIImage(systemName: symbolName)
                iconImageView.isHidden = false
                dotView.isHidden = true
            } else {
                iconImageView.isHidden = true
                dotView.isHidden = false
            }
        }
    }
    
    var dotColor: UIColor? {
        didSet {
            dotView.backgroundColor = dotColor
            iconImageView.tintColor = dotColor
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(txtLabel)
        contentView.addSubview(dotView)
        contentView.addSubview(iconImageView)
        contentView.addSubview(timeLabel)
        
        dotView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        txtLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
    
        let leftDot = dotView.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor)
        let centerYDot = dotView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        let widthDot = dotView.widthAnchor.constraint(equalToConstant: 20)
        let heightDot = dotView.heightAnchor.constraint(equalToConstant: 20)
        NSLayoutConstraint.activate([leftDot, centerYDot, widthDot, heightDot])
        
        // Icon constraints (same position as dot)
        let leftIcon = iconImageView.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor)
        let centerYIcon = iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        let widthIcon = iconImageView.widthAnchor.constraint(equalToConstant: 20)
        let heightIcon = iconImageView.heightAnchor.constraint(equalToConstant: 20)
        NSLayoutConstraint.activate([leftIcon, centerYIcon, widthIcon, heightIcon])
        
        // Time label on the right
        let rightTime = timeLabel.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor)
        let centerYTime = timeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        NSLayoutConstraint.activate([rightTime, centerYTime])
        
        // Text label constraints (between dot/icon and time)
        let topTxt = txtLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15)
        let bottomTxt = txtLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15)
        let leftTxt = txtLabel.leftAnchor.constraint(equalTo: dotView.rightAnchor, constant: 10)
        let rightTxt = txtLabel.rightAnchor.constraint(equalTo: timeLabel.leftAnchor, constant: -10)
        NSLayoutConstraint.activate([topTxt, bottomTxt, leftTxt, rightTxt])
        
        // Initially hide icon, show dot
        iconImageView.isHidden = true
        
        if #available(iOS 13.4, *) {
            addPointInteraction()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSkeletons(_ skeletons: Bool,
                               insets: UIEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4),
                               cornerRadius: CGFloat = 2) {
        isUserInteractionEnabled = !skeletons
        txtLabel.isHidden = skeletons
        timeLabel.isHidden = skeletons
        dotView.isHidden = skeletons
        iconImageView.isHidden = skeletons

        let stubLabelView = UIView(frame: CGRect(x: 30, y: 0, width: bounds.width - 100, height: bounds.height))
        let stubDotView = UIView(frame: CGRect(x: 10, y: (bounds.height / 2) - 18, width: 30, height: 30))
        let stubTimeView = UIView(frame: CGRect(x: bounds.width - 70, y: (bounds.height / 2) - 10, width: 60, height: 20))
        if skeletons {
            contentView.addSubview(stubDotView)
            contentView.addSubview(stubLabelView)
            contentView.addSubview(stubTimeView)
            [stubDotView, stubLabelView, stubTimeView].forEach { $0.setAsSkeleton(skeletons, cornerRadius: cornerRadius, insets: insets) }
        } else {
            stubDotView.removeFromSuperview()
            stubLabelView.removeFromSuperview()
            stubTimeView.removeFromSuperview()
        }
    }
    
}

@available(iOS 13.4, *)
extension ListViewCell: UIPointerInteractionDelegate {
    func addPointInteraction() {
        let interaction = UIPointerInteraction(delegate: self)
        addInteraction(interaction)
    }
    
    public func pointerInteraction(_ interaction: UIPointerInteraction, styleFor region: UIPointerRegion) -> UIPointerStyle? {
        var pointerStyle: UIPointerStyle?
        
        if let interactionView = interaction.view {
            let targetedPreview = UITargetedPreview(view: interactionView)
            pointerStyle = UIPointerStyle(effect: .highlight(targetedPreview))
        }
        return pointerStyle
    }
}

#endif
