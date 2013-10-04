require 'sinatra'
require 'sinatra/reloader' if development?
require 'chunky_png'
unless production?
  require 'FileUtils'
  require 'SecureRandom'
end

GRID = 5
PADDING = 35
ICON_SIZE = 420
CELL_SIZE = (ICON_SIZE - PADDING * 2) / GRID

get '/' do
  @images = Dir.glob(File.join(images_dir, '*.png')).shuffle[0..4].map { |f| '/gen/' + File.basename(f, '.png').gsub(/_/, '/') }
  @color = SecureRandom.hex(3)
  @cells = random_cells
  erb :index
end

get '/gen/:fill/:color' do

  raise 'Invalid parameters' unless params[:fill] =~ /\A\d{#{GRID ** 2}}\z/ && params[:color] =~ /\A\h{6}\z|\A\h{3}\z/ 

  path = image_path(params)

  unless File.exists?(path) 
    cells = params[:fill].split('').map { |f| f == '1' }
    hex = '#' + (params[:color].size == 3 ? params[:color].split('').map { |h| h * 2 }.join('') : params[:color])
    image = generate_image(path, cells, hex)
  end

  send_file path

end

def image_path(params)
  File.join(images_dir, "#{params[:fill]}_#{params[:color]}.png")
end

def random_cells
  cells = []
  GRID.times.map do |y|
    left = (GRID / 2).times.map { |i| random_cell }
    right = left.reverse
    center = GRID.odd? ? [random_cell] : []
    cells += GRID.odd? ? left + center + right : left + right
  end
  cells
end 

def random_cell
  rand(GRID) == 0 ? 1 : 0
end

def generate_image(path, cells, hex)
  color = ChunkyPNG::Color(hex)
  image = ChunkyPNG::Image.new(ICON_SIZE, ICON_SIZE, ChunkyPNG::Color('#f0f0f0')) 

  GRID.times do |y|
    GRID.times do |x|
      i = (GRID * y + x).to_i
      if cells[i]
        x0 = x * CELL_SIZE + PADDING
        y0 = y * CELL_SIZE + PADDING
        x1 = x0 + CELL_SIZE
        y1 = y0 + CELL_SIZE
        image.rect(x0, y0, x1, y1, color, color)
      end
    end
  end

  image.save(path)
end

def images_dir
  path = './tmp/images'
  FileUtils.mkdir_p(path)
  path
end

