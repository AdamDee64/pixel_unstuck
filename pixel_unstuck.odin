package main

import rl "vendor:raylib"
import "core:math/rand"

WIDTH   :: 150
HEIGHT  :: 150

Colors_Enum :: enum  {
    FULL_BLACK,
    FULL_WHITE,
    FULL_R,
    FULL_G,
    FULL_B,
    FULL_C,
    FULL_Y,
    FULL_M,
}

Draw_What :: enum {
    COLOR_SOLID,
    COLOR_RANGE,
    GRAYSCALE,
}

Draw_How :: enum {
    UNIFORM,
    PER_PIXEL,
}

draw_what : Draw_What = .COLOR_RANGE
draw_how : Draw_How = .PER_PIXEL

main :: proc() {
    
    TITLE : cstring : "pixel unstuck"
    
    rl.SetTraceLogLevel(.ERROR)

    flags : rl.ConfigFlags
    flags = {.WINDOW_TOPMOST} // .VSYNC_HINT for auto monitor dependent refresh
    rl.SetConfigFlags(flags)

    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    colors := [Colors_Enum]rl.Color {
        .FULL_BLACK  = {0, 0, 0, 255},
        .FULL_WHITE  = {255, 255, 255, 255},
        .FULL_R      = {255, 0, 0, 255},
        .FULL_G      = {0, 255, 0, 255},
        .FULL_B      = {0, 0, 255, 255},
        .FULL_C      = {0, 255, 255, 255},
        .FULL_Y      = {255, 255, 0, 255},
        .FULL_M      = {255, 0, 255, 255},
    }

    assert(colors[cast(Colors_Enum) 2] == {255, 0, 0, 255})

    color : rl.Color
    color_index : int
    swap : b32

    for !rl.WindowShouldClose() {

        if rl.IsKeyPressed(.W) || rl.IsKeyPressed(.UP){
            next_what_state()
        }

        if rl.IsKeyPressed(.S) || rl.IsKeyPressed(.DOWN){
            next_how_state()
        }

        if rl.IsKeyPressed(.A) || rl.IsKeyPressed(.LEFT){
            color_index += len(colors) + 1
            color_index %= len(colors)
        }
        if rl.IsKeyPressed(.D) || rl.IsKeyPressed(.RIGHT){
            color_index += len(colors) - 1
            color_index %= len(colors)
        }

        rl.BeginDrawing()

        switch draw_how {
            case .UNIFORM:
                    switch draw_what {
                        case .COLOR_SOLID:
                            if swap {
                                color = colors[cast(Colors_Enum) color_index]
                            } else {
                                color = colors[.FULL_BLACK]
                            }
                            swap = !swap
                        case .COLOR_RANGE:
                            color = random_color()
                        case .GRAYSCALE:
                            gray := rand_u8()
                            color = {gray, gray, gray, 255}
                    }
                rl.ClearBackground(color)

            case .PER_PIXEL:
                switch draw_what {
                    case .COLOR_SOLID:
                        rl.ClearBackground(colors[.FULL_BLACK])     
                        for x in 0..<WIDTH {
                            for y in 0..<HEIGHT{
                                if coin_flip() {
                                    rl.DrawPixel(i32(x), i32(y), colors[cast(Colors_Enum) color_index])
                                }
                            }
                        }

                    case .COLOR_RANGE:
                        for x in 0..<WIDTH {
                            for y in 0..<HEIGHT{
                                rl.DrawPixel(i32(x), i32(y), {rand_u8(), rand_u8(), rand_u8(), 255})
                            }
                        }
                    case .GRAYSCALE:
                        for x in 0..<WIDTH {
                            for y in 0..<HEIGHT{
                                gray := rand_u8()
                                rl.DrawPixel(i32(x), i32(y), {gray, gray, gray, 255})
                            }
                        }
                }
        }

        rl.EndDrawing()
    }
    rl.CloseWindow()
}

random_color :: proc() -> rl.Color {
    return {
        rand_u8(),
        rand_u8(),
        rand_u8(),
        255
    }
}

coin_flip :: proc() -> b8 {
    return rand.int31() & 1 == 0 ? false : true
}

rand_u8 :: proc() -> u8 {
    return u8(rand.int31() % 256)
}

next_how_state :: proc() {
    v := int(draw_how)
    v += len(Draw_How) + 1
    v %= len(Draw_How)
    draw_how = Draw_How(v)
}

next_what_state :: proc() {
    v := int(draw_what)
    v += len(Draw_What) + 1
    v %= len(Draw_What)
    draw_what = Draw_What(v)
}