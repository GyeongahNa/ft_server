## ft_server
This is a System Administration subject. You will discover Docker and you will set up your first web server.

### Contents
- [X] docker
- [X] nginx & ssl
- [X] phpmyadmin
- [X] mysql & wordpress 

```
sudo docker build --tag ft_server
sudo docker run --name ft_server_container -d -p 80:80 -p 443:443 ft_server
