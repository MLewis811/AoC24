//
//  ContentView.swift
//  AoC24
//
//  Created by Mike Lewis on 11/25/24.
//

import SwiftUI

struct ContentView: View {
    @State private var dayNum = 1
    @State private var inputFileNum = 0
    @State private var fileName = "sampleInput.txt"
    @State private var outputVal = ""
    @State private var partNum = 1
    
    private let inputFiles = ["Sample Data", "Full Data"]
    private let inputFileNames = ["sampleInput.txt", "input.txt"]

    var body: some View {
        VStack {
            Spacer()
            
            VStack {
                HStack {
                    Text("Day")
                        .bold()
                    Picker("Day #", selection: $dayNum) {
                        ForEach(1...25, id: \.self) {day in
                            Text(day, format: .number)
                        }
                    }
                    .pickerStyle(.menu)
                }
                .padding(.horizontal)
                
                
                Picker("Part", selection: $partNum) {
                    ForEach(1 ... 2, id: \.self) { part in
                        Text("\(part)")
                    }
                }
                .padding(.horizontal)
                .pickerStyle(.segmented)
            }
            
            Spacer()
            
            Picker("Input", selection: $inputFileNum) {
                ForEach(0 ..< inputFiles.count, id: \.self) {
                    Text(inputFiles[$0])
                }
            }
            .padding(.horizontal)
            .pickerStyle(.segmented)
            
            Spacer()
            
            VStack(spacing: 20) {
                Button("Run") {
                    outputVal = doDay(day: dayNum, file: inputFileNames[inputFileNum], part: partNum)
                }
                .font(.title2.bold())
                
                Text(outputVal)
                    .font(.title)
            }
            
            Spacer()
                        
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
