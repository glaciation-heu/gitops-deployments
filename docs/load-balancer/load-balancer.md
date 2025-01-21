# Primitive Nginx load-balancer

## About

The folder contains a configuration for a primitive load balancer for Kubernetes. We use Nginx installed on master node of Kubernetes cluster via package manager of node operating system.

It is not the best practice. We use this approach for a quick start. Consider to use MetalLB, hardware alternative, etc.


## How to install

1. SSH to master node of your cluster and install Nginx
    
   ```shell
   sudo apt install nginx
    ```

1. Disable default config
   
   ```shell
   sudo rm /etc/nginx/sites-enabled/default
   ```
   
1. Append the text from [kubernetes.conf](kubernetes.conf) to the end of `/etc/nginx/nginx.conf`

1. Check the config

   ```shell
   sudo nginx -t
   ```

1. Reload Nginx

   ```
   sudo systemctl restart nginx
   ```