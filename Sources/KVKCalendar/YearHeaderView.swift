//
//  YearHeaderView.swift
//  KVKCalendar
//
//  Created by Sergei Kviatkovskii on 03/01/2019.
//

#if os(iOS)

import UIKit

final class YearHeaderView: UICollectionReusableView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        return label
    }()
    
    private let dividerLine: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        return view
    }()
    
    var date: Date? {
        didSet {
            guard let date = date else { return }
            
            titleLabel.text = date.titleForLocale(style.locale, formatter: style.year.titleFormatter)
            if Date().kvkYear == date.kvkYear {
                titleLabel.textColor = .systemRed
            } else {
                titleLabel.textColor = style.year.colorTitleHeader
            }
        }
    }
    
    var style: Style = Style() {
        didSet {
            titleLabel.textColor = style.year.colorTitleHeader
            titleLabel.font = style.year.fontTitleHeader
            titleLabel.textAlignment = style.year.alignmentTitleHeader
            backgroundColor = style.year.colorBackgroundHeader
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension YearHeaderView: CalendarSettingProtocol {
    
    var currentStyle: Style {
        style
    }
    
    func setUI(reload: Bool = false) {
        // Align with month cells below (3px padding matches YearCell titleLabel x position)
        titleLabel.frame = CGRect(x: 3, y: 0, width: frame.width - 6, height: frame.height - 12)
        addSubview(titleLabel)
        
        // Add divider line right below the year title (like iOS Calendar year view)
        // Positioned just below the title text, not at the very bottom of the header
        dividerLine.frame = CGRect(x: 3, y: frame.height - 10, width: frame.width - 6, height: 1)
        addSubview(dividerLine)
    }
    
    func reloadFrame(_ frame: CGRect) {
        self.frame.size.width = frame.width
        titleLabel.frame.size.width = frame.width - 6
        dividerLine.frame = CGRect(x: 3, y: frame.height - 10, width: frame.width - 6, height: 1)
    }
    
    func updateStyle(_ style: Style, force: Bool) {
        self.style = style
    }
}

#endif
