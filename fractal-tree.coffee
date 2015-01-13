canvas = document.getElementById("myCanvas")
c = canvas.getContext("2d")

# Simple helper functions
decimalToHex = (d, padding) ->
  hex = Number(Math.round(d)).toString(16)
  hex = "0" + hex while (hex.length < padding)
  hex

# Our 2D Drawing Environment
whole_canvas = [0,0,canvas.width, canvas.height]
max_y = canvas.height

# Our 3D Environment
bbox_radius = 5
bbox_height = 10
ws_bbox = [[-bbox_radius, 0, -bbox_radius],[bbox_radius, bbox_height, bbox_radius]]

# 2D/3D transforms
ra_xrange = ws_bbox[1][0] - ws_bbox[0][0]
x_per = (val) ->  (val - ws_bbox[0][0]) / ra_xrange
x_trans = (val) -> x_per(val) * canvas.width # X range is canvas width
y_trans = (val) -> (1-val/bbox_height) * max_y # Y range is canvas height
z_trans = (val) -> x_per(val) * 9 + 1 # Z range is 1 to 10
draw_trans = (val) -> {x: x_trans(val.x), y: y_trans(val.y), z: z_trans(val.z)}

# Clean the screen function
cls = () ->
  c.fillStyle = 'black'
  c.fillRect.apply(c, whole_canvas)

draw_line = (line) ->
  c.beginPath()
  new_pos = draw_trans(line[0])
  c.moveTo(new_pos.x,new_pos.y)
  new_pos = draw_trans(line[1])
  c.lineTo(new_pos.x,new_pos.y)
  c.stroke()

vec_dot = (v1, v2) ->
  v1.x * v2.x + v1.y * v2.y + v1.z * v2.z
#  {x: v1.x * v2.x, y: v1.y * v2.y, z: v1.z * v2.z}

vec_xform = (v, xform) ->
  {x: vec_dot(v, {x: xform[0].x, y: xform[1].x, z: xform[0].z}),
  y: vec_dot(v, {x: xform[0].y, y: xform[1].y, z: xform[1].z}),
  z: xform[0].z}

draw_split = (xform) ->
  sq3_2 = Math.sqrt(3)/2
  base_l = {x: -sq3_2, y: 0.5, z:1.0}
  base_r = {x: sq3_2, y: 0.5, z:1.0}
  new_l = vec_xform(base_l, xform)
  new_r = vec_xform(base_r, xform)
  new_o = {x: xform[0].z, y: xform[1].z, z:0}
  draw_line([new_o, new_l])
  draw_line([new_o, new_r])

render = ->
  cls()
  c.fillStyle = '#FFAA33'
  c.strokeStyle = '#FFAA33'
  c.lineWidth = 20
#  w = 2
#  h = 5
#  origin = {x: 0, y: 0, z:0}
#  sq3_2 = Math.sqrt(3)/2
#  base_l = {x: -sq3_2, y: 0.5, z:0.0}
#  base_r = {x: sq3_2, y: 0.5, z:0.0}
#  draw_line([origin, {x:0, y:5, z:0}])
#  draw_line([origin, base_l])
#  draw_line([origin, base_r])

  just_x = {x: 1, y:0, z:0}
  just_y = {x: 0, y:1, z:5}

  xform = [just_x, just_y]
  draw_split(xform)

#  c.beginPath()
#  new_pos = draw_trans(t)
#  c.moveTo(new_pos.x,new_pos.y)
#  new_pos = draw_trans({x:0, y:5, z:0})
#  c.lineTo(new_pos.x,new_pos.y)
#  c.stroke()
#c.fillRect(new_pos.x, new_pos.y, 20, -50 )

setInterval(render,30);
