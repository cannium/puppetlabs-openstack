module Puppet::Parser::Functions

    newfunction(:ip_from_hosts, :type => :rvalue, :doc => <<-EOS
            get agent's hostname via facter, and then get the corresponding
            IP address via parsing /etc/hosts file(hosts file on master node)
            EOS
    ) do |args|
        
        hosts = {}
        File.open('/etc/hosts', 'r').readlines.each do |line|
            unless line.start_with? '#'
                hosts[line.split[1]] = line.split[0]
            end
        end

        return hosts[lookupvar('hostname')]
    end
end
