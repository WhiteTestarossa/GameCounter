//
//  HistoryCell.swift
//  GameCounter
//
//  Created by Daniel Belokursky on 12.10.22.
//

import UIKit

class HistoryCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
          super.init(style: .value1, reuseIdentifier: reuseIdentifier)
      }

      required init?(coder aDecoder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
}
