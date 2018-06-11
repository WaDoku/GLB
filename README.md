[![Gitter](https://badges.gitter.im/WaDoku/GLB.svg)](https://gitter.im/WaDoku/GLB?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Deployment
==========

* Am Server rvm-default auf ruby-2.2.*; `set :rvm_ruby_string, :local` wird von Capistrano leider ignoriert.
* mit `cap <environment> rvm:info` überprüfen
* mit `cap <environment> deploy` ausrollen
  
ToDo
____

* secret.yml
* Upgrade auf Capistrano 3.x