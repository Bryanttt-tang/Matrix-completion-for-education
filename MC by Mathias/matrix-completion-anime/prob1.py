import numpy as np
import cvxpy as cp
import pandas as pd
import scipy as scipy
import cvxopt
import mosek
import ecos


anime_df = pd.read_csv("anime_upload_scifi_new_index.csv", header=0)
rating_df = pd.read_csv("rating_upload_scifi_new_index.csv", header=0)

anime = anime_df.to_numpy()
rating = rating_df.to_numpy()
anime[:,0] = anime[:,0]-1
rating[:,0] = rating[:,0]-1;
rating[:,1] = rating[:,1]-1;

# use first 100 users and 1000 animes
# anime = anime[0:999,:]

n_ani = 500
n_rat = 50
rating = rating[rating[:,1]<=n_ani-1,:]
rating = rating[rating[:,0]<=n_rat-1,:]

known_value_indices = tuple(zip(*rating[:,0:2].tolist()))
known_values = rating[:,2].tolist()

#n_rat = rating[:,0].max() + 1
#n_ani = anime[:,0].max() + 1

X = cp.Variable((n_rat, n_ani), pos=True)
W1 = cp.Variable((n_rat,n_rat))
W2 = cp.Variable((n_ani,n_ani))
t = cp.Variable(1)
#objective_fn = cp.normNuc(X)
objective_fn = t
#objective_fn = cp.norm(X,2)
constraints = [
  X[known_value_indices] == known_values,
   # X[10,1] == 1,
   cp.bmat([[W1, X],[X.T, W2]]) >> 0,
   cp.trace(W1) + cp.trace(W2) <= 2*t
]

problem = cp.Problem(cp.Minimize(objective_fn), constraints)
problem.solve(solver=cp.SCS, verbose=True, use_indirect=True)
print("Optimal value: ", problem.value)
print("X:\n", X.value)
