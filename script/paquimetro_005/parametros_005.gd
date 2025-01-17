extends Node

const img_paquimetro_x0 = 103

const cur_min_x = 223.00 # trocar
const cur_max_x = 1053.00 # trocar

# Fundo de escala do paquimetro
const F = 150.0

const cur_dim_mm = 209.00
const cur_num_div = 21.00 # Trocar

const cur_dx_mm = cur_dim_mm / cur_num_div

const pq_dim_px = cur_max_x - cur_min_x
const pq_num_div = F
const pq_dx_mm = F / pq_num_div

const cur_res = 0.05 # trocar"
