//
//  BannerCard.swift
//  MyAsset
//
//  Created by UAPMobile on 2022/01/28.
//

import SwiftUI

struct BannerCard: View {
    var banner: AssetBanner
    var body: some View {
//        Color(banner.backgroundColor)
//            .overlay(
//                VStack{
//                    Text(banner.title)
//                        .font(.title)
//                    Text(banner.description)
//                        .font(.subheadline)
//                }
//            )
        ZStack {
            Color (banner.backgroundColor)
            VStack {
                Text(banner.title)
                    .font(.title)
                Text(banner.description)
                    .font(.subheadline)
            }
        }
    }
}

struct BannerCard_Previews: PreviewProvider {
    static var previews: some View {
        BannerCard(banner: AssetBanner(title: "banner1", description: "description1", backgroundColor: .cyan))
    }
}
