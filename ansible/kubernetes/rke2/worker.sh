- name: Instalación RKE2 Worker desde Cero - RHEL 9
  hosts: workers
  become: yes
  vars:
    rke2_version: "v1.31.8+rke2r1"
    rke2_token: "SecretToken2026!" # Debe coincidir con el del master
    master_ip: "192.168.1.10" # IP real de tu servidor master

  tasks:
    - name: 1. Preparación de Red y Kernel
      block:
        - name: Desactivar Swap
          command: swapoff -a
          when: ansible_swaptotal_mb > 0

        - name: Configurar NetworkManager (Ignorar CNI)
          copy:
            dest: /etc/NetworkManager/conf.d/rke2-canal.conf
            content: |
              [keyfile]
              unmanaged-devices=interface-name:flannel*;interface-name:cali*;interface-name:tunl*;interface-name:vxlan.calico;interface-name:wireguard.cali
          notify: Reload NetworkManager

    - name: 2. Instalar Binario RKE2 Agent
      shell: |
        curl -sfL https://get.rke2.io | INSTALL_RKE2_VERSION={{ rke2_version }} INSTALL_RKE2_TYPE="agent" sh -
      args:
        creates: /usr/local/bin/rke2

    - name: 3. Configurar RKE2 Agent
      block:
        - name: Crear directorio de configuración
          file:
            path: /etc/rancher/rke2
            state: directory

        - name: Generar config.yaml para el Agente
          copy:
            dest: /etc/rancher/rke2/config.yaml
            content: |
              server: https://{{ master_ip }}:9345
              token: {{ rke2_token }}

    - name: 4. Iniciar Servicio RKE2 Agent
      systemd:
        name: rke2-agent
        state: started
        enabled: yes

  handlers:
    - name: Reload NetworkManager
      systemd:
        name: NetworkManager
        state: reloaded
