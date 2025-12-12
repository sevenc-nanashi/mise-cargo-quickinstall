# frozen_string_literal: true

task default: [:create_index]

desc "Create index of cargo-quickinstall packages"
task :create_index do
  require "dotenv/load"
  require "octokit"
  require "json"

  client = Octokit::Client.new(access_token: ENV["GITHUB_TOKEN"])
  client.auto_paginate = true

  puts "Fetching releases from cargo-bins/cargo-quickinstall..."
  repos = client.releases("cargo-bins/cargo-quickinstall")

  puts "Fetched #{repos.size} releases."

  index =
    repos.each_with_object({}) do |release, acc|
      if release.name.match?(/^v[0-9\.]+$/)
        puts "Skipping release #{release.tag_name}, looks like cargo-quickinstall itself's release."
        next
      end
      match = release.body.match(/^build (?<package>.+)@(?<version>.+?)$/)
      unless match in { package:, version: }
        puts "Skipping release #{release.tag_name}, no build info found."
        next
      end
      assets = {}
      sign_assets = {}
      release.assets.each do |asset|
        name_match =
          asset.name.match(
            /^#{Regexp.escape(package)}-#{Regexp.escape(version)}-(?<platform>.+)\.tar\.gz(?<sign>\.sig)?$/
          )
        unless name_match
          puts "Skipping asset #{asset.name}, does not match expected pattern."
          next
        end
        platform = name_match[:platform]
        if name_match[:sign]
          sign_assets[platform] = asset.browser_download_url
        else
          assets[platform] = {
            url: asset.browser_download_url,
            size: asset.size
          }
        end
      end
      entry = {
        version: version,
        url: release.html_url,
        published_at: release.published_at,
        assets:
          assets.transform_values do |v|
            { **v, signature_url: sign_assets[v[:platform]] }
          end
      }
      acc[package] ||= []
      acc[package] << entry
    end
  puts "Writing index.generated.json with #{index.keys.size} packages."
  File.write("index.generated.json", JSON.pretty_generate(index))
end
