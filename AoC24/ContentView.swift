//
//  ContentView.swift
//  AoC24
//
//  Created by Mike Lewis on 11/25/24.
//

import SwiftUI

// Needed for Day 14, part 2
func makeBoolArray() -> [Bool] {
    
    let gridWid = 101
    let gridHgt = 103
    
    var retArray = Array(repeating: false, count:gridWid*gridHgt)
    
    retArray[4] = true
    retArray[480] = true
    
    return retArray
}

struct ContentView: View {
    @State private var dayNum = 18
    @State private var inputFileNum = 0
    @State private var fileName = "sampleInput.txt"
    @State private var outputVal = ""
    @State private var partNum = 1
    
    @State var t = 8200 // Needed for Day 14, part 2 (repeats after 101*103 secs, FYI)
    @State var isTimerRunning = false // Needed for Day 14, part 2
    
    
    private let inputFiles = ["Sample Data", "Full Data"]
    private let inputFileNames = ["sampleInput.txt", "input.txt"]
    
    var body: some View {
        if dayNum == 14 && partNum == 2 {
            
            let gridWid = 101
//            let gridHgt = 103
            
            let pixelSize = 6.0
            
            let columns = Array(repeating: GridItem(.fixed(pixelSize), spacing: 0), count: gridWid)
            let entries = Day14Part2(file: "day14input.txt", part: partNum, t: t)
            
            let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
            
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(0..<entries.count, id: \.self) { entryNum in
                    Rectangle()
                        .fill( entries[entryNum] ? Color.black : Color.white )
                        .frame(width: pixelSize, height: pixelSize)
                }
            }
            Spacer()
            HStack {
                Spacer()
                
                Button("Back") {
                    t -= 1
                }
                .padding()
                .background(Color.gray)
                .bold()
                .foregroundStyle(.white)
                .clipShape(Capsule())
                .disabled(isTimerRunning)
                
                Button("\(t)") {
                    t += 1
                }
                .padding()
                .background(Color.gray)
                .bold()
                .font(.largeTitle)
                .foregroundStyle(.white)
                .clipShape(Capsule())
                .disabled(isTimerRunning)
                
                Button(isTimerRunning ? "Pause" : "Run") {
                    isTimerRunning.toggle()
                }
                .padding()
                .background(Color.gray)
                .bold()
                .foregroundStyle(.white)
                .clipShape(Capsule())
                
                Spacer()
            }
            .onReceive(timer) { _ in
                if isTimerRunning {
                    t += 1
                }
            }
            Spacer()
        } else {
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
