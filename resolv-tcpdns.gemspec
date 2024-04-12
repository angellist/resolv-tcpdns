# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "resolv-tcpdns"
  spec.version = '0.0.1'
  spec.authors = ["AngelList Advisors Management"]
  spec.email = ["team@angellist.com"]

  spec.summary = "TCP-only DNS Resolver"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.files = [
    "lib/resolv-tcpdns.rb",
  ]

  spec.require_paths = ["lib"]

  spec.add_dependency "resolv"
end
