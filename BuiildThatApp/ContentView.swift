//
//  ContentView.swift
//  BuiildThatApp
//
//  Created by Frimpong Anorchie II on 26/02/2021.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable{
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
    
}

class Expenses: ObservableObject {
    @Published var items = [ExpenseItem](){
    
        didSet {
            let encoder = JSONEncoder()
            
            if let encoded = try? encoder.encode(items){
                UserDefaults.standard.setValue(encoded, forKey: "Items")
            }
            
        }
    }
    
    init() {
        if let items = UserDefaults.standard.data(forKey: "Items"){
            let decoder = JSONDecoder()
            
            if let decoded = try? decoder.decode([ExpenseItem].self, from: items){
                self.items = decoded
                return
            }
        }
        self.items = []
    }
}


struct ContentView: View {
    @ObservedObject var expenses = Expenses()
    @State private var showingAddExpenses = false
    
    var body: some View{
        NavigationView{
            List{
                ForEach(expenses.items){ item in
                    HStack{
                        VStack(alignment: .leading, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        })
                        
                        Spacer()
                        Text("$\(item.amount, specifier: "%.2f")")
                    }
                }
                .onDelete(perform: onRemove)
            }
            .navigationTitle("iExpenses")
            .navigationBarItems(trailing: Button(action: {
                self.showingAddExpenses = true
            }, label: {
                Image(systemName: "plus")
            }))
        }
        .sheet(isPresented: $showingAddExpenses, content: {
            AddView(expenses: self.expenses)
        })
       
    }
    
    func onRemove(at offsets: IndexSet){
        expenses.items.remove(atOffsets: offsets)
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

