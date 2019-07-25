# Configuration file for ipython-notebook.
c = get_config()

import os
home = os.path.expanduser('~')

# Notebook config
c.NotebookApp.ip = '*'
c.NotebookApp.open_browser = False
# It is a good idea to put it on a known, fixed port
c.NotebookApp.port = 9999
c.IPKernelApp.pylab = 'inline' 
