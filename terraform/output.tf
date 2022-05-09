output "user" {
  value = azurerm_linux_virtual_machine.linux-basic.admin_username 
}

output "ip_public_vm_linux" {
  value = azurerm_linux_virtual_machine.linux-basic.public_ip_address
  description = "Public ip of Ubuntu devops server"
}

output "tls_private_key" {
  value     = tls_private_key.poc.private_key_pem
  description = "Pem of Ubuntu server - Check the secrets in azure vault key"
  sensitive = true
}
