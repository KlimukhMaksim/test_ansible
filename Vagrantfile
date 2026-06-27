require 'yaml'
configuration = YAML.load_file('services.yml')

Vagrant.configure("2") do |config|
    config.ssh.insert_key = false
    config.ssh.verify_host_key = :accept_new
    config.ssh.private_key_path = [
        '~/.ssh/id_rsa',
        '~/.vagrant.d/insecure_private_key'
    ]

    configuration['services'].each do |hostname, service|
        config.vm.define hostname do |node|
            node.vm.box = service['box'] || "bento/ubuntu-24.04"
            node.vm.hostname = hostname
            node.vm.network :public_network, ip: service['ip'], bridge: "enp0s9"
            node.vm.network "forwarded_port", guest: 22, host: service['ssh_port'], id: "ssh"


            node.vm.provision 'file',
                source: '~/.ssh/id_rsa.pub',
                destination: '~/.ssh/authorized_keys'

            node.vm.provider :virtualbox do |vb|
                vb.name = "#{hostname}"
                vb.memory = service['memory']
                vb.cpus = service['cpus']
            end
            node.vm.provision "shell", path: service['script']
        end
    end
end
