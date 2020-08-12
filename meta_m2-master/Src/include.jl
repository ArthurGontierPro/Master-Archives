using  DataFrames,CSV,DelimitedFiles,JuMP,Gurobi,StatsBase
####################################################.
#includes
include("structures.jl")
include("tools.jl")
include("parser.jl")
include("model.jl")
include("epsconstraint.jl")
include("KetS.jl")
####################################################
solver = Gurobi.Optimizer
const GUROBI_ENV = Gurobi.Env()
