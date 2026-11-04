pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
arrow_speed=3
camera_speed=2
ball={
  x=64,
  y=10,
  size=3,
  speed=3,
  up_space=0,
  right_space=0,
  down_space=0,
  left_space=0,
  can_fall=true,
  alive=true,
  color=11
}
platforms={}
platform_w=16
platform_h=2
spread=32
score=0
bg_color=0
text_color=4

function check_space()
  local ceilings={1}
  local right_walls={128}
  local floors={128}
  local left_walls={1}
  local ball_top=ball.y-ball.size-1
  local ball_right=ball.x+ball.size+1
  local ball_bottom=ball.y+ball.size+1
  local ball_left=ball.x-ball.size-1
  for p in all(platforms) do
    local platform_top=p.y
    local platform_right=p.x+platform_w
    local platform_bottom=p.y+platform_h
    local platform_left=p.x
    if not(ball_left >= platform_right
        or ball_right <= platform_left) then
      if platform_bottom <= ball_top then
        add(ceilings,platform_bottom)
      elseif platform_top >= ball_bottom then
        add(floors,platform_top)
      end
    end
    if not(ball_top >= platform_bottom
        or ball_bottom <= platform_top) then
      if platform_left >= ball_right then
        add(right_walls,platform_left)
      elseif platform_right <= ball_left then
        add(left_walls,platform_right)
      end
    end
  end
  ball.up_space=128
  for c in all(ceilings) do
    local space=ball_top-c
    if space < ball.up_space then
      ball.up_space=space
    end
  end
  ball.right_space=128
  for w in all(right_walls) do
    local space=w-ball_right
    if space < ball.right_space then
      ball.right_space=space
    end
  end
  ball.down_space=128
  for f in all(floors) do
    local space=f-ball_bottom
    if space < ball.down_space then
      ball.down_space=space
    end
  end
  ball.left_space=128
  for w in all(left_walls) do
    local space=ball_left-w
    if space < ball.left_space then
      ball.left_space = space
    end
  end
  local platform_string=""
  for p in all(platforms) do
    platform_string..=p.x..","..p.y.." "
  end
  printh("ball.y "..ball.y)
  printh("ball top "..ball_top.." right "..ball_right.." bottom "..ball_bottom.." left "..ball_left)
  printh("ball spc bot "..ball.down_space)
  printh("platforms "..platform_string)
  printh("")
end

function move_ball()
  if btn(0) then
    if ball.left_space > arrow_speed then
      ball.x-=arrow_speed
    else
      ball.x-=ball.left_space
    end
  elseif btn(1) then
    if ball.right_space > arrow_speed then
      ball.x+=arrow_speed
    else
      ball.x+=ball.right_space
    end
  end
end

function drop_ball()
  if ball.down_space >= ball.speed then
    ball.y += ball.speed
    printh("move ball "..ball.speed.." down to "..ball.y)
  else
    ball.y += ball.down_space
    printh("move ball "..ball.down_space.." down to "..ball.y)
  end
end

function lift()
  if ball.down_space == 0
      and ball.y < 128 - ball.size then
    ball.y-=camera_speed
    printh("move ball up "..camera_speed.." to "..ball.y)
  end
  printh("move platforms up "..camera_speed)  
  for p in all(platforms) do
    p.y-=camera_speed
  end
  if ball.y < ball.size then
    ball.alive = false
  else
    score+=1
  end
end

function add_platforms()
  should_add=true
  for p in all(platforms) do
    if p.y > 128 - spread then
      should_add=false
      break
    end
  end
  if should_add then
    local newbies={}
    full=128/platform_w
    for x = 1, 128, platform_w do
      if rnd(64) > spread then
      --if rnd(256) > spread then
        new={x=x,y=128}
        add(platforms,new)
        add(newbies,new)
      end
    end
    if count(newbies) == full then
      remove = rnd(newbies)
      del(platforms,remove)
    end
    if spread > ball.size * 2 + platform_h * 2
        and rnd() > 0.75 
        then
      spread-=1
    end
  end
end

function remove_platforms()
  for p in all(platforms) do
    if p.y < 1 then
      del(platforms,p)
    end
  end
end

function check_reset()
  if btn(4) then
    score=0
    ball.x=64
    ball.y=ball.size
    ball.alive=true
    ball.can_fall=true
    for p in all(platforms) do
      del(platforms, p)
    end
  end
end

function _update()
  if ball.alive then
    check_space()
    move_ball()
    check_space()
    drop_ball()
    check_space()
    lift()
    add_platforms()
    remove_platforms()
  else
    check_reset()
  end
end

function draw_game()
  circfill(
    ball.x,
    ball.y,
    ball.size,
    ball.color
  )
  for p in all(platforms) do
    rectfill(
      p.x,
      p.y,
      p.x+platform_w,
      p.y+platform_h,
      6
    )
  end
  print("score "..score,1,1,text_color)
  print("up    "..ball.up_space,1,10,text_color)
  print("right "..ball.right_space,1,20,text_color)
  print("down  "..ball.down_space,1,30,text_color)
  print("left  "..ball.left_space,1,40,text_color)
end

function draw_score()
  print(score,64,64,text_color)
  print("0 to restart",64,96,text_color)
end

function _draw()
  rectfill(0,0,128,128,bg_color)
  if ball.alive then
    draw_game()
  else
    draw_score()
  end
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
