% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/GoFTest_BetaSBM.R
\name{goftest_BetaSBM}
\alias{goftest_BetaSBM}
\title{Monte Carlo goodness-of-fit test for a beta stochastic blockmodel (beta-SBM)}
\usage{
goftest_BetaSBM(A, K = NULL, C = NULL, numGraphs = 100)
}
\arguments{
\item{A}{n by n binary symmetric adjacency matrix representing an undirected graph where n is the number of nodes in the graph}

\item{K}{positive integer scalar representing the number of blocks; K>1}

\item{C}{positive integer vector of size n for block assignments of each node; from 1 to K (no of blocks)}

\item{numGraphs}{number of graphs to be sampled; default value is 100}
}
\value{
A list with the elements
\item{statistic}{the values of the chi-square test statistics on each sampled graph}
\item{p.value}{the p-value for the test}
}
\description{
\code{goftest_BetaSBM} performs chi square goodness-of-fit test for network data considering the model as beta-SBM (Karwa et al. (2023))
}
\examples{

RNGkind(sample.kind = "Rounding")
set.seed(1729)

# We model a network with 3 even classes
n1 = 10
n2 = 10
n3 = 10

# Generating block assignments for each of the nodes
n = n1 + n2 + n3
class = rep(c(1, 2, 3), c(n1, n2, n3))

# Generating the adjacency matrix of the network
# Generate the matrix of connection probabilities
cmat = matrix(
  c(
    0.80, 0.05, 0.05,
    0.05, 0.80, 0.05,
    0.05, 0.05, 0.80
  ),
  ncol = 3,
  byrow = TRUE
)
pmat = cmat / n

# Creating the n x n adjacency matrix
adj <- matrix(0, n, n)
for (i in 2:n) {
  for (j in 1:(i - 1)) {
    p = pmat[class[i], class[j]] # We find the probability of connection with the weights
    adj[i, j] = rbinom(1, 1, p) # We include the edge with probability p
  }
}

adjsymm = adj + t(adj)

# When class assignment is known
out = goftest_BetaSBM(adjsymm, C = class, numGraphs = 10)

chi_sq_seq = out$statistic
pvalue = out$p.value
print(pvalue)

# Plotting histogram of the sequence of the test statistics
hist(chi_sq_seq, 20, xlab = "chi-square test statistics", main = NULL)
abline(v = chi_sq_seq[1], col = "red", lwd = 5) # adding test statistic on the observed network
legend("topleft", legend = paste("observed GoF = ", chi_sq_seq[1]))

}
\references{
Karwa et al. (2023). "Monte Carlo goodness-of-fit tests for degree corrected and related stochastic blockmodels",
\emph{Journal of the Royal Statistical Society Series B: Statistical Methodology},
\doi{https://doi.org/10.1093/jrsssb/qkad084}
}
