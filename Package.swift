import PackageDescription

let package = Package(
    name: "Git2Swift",
    dependencies: [
        .Package(url: "https://github.com/damicreabox/CLibgit2.git", majorVersion: 1)
    ]
)
