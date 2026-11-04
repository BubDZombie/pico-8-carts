pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
arrow_speed=1
camera_speed=1
ball={
  x=64,
  y=10,
  size=3,
  speed=2,
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

function drop_ball()
  ball.can_fall=true
  for p in all(platforms) do
    if (p.x < ball.x
      and p.x + platform_w > ball.x
      and p.y <= ball.y + ball.size + 1
      and p.y + platform_h >= ball.y + ball.size)
    then
      ball.can_fall=false
      ball.y = p.y - ball.size - 1
    end
  end
  if ball.y >= 128 - ball.size then
    ball.can_fall=false
  end
  if ball.can_fall then
    ball.y+=ball.speed
  end
end

function move_ball()
  if btn(0) and ball.x > ball.size then
    ball.x-=arrow_speed
  elseif btn(1) and ball.x < 128 - ball.size then
    ball.x+=arrow_speed
  end
end

function lift()
  if not ball.can_fall then
    ball.y-=camera_speed
  end  
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
        new={x=x,y=128}
        add(platforms,new)
        add(newbies,new)
      end
    end
    if count(platforms) == full then
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
    move_ball()
    drop_ball()
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
