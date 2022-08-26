import random
import time
from indices_DR import *
from numpy import array
from scipy.stats import norm, uniform

seed = 100
random.seed(seed)
np.random.seed(seed)

arms_prob = [r.p0, r.p1]
arms_missprob = [r.pmiss0, r.pmiss1]
# arms_prob = [0.6, 0.9]
# arms_missprob = [0, 0]

print("simulating...")
tstart = time.time()
N = int(r.N)
T = int(r.Nt)
# N = 1000
# T = 82
K = len(arms_prob)


# allocate kth treatement arm
def alloKthArm(k):
    return int(random.random() < arms_prob[k])

arms_prior = [[1, 1], [1, 1]]

S_obs = [[[0 for ___ in range(K)] for __ in range(T+1)] for _ in range(N)]
F_obs = [[[0 for ___ in range(K)] for __ in range(T+1)] for _ in range(N)]
N_missing = [[[0 for ___ in range(K)] for __ in range(T+1)] for _ in range(N)]
N1_allocate = [[0 for __ in range(T+1)] for _ in range(N)]


S_observe = [[0 for __ in range(K)] for _ in range(N)]
F_observe = [[0 for __ in range(K)] for _ in range(N)]
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
            indices_value[k] = RandUCB(arms_prior[k][0], S_obs[n][t-1][k], 
                         arms_prior[k][1], F_obs[n][t-1][k], T, t-1, K,
                         S_obs=S_obs, F_obs=F_obs, 
                         n=n, arms_prior=arms_prior, k=k, probs = probs)
                
            best_indices_value = max(indices_value)
            candidates = list(filter(lambda x: indices_value[x] == best_indices_value, list(range(K))))
                
            # if args.shuffle:
            random.shuffle(candidates)
            arm_choice[n][t-1] = candidates[0]
            
            for k in range(K):
                S_obs[n][t][k] = S_obs[n][t-1][k]
                F_obs[n][t][k] = F_obs[n][t-1][k]
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
            # missed 
            else: 
              N_missing[n][t][arm_choice[n][t-1]] += 1                           
    N_miss[n] = N_missing[n][T]
    S_observe[n] = S_obs[n][T]
    F_observe[n] = F_obs[n][T]
    N1[n] = N1_allocate[n][T]


time_elapsed = time.time() - tstart
print(time_elapsed, "seconds.")

