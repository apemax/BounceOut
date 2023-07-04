def tick args
  defaults args

  args.state.current_scene ||= :title_scene

  current_scene = args.state.current_scene

  case current_scene
  when :title_scene
    tick_title_scene args
  when :game_scene
    tick_game_scene args
  when :game_over_scene
    tick_game_over_scene args
  end

  if args.state.current_scene != current_scene
    raise "Scene was changed incorrectly. Set args.state.next_scene to change scenes."
  end

  if args.state.next_scene
    args.state.current_scene = args.state.next_scene
    args.state.next_scene = nil
  end
end

def tick_title_scene args
  args.outputs.background_color = [255, 255, 255]
  if args.state.blocks.empty?
    args.state.blocks = make_blocks args
  end
  args.outputs.sprites << args.state.blocks
  args.outputs.labels << [540, 500, "BounceOut", 15, 0, 0, 0, 0]
  args.outputs.labels << [380, 400, "Press the Enter key to start.", 10, 0, 0, 0, 0]
  args.outputs.labels << [570, 300, "Controls:", 10, 0, 0, 0, 0]
  args.outputs.labels << [320, 250, "w,a,s,d = Direction for ball to move.", 10, 0, 0, 0, 0]
  args.outputs.labels << [380, 200, "Space = Change ball direction.", 10, 0, 0, 0, 0]

  if args.inputs.keyboard.enter
    args.state.next_scene = :game_scene
  end
end

def tick_game_scene args
  defaults args
  render args
  calc args
  drop_block args

  if args.inputs.keyboard.p
    args.state.debug_enabled = true
  end
  if args.inputs.keyboard.o
    args.state.debug_enabled = false
  end
    

  if args.state.debug_enabled
    debug args
  end

  if args.state.score >= 640
    args.state.end_timer += 1
    if args.state.end_timer == 120
      args.state.next_scene = :game_over_scene
    end
  end

  args.state.time_frame += 1

  if args.state.time_frame == 60
    args.state.time_frame = 0
    args.state.time_seconds += 1

    if args.state.time_seconds == 60
      args.state.time_seconds = 0
      args.state.time_minutes += 1
    end
  end

  if args.state.blocks.empty?
    args.state.blocks = make_blocks args
  end
end

def tick_game_over_scene args
  args.outputs.background_color = [255, 255, 255]
  args.outputs.labels << [520, 500, "Stage clear!", 10, 255, 0, 0, 0]
  args.outputs.labels << [480, 450, "Final time: #{(args.state.time_minutes)}:#{(args.state.time_seconds)}", 10, 255, 0, 0, 0]
  args.outputs.labels << [320, 350, "Press the Enter key to try again.", 10, 255, 0, 0, 0]
  if args.inputs.keyboard.enter
    args.state.next_scene = :game_scene
    args.state.score = 0
    args.state.time_seconds = 0
    args.state.time_minutes = 0
    args.state.end_timer = 0
    args.state.blocks.clear
    args.state.ball_dx = 0
    args.state.ball_dy = 0
    args.state.ball[:x] = 620
    args.state.ball[:y] = 250
  end
end

# Sets default values.
def defaults args
  args.state.ball_speed   = 15
  args.state.ball_size    = 48
  args.state.ball_dx    ||=  0
  args.state.ball_dy    ||=  0
  args.state.ball       ||= {x: 620, y: 250, w: args.state.ball_size, h: args.state.ball_size, path: 'sprites/ball.png'} # ball_size is set as the width and height
  args.state.ball_angle ||=  0

  args.state.block_height ||= 20
  args.state.block_width ||= 160
  
  args.state.blocks ||= []
  args.state.block_hit ||= false

  args.state.score ||= 0
  args.state.time_seconds   ||= 0
  args.state.time_minutes   ||= 0
  args.state.time_frame     ||= 0
  args.state.end_timer      ||= 0

  args.state.debug_enabled ||= false
end

