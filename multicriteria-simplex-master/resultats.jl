-----exemple généré-----
C[3,5]
A[3,5]
-P1-
X0 = [0.714286, 3.0, 0.0, 0.0, 0.0, 0.0, -2.0]
-P2-
u = [0.0, 0.0, 0.0] w = [1.0, 1.0, 1.0]
First basis : [1, 2, 3, 7]
-P3-
B = [1, 2, 3, 7]
    x4:Inefficient variable
    x5:x3 ==> Nouvelle base 
    x6:x7 ==> Nouvelle base 
B = [1, 2, 5, 7]
    x3:x5 ==> Base déja vue
    x4:Inefficient variable
    x6:x7 ==> Nouvelle base 
B = [1, 2, 3, 6]
    x4:Inefficient variable
    x5:x3 ==> Base déja vue
    x7:Inefficient variable
B = [1, 2, 5, 6]
    x3:x5 ==> Base déja vue
    x4:Inefficient variable
    x7:Inefficient variable
  0.002054 seconds (4.31 k allocations: 1.734 MiB)

Bases : Array{Int64,1}[[1, 2, 3, 7], [1, 2, 5, 7], [1, 2, 3, 6], [1, 2, 5, 6]]
Sol associées : Any[[0.961511, 2.56735, 0.721075, -0.163226], [0.972284, 2.5485, 0.564372, -0.257489], [0.909356, 2.6, 0.627582, -0.234505], [0.915666, 2.6, 0.476208, -0.190335]]

-----exemple généré-----
C[7,6]
A[3,6]
-P1-
X0 = [0.0, 0.0, 0.5, 0.5, 0.0, 0.0, 19.0, 0.0]
-P2-
u = [0.730769, 0.0, 0.0] w = [1.0, 2.19231, 1.0, 1.83333, 1.0, 1.0, 1.0]
First basis : [3, 4, 7]
-P3-
B = [3, 4, 7]
    x1:x7 ==> Nouvelle base 
    x2:x7 ==> Nouvelle base 
    x5:Rayon infini
    x6:x3 ==> Nouvelle base 
    x8:Rayon infini
B = [3, 4, 1]
    x2:x1 ==> Base déja vue
    x5:Rayon infini
    x6:x3 ==> Nouvelle base 
    x7:x1 ==> Base déja vue
    x8:Rayon infini
B = [3, 4, 2]
    x1:x2 ==> Base déja vue
    x5:Rayon infini
    x6:Rayon infini
    x7:x2 ==> Base déja vue
    x8:Rayon infini
B = [6, 4, 7]
    x1:x7 ==> Base déja vue
    x2:Rayon infini
    x3:x6 ==> Base déja vue
    x5:Rayon infini
    x8:Rayon infini
B = [6, 4, 1]
    x2:Rayon infini
    x3:x6 ==> Base déja vue
    x5:Rayon infini
    x7:x1 ==> Base déja vue
    x8:Rayon infini
  0.005094 seconds (8.86 k allocations: 642.711 KiB)

Bases : Array{Int64,1}[[3, 4, 7], [3, 4, 1], [3, 4, 2], [6, 4, 7], [6, 4, 1]]
Sol associées : Any[[0.5, 0.5, 19.0], [0.5, 0.5, 2.71429], [2.7619, 0.5, 2.71429], [3.0, 0.5, 25.0], [3.0, 0.5, 3.57143]]

-----exemple généré-----
C[3,6]
A[2,6]
-P1-
X0 = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 17.0, 18.0]
-P2-
u = [0.777778, 0.0] w = [1.0, 1.0, 1.0]
First basis : [2, 8]
-P3-
B = [2, 8]
    x1:Inefficient variable
    x3:Inefficient variable
    x4:x2 ==> Nouvelle base 
    x5:Inefficient variable
    x6:x2 ==> Nouvelle base 
    x7:Inefficient variable
B = [4, 8]
    x1:Rayon infini
    x2:x4 ==> Base déja vue
    x3:Inefficient variable
    x5:Inefficient variable
    x6:x4 ==> Base déja vue
    x7:Inefficient variable
B = [6, 8]
    x1:Inefficient variable
    x2:x6 ==> Base déja vue
    x3:Inefficient variable
    x4:x6 ==> Base déja vue
    x5:Inefficient variable
    x7:Inefficient variable
  0.002484 seconds (4.54 k allocations: 342.016 KiB)

Bases : Array{Int64,1}[[2, 8], [4, 8], [6, 8]]
Sol associées : Any[[1.88889, 18.0], [17.0, 86.0], [5.66667, 18.0]]

-----exemple généré-----
C[3,17]
A[19,17]
-P1-
X0 = [0.0, 1.95124, 6.04157, 0.979332, 4.02137, 0.0, 0.275686, 0.829454, 0.701189, 1.49578, 0.825785, 0.933189, 0.365501, 3.94486, 1.201, 0.0, 0.219982, -7.10543e-15, -1.77636e-15, 17.6572, 20.7311, 3.55271e-15, 0.0, -2.66454e-15, 52.5352, -3.55271e-15, 7.10543e-15, 7.10543e-15, 27.3349, 7.10543e-15, 1.77636e-15, -0.499625, 0.0]
-P2-
u = [2.42035, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.903692, 0.0, 0.0, 2.09708, 0.0, 0.0, 0.0, 1.24923, 0.0, 0.0, 2.11128] w = [2.30584, 2.55487, 1.0]
First basis : [2, 3, 5, 6, 7, 8, 10, 11, 12, 13, 14, 15, 18, 19, 20, 21, 22, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33]
-P3-
B = [2, 3, 5, 6, 7, 8, 10, 11, 12, 13, 14, 15, 18, 19, 20, 21, 22, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33]
    x1:Inefficient variable
    x4:Inefficient variable
    x9:Inefficient variable
    x16:Inefficient variable
    x17:x14 ==> Nouvelle base 
    x23:x18 ==> Nouvelle base 
B = [2, 3, 5, 6, 7, 8, 10, 11, 12, 13, 17, 15, 18, 19, 20, 21, 22, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33]
    x1:Inefficient variable
    x4:Inefficient variable
    x9:Inefficient variable
    x14:x26 ==> Nouvelle base 
    x16:Inefficient variable
    x23:x32 ==> Nouvelle base 
B = [2, 3, 5, 6, 7, 8, 10, 11, 12, 13, 14, 15, 23, 19, 20, 21, 22, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33]
    x1:x2 ==> Nouvelle base 
    x4:Inefficient variable
    x9:x2 ==> Nouvelle base 
    x16:Inefficient variable
    x17:x14 ==> Nouvelle base 
    x18:Inefficient variable
B = [2, 3, 5, 6, 7, 8, 10, 11, 12, 13, 17, 15, 18, 19, 20, 21, 22, 24, 25, 14, 27, 28, 29, 30, 31, 32, 33]
    x1:Inefficient variable
    x4:Inefficient variable
    x9:Inefficient variable
    x16:Inefficient variable
    x23:Inefficient variable
    x26:Inefficient variable
B = [2, 3, 5, 6, 7, 8, 10, 11, 12, 13, 17, 15, 18, 19, 20, 21, 22, 24, 25, 26, 27, 28, 29, 30, 31, 23, 33]
    x1:Inefficient variable
    x4:Inefficient variable
    x9:Inefficient variable
    x14:Inefficient variable
    x16:Inefficient variable
    x32:Inefficient variable
B = [1, 3, 5, 6, 7, 8, 10, 11, 12, 13, 14, 15, 23, 19, 20, 21, 22, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33]
    x2:Inefficient variable
    x4:Inefficient variable
    x9:Inefficient variable
    x16:Inefficient variable
    x17:Inefficient variable
    x18:Inefficient variable
B = [9, 3, 5, 6, 7, 8, 10, 11, 12, 13, 14, 15, 23, 19, 20, 21, 22, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33]
    x1:Inefficient variable
    x2:Inefficient variable
    x4:Inefficient variable
    x16:Inefficient variable
    x17:Inefficient variable
    x18:Inefficient variable
B = [2, 3, 5, 6, 7, 8, 10, 11, 12, 13, 17, 15, 23, 19, 20, 21, 22, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33]
    x1:Inefficient variable
    x4:Inefficient variable
    x9:Inefficient variable
    x14:Inefficient variable
    x16:Inefficient variable
    x18:Inefficient variable
  0.019460 seconds (19.77 k allocations: 4.964 MiB, 34.75% gc time)

