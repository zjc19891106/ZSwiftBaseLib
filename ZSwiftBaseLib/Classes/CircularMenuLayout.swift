//
//  CircularMeunLayout.swift
//  CircularMeunLayout
//
//  Created by 朱继超 on 2022/7/5.
//

import UIKit

/// Description CircularMenuLayout is a circular menu layout
public final class CircularMenuLayout: UICollectionViewFlowLayout {
    
    var attributes: [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    
    public weak var delegate: CircularMenuLayoutDelegate?
    
    public override func prepare() {
        super.prepare()
        if let sections = self.collectionView?.numberOfSections {
            for section in 0...sections {
                if let rows = self.collectionView?.numberOfItems(inSection: section) {
                    for row in 0...rows {
                        let index = IndexPath(row: row, section: section)
                        self.attributes.append((self.collectionView?.layoutAttributesForItem(at: index))!)
                    }
                }
            }
        }
    }
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        //total count of indexPath.section
        guard let collectionView = self.collectionView else {
            return UICollectionViewLayoutAttributes(forCellWith: indexPath)
        }
        let count = collectionView.numberOfItems(inSection: indexPath.section)
        //degree of item
        var angle = 2 * CGFloat(Double.pi) / CGFloat(count) * CGFloat(indexPath.row)

        //radius of item
        var radius: CGFloat = 140
        let attrs = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        if let delegate = self.delegate {
            if delegate.degree > 0 {
                angle = delegate.degree * CGFloat(indexPath.row)
            }
            if delegate.radius > 0 {
                radius = delegate.radius
            }
            if delegate.layoutSize != .zero {
                attrs.size = delegate.layoutSize
            } else {
                attrs.size = CGSize(width: 40, height: 40)
            }
        }
        //center
        let centerX = collectionView.frame.width / 2
        let centerY = collectionView.frame.height / 2
        attrs.center = CGPoint(x: centerX + radius * sin(angle), y: centerY + radius * cos(angle))
        return attrs
    }
    
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.attributes
    }

}


/// CircularMenuLayoutDelegate using to setting some parameters
public protocol CircularMenuLayoutDelegate: NSObjectProtocol {
    
    var degree: CGFloat { get }
    
    var radius: CGFloat { get }
    
    var layoutSize: CGSize { get }
    
}
