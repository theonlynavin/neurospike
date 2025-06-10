
import numpy as np
from scipy.special import softmax

def to_float(x,e):
    x=int(x)
    c = abs(x)
    sign = 1 
    if x < 0:
        c = x - 1 
        c = ~c
        sign = -1
    f = (1.0 * c) / (2 ** e)
    f = f * sign
    return f

import csv
r = csv.reader(open("ns_hw/ns_hw.sim/sim_1/behav/xsim/neural.txt"))

#fpga_fixed = [l[0].split('neuron_out:')[1].strip().split(' ')[0] for l in r]
fpga_fixed = [l[0].strip() for l in r]
print(fpga_fixed)
fpga_floats = [to_float(fpga_fixed[i], 45) for i in range(10)]

print(softmax(fpga_floats))
print(np.argsort(softmax(fpga_floats))[::-1])