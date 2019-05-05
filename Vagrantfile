Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/bionic64"

    config.vm.network "forwarded_port", guest: 22, host: 3022
    config.vm.hostname = "blair-cubesat"
    config.vm.define "blair-cubesat"
    config.vm.synced_folder "vm", "/blair3sat"

    config.ssh.forward_x11 = true
    config.ssh.forward_agent = true
    config.vm.provider "virtualbox" do |v|
        v.gui = true
        v.name = "blair-cubesat"
        v.memory = 4096 #1024
        v.cpus = 4
    end
end