import random
import time
import math
from indices_DR import *
import numpy as np
from numpy import array

# set seed 
seed = 100
random.seed(seed)
np.random.seed(seed)

arms_prob = [r.p0, r.p1]
arms_missprob = [r.pmiss0, r.pmiss1]

print("simulating...")
tstart = time.time()
N = int(r.N)
T = int(r.Nt)

K = len(arms_prob)


# allocate kth treatement arm
def alloKthArm(k):
    return int(random.random() < arms_prob[k])

# impuate to obtain the response
def imputeRes(impute_success_prob):
    return int(random.random() < impute_success_prob)


method = locals()[r.method_name]
arms_prior = [[1, 1], [1, 1]]

S_fin = [[[0 for ___ in range(K)] for __ in range(T+1)] for _ in range(N)]
F_fin = [[[0 for ___ in range(K)] for __ in range(T+1)] for _ in range(N)]
S_obs = [[[0 for ___ in range(K)] for __ in range(T+1)] for _ in range(N)]
F_obs = [[[0 for ___ in range(K)] for __ in range(T+1)] for _ in range(N)]
S_imp = [[[0 for ___ in range(K)] for __ in range(T+1)] for _ in range(N)]
F_imp = [[[0 for ___ in range(K)] for __ in range(T+1)] for _ in range(N)]
N_missing = [[[0 for ___ in range(K)] for __ in range(T+1)] for _ in range(N)]
N1_allocate = [[0 for __ in range(T+1)] for _ in range(N)]

# initiate probabilities of success for imputation with arms_prob
current_success_prob = [[[0.5 for ___ in range(K)] for __ in range(T+1)] for _ in range(N)]


S_final = [[0 for __ in range(K)] for _ in range(N)]
F_final = [[0 for __ in range(K)] for _ in range(N)]
S_observe = [[0 for __ in range(K)] for _ in range(N)]
F_observe = [[0 for __ in range(K)] for _ in range(N)]
S_impute = [[0 for __ in range(K)] for _ in range(N)]
F_impute = [[0 for __ in range(K)] for _ in range(N)]
N_miss = [[0 for __ in range(K)] for _ in range(N)]
N1 = [0 for _ in range(N)]


# arm choose 0 or 1
arm_choice = [[0 for __ in range(T)] for _ in range(N)]

# --- random seeds generation ---
# numpy_randomGenNorm = Generator(PCG64(seed))
# scipy_randomGenNorm = norm
# scipy_randomGenNorm.random_state=numpy_randomGenNorm


x = np.linspace(0, 1, 20)
probs = norm.pdf(x, loc = 0, scale = 0.125)
probs[-1] = 1e-6# constant probability of choosing the last confidence interval            
probs = probs / np.sum(probs)     

for n in range(N):
    indices_value = [0 for _ in range(K)]
    for t in range(1, T+1):
        miss_obs = [0 for _ in range(K)]
        for k in range(K):
            indices_value[k] = RandUCB(arms_prior[k][0], S_fin[n][t-1][k], 
                         arms_prior[k][1], F_fin[n][t-1][k], T, t-1, K,
                         S_obs=S_obs, F_obs=F_obs, S_imp=S_imp, F_imp=F_imp, 
                         n=n, arms_prior=arms_prior, k=k, probs = probs)
                
            best_indices_value = max(indices_value)
            candidates = list(filter(lambda x: indices_value[x] == best_indices_value, list(range(K))))
                
            # if args.shuffle:
            random.shuffle(candidates)
            arm_choice[n][t-1] = candidates[0]
            for k in range(K):
                S_obs[n][t][k] = S_obs[n][t-1][k]
                F_obs[n][t][k] = F_obs[n][t-1][k]
                S_imp[n][t][k] = S_imp[n][t-1][k]
                F_imp[n][t][k] = F_imp[n][t-1][k]
                S_fin[n][t][k] = S_fin[n][t-1][k]
                F_fin[n][t][k] = F_fin[n][t-1][k]
                N_missing[n][t][k] = N_missing[n][t-1][k]
                N1_allocate[n][t] = N1_allocate[n][t-1]
                
            # ---------------------------------------
            miss_obs[arm_choice[n][t-1]] = (random.random() <= arms_missprob[arm_choice[n][t-1]]) 
            # count the patients allocated to the treatment arm
            if(array(arm_choice[n][t-1]) == 1):
                N1_allocate[n][t] += 1  
            # observed
            if (not(miss_obs[arm_choice[n][t-1]])):
                res = alloKthArm(arm_choice[n][t-1])
                S_obs[n][t][arm_choice[n][t-1]] += res  
                F_obs[n][t][arm_choice[n][t-1]] += 1 - res
            # missed and imputation
            else:
                N_missing[n][t][arm_choice[n][t-1]] += 1
                # ------- imputation after the first observation -----
                if((S_obs[n][t][arm_choice[n][t-1]] + F_obs[n][t][arm_choice[n][t-1]]) != 0):
                    current_success_prob[n][t][arm_choice[n][t-1]] = S_obs[n][t][arm_choice[n][t-1]]/(S_obs[n][t][arm_choice[n][t-1]] + F_obs[n][t][arm_choice[n][t-1]])
                    impute_success_prob = current_success_prob[n][t][arm_choice[n][t-1]]
                    res_imp = imputeRes(impute_success_prob)
                    S_imp[n][t][arm_choice[n][t-1]] += res_imp                
                    F_imp[n][t][arm_choice[n][t-1]] += 1 - res_imp 
            for k in range(K):
                S_fin[n][t][k] = S_imp[n][t][k] + S_obs[n][t][k]
                F_fin[n][t][k] = F_imp[n][t][k] + F_obs[n][t][k] 
            # if we take imputed responses into account for allocation procedure
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

