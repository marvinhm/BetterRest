//
//  ContentView.swift
//  BetterRest
//
//  Created by Marvin Matovu on 12/07/2020.
//  Copyright © 2020 Marvin Matovu. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var wakeUp = defaultWakeUpTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingMessage = false
    
    var maxNumberOfCoffee: Array = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    @State private var numberOfCoffee = 0
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Text("When so you want to wake up?")
                        .font(.headline)
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
               Section {
                    Text("How much sleep do you want?")
                        .font(.headline)
                    
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                }
                
                Section {
                    Text("Daily coffee intake")
                    .font(.headline)
                    
//                    Stepper(value: $coffeeAmount, in: 1...20) {
//                        if coffeeAmount == 1 {
//                            Text("1 cup")
//                        } else {
//                            Text("\(coffeeAmount) cups")
//                        }
//                    }
                    
                     Section(header: Text("How much coffee do you want to take?")) {
                       Picker("Tip Percentage", selection: $coffeeAmount) {
                           ForEach(0 ..< maxNumberOfCoffee.count) {
                            
                            if self.coffeeAmount == 1 {
                                Text("\(self.maxNumberOfCoffee[$0]) cup")
                            } else {
                                Text("\(self.maxNumberOfCoffee[$0]) cups")
                            }
                        }
                            
                       }
                       .pickerStyle(SegmentedPickerStyle())
                   }
                }
            }
            .navigationBarTitle("BetterRest")
            .navigationBarItems(trailing:
                Button(action: calculateBedtime) {
                    Text("Calculate")
                }
            )
            .alert(isPresented: $showingMessage) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    static var defaultWakeUpTime: Date {
    var components = DateComponents()
    components.hour = 7
    components.minute = 0
    return Calendar.current.date(from: components) ?? Date()
    }
    
    func calculateBedtime() {
        let model = SleepCalculator()
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        print("\(components) components")
        print("\(hour) hour & \(minute) minute")
        
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            alertMessage = formatter.string(from: sleepTime)
            alertTitle = "Your ideal bedtime is..."
            
            
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime."
        }
        
        showingMessage = true
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
