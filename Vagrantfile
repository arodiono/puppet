Vagrant.configure("2") do |config|
    config.vm.box = "laravel/homestead"
    config.vm.provider "virtualbox" do |vb|
        vb.gui = false
        vb.memory = "512"
    end
    config.vm.define "guest" do |guest|
        guest.vm.hostname = "portfolio"
        guest.vm.network "private_network", ip: "172.28.128.105", bridge: "en0: Ethernet"
        guest.vm.synced_folder "/Users/lvovych/Documents/development/portfolio", "/opt/data/web"
        # portfolio.vm.provision "puppet" do |puppet|
        #     puppet.manifests_path = "provision/manifests"
        #     puppet.module_path = '~/Documents/development/puppet/modules'
        #     puppet.manifest_file = 'init.pp'
        #     # puppet.options = "--verbose --debug"
        # end
        guest.vm.provision "shell", path: "provision/script.sh"
    end
end
