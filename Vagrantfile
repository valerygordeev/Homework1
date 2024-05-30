MACHINES = {
  :"kernel-update" => {
              :box_name => "generic/centos8s",
              :box_version => "4.3.4",
              :cpus => 2,
              :memory => 1024,
            }
}

Vagrant.configure("2") do |config|
  MACHINES.each do |boxname, boxconfig|
    #config.vm.synced_folder ".", "/vagrant", type: "virtualbox"
    config.vm.define boxname do |box|
      box.vm.box = boxconfig[:box_name]
      box.vm.box_version = boxconfig[:box_version]
      box.vm.host_name = boxname.to_s
      box.vm.provider "virtualbox" do |v|
        v.memory = boxconfig[:memory]
        v.cpus = boxconfig[:cpus]
      end
    end
  end
  config.vm.provision "shell", inline: <<-SHELL
	  uname -r > kernel_version
	  echo "подключаем репозиторий ELREPO"
	  yum install -y https://www.elrepo.org/elrepo-release-8.el8.elrepo.noarch.rpm
	  echo "загрузка ядра"
	  yum --enablerepo elrepo-kernel install kernel-ml -y
	  echo "устанавливаем значение параметра GRUB_DEFAULT=0"
	  sed 's/GRUB_DEFAULT=saved/GRUB_DEFAULT=0/' /etc/default/grub
	  echo "генерируем конфиг"
	  grub2-mkconfig -o /boot/grub2/grub.cfg
	  echo "Устанавливаем конфигурацию по умолчанию"
	  grub2-set-default 0
  SHELL
  
  config.vm.provision :reload
  
  config.vm.provision "shell", inline: <<-SHELL
	  uname -r >> kernel_version
	  echo "Номера ядер"
	  cat kernel_version
	  echo "Смотрим список существующих ядер в системе"
	  rpm -qa | grep kernel
	  echo "Удаляем старую версию ядра"
	  for i in `rpm -qa | grep kernel | grep 4.18`
	  do
	  	yum remove $i -y
	  done
  SHELL
end
