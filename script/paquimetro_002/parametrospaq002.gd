extends Node

const img_paquimetro_x0 = 100

const cur_min_x = 236.00 # trocar6
const cur_max_x = 1255.80 # trocar6

# Fundo de escala do paquimetro
const F = 150.00

const cur_dim_mm = 388.20
const cur_num_div = 51.00 # Trocar

const cur_dx_mm = cur_dim_mm / cur_num_div

const pq_dim_px = cur_max_x - cur_min_x
const pq_num_div = F
const pq_dx_mm = F / pq_num_div

const cur_res = 0.02 # trocar"
