//
//  AddView.swift
//  BuiildThatApp
//
//  Created by Frimpong Anorchie II on 14/03/2021.
//

import SwiftUI

struct AddView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var expenses: Expenses
    @State private var name =  ""
    @State private var type = "Personal"
    @State private var amount = ""
    static let types = ["Personal", "Business"]
    
    
    var body: some View {
        NavigationView{
            Form{
                TextField("Name", text: $name)
                
                Picker("Type", selection: $type){
                    ForEach(Self.types, id:\.self){
                        Text($0)
                    }
                }
                
                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)
                
            }
            .navigationTitle("Add New Expense ")
            .navigationBarItems(trailing: Button("Save"){
                if let actualamoount = Double(self.amount){
                    let item = ExpenseItem(name: self.name, type: self.type, amount: actualamoount)
                    self.expenses.items.append(item)
                    self.presentationMode.wrappedValue.dismiss()
                }
                
            })
        }
        
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
