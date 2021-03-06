//
//  FyberMobileOffersTests.swift
//  FyberMobileOffersTests
//
//  Created by Won Cheul Seok on 2017. 8. 12..
//  Copyright © 2017년 Won Cheul Seok. All rights reserved.
//

import XCTest
import RxSwift
import UIKit
import FLAnimatedImage
@testable import FyberMobileOffers

class FyberMobileOffersTests: XCTestCase {
    var disposeBag:DisposeBag!
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testHashGeneration() {
        
        // given example : HASHKEY CALCULATION section in https://ios.fyber.com/docs/rest-api-preparing-request
        let paramsDict = "appid=157&device_id=2b6f0cc904d137be2e1730235f5664094b831186&ip=212.45.111.17&locale=de&page=2&ps_time=1312211903&pub0=campaign2&timestamp=1312553361&uid=player1".components(separatedBy: "&")
            .map { (pairString) -> (String, String) in
                let pair = pairString.components(separatedBy: "=")
                return (pair[0], pair[1])
            }.reduce([String:String]()) { (dict, tuple) -> [String:String] in
                var joinedDict = dict
                joinedDict[tuple.0] = tuple.1
                return joinedDict
        }
        let resultHash = FOOffersFetcher.generateHash(params: paramsDict, apiKey: "e95a21621a1865bcbae3bee89c4d4f84")
        XCTAssertEqual(resultHash, "7a2b1604c03d46eec1ecd4a686787b75dd693c4d")
    }
    func testFOOfferModel() {
        
        var offerEntry = [String:Any]()
        
        XCTAssertThrowsError(try FOOfferModel(offerEntry: offerEntry))
        
        
        
        offerEntry["title"] = "" // empty is not allowed
        XCTAssertThrowsError(try FOOfferModel(offerEntry: offerEntry))
        
        offerEntry["title"] = "this title is allowed"
        XCTAssertThrowsError(try FOOfferModel(offerEntry: offerEntry))
        
        
        
        
        offerEntry["teaser"] = "" // empty is not allowed
        XCTAssertThrowsError(try FOOfferModel(offerEntry: offerEntry))
        
        offerEntry["teaser"] = "this teaser is allowed"
        XCTAssertThrowsError(try FOOfferModel(offerEntry: offerEntry))
        
        
        
        offerEntry["thumbnail"] = "" // expecte dictionary entry
        XCTAssertThrowsError(try FOOfferModel(offerEntry: offerEntry))
        
        offerEntry["thumbnail"] = ["hires":"this.is.bad.url"] // invaild url is not allowed
        XCTAssertThrowsError(try FOOfferModel(offerEntry: offerEntry))
        
        offerEntry["thumbnail"] = ["hires":"http://www.google.com"]
        XCTAssertThrowsError(try FOOfferModel(offerEntry: offerEntry))
        
        
        
        offerEntry["payout"] = "this property expect number"
        XCTAssertThrowsError(try FOOfferModel(offerEntry: offerEntry))
        
        offerEntry["payout"] = 33 // invaild url is not allowed
        XCTAssertNoThrow(try FOOfferModel(offerEntry: offerEntry))
        
        
    }
    func testObservableOffersFetcher() {
        
        let onNextExpectation = expectation(description: "onNextExpectation")
        
        FOOffersFetcher.shared.observableFetcher()
            .subscribe(onNext: { (offers) in
                onNextExpectation.fulfill()
            }, onError: { (error) in
                XCTFail(error.localizedDescription)
            }, onCompleted: nil, onDisposed: nil)
            .addDisposableTo(disposeBag)
        
        
        self.waitForExpectations(timeout: 6) { (error) in
            guard nil == error else {
                XCTFail((error?.localizedDescription)!)
                return
            }
            
        }
    }
    func testObservableImageFetcherWithGif() {
        
        let onNextExpectation = expectation(description: "onNextExpectation")
        FOImageFetcher.shared.observableImageFetcher(imageURL: URL(string:"http://cdn2.sponsorpay.com/assets/66971/Supereasy_cat_GIF_175x175_square_175.gif"))
            .subscribe(onNext: { (tuple: (image:UIImage?, gif:FLAnimatedImage?)) in
                XCTAssertNil(tuple.image)
                XCTAssertNotNil(tuple.gif)
                onNextExpectation.fulfill()
            }, onError: { (error) in
                XCTFail(error.localizedDescription)
            }, onCompleted: nil, onDisposed: nil)
        .addDisposableTo(disposeBag)
        
        self.waitForExpectations(timeout: 10) { (error) in
            guard nil == error else {
                XCTFail((error?.localizedDescription)!)
                return
            }
            
        }
    }
    func testObservableImageFetcherWithPng() {
        
        let onNextExpectation = expectation(description: "onNextExpectation")
        FOImageFetcher.shared.observableImageFetcher(imageURL: URL(string:"http://cdn4.sponsorpay.com/app_icons/90930/big_mobile_icon.png"))
            .subscribe(onNext: { (tuple: (image:UIImage?, gif:FLAnimatedImage?)) in
                XCTAssertNil(tuple.gif)
                XCTAssertNotNil(tuple.image)
                onNextExpectation.fulfill()
            }, onError: { (error) in
                XCTFail(error.localizedDescription)
            }, onCompleted: nil, onDisposed: nil)
        .addDisposableTo(disposeBag)
        
        self.waitForExpectations(timeout: 10) { (error) in
            guard nil == error else {
                XCTFail((error?.localizedDescription)!)
                return
            }
            
        }
    }
    func testObservableImageFetcherWithJpg() {
        
        let onNextExpectation = expectation(description: "onNextExpectation")
        FOImageFetcher.shared.observableImageFetcher(imageURL: URL(string:"http://cdn4.sponsorpay.com/assets/66958/ice_cream_175x175_square_175.jpg"))
            .subscribe(onNext: { (tuple: (image:UIImage?, gif:FLAnimatedImage?)) in
                XCTAssertNil(tuple.gif)
                XCTAssertNotNil(tuple.image)
                onNextExpectation.fulfill()
            }, onError: { (error) in
                XCTFail(error.localizedDescription)
            }, onCompleted: nil, onDisposed: nil)
        .addDisposableTo(disposeBag)
        
        self.waitForExpectations(timeout: 10) { (error) in
            guard nil == error else {
                XCTFail((error?.localizedDescription)!)
                return
            }
            
        }
    }
}
