//
//  BudgetCategroyCell.swift
//  Budget App
//
//  Created by Mohd Kashif on 25/06/24.
//

import Foundation
import UIKit
import SwiftUI

class BudgetCategroyCell:UITableViewCell{
    lazy var nameLabel:UILabel={
        let label=UILabel()
        return label
    }()
    
    lazy var amountLabel:UILabel={
        let label=UILabel()
        return label
    }()
    
    lazy var remainingLable:UILabel={
        let label=UILabel()
        label.font=UIFont.systemFont(ofSize: 14)
        label.alpha=0.5
        return label
    }()
    
    override init(style:UITableViewCell.CellStyle, reuseIdentifier:String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        let stack=UIStackView()
        stack.layoutMargins=UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 44)
        stack.spacing=UIStackView.spacingUseSystem
        stack.isLayoutMarginsRelativeArrangement=true
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints=false
        stack.isLayoutMarginsRelativeArrangement=true
        
        stack.addArrangedSubview(nameLabel)
        
        let vStack=UIStackView()
        vStack.axis = .vertical
        vStack.alignment = .trailing
        vStack.addArrangedSubview(amountLabel)
        vStack.addArrangedSubview(remainingLable)
        
        stack.addArrangedSubview(vStack)
        self.addSubview(stack)
        
        stack.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive=true
        stack.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive=true
        stack.widthAnchor.constraint(equalTo: self.widthAnchor).isActive=true
        
    }
    
    func configure(_ budget:BudgetCategory){
        nameLabel.text=budget.name
        amountLabel.text=budget.amount.formatCurrency()
        remainingLable.text="Remaing:- \(budget.remainingAmount)"
    }
}

struct BugetView:UIViewRepresentable{
    
    func makeUIView(context: Context) -> some UIView {
        BudgetCategroyCell(style: .default, reuseIdentifier: "Budget")
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

//struct BugetView_Previews:PreviewProvider{
//    static var previews:some View{
//        BugetView()
//    }
//}
