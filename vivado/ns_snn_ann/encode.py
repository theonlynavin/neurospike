import cv2
import numpy as np

img = cv2.imread('digit.png', 0)
img = img.flatten()

def to_fixed(f,e):
    a = f* (2**e)
    b = int(round(a))
    if a < 0:
        b = abs(b)
        b = ~b
        b = b + 1
    return b

def tohex(val, nbits):
    return hex((val + np.int64(1 << nbits)) % (1 << nbits))

h = [tohex(to_fixed(img[i]/255, 15), 32).replace('0x','') for i in range(len(img))]
h = ["00000000"]*20 + h + ["00000000"]*20
h = ['0' * (8 -len(h[i])) + h[i] for i in range(len(h))]

# print(h)

np.savetxt("src/data_in.mem", h, delimiter="\n", fmt="%s")