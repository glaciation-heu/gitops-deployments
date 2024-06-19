# Primitive Nginx load-balancer

## About

The folder contains a configuration for a primitive load balancer for Kubernetes. We use Nginx installed on master node of Kubernetes cluster via package manager of node operating system.

It is not the best practice. We use this approach for a quick start. Consider to use MetalLB, hardware alternative, etc.


## How to install

1. SSH to master node of your cluster and install Nginx
    
   ```shell
   sudo apt install nginx
    ```

1. Copy [kubernetes.conf](kubernetes.conf) to the node
   
   ```shell
   scp kubernetes.conf <node>:/etc/nginx/sites-available/
   ```

1. Disable default config
   
   ```shell
   rm /etc/nginx/sites-enabled/default
   ```

1. Enable the new config

   ```shell
   ln -s /etc/nginx/sites-available/kubernetes.conf /etc/nginx/sites-enabled/kubernetes.conf
   ```

1. Reload Nginx

   ```
   sudo systemctl restart nginx
   ```