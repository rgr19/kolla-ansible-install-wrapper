# BEGIN ANSIBLE MANAGED BLOCK
python -c "print('#'*200)"
echo "#### Local SSH wrapper for /home/kolla/kolla_ansible_run_demo_image.sh"
python -c "print('='*200)"
export TERM=xterm
echo "Execute this script to connect to kolla and start deployment of kolla-ansible..."
ssh kolla@192.168.8.158 \
  -i files/ssh/id_rsa_kolla \
  -o UserKnownHostsFile=/dev/null \
  -o StrictHostKeyChecking=no \
  -t \
  "bash /home/kolla/kolla_ansible_run_demo_image.sh"
python -c "print('#'*200)"
# END ANSIBLE MANAGED BLOCK
