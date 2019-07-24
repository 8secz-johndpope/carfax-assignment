clean:
	rm -rf ~/Library/Developer/Xcode/DerivedData

imagescript:
	swiftc scripts/image_assets.swift -o scripts/image_assets
	chmod +x scripts/image_assets

generate-images:
	./scripts/image_assets.swift \
		CarfaxFrameworks/CarfaxUI/Assets.xcassets \
		CarfaxFrameworks/CarfaxUI/Sources/UIImage+Icons.swift
