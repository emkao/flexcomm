//
//  HelpView.swift
//  CustomComm
//
//  Created by emily kao on 4/18/21.
//

import SwiftUI

struct HelpView: View {
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Text("Help")
                    .font(.custom("SFProText-Thin", size: 50))
                    .padding(30)
                Text("put instructions here")
                Spacer()
            }
            .edgesIgnoringSafeArea(.top)
            Spacer()
        }
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
