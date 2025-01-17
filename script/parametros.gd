extends Node

const img_paquimetro_x0 = 50

const cur_min_x = 187 # trocar
const cur_max_x = 755.6 # trocar

# Fundo de escala do paquimetro
const F = 5.812

const cur_dim_pol = 1/16
const cur_num_div = 8 # Trocar

const cur_dx_pol = cur_dim_pol / cur_num_div

const pq_dim_px = cur_max_x
const pq_num_div = F
const pq_dx_mm = F / pq_num_div

const cur_res = 1/128 # trocar
