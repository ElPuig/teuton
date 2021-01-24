
group "Comprobaciones Practica GNS3 - SMX-M05" do

  target "Comprobacion proyecto test"
  run "ls #{get(:proyecto)}", on: :host1
  expect_none "No existe el archivo"

 target "Existe PC1, PC2, PC3 y R1"
  run "jq '.topology.nodes[] | select (.name == \"PC1\") | .console' #{get(:proyecto)}", on: :host1
  set(:pc1con,result.value)
  run "jq '.topology.nodes[] | select (.name == \"PC2\") | .console' #{get(:proyecto)}", on: :host1
  set(:pc2con,result.value)
  run "jq '.topology.nodes[] | select (.name == \"PC3\") | .console' #{get(:proyecto)}", on: :host1
  set(:pc3con,result.value)
  run "jq '.topology.nodes[].name' #{get(:proyecto)}",  on: :host1
  #result.debug
  expect result.find(['PC1','PC2','PC3','R1']).count.eq 4


 target "responde ping PC1 --> PC2"
  run "echo \"ping #{get(:ip_pc2)} -c 5 -i 1 -w 100\" | curl -m 1 telnet://127.0.0.1:#{get(:pc1con)}", on: :host1
  expect "bytes from"

 target "responde ping PC1 --> R1E0"
  run "echo \"ping #{get(:ip_r1_e0)} -c 5 -i 1 -w 100\" | curl -m 1 telnet://127.0.0.1:#{get(:pc1con)}", on: :host1
  expect "bytes from"

 target "responde ping PC1 --> R1E1"
  run "echo \"ping #{get(:ip_r1_e1)} -c 5 -i 1 -w 100\" | curl -m 1 telnet://127.0.0.1:#{get(:pc1con)}", on: :host1
  expect "bytes from"

 target "responde ping PC3 --> PC1"
  run "echo \"ping #{get(:ip_pc1)} -c 5 -i 1 -w 100\" | curl -m 1 telnet://127.0.0.1:#{get(:pc3con)}", on: :host1
  expect "bytes from"

 target "responde ping PC2 --> PC3"
  run "echo \"ping #{get(:ip_pc3)} -c 5 -i 1 -w 100\" | curl -m 1 telnet://127.0.0.1:#{get(:pc2con)}", on: :host1
  expect "bytes from"



=begin
 target "Servicio vsftpd instalado"     #{get(:pc1con)}
  run "apt list vsftpd",  on: :host1
  expect "installed"

  target "Servicio vsftpd Activo"
  run "systemctl status vsftpd",  on: :host1
  expect "active (running"

  target "Existe usuari1"
  run "id usuari1",  on: :host1
  expect "uid="

  target "Existe usuari1.txt"
  run "ls /home/usuari1/",  on: :host1
  expect "usuari1.txt"

  target "Existe usuari2"
  run "id usuari2",  on: :host1
  expect "uid="

  target "Existe usuari2.txt"
  run "ls /home/usuari2/",  on: :host1
  expect "usuari2.txt"

  target "Usuario Locales habilitados"
  run "grep '^local_enable=YES' /etc/vsftpd.conf",  on: :host1
  expect "YES"
=end

end

play do
  show
  export
  export :format => :html 
#  send :copy_to => :host1
end
