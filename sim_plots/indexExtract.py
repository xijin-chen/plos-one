import random
import time
import math
from indices import *
import numpy as np
from numpy import array

N = 1
T = int(r.nt)
seed = 100
random.seed(seed)
np.random.seed(seed)

arms_prob = [r.p0, r.p1]
arms_prior = [[1, 1], [1, 1]]


method = locals()[r.method_name]
# allocate kth treatement arm
def alloKthArm(k):
    return int(random.random() < arms_prob[k])


print("simulating...")
K = len(arms_prob)

tstart = time.time()

# arm choose 0 or 1
S = [[[0 for ___ in range(K)] for __ in range(T+1)] for _ in range(N)]
F = [[[0 for ___ in range(K)] for __ in range(T+1)] for _ in range(N)]

arm_choice = [[0 for __ in range(T)] for _ in range(N)]

x = np.linspace(0, 1, 20)
probs = norm.pdf(x, loc = 0, scale = 0.125)
probs[-1] = 1e-6# constant probability of choosing the last confidence interval            
probs = probs / np.sum(probs)           



indices_value_result = [[[0 for ___ in range(K)] for __ in range(T+1)] for _ in range(N)]
candidates_result = [[[0 for ___ in range(K)] for __ in range(T+1)] for _ in range(N)]

for n in range(N):
    for t in range(1, T+1):
        indices_value = [0 for _ in range(K)]
        for k in range(K):
            indices_value[k] = method(arms_prior[k][0], S[n][t-1][k], arms_prior[k][1],
            F[n][t-1][k], T, t-1, K,
            S=S, F=F, n=n, arms_prior=arms_prior, k=k, probs=probs)
                
            best_indices_value = max(indices_value)
            candidates = list(filter(lambda x: indices_value[x] == best_indices_value, list(range(K))))
                
            # if args.shuffle:
            random.shuffle(candidates)
                
            arm_choice[n][t-1] = candidates[0]
            res = alloKthArm(arm_choice[n][t-1])
                
            for k in range(K):
                S[n][t][k] = S[n][t-1][k]
                F[n][t][k] = F[n][t-1][k]
            S[n][t][arm_choice[n][t-1]] += res
            F[n][t][arm_choice[n][t-1]] += 1 - res
        indices_value_result[n][t] = indices_value    
        candidates_result[n][t] = candidates 

time_elapsed = time.time() - tstart
print(time_elapsed, "seconds.")


S_final = [[0 for __ in range(K)] for _ in range(T)]
F_final = [[0 for __ in range(K)] for _ in range(T)]
indices_final = [[0 for __ in range(K)] for _ in range(T)]
candidate_final = [[0 for __ in range(K)] for _ in range(T)]

S_final= S[n]
F_final = F[n]
indices_final= indices_value_result[n]
candidate_final = candidates_result[n]
