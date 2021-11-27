polyinv = polyinv or {}

print '[~] LIB - Inventory Init.'

library.server 'config/polyitems'

library.server 'polyinv/server'
library.server 'polyinv/head/server'

library.client 'polyinv/client'
library.client 'polyinv/head/client'
