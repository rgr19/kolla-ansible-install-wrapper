# Ansible starter 

## Issues

### Centos 7 with Python 2.7.5

Python <= 2.7.9 will not trust self-signed or privately signed CAs even
if they are added into the OS trusted CA folder and update-ca-trust is
executed. This is also true for the Python Requests library, regardless of
Python version. For services that run Python <= 2.7.9 or rely on the
Python Requests library, either CA verification must be explicitly disabled
in the service or the path to the CA certificate must be configured using
the ``openstack_cacert`` parameter.

### Certificates

Set in globals.yml

```yml
#############
# TLS options
#############
# To provide encryption and authentication on the kolla_external_vip_interface,
# TLS can be enabled.  When TLS is enabled, certificates must be provided to
# allow clients to perform authentication.

# NOTE ERROR (with self signed certs)
#     TASK [service-ks-register : keystone | Creating services] ***********************************************************************************************************************************************************************************
#     Friday 27 March 2020  16:36:15 -0400 (0:00:09.770)       0:08:41.940 **********
#     FAILED - RETRYING: keystone | Creating services (5 retries left).
#     FAILED - RETRYING: keystone | Creating services (4 retries left).
#     FAILED - RETRYING: keystone | Creating services (3 retries left).
#     FAILED - RETRYING: keystone | Creating services (2 retries left).
#     FAILED - RETRYING: keystone | Creating services (1 retries left).

#    When ‘kolla_copy_ca_into_containers’ is configured to ‘yes’, the certificate authority files in /etc/kolla/certificates/ca
#    will be copied into service containers to enable trust for those CA certificates. This is required for any certificates
#    that are either self-signed or signed by a private CA, and are not already present in the service image trust store.
#    Otherwise, either CA validation will need to be explicitly disabled or the path to the CA certificate must be configured
#    in the service using the openstack_cacert parameter.
kolla_copy_ca_into_containers: "yes"

# Openstack CA certificate bundle file
# CA bundle file must be added to both the Horizon and Kolla Toolbox containers

{% endraw %}
{% if ansible_python_version.replace("python","") is version_compare('2.7.9', '<=') %}{% raw %}

kolla_enable_tls_internal: "no"
kolla_enable_tls_external: "yes"

#    Python <= 2.7.9 will not trust self-signed or privately signed CAs even
#    if they are added into the OS trusted CA folder and update-ca-trust is
#    executed. This is also true for the Python Requests library, regardless of
#    Python version. For services that run Python <= 2.7.9 or rely on the
#    Python Requests library, either CA verification must be explicitly disabled
#    in the service or the path to the CA certificate must be configured using
#    the ``openstack_cacert`` parameter.

openstack_cert: "{{ node_config }}/certificates/haproxy.pem"
openstack_cacert: "{{ node_config }}/certificates/haproxy-ca.crt"

kolla_external_fqdn_cert: "{{ openstack_cert }}"
kolla_external_fqdn_cacert: "{{ openstack_cacert }}"

{% endraw %}{% else %}{% raw %}

kolla_enable_tls_internal: "yes"
kolla_enable_tls_external: "yes"
# kolla_enable_tls_external: "{{ kolla_enable_tls_internal if kolla_same_external_internal_vip | bool else 'no' }}"

openstack_cacert: ""
openstack_cert: ""

kolla_external_fqdn_cert: "{{ node_config }}/certificates/haproxy.pem"
kolla_internal_fqdn_cert: "{{ node_config }}/certificates/haproxy-internal.pem"
kolla_external_fqdn_cacert: "{{ node_config }}/certificates/haproxy-ca.crt"
kolla_internal_fqdn_cacert: "{{ node_config }}/certificates/haproxy-ca-internal.crt"
{% endraw %}{% endif %}{% raw %}
```

## Nova endpoints

ok: [192.168.8.158] => (item={u'url': u'http://10.0.0.10:8774/v2/%(tenant_id)s', u'interface': u'admin', u'service': u'nova_legacy'})
ok: [192.168.8.158] => (item={u'url': u'http://10.0.0.10:8774/v2/%(tenant_id)s', u'interface': u'internal', u'service': u'nova_legacy'})                                                                                                     
ok: [192.168.8.158] => (item={u'url': u'https://10.0.0.15:8774/v2/%(tenant_id)s', u'interface': u'public', u'service': u'nova_legacy'})
ok: [192.168.8.158] => (item={u'url': u'http://10.0.0.10:8774/v2.1', u'interface': u'admin', u'service': u'nova'})
ok: [192.168.8.158] => (item={u'url': u'http://10.0.0.10:8774/v2.1', u'interface': u'internal', u'service': u'nova'})
ok: [192.168.8.158] => (item={u'url': u'https://10.0.0.15:8774/v2.1', u'interface': u'public', u'service': u'nova'})         