def make_blocks args
  args.state.blocks = []
  # Top blocks
  args.state.blocks += 1.times.map { |n| {x: 0, y: 700, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-green.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 160, y: 700, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-blue.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 320, y: 700, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-green.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 480, y: 700, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-blue.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 640, y: 700, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-green.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 800, y: 700, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-blue.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 960, y: 700, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-green.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 1120, y: 700, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-blue.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 0, y: 680, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-blue.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 160, y: 680, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-green.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 320, y: 680, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-blue.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 480, y: 680, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-green.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 640, y: 680, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-blue.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 800, y: 680, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-green.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 960, y: 680, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-blue.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 1120, y: 680, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-green.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 0, y: 660, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-green.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 160, y: 660, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-blue.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 320, y: 660, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-green.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 480, y: 660, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-blue.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 640, y: 660, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-green.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 800, y: 660, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-blue.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 960, y: 660, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-green.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 1120, y: 660, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-blue.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 0, y: 640, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-blue.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 160, y: 640, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-green.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 320, y: 640, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-blue.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 480, y: 640, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-green.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 640, y: 640, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-blue.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 800, y: 640, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-green.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 960, y: 640, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-blue.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 1120, y: 640, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-green.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  # bottom blocks
  args.state.blocks += 1.times.map { |n| {x: 0, y: 0, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-green.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 160, y: 0, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-blue.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 320, y: 0, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-green.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 480, y: 0, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-blue.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 640, y: 0, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-green.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 800, y: 0, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-blue.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 960, y: 0, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-green.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 1120, y: 0, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-blue.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 0, y: 20, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-blue.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 160, y: 20, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-green.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 320, y: 20, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-blue.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 480, y: 20, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-green.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 640, y: 20, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-blue.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 800, y: 20, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-green.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 960, y: 20, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-blue.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 1120, y: 20, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-green.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 0, y: 40, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-green.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 160, y: 40, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-blue.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 320, y: 40, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-green.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 480, y: 40, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-blue.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 640, y: 40, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-green.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 800, y: 40, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-blue.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 960, y: 40, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-green.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 1120, y: 40, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-blue.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 0, y: 60, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-blue.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 160, y: 60, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-green.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 320, y: 60, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-blue.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 480, y: 60, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-green.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 640, y: 60, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-blue.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 800, y: 60, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-green.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 960, y: 60, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-blue.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  args.state.blocks += 1.times.map { |n| {x: 1120, y: 60, w: args.state.block_width, h: args.state.block_height, path: 'sprites/block-green.png', vel: 0, hit: false, out: false, block_up: 0, Block_down: false} }
  # Side blocks
  args.state.blocks
end

def make_bottom_blocks args
  args.state.blocks = []
    args.state.blocks
end

def render args
  args.outputs.sprites << args.state.ball

  args.outputs.sprites << args.state.blocks
end

def calc args
  position_ball args
  determine_collision_center_box args
end

def drop_block args
  args.state.blocks.each do |block|
    if block[:hit]
      if block[:block_up] == 0
        block[:vel] += 1
      end
      if block[:vel] == 6
        block[:block_up] = 1
        block[:block_down] = true
      end
      if block[:block_down] == true
        block[:vel] -= 1
        if block[:vel] == -15
          block[:block_down] = false
        end
      end
      block[:y] += block[:vel]
      if block[:y] < -20
        block[:out] = true
        block[:hit] = false
        block[:block_up] = 0
      end
    end
  end
end

def position_ball args
  screen_width  = 1280
  screen_height = 720

  if args.inputs.left
    args.state.ball_angle = 180
  end
  if args.inputs.right
    args.state.ball_angle = 0
  end
  if args.inputs.up
    args.state.ball_angle = 90
  end
  if args.inputs.down
    args.state.ball_angle = 270
  end
  if args.inputs.left && args.inputs.up
    args.state.ball_angle = 135
  end
  if args.inputs.left && args.inputs.down
    args.state.ball_angle = 225
  end
  if args.inputs.right && args.inputs.up
    args.state.ball_angle = 45
  end
  if args.inputs.right && args.inputs.down
    args.state.ball_angle = 315
  end

  if args.inputs.keyboard.space
    if args.state.ball_angle == 180
      args.state.ball_dx = -1
    end
    if args.state.ball_angle == 0
      args.state.ball_dx = 1
    end
    if args.state.ball_angle == 90
      args.state.ball_dy = 1
      args.state.ball_dx = 0
    end
    if args.state.ball_angle == 270
      args.state.ball_dy = -1
      args.state.ball_dx = 0
    end
    if args.state.ball_angle == 135
      args.state.ball_dx = -1
      args.state.ball_dy = 1
    end
    if args.state.ball_angle == 225
      args.state.ball_dx = -1
      args.state.ball_dy = -1
    end
    if args.state.ball_angle == 45
      args.state.ball_dx = 1
      args.state.ball_dy = 1
    end
    if args.state.ball_angle == 315
      args.state.ball_dx = 1
      args.state.ball_dy = -1
    end
  end

  args.state.ball[:y] += args.state.ball_dy * args.state.ball_speed

  args.state.ball[:x] += args.state.ball_dx * args.state.ball_speed

  if args.state.ball[:x] > screen_width - args.state.ball_size
    args.state.ball_dx = -1 # moves left
  elsif args.state.ball[:x] < 0
    args.state.ball_dx =  1 # moves right
  end

  if args.state.ball[:y] > screen_height - args.state.ball_size
    args.state.ball_dy = -1 # moves down
  elsif args.state.ball[:y] < 0
    args.state.ball_dy =  1 # moves up
  end
end

def determine_collision_center_box args
  blocks = []
  args.state.blocks.each do |block|
    if block[:hit] == false and block[:out] == false and args.state.block_hit == false
      if block.intersect_rect? args.state.ball
        case args.state.ball_dy
        when -1
          args.state.ball_dy = 1
        when 1
          args.state.ball_dy = -1
        end
        block[:hit] = true
        args.state.block_hit = true
        if block[:out] == false
          args.state.score += 10
        end
      else
      end
    end
  end
  if args.state.block_hit == true
    args.state.block_hit = false
  end
end

def debug args
  args.outputs.labels << { x: 10, y: 300, text: "ball_dx: #{args.state.ball_dx}"}
  args.outputs.labels << { x: 10, y: 320, text: "ball_dy: #{args.state.ball_dy}"}
  args.state.blocks.each do |block|
    args.outputs.labels << { x: 10, y: 340, text: "block hit: #{block[:hit]}"}
  end
end