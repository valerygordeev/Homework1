# manual_kernel_update
homework1
```
Обновление ядра
1.Устанавливаем плагин перезагрузки 
	vagrant plugin install vagrant-reload
2. Загружаем систему "generic/centos8s"  версии 4.3.4 в ВМ с помощью vagrant
3. Записываем текущую версию ядра uname -r 
	4.18.0-516.el8.x86_64
4. Добавляем репозиторий epel:
	yum install -y https://www.elrepo.org/elrepo-release-8.el8.elrepo.noarch.rpm 
5. Загружаем ядро последней версии:
	yum --enablerepo elrepo-kernel install kernel-ml -y     
6. Устанавливаем значение параметра GRUB_DEFAULT=0
	sed 's/GRUB_DEFAULT=saved/GRUB_DEFAULT=0/' /etc/default/grub
7. C помощью утилиты grub2-mkconfig генерируем файл конфигурации (и проверит конфигурацию на наличие ошибок)
      grub2-mkconfig -o /boot/grub2/grub.cfg
8. Устанавливаем конфигурацию по умолчанию (меню загрузки начинается с 0)    
      grub2-set-default 0
9. Перезагружаем ВМ      
      reboot      
10. Записываем версию обновленного ядра:
     6.8.6-1.el8.elrepo.x86_64
11. Смотрим список существующих ядер в системе:
     rpm -qa | grep kernel
12. Удаляем старую версию ядра 4.18.0-516.el8.x86_64:
     for i in `rpm -qa | grep kernel | grep 4.18`
	  do
	  	yum remove $i -y
     done
10. Проверяем:
     rpm -qa | grep kernel
     
	kernel-ml-modules-6.8.6-1.el8.elrepo.x86_64
	kernel-ml-core-6.8.6-1.el8.elrepo.x86_64
	kernel-ml-6.8.6-1.el8.elrepo.x86_64

Создание образа системы
1. В директории с Vagrantfile cоздаем директорию packer, в ней директории http и scripts.
2. В директории packer создаем файл centos.json и заполняем его кодом указанном в задании. В директории http создаем файл vagrant.ks, в директории scripts создаем файлы scripts stage-1-kernel-update.sh и stage-2-clean.sh, и заполняем их кодом указанном в задании.
3. Обновляем контрольную сумму в файле centos.json для загрузки образа https://mirror.linux-ia64.org/centos/8-stream/isos/x86_64/CentOS-Stream-8-x86_64-latest-boot.iso, взяв их на сайте https://mirror.linux-ia64.org/centos/8-stream/isos/x86_64/CHECKSUM:
     "iso_checksum": "sha256:e42a218956f988aae48a661bcb9026315a405ba1ff64e0e9acf35724db1ff9fc"
5. После всех приготовления соберем образ обновленной системы (запускаем команду в директории packer):
     packer build -force centos.json
6. Окончание процесса сборки завершается сообщением:

     Build 'virtualbox-iso.centos-8stream' finished after 1 hour 4 minutes.

     ==> Wait completed after 1 hour 4 minutes

     ==> Builds finished. The artifacts of successful builds are:
     --> virtualbox-iso.centos-8stream: 'virtualbox' provider box: centos-8-kernel-6-x86_64-Minimal.box
     
7. Проверяем созданный образ:
     - добавляем образ:
       	valery@valery-notebook:~/homework1/packer$ vagrant box add --name UpdateKernel centos-8-kernel-6-x86_64-Minimal.box
	==> box: Box file was not detected as metadata. Adding it directly...
	==> box: Adding box 'UpdateKernel' (v0) for provider: 
	    box: Unpacking necessary files from: file:///home/valery/homework1/packer/centos-8-kernel-6-x86_64-Minimal.box
	==> box: Successfully added box 'UpdateKernel' (v0) for ''!

    - Проверяем добавленный образ в списке вм:
	valery@valery-notebook:~/homework1/packer$ vagrant box list
	bento/centos-8.4   (virtualbox, 202110.26.0)
	UpdateKernel    (virtualbox, 0)

     - создаем Vagrantfile:
	valery@valery-notebook:~/homework1/packer$ vagrant init UpdateKernel
	A `Vagrantfile` has been placed in this directory. You are now
	ready to `vagrant up` your first virtual environment! Please read
	the comments in the Vagrantfile as well as documentation on
	`vagrantup.com` for more information on using Vagrant.
	
     - добавляем в файл сетевые настройки и логин/пароль для доступа по ssh (см. файл Vagrantfile)

     - запускаем ВМ:
       vagrant up
     - заходим на ВМ и проверяем версию ядра:
       vagrant ssh
       [vagrant@otus-c8 ~]$ uname -r
       6.7.1-1.el8.elrepo.x86_64
8. Выходим и удаляем ВМ:
     exit
     vagrant destroy -f
     
Загрузка образа в Vagrant cloud
1. Авторизируемся в vagrant cloud
   vagrant cloud auth login
2. Публикуем box на vagrant cloud 
   vagrant cloud publish --release valerygordeev/centos8kernel6 1.0 virtualbox ./centos-8-kernel-6-x86_64-Minimal.box

valery@valery-notebook:~/homework1/packer$ vagrant cloud publish --release valerygordeev/centos8kernel6 1.0 virtualbox ./centos-8-kernel-6-x86_64-Minimal.box
You are about to publish a box on Vagrant Cloud with the following options:
valerygordeev/centos8kernel6:   (v1.0) for provider 'virtualbox'
Automatic Release:     true
Box Architecture:      amd64
Do you wish to continue? [y/N]y
Saving box information...
Uploading provider with file /home/valery/homework1/packer/centos-8-kernel-6-x86_64-Minimal.box
Releasing box...
Complete! Published valerygordeev/centos8kernel6
Box:                  valerygordeev/centos8kernel6
Private:              yes
Version:              1.0
Provider:             virtualbox
Architecture:         amd64
Default Architecture: yes

Принтскрин ЛК на vagrant cloud

       
