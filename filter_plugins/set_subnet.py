# !/usr/bin/env python

class FilterModule(object):
    def filters(self):
        return {
            'set_subnet': self.set_subnet,
        }

    def set_subnet(self, network: str, subnet: int) -> str:
        network = network.split(".")
        network[-1] = str(subnet)
        network = ".".join(network)
        return network
