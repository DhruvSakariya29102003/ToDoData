//
//  ViewController.swift
//  Oop
//
//  Created by Droadmin on 7/6/23.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        demoOOPConcepts()
        // Do any additional setup after loading the view.
    }


}
func demoOOPConcepts() {
        // Class definition
        class Car {
            var brand: String
            var model: String
            var year: Int

            // Initializer
            init(brand: String, model: String, year: Int) {
                self.brand = brand
                self.model = model
                self.year = year
            }

            // Method
            func startEngine() {
                print("Starting the engine of \(brand) \(model)")
            }
        }

        // Inheritance
        class ElectricCar: Car {
            var batteryCapacity: Double

            init(brand: String, model: String, year: Int, batteryCapacity: Double) {
                self.batteryCapacity = batteryCapacity
                super.init(brand: brand, model: model, year: year)
            }

            // Method override
            override func startEngine() {
                print("\(brand) \(model) is starting silently...")
            }

            // Additional method
            func chargeBattery() {
                print("Charging the battery of \(brand) \(model)")
            }
        }

        // Creating objects
        let myCar = Car(brand: "Toyota", model: "Camry", year: 2022)
        let electricCar = ElectricCar(brand: "Tesla", model: "Model S", year: 2023, batteryCapacity: 85.0)

        // Accessing properties
        print(myCar.brand)             // Output: Toyota
        print(electricCar.year)        // Output: 2023

        // Calling methods
        myCar.startEngine()            // Output: Starting the engine of Toyota Camry
        electricCar.startEngine()      // Output: Tesla Model S is starting silently...
        electricCar.chargeBattery()    // Output: Charging the battery of Tesla Model S
    }