Bases : Array{Int64,1}[[2, 3, 5, 6, 7, 8, 10, 11, 12, 13, 14, 15, 18, 19, 20, 21, 22, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33], [2, 3, 5, 6, 7, 8, 10, 11, 12, 13, 17, 15, 18, 19, 20, 21, 22, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33], [2, 3, 5, 6, 7, 8, 10, 11, 12, 13, 14, 15, 23, 19, 20, 21, 22, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33], [2, 3, 5, 6, 7, 8, 10, 11, 12, 13, 17, 15, 18, 19, 20, 21, 22, 24, 25, 14, 27, 28, 29, 30, 31, 32, 33], [2, 3, 5, 6, 7, 8, 10, 11, 12, 13, 17, 15, 18, 19, 20, 21, 22, 24, 25, 26, 27, 28, 29, 30, 31, 23, 33], [1, 3, 5, 6, 7, 8, 10, 11, 12, 13, 14, 15, 23, 19, 20, 21, 22, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33], [9, 3, 5, 6, 7, 8, 10, 11, 12, 13, 14, 15, 23, 19, 20, 21, 22, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33], [2, 3, 5, 6, 7, 8, 10, 11, 12, 13, 17, 15, 23, 19, 20, 21, 22, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33]]
Sol associées : Any[[-0.214479, 4.24328, 1.36214, 3.0641, -2.55062, 1.51504, -1.1604, 1.76801, 0.837327, 1.36123, 0.455358, -0.427444, 0.606967, 3.27318, -5.03842, 2.13939, -20.163, -12.8362, 20.5542, -14.1692, -4.70472, -10.0677, 15.1417, 7.3375, 9.63857, 3.91051, 5.68981], [0.770218, 4.92925, -0.229636, 4.36285, -3.26517, 1.59213, -2.07811, 1.43166, 1.08759, 0.856213, -2.61978, -1.67288, -5.04495, 5.5588, -2.28733, -5.59822, -10.4056, -14.9717, 7.75474, -2.85371, -3.22323, -11.1045, 25.1084, 8.59112, 1.3689, -1.73795, 6.96138], [0.0551185, 3.67542, 0.476824, 2.79531, -2.92249, 1.64356, -1.60719, 1.10173, 0.566973, 1.18492, 0.342895, -0.726197, -15.3903, 5.31519, -3.7046, 2.04931, -19.2639, -7.90334, 17.5831, -15.6933, -2.77345, -7.10804, 11.6408, 3.26811, 10.6059, 3.33565, 4.16314], [1.10512, 5.78657, -0.156055, 4.05441, -2.75832, 1.60944, -2.11605, 1.21803, 1.02701, 0.464582, -3.20116, -1.25419, -5.13406, 5.64098, -1.40714, 0.129662, -3.50402, -13.788, 10.1488, 0.859586, -2.97088, -11.6095, 26.2011, 7.28369, 1.50758, -0.875157, 7.01558], [0.858472, 4.44409, -0.715207, 3.95048, -3.72638, 1.80546, -2.71472, 0.764298, 1.10986, 0.617779, -2.39261, -2.14429, -5.25984, 7.96431, -3.29431, -3.79097, -8.13072, -7.48831, 4.11421, -8.32608, 0.967367, -13.2388, 21.9716, 6.93405, 2.82405, -9.50676, 2.36219], [0.0588802, 1.56616, -0.00134563, 4.12654, -3.88939, 1.0645, -2.8943, 1.32107, 0.746622, 1.68572, -0.819651, -2.14171, -9.28623, 0.581835, 3.4833, 0.665594, -11.7886, -9.78909, 4.33671, -8.12645, 2.83937, -10.3245, 17.5691, 5.77771, 6.89759, 13.6346, 1.8066], [-0.685635, 1.21796, 1.14594, 2.26725, -0.996483, 0.0475446, -1.45435, 1.60562, 0.977086, 1.52991, -0.745045, -2.72468, -10.7613, -8.34677, -19.1221, 8.31076, -12.9203, -5.16736, 15.9871, -11.3971, -4.93318, -14.188, 17.4808, 6.42159, -1.44038, -9.31294, -4.44228], [1.03001, 4.14018, -0.915204, 3.79278, -3.20687, 1.54631, -2.42309, 0.750324, 0.828823, 0.644225, -2.63521, -2.00143, -15.9549, 5.832, -2.4426, -4.1101, -8.91307, -8.8053, 4.91906, -4.72073, -1.87673, -7.60879, 18.8894, 4.35637, 1.68986, -3.68884, 4.72515]]

-----exemple généré-----
C[9,6]
A[1,6]
-P1-
X0 = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0]
-P2-
u = [0.0] w = [1.0, 1.0, 1.0, 1.0, 1.5, 1.0, 1.0, 1.0, 2.25]
First basis : [7]
-P3-
B = [7]
    x1:Rayon infini
    x2:x7 ==> Nouvelle base 
    x3:Rayon infini
    x4:x7 ==> Nouvelle base 
    x5:Rayon infini
    x6:Rayon infini
B = [2]
    x1:Rayon infini
    x3:Rayon infini
    x4:x2 ==> Base déja vue
    x5:Rayon infini
    x6:Rayon infini
    x7:x2 ==> Base déja vue
B = [4]
    x1:Rayon infini
    x2:x4 ==> Base déja vue
    x3:Rayon infini
    x5:Rayon infini
    x6:Rayon infini
    x7:x4 ==> Base déja vue
  0.004055 seconds (6.86 k allocations: 501.891 KiB)

Bases : Array{Int64,1}[[7], [2], [4]]
Sol associées : Any[[4.0], [0.666667], [0.666667]]


