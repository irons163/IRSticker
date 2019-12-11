Pod::Spec.new do |spec|
  spec.name         = "IRSticker"
  spec.version      = "0.1.0"
  spec.summary      = "A powerful sticker of iOS."
  spec.description  = "A powerful sticker of iOS."
  spec.homepage     = "https://github.com/irons163/IRSticker.git"
  spec.license      = "MIT"
  spec.author       = "irons163"
  spec.platform     = :ios, "9.0"
  spec.source       = { :git => "https://github.com/irons163/IRSticker.git", :tag => spec.version.to_s }
  spec.source_files  = "IRSticker/**/*.{h,m}"
  spec.resources = ["IRSticker/**/IRSticker.bundle"]
end