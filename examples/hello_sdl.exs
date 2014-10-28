defmodule HelloSDL do
  def start do
    :ok = :sdl.start([:video])
    :ok = :sdl.stop_on_exit
    {:ok, window} = :sdl_window.create('Hello SDL', 10, 10, 500, 500, [])
    {:ok, renderer} = :sdl_renderer.create(window, -1, [:accelerated, :present_vsync])
    :ok = :sdl_renderer.set_draw_color(renderer, 255, 255, 255, 255)
    {:ok, texture} = :sdl_texture.create_from_file(renderer, 'erlang.png')
    loop(%{window: window, renderer: renderer, texture: texture})
  end

  def loop(state) do
    events_loop
    render(state)
    loop(state)
  end

  def events_loop do
    case :sdl_events.poll do
      false -> :ok
      %{type: :quit} -> terminate
      _ -> events_loop
    end
  end

  def render(%{renderer: renderer, texture: texture}) do
    :ok = :sdl_renderer.clear(renderer)
    :ok = :sdl_renderer.copy(renderer, texture, :undefined, %{x: 100, y: 100, w: 300, h: 300})
    :ok = :sdl_renderer.present(renderer)
  end

  def terminate do
    :init.stop
    exit(:normal)
  end
end

HelloSDL.start
