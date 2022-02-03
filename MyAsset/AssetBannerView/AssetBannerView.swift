//
//  AssetBannerView.swift
//  MyAsset
//
//  Created by UAPMobile on 2022/02/03.
//

import SwiftUI

struct AssetBannerView: View {
    let bannerList: [AssetBanner] = [
        AssetBanner(title: "공지사항", description: "추가된 공지사항", backgroundColor: .red),
        AssetBanner(title: "주말 이벤트", description: "주말 이벤트 놓치지 마세요.", backgroundColor: .yellow),
        AssetBanner(title: "깜짝 이벤트", description: "엄청난 이벤트가 기다려요.", backgroundColor: .blue),
        AssetBanner(title: "겨울 프로모션", description: "추운 겨울을 따뜻하게", backgroundColor: .gray),
    ]
    @State private var currentPage = 0
    
    var body: some View {
        let bannerCards = bannerList.map { BannerCard(banner: $0) }
        
        // pageViewController 위에 PageControl이 overlay
        ZStack(alignment: .bottomTrailing) {
            PageViewController(pages: bannerCards, currentPage: $currentPage)
            PageControl(numberOfPages: bannerCards.count, currentPage: $currentPage)
                .frame(width: CGFloat(bannerCards.count * 18))
                .padding(.trailing)
        }
    }
}

struct AssetBannerView_Previews: PreviewProvider {
    static var previews: some View {
        AssetBannerView()
            .aspectRatio(5/2, contentMode: .fit)
    }
}
