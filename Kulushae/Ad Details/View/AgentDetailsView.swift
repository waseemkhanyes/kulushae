//
//  AgentDetailsView.swift
//  Kulushae
//
//  Created by ios on 30/11/2023.
//

import SwiftUI

struct AgentDetailsView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @Binding var agentData: UserIDModel?
    @Binding var isAgentListSelected: Bool
    
    var body: some View {
        HStack {
            VStack {
                Spacer()
                HStack{
                    Image("icn_star")
                        .resizable()
                        .frame(width: 10, height: 10)
                    Text(LocalizedStringKey("Super Agent"))
                        .font(.roboto_14())
                        .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                        .foregroundColor(.black)
                }
                .padding(.bottom, 1)
                AsyncImage(url: URL(string: (Config.imageBaseUrl) + (agentData?.image ?? ""))) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 95, height: 95)
                        .clipped()
                } placeholder: {
                    Image("imgUserPlaceHolder")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 95, height: 95)
                        .clipped()
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 95)
                        .inset(by: -0.5)
                        .stroke(.black, lineWidth: 1))
                
                Spacer()
            }
            .padding(.horizontal, 15)
            VStack {
                Spacer()
                Text((agentData?.firstName ?? "") + (agentData?.lastName ?? "") )
                    .font(.roboto_18_bold())
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.black)
                HStack(spacing: 1) {
                    Text(LocalizedStringKey("Member Since"))
                        .font(.roboto_14())
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                        .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                    Text(" \(agentData?.member_since ?? "")")
                        .font(.roboto_14())
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.gray)
                    Spacer()
                }
                
                Button(action: {
                    isAgentListSelected = true
                }) {
                    HStack(spacing: 1){
                        Text(String(agentData?.total_listings ?? 1))
                            .font(.Roboto.Regular(of: 14))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.leading)
                        Text(LocalizedStringKey("Listed"))
                            .font(.Roboto.Regular(of: 14))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.leading)
                            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                        Text("→")
                            .font(.Roboto.Regular(of: 14))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.leading)
                            .environment(\.locale, .init(identifier: languageManager.currentLanguage))
                    }
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .inset(by: 0.5)
                        .stroke(.black, lineWidth: 1)
                )
                
                
                Spacer()
            }
            Spacer()
        }
        .frame(height: 171)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .inset(by: 0.5)
                .stroke(.black.opacity(0.5), lineWidth: 1)
            
        )
    }
}

//#Preview {
//    AgentDetailsView(agentData: .constant(<#T##value: UserIDModel##UserIDModel#>))
//}
