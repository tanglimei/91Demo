Pod::Spec.new do |s|
  s.name         = "91Demo"
  s.version      = "1.0.0"
  s.summary      = ""
  s.description  = <<-DESC
                   DESC
  s.homepage     = "https://github.com/tanglimei/91Demo"
  s.license      = "MIT (example)"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "tanglimei" => "email@address.com" }
  s.source       = { :git => "https://github.com/tanglimei/91Demo.git", :tag => "1.0.0" }
  s.source_files  = "Classes", "Classes/**/*.{h,m}"
  s.exclude_files = "Classes/Exclude"
end
