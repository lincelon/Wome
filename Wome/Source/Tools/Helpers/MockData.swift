//
//  MockData.swift
//  Wome
//
//  Created by Maxim Soroka on 28.05.2021.
//

import UIKit

struct MockData {
    static let feedPublications: [Publication] = [
        .init(type: .post(
                .init(caption: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum",
                      image: Asset(image: UIImage(named: "feed-post-3") ?? UIImage())
                    )
                )
            ),
        .init(type: .story(
                .init(title: "Lorem Ipsum",
                      caption: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum",
                      images: [Asset(image: UIImage(named: "feed-post-10") ?? UIImage())]
                )
            )
        ),
        .init(type: .post(
                .init(caption: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
                      image: Asset(image: UIImage(named: "feed-post-7") ?? UIImage())))),
        .init(type: .story(
                .init(title: "Lorem Ipsum",
                      caption: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum",
                      images: [
                        Asset(image: UIImage(named: "feed-post-12") ?? UIImage()),
                        Asset(image: UIImage(named: "feed-post-1") ?? UIImage())
                        ]
                      )
                    )
            ),
        .init(type: .post(
                .init(caption: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum",
                      image: Asset(image: UIImage(named: "feed-post-8") ?? UIImage())
                    )
                )
            ),
        .init(type: .story(
                .init(title: "Lorem Ipsum",
                      caption: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.",
                      images: [Asset(image: UIImage(named: "feed-post-13") ?? UIImage())]
                    )
                )
            )
    ]
    
    static let clothes: [Clothes] = [
        Clothes(image: "showcase-cell-0", name: "Платье",
                description: "it is a long esteblished fact that a reader will be distracted by the readable content of a page when looking at its layout", price: 3450, type:  .dress),
        Clothes(image: "showcase-cell-1", name: "Пальто",
                description: "it is a long esteblished fact that a reader will be distracted by the readable content of a page when looking at its layout", price: 3490, type: .coat),
        Clothes(image: "showcase-cell-2", name: "Костюм",
                description: "it is a long esteblished fact that a reader will be distracted by the readable content of a page when looking at its layout", price: 845, type: .suit),
        Clothes(image: "showcase-cell-3", name: "Костюм",
                description: "it is a long esteblished fact that a reader will be distracted by the readable content of a page when looking at its layout", price: 1870, type: .coat),
        Clothes(image: "showcase-cell-4", name: "Платье",
                description: "it is a long esteblished fact that a reader will be distracted by the readable content of a page when looking at its layout", price: 890, type: .dress),
        Clothes(image: "showcase-cell-5", name: "Костюм",
                description: "it is a long esteblished fact that a reader will be distracted by the readable content of a page when looking at its layout", price: 1440, type: .dress),
        Clothes(image: "showcase-cell-6", name: "Пальто",
                description: "it is a long esteblished fact that a reader will be distracted by the readable content of a page when looking at its layout", price: 2399, type:  .suit),
        Clothes(image: "showcase-cell-7", name: "Костюм",
                description: "it is a long esteblished fact that a reader will be distracted by the readable content of a page when looking at its layout", price: 2790, type: .suit),
        Clothes(image: "showcase-cell-8", name: "Костюм",
                description: "it is a long esteblished fact that a reader will be distracted by the readable content of a page when looking at its layout", price: 1690, type: .suit)
    ]
}
