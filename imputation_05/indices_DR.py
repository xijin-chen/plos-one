import random
import math
import pickle
import numpy as np
from scipy.stats import norm, uniform

def choice(options,probs):
    x = np.random.rand()
    cum = 0
    for i,p in enumerate(probs):
        cum += p
        if x < cum:
            break
    return options[i]

# Randomized Upper condfidence bound index
def RandUCB(sk0, skt, fk0, fkt, T, t, K, probs, **kw):
    mu_hat = (sk0 + skt) / (sk0 + fk0 + skt + fkt)
    # m = np.random.choice(20, p=probs)
    m = choice(range(20), probs)
    zt = m/19 
    c = math.sqrt(1/(sk0 + fk0 + skt + fkt)) 
    return  mu_hat + zt*c


