define( :get_and_build,
        :package_url => '!!unspecified',
        :package_output => '!!unspecified',
        :working_dir => '!!unspecified',
        :untar_dir => '!!unspecified',
        :untar_flags => 'zxvf',
        :not_if => "" ) do

  log "Downloading package..."
  execute "download package" do
    command "wget #{params[:package_url]} -O #{params[:package_output]}"
    cwd params[:working_dir]
    action :run
    not_if params[:not_if]
  end

  log "Untarring package..."
  execute "untar package" do
    command "tar --overwrite -#{params[:untar_flags]} #{params[:package_output]}"
    cwd params[:working_dir]
    action :run
    not_if params[:not_if]
  end

  log "Build and install..."
  execute "make and install" do
    command "./configure; make; make install"
    cwd (params[:working_dir] + params[:untar_dir])
    action :run
    not_if params[:not_if]
  end
end
