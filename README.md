[![Build Status](https://travis-ci.com/aredan/nx.do.svg?branch=main)](https://travis-ci.com/aredan/nx.do)

# nx.do

La finalidad de este repositorio es brindar la opción de solicitar un subdomain basado en NX.DO de manera gratuita, la palabra subdomain queda un poco fuera de lugar ya que al solictar un registro, no lo estaria usando como subdomain. 
Usando la información en zone/ se generan las delegaciones NS de los dominios.

Esta idea original de https://github.com/moderntld/.o pero esta siendo aplatanada en este repositorio. Ya que al usar Git como fuente de origen para las asignaciones NS, se elimina la necesidad de crear una plataforma que administre los cambios y valide las cuentas de usuario.

Si crear un pull request agregando su zone/newdomain es muy complicado, de nuestro lado podemos realizar esa operación con simplemente un reporte en Github solicitando la creación.

Actualmente no tenemos documentación detallada de como solicitar un dominio, se pueden usar los pasos descritos en https://github.com/moderntld/.o/wiki/Claiming-Your-Domain ya que esto es una copia de ese proyecto.