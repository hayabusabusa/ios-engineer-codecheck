//
//  UIScrollView+Rx.swift
//  iOSEngineerCodeCheck
//
//  Created by 山田隼也 on 2020/09/29.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

// https://github.com/tryswift/RxPagination/blob/master/Pagination/UIScrollView%2BRx.swift
extension Reactive where Base: UIScrollView {
    var reachedBottom: ControlEvent<Void> {
        let observable = contentOffset
            .flatMap { [weak base] contentOffset -> Observable<Void> in
                guard let scrollView = base else {
                    return Observable.empty()
                }

                // NOTE: inset で余白を持たせた分を考慮する.
                let visibleHeight = scrollView.frame.height - scrollView.contentInset.top - scrollView.contentInset.bottom
                let y = contentOffset.y + scrollView.contentInset.top
                let threshold = max(0.0, scrollView.contentSize.height - visibleHeight)

                return y > threshold ? Observable.just(()) : Observable.empty()
            }
        return ControlEvent(events: observable)
    }
}
