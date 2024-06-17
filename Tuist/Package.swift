// swift-tools-version: 5.9
import PackageDescription

#if TUIST
import ProjectDescription

let packageSettings = PackageSettings(
    productTypes: [
        "Lottie": .framework,
        "AlamofireDynamic": .framework,
        "Firebase" : .framework,
        "GoogleSignIn" : .framework,
        "GoogleUtilities" : .framework,
    ]
)
#endif

let package = Package(
    name: "SwiftyProteins",
    dependencies: [
        .package(url: "https://github.com/airbnb/lottie-ios.git", from: "4.4.3"),
        .package(url: "https://github.com/Alamofire/Alamofire", from: "5.9.0"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "10.27.0"),
        .package(url: "https://github.com/google/GoogleSignIn-iOS", from: "6.2.4"),
        .package(url: "https://github.com/google/GoogleUtilities.git", from: "7.13.2")
    ]
)
