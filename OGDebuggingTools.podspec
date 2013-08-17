Pod::Spec.new do |s|
  s.name                 = "OrangeGroove Debugging Tools"
  s.version              = "0.1.0"
  s.summary              = "Code snippets for debugging"
  s.homepage             = "https://github.com/OrangeGroove/OGDebuggingTools"
  s.license              = :type => "MIT"
  s.authors              = "Jesper" => "jesper@orangegroove.net"
  s.source               = :git => "https://github.com/OrangeGroove/OGDebuggingTools.git", :tag => s.version.to_s
  s.platform             = :ios, "7.0"
  s.source_files         = "OGDebuggingTools/"
  s.requires_arc         = true
  s.dependency           = "JRSwizzle", "~> 1.0"
end
