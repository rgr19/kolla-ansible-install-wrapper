#!/usr/bin/python
from operator import attrgetter

from ansible.module_utils.basic import *

import re


def main():
    fields = {
        "interfaces": {"type": list},
        "pattern": {"type": str},
    }

    module = AnsibleModule(argument_spec=fields)
    # change the name
    interfaces = module.params["interfaces"]
    pattern = module.params["pattern"]
    interfaces = {re.match(pattern, intf) for intf in interfaces}
    interfaces = filter(None, interfaces)
    interfaces = set(map(lambda x: x.group(0), interfaces))

    module.exit_json(changed=True, ansible_facts={'interfaces': interfaces})


if __name__ == '__main__':
    main()
