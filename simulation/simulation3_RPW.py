import random
import time
import math
import numpy as np


# set seed 
random.seed(100)
rng = np.random.RandomState(100)

N = r.N
T = r.Nt
arms_prob = [r.p0, r.p1]
pmiss1 = r.pmiss1
pmiss0 = r.pmiss0


K = len(arms_prob)
S = [[[0 for ___ in range(K)] for __ in range(T+1)] for _ in range(N)]
F = [[[0 for ___ in range(K)] for __ in range(T+1)] for _ in range(N)]
arm_choice = [[0 for __ in range(T)] for _ in range(N)]

S_final = [[0 for __ in range(K)] for _ in range(N)]
F_final = [[0 for __ in range(K)] for _ in range(N)]
N1 = [0 for _ in range(N)]
N_miss0 = [0 for _ in range(N)]
N_miss1 = [0 for _ in range(N)]

print("simulating...")    
tstart = time.time()
for n in range(N):
    n_miss0 = 0
    n_miss1 = 0
   # urn = [0,1]
    urn = [0, 1]
    for t in range(1, T+1):
# ------------ urn model ------------ 
        ball = int(np.array(random.sample(urn, 1)))
        for k in range(K):
            S[n][t][k] = S[n][t-1][k]
            F[n][t][k] = F[n][t-1][k]
        if ball == 1:
            arm_choice[n][t-1] = 1
            miss_obs1 = (random.random() <= pmiss1) 
            if (not(miss_obs1)):
                res = int(np.random.binomial(1, arms_prob[1], 1))
                S[n][t][arm_choice[n][t-1]] += res
                F[n][t][arm_choice[n][t-1]] += 1 - res
                urn = np.append(urn, int(res == ball))
                urn = urn.tolist()
            else: n_miss1 += 1
        else:
            arm_choice[n][t-1] = 0
            miss_obs0 = (random.random() <= pmiss0) 
            if (not(miss_obs0)):
                res = int(np.random.binomial(1, arms_prob[0], 1))
                S[n][t][arm_choice[n][t-1]] += res
                F[n][t][arm_choice[n][t-1]] += 1 - res
                # update urn
                urn = np.append(urn, int(res == ball))
                urn = urn.tolist()
            else: n_miss0 += 1
# ------------ urn model ------------ 
    N_miss0[n] = n_miss0
    N_miss1[n] = n_miss1

time_elapsed = time.time() - tstart
print(time_elapsed, "seconds.")



for n in range(N):
    S_final[n] = S[n][T]
    F_final[n] = F[n][T]
    N1[n] = sum(arm_choice[n])
