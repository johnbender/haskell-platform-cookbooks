#update apt
include_recipe "apt"

#packages required for haskell platform to build
package "libgmp3-dev"
package "zlib1g-dev"
package "libglc-dev"
package "libglut3-dev"

#ghc binary package names
ghc = "ghc-#{node[:ghc_version]}"
ghc_tar = "#{ghc}.tar.bz"

#platform package names
platform = "haskell-platform-#{node[:haskell_platform_version]}"
platform_tar = "#{platform}.tar.gz"

# working directory
dir = "/tmp/haskell-platform-work/"

log "Create working directory..."
directory dir do
  action :create
  recursive true
end

get_and_build "ghc binary" do
  package_url "http://darcs.haskell.org/download/dist/#{node[:ghc_version]}/ghc-#{node[:ghc_version]}-i386-unknown-linux-n.tar.bz2"
  package_output ghc_tar
  working_dir dir
  untar_dir ghc
  untar_flags 'jxvf'
end

get_and_build "haskell platform" do
  package_url "http://hackage.haskell.org/platform/#{node[:haskell_platform_version]}/#{platform_tar}"
  package_output platform_tar
  working_dir dir
  untar_dir platform
end

log "Cleaning up..."
directory dir do
  action :delete
  recursive true
end
