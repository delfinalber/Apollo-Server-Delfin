

# https://serverspec.org/resource_types.html


require 'spec_helper'

if os[:family] == 'ubuntu' 
    describe package('apache2') do 
        it {should be_installed} 
    end
end

if os[:family] =='redhat'
    describe package('apache2') do 
        it {should be_installed}
    end

end

describe command('ls -al /') do
    its(:stdout) { should match /bin/ }
  end
 
describe service('mysql') do
    it { should be_enabled }
end

describe service('apache2') do
    it { should be_enabled }
end

describe file('/etc/apache2/sites-available/wordpress.conf') do
    it { should exist }
end

describe file('/srv/www/wordpress') do
    it { should be_directory }
end

describe file('/srv/www/wordpress/wp-config.php') do
    it { should contain 'wordpressdb' }
end