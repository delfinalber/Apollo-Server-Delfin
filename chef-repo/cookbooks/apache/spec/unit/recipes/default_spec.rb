require 'spec_helper'

describe 'apache::default' do

  platform 'ubuntu'

  context 'with default attributes' do

    it "should have mysql databasename 'wordpressdb'" do
     expect(chef_run.node['mysql']['databasename']).to eq('wordpressdb') 
    end

    it "should include the default recipe" do
      expect(chef_run).to include_recipe('apache::default')
    end

    it 'creates a file' do
      expect(chef_run).to render_file('/etc/apache2/sites-available/wordpress.conf')
    end

    it 'creates a directory ' do
      expect(chef_run).to create_directory('/srv/www/wordpress')
      expect(chef_run).to_not create_directory('/srv/www/no-valid-dir')
    end

    it 'start mysql service' do
      expect(chef_run).to start_service('mysql')
    end

    it 'executes some commands' do
      expect(chef_run).to run_execute('mysql restore')
      expect(chef_run).to run_execute('a2ensite wordpress')
    end

  end
 
end


# describe 'vim_pruebas_chef::default' do
#   platform 'ubuntu'

#   context 'with default attributes' do
#     it "should have default install_method 'package'" do
#      expect(chef_run.node['vim']['install_method']).to eq('package') 
#     end

#     it "should include the vim_pruebas_chef::package recipe when install_method='package'" do 
#       expect(chef_run).to include_recipe('vim_pruebas_chef::package') 
#     end
#   end
  
#   context "with 'source' as install_method" do
    
#     override_attributes['vim']['install_method'] = 'source' 

#     it "should include the vim_pruebas_chef::source recipe when install_method='source'" do 
#       expect(chef_run).to include_recipe('vim_pruebas_chef::source') 
#     end
#   end
# end