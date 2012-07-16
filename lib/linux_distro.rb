require 'ftools'

module LinuxDistro

  DISTROS = {
    'suse'   => { :file => '/etc/SuSE-release'   },
    'debian' => { :file => '/etc/debian_version' },
    'ubuntu' => { :file => '/etc/ubuntu-release' },
    'centos' => { :file => '/etc/centos-release' },
    'fedora' => { :file => '/etc/fedora-release' },
    'mandriva' => { :file => '/etc/mandriva-release' }
  }

  class << self

    DISTROS.each_key do |distro_name|
      define_method "#{distro_name}?" do
        distro == distro
      end
    end

    def chroot=(directory)
      raise "Directory '#{directory}' does not exist" unless File.exists? directory
      raise "'#{directory}' is not a directory"       unless File.directory? directory
      # library needs to be reinitialized
      reset
      @chroot = directory
    end

    def distro
      init
      @distro
    end

    alias :name :distro

    private

    def detect_distro
      # 1.) Simply detect files
      DISTROS.each do |distro,detect|
        file = File.join(@chroot, detect[:file]) if @chroot
        return distro if File.exists? detect[:file]
      end

      raise NotImplementedError, "Your distribution was not recognized"
    end

    def init
      @distro = detect_distro unless @initialized
      @initialized = true
    end

    # For testing and chrooting purposes, module needs to be re-initialized
    def reset
      @initialized = false
      @chroot = nil
    end
  end
end
