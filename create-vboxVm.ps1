
# Lab's name 
$labName = "pki2019"

# VMs Location
$vmLocation = "d:\vboxvms"

# ISO file
$isoFile = "E:\ISO Images\SERVER_2019_EVAL_x64_en-us.iso"

# VM's name
$vmName = "DC01" 

# VM OS type: run the command 'vboxmanage list ostypes' to get OS types supported by VirtualBox
$vmOsType = "Windows2019_64"

# VM Memory 
$vmMemory = 4096

# VM HDD 
$vmHDD = 60000

#VM network
$vmNetwork = "nat"

#Create VM folder
$vmFolder = -join($vmLocation, '\', $labName, '\', $vmName)
New-Item -Path $vmFolder -ItemType Directory 

# switch into default VirtualBox directory
Set-Location -Path $vmFolder

# create new VirtualBox VM
VBoxManage createvm --name $vmName --ostype $vmOsType --register

# Create a group and assign the VM.
VBoxManage modifyvm $vmName --groups $( -join('/', $labName))

# configure system settings of VM
VBoxManage modifyvm $vmName --memory $vmMemory = 4096 --cpus 2 --acpi on --pae on --hwvirtex on --nestedpaging on

# configure boot settings of VM
VBoxManage modifyvm $vmName --boot1 dvd --boot2 disk --boot3 none --boot4 none

# configure video settings
VBoxManage modifyvm $vmName --vram 128 --accelerate3d on

# configure audio settings
VBoxManage modifyvm $vmName --audio coreaudio --audiocontroller hda

# configure network settings
VBoxManage modifyvm $vmName --nic1 $vmNetwork

# configure usb settings
VBoxManage modifyvm $vmName --usb on

# create storage medium for VM
VBoxManage createhd --filename $(-join("./",$vmName,'.vdi')) --size $vmHDD

# modify a storage controller
VBoxManage storagectl $vmName --name "SATA" --add sata

# attache storage medium to VM
VBoxManage storageattach $vmName --storagectl "SATA" --port 0 --device 0 --type hdd --medium $(-join("./",$vmName,'.vdi'))

# add windows iso
VBoxManage storageattach $vmName --storagectl "SATA" --port 1 --device 0 --type dvddrive --medium $isoFile

# add guest addition iso
#VBoxManage storageattach $vmName --storagectl "SATA" --port 2 --device 0 --type dvddrive --medium /path/to/VBoxGuestAdditions.iso

# start VM
VBoxManage startvm $vmName