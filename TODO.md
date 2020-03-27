Fix certificates

TASK [service-ks-register : keystone | Creating services] ***********************************************************                                                                                                                        
Friday 27 March 2020  04:49:08 -0400 (0:00:07.762)       0:07:27.525 **********                                                                                                                                                              
FAILED - RETRYING: keystone | Creating services (5 retries left).                                                                                                                                                                            
FAILED - RETRYING: keystone | Creating services (4 retries left).                                                                                                                                                                            
FAILED - RETRYING: keystone | Creating services (3 retries left).                                                                                                                                                                            
FAILED - RETRYING: keystone | Creating services (2 retries left).                                                                                                                                                                            
FAILED - RETRYING: keystone | Creating services (1 retries left).                                                                                                                                                                            
failed: [192.168.8.158] (item={u'service_type': u'identity', u'name': u'keystone'}) => {                                                                                                                                                     
    "action": "os_keystone_service",                                                                                                                                                                                                         
    "ansible_loop_var": "item",                                                                                                                                                                                                              
    "attempts": 5,                                                                                                                                                                                                                           
    "changed": false,                                                                                                                                                                                                                        
    "item": {                                                                                                                                                                                                                                
        "description": "Openstack Identity Service",                                                                                                                                                                                         
        "endpoints": [                                                                                                                                                                                                                       
            {                                                                                                                                                                                                                                
                "interface": "admin",                                                                                                                                                                                                        
                "url": "https://10.0.0.10:35357"                                                                                                                                                                                             
            },                                                                                                                                                                                                                               
            {                                                                                                                                                                                                                                
                "interface": "internal",                                                                                                                                                                                                     
                "url": "https://10.0.0.10:5000"                                                                                                                                                                                              
            },                                                                                                                                                                                                                               
            {                                                                                                                                                                                                                                
                "interface": "public",                                                                                                                                                                                                       
                "url": "https://10.0.0.15:5000"                                                                                                                                                                                              
            }
        ], 
        "name": "keystone", 
        "type": "identity"
    }, 
    "rc": 1
}

MSG:

MODULE FAILURE
See stdout/stderr for the exact error


MODULE_STDERR:
