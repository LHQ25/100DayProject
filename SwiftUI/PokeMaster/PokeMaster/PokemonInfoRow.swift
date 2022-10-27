//
//  PokemonInfoRow.swift
//  PokeMaster
//
//  Created by 9527 on 2022/9/30.
//

import SwiftUI

struct PokemonInfoRow: View {
    
    var body: some View {
        
        VStack {
            HStack {
                Image(systemName: "sun")
                VStack {
                    Text("1")
                    Text("2")
                }
            }
            HStack {
                Spacer()
                Button {
                    
                } label: {
                    Text("1")
                }
                Button {
                    
                } label: {
                    Text("1")
                }
                Button {
                    
                } label: {
                    Text("1")
                }

            }
        }
        .border(.green, width: 1)
    }
}

struct PokemonInfoRowPrev: PreviewProvider {
    
    static var previews: some View {
        PokemonInfoRow()
    }
    
    static var platform: PreviewPlatform? {
        .iOS
    }
}

