import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import seaborn as sns
import warnings


# 设置
def jupyter_settings(style='white', context='notebook', palette='husl', font_name='SimHei'):
    plt.rcParams['axes.unicode_minus'] = False
    plt.rcParams['font.sans-serif'] = font_name
    sns.set_style(style=style)
    sns.set_context(context=context)
    sns.set_palette(palette=palette)

# 忽略警告
def ignore_warnings():
    warnings.filterwarnings('ignore')
