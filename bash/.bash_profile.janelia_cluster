# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

alias emacs=/usr/bin/emacs-26.2

# User specific environment and startup programs
PATH=$PATH:$HOME/bin
export PATH=/usr/local/bin:$PATH
export PYQTGRAPH_QT_LIB='PyQt5'

# Need this to get jupyter notebook to work for interactive jobs
export JUPYTER_RUNTIME_DIR='/scratch/bennettd/' 

# Pyspark settings
export SPARK_HOME='/groups/ahrens/home/bennettd/spark/spark-2.2.1-bin-hadoop2.7'
export PYSPARK_PYTHON='/groups/ahrens/home/bennettd/anaconda3/bin/python'
export PYSPARK_DRIVER_PYTHON='/groups/ahrens/home/bennettd/anaconda3/bin/ipython'
export PYTHON_OPTS_DRIVER='jupyter'
export PYTHON_OPTS_DRIVER_PYTHON='lab'
export PYTHONHASHSEED=0

export PYTHONPATH=/groups/ahrens/home/bennettd/fish/:$PYTHONPATH
export PYTHONPATH=/groups/ahrens/home/bennettd/fishtrack/:$PYTHONPATH
export GIT_EDITOR=emacs

# run zsh
/bin/zsh
