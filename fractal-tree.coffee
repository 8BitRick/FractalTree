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

render = ->
  cls()
  c.fillStyle = '#FFAA33'
  c.strokeStyle = '#FFAA33'
  c.lineWidth = 20
  w = 2
  h = 5
  t = {x: 0, y: 0, z:0}

  c.beginPath()
  new_pos = draw_trans(t)
  c.moveTo(new_pos.x,new_pos.y)
  new_pos = draw_trans({x:0, y:5, z:0})
  c.lineTo(new_pos.x,new_pos.y)
  c.stroke()
#c.fillRect(new_pos.x, new_pos.y, 20, -50 )

setInterval(render,30);
