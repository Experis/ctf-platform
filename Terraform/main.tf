
provider "azurerm" {
  features {}
  subscription_id = var.ARM_SUBSCRIPTION_ID
  client_id       = var.ARM_CLIENT_ID
  client_secret   = var.ARM_CLIENT_SECRET
  tenant_id       = var.ARM_TENANT_ID
}



resource "azurerm_resource_group" "rg" {
  name     = "experis-ctf-rg"
  location = "norwayeast"
}
resource "azurerm_virtual_network" "vnet" {
  name                = "myVnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}
resource "azurerm_subnet" "subnet" {
  name                 = "mySubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}
resource "azurerm_network_security_group" "nsg" {
  name                = "myNSG"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  security_rule {
    name                       = "allow_http"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "allow_ssh"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_public_ip" "publicip" {
  name                = "myPublicIP"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}
resource "azurerm_network_interface" "nic" {
  name                = "myNIC"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "myNicConfig"
    subnet_id                     = azurerm_subnet.subnet.id
    public_ip_address_id          = azurerm_public_ip.publicip.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_security_group_association" "nic_nsg_asc" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_virtual_machine" "vm" {
  name                  = "myVM"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = "Standard_DS1_V2"
  storage_os_disk {
    name              = "myOsDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }
  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
  os_profile {
    computer_name  = "myVM"
    admin_username = "experisadmin343"
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/experisadmin343/.ssh/authorized_keys"
      key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCeuIuuzYU4m/g9QQj2yFyc1dWlCptEjeALqcrLw/3w0ZU6cGJ1c5V9kcfeZ2pE2JZIFlOxPKSdMrQahBAZ2fYfnfCyg0WJ0FOhjKpb4IWIvtVl0EazNMgGqg5uXUhVmORDRdSa9uJuBa7sbdaJKTJk1VkFi/belrn1owAzM1h0Jll7v8kJEvlUyWQ3kPwhZ2REkmzF4zoCDOTrZA6FXuul3sHCGrN7D+v+Xfv9dtr2lqRBH4/apF16eMRt5C6GizgZf2GPhDc9Zx5oAkEcwOwOVcBbvs8jZnjVvLV9TlhHVc7n3IVbYW4sySlN+ASCHXs6LwAe/nnddLWE4E1o7nMrQgxRU/U7XW6llX3m9qrSeyuwcdkYUlDLQjfEaaMdjhFj13xqSqyFHBQpAehUc4Kp9+B8jJHm4ugq87g8mpGs1PzzyjcYhWIa2NwZpcEoGgO3LS1B6JFqQPBTXAFWUjHrotNnCNBIzvTnPmIEEmoTZ8kyceSSgL+Iq6f2x9YBcB0= corp\\grmart@ND-CND038578T"
    }
  m
}


# POST SETUP
# Add user
	/*
		
		resource "null_resource" "add_user" {
		  provisioner "local-exec" {
			command = "sudo useradd -m -s /bin/bash ctfuser && echo 'ctfuser:ctfmylifeaway9551_' | sudo chpasswd"
		  }
		  depends_on = [
			azurerm_virtual_machine.vm
		  ]
		}
*/
