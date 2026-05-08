临时方法就是

```
vi /etc/init.d/redis 
```

把sudo -u redis 改成sudo -a redis
![[28484771691_214221829421_d07c72222fae4b289e66c3a7485c70cd.png]]

然后重启redis服务


service restart redis
