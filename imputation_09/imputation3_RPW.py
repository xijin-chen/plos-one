import random
import time
import math
import numpy as np

# set seed 
random.seed(100)
rng = np.random.RandomState(100)


print("simulating...")

N = r.N
T = r.Nt
arms_prob = [r.p0, r.p1]
arms_missprob = [r.pmiss0, r.pmiss1]


K = len(arms_prob)
# ----------------------
S_fin = [[[0 for ___ in range(K)] for __ in range(T+1)] for _ in range(N)]
F_fin = [[[0 for ___ in range(K)] for __ in range(T+1)] for _ in range(N)]
S_obs = [[[0 for ___ in range(K)] for __ in range(T+1)] for _ in range(N)]
F_obs = [[[0 for ___ in range(K)] for __ in range(T+1)] for _ in range(N)]
S_imp = [[[0 for ___ in range(K)] for __ in range(T+1)] for _ in range(N)]
F_imp = [[[0 for ___ in range(K)] for __ in range(T+1)] for _ in range(N)]
N_missing = [[[0 for ___ in range(K)] for __ in range(T+1)] for _ in range(N)]
N1_allocate = [[0 for __ in range(T+1)] for _ in range(N)]

current_success_prob = [[[0.9 for ___ in range(K)] for __ in range(T+1)] for _ in range(N)]


arm_choice = [[0 for __ in range(T)] for _ in range(N)]

S_final = [[0 for __ in range(K)] for _ in range(N)]
F_final = [[0 for __ in range(K)] for _ in range(N)]
S_observe = [[0 for __ in range(K)] for _ in range(N)]
F_observe = [[0 for __ in range(K)] for _ in range(N)]
S_impute = [[0 for __ in range(K)] for _ in range(N)]
F_impute = [[0 for __ in range(K)] for _ in range(N)]
N_miss = [[0 for __ in range(K)] for _ in range(N)]
N1 = [0 for _ in range(N)]

# impuate to obtain the response
def imputeRes(impute_success_prob):
    return int(random.random() < impute_success_prob)

    
tstart = time.time()
for n in range(N):
    urn = [0,1]
    for t in range(1, T+1):
        miss_obs = [0 for _ in range(K)]
# ------------ urn model ------------ 
        ball = int(np.array(random.sample(urn, 1)))
        if (ball == 1):
            N1_allocate[n][t-1] += 1
        miss_obs[ball] = (random.random() <= arms_missprob[ball]) 
        for k in range(K):
            S_obs[n][t][k] = S_obs[n][t-1][k]
            F_obs[n][t][k] = F_obs[n][t-1][k]
            S_imp[n][t][k] = S_imp[n][t-1][k]
            F_imp[n][t][k] = F_imp[n][t-1][k]
            S_fin[n][t][k] = S_fin[n][t-1][k]
            F_fin[n][t][k] = F_fin[n][t-1][k]
            N_missing[n][t][k] = N_missing[n][t-1][k]
            N1_allocate[n][t] = N1_allocate[n][t-1]
        # observed
        if (not(miss_obs[ball])):
            res = int(rng.binomial(1, arms_prob[ball], 1))
            if (res == 1):
                urn = np.append(urn, ball)
            else:
                urn = np.append(urn, 1-ball)
            urn = urn.tolist()
            S_obs[n][t][ball] += res
            F_obs[n][t][ball] += 1 - res
        # missed and imputation
        else:
            N_missing[n][t][ball] += 1  
            # ------------------ impute based on observations if there are ------------------
            if((S_obs[n][t][arm_choice[n][t-1]] + F_obs[n][t][arm_choice[n][t-1]]) != 0):
                current_success_prob[n][t][arm_choice[n][t-1]] = S_obs[n][t][arm_choice[n][t-1]]/(S_obs[n][t][arm_choice[n][t-1]] + F_obs[n][t][arm_choice[n][t-1]])
            # ------------------ impute based on observations if there are ------------------
            impute_prob = current_success_prob[n][t][ball]
            res_imp = imputeRes(impute_prob)
            # update urn
            if (res_imp == 1):
                urn = np.append(urn, ball)
            else:
                urn = np.append(urn, 1-ball)
            urn = urn.tolist()
            S_imp[n][t][ball] += res_imp                
            F_imp[n][t][ball] += 1 - res_imp 
        for k in range(K):
            S_fin[n][t][k] = S_imp[n][t][k] + S_obs[n][t][k]
            F_fin[n][t][k] = F_imp[n][t][k] + F_obs[n][t][k] 
# ------------ urn model ------------ 
    N_miss[n] = N_missing[n][T]
    S_observe[n] = S_obs[n][T]
    F_observe[n] = F_obs[n][T]
    S_impute[n] = S_imp[n][T]
    F_impute[n] = F_imp[n][T]
    S_final[n] = S_fin[n][T]
    F_final[n] = F_fin[n][T]
    N1[n] = N1_allocate[n][T]


time_elapsed = time.time() - tstart
print(time_elapsed, "seconds.")



