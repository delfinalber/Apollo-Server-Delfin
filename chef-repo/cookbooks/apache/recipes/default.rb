
# IMPORTANTE: NO FUNCIONA ESTA FUNCION PORQUE LUEGO DA ERROR 2002 (HY000): Can't connect to local MySQL server through socket
# DEBIDO A QUE NO DA "TIEMPO" A ARRANCAR EL SERVICIO MYSQL Y FALLA TODO LO DEMAS. 
# INSTALAR MYSQL EN EL VAGRANT FILE DIRECTAMENTE O HACERLO CON COMANDOS EXECUTE COMO A CONTINUACION
# # If you use default as the name the service name will be mysql instead of mysql-default
# mysql_service 'default' do
#    port '3306'
#    version '8.0'
#    initial_root_password 'password'
#    bind_address 'localhost'
#    action [:create]
#  end


apt_update

# execute 'sudo apt-get update' do 
#   action :run 
#   command 'sudo apt-get update' 
# end 

if node['platform'] == 'ubuntu'
  
  execute 'sudo apt install -y mysql-server' do 
    action :run 
    command 'sudo apt install -y mysql-server' 
  end 

  execute 'sudo apt install -y ghostscript libapache2-mod-php php php-bcmath php-curl php-imagick  php-intl php-json php-mbstring php-mysql php-xml php-zip' do 
    action :run 
    command 'sudo apt install -y ghostscript libapache2-mod-php php php-bcmath php-curl php-imagick  php-intl php-json php-mbstring php-mysql php-xml php-zip' 
  end 

  service 'mysql' do
    supports :status => true 
    action :start
  end
  

end

if node['platform'] == 'centos'

  execute 'sudo yum -y install wget' do 
    action :run 
    command 'sudo yum -y install wget' 
  end 

  execute 'wget https://dev.mysql.com/get/mysql57-community-release-el7-9.noarch.rpm' do 
    action :run 
    command 'wget https://dev.mysql.com/get/mysql57-community-release-el7-9.noarch.rpm' 
  end 

  execute 'sudo rpm -ivh mysql57-community-release-el7-9.noarch.rpm' do 
    action :run 
    command 'sudo rpm -ivh mysql57-community-release-el7-9.noarch.rpm' 
  end 


  execute 'sudo yum install mysql-community-server -y' do 
    action :run 
    command 'sudo yum install mysql-community-server -y' 
  end 
  #sudo systemctl start mysqld
  #sudo systemctl status mysqld
  
  execute 'sudo yum install ghostscript libapache2-mod-php php php-bcmath php-curl php-imagick  php-intl php-json php-mbstring php-mysql php-xml php-zip -y' do 
    action :run 
    command 'sudo yum install ghostscript libapache2-mod-php php php-bcmath php-curl php-imagick  php-intl php-json php-mbstring php-mysql php-xml php-zip -y' 
  end 

  # execute 'sudo systemctl start mysqld' do 
  #   action :run 
  #   command 'sudo systemctl start mysqld' 
  # end 

  service 'mysqld' do
    supports :status => true 
    action :start
  end

end


apt_update
# execute 'sudo apt-get update' do 
#   action :run 
#   command 'sudo apt-get update' 
# end 


mysql_database 'wordpressdb' do
  host 'localhost'
  user 'root'
  password 'password'
  action :create
end

mysql_user 'myuser' do
  password 'mypass'
  action :create
end

mysql_user 'myuser' do
  password 'mypass'
  database_name node['mysql']['databasename']
  host 'localhost'
  privileges [:select,:update,:insert,:delete,:create,:drop,:alter]
  action :grant
end

# execute 'mysql_create_database_wordpress' do
#   action :run
#   command 'sudo /usr/bin/mysql  -u"root" -p"password" -h"localhost" -e "CREATE DATABASE wordpress"'
# end

#  sudo /usr/bin/mysql -S /run/mysqld/mysqld.sock  -u"root" -p"password" -h"localhost" -e "show databases"




execute 'curl -O https://wordpress.org/latest.tar.gz' do
  action :run
  command 'curl -O https://wordpress.org/latest.tar.gz'
end

execute 'tar xzvf latest.tar.gz' do
  action :run
  command 'tar xzvf latest.tar.gz'
end
  
package 'apache2'
  
service 'apache2' do
   supports :status => true
   action :nothing
end
  
cookbook_file '/etc/apache2/sites-enabled/000-default.conf' do
  action :delete
  notifies :restart, resources(:service => "apache2")
end

cookbook_file '/etc/apache2/sites-available/wordpress.conf' do
  source 'wordpress.conf'
  action :create
  notifies :restart, resources(:service => "apache2")
end

link '/etc/apache2/sites-enabled/wordpress.conf' do
   to '/etc/apache2/sites-available/wordpress.conf'
   notifies :restart, resources(:service => "apache2")
end



directory '/srv/www' do
  action :create
end

directory  '/srv/www/wordpress' do
  action :create
end

execute 'cp wordpress' do
  action :run
  command 'cp -r /wordpress/* /srv/www/wordpress'
end

cookbook_file '/srv/www/wordpress/wp-config.php' do
  source 'wp-config.php'
  action :create
  notifies :restart, resources(:service => "apache2")
end

cookbook_file '/home/vagrant/backup.sql' do
  source 'backup.sql'
  action :create
end

execute 'mysql restore' do
  action :run
  command 'mysql -u"root" -p"password" -h"localhost" wordpressdb < /home/vagrant/backup.sql'
end

execute 'a2ensite wordpress' do
  action :run
  command 'a2ensite wordpress'
end
