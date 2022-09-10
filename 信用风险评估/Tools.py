# 设置
def jupyter_settings(style='darkgrid', context='notebook', palette=["#39A7D0","#36ADA4"], font_name='SimHei'):
    import matplotlib.pyplot as plt
    import numpy as np
    import pandas as pd
    import seaborn as sns
    # %config IPCompleter.greedy=True
    sns.set()
    # %matplotlib inline
    # %config Inlinebackend.figure_format = 'svg'
    plt.rcParams['axes.unicode_minus'] = False
    plt.rcParams['font.sans-serif'] = font_name
    sns.set_style(style=style)
    sns.set_context(context=context)
    sns.set_palette(palette=palette)

# 忽略警告
def ignore_warnings():
    import warnings
    warnings.filterwarnings('ignore')


