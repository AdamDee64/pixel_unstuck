package main

import rl "vendor:raylib"
import "core:math/rand"

import "core:c"

main :: proc() {
    
    WIDTH   :: 150
    HEIGHT  :: 150

    TITLE : cstring : "pixel unstuck"
    
    rl.SetTraceLogLevel(.ERROR)

    flags : rl.ConfigFlags
    flags = {.WINDOW_TOPMOST}
    rl.SetConfigFlags(flags)

    rl.InitWindow(WIDTH, HEIGHT, TITLE)

    rl.SetTargetFPS(60)

    rl.DisableCursor()
    
    for !rl.WindowShouldClose() {

        rl.BeginDrawing()
        
            for x in 0..<WIDTH {
                for y in 0..<HEIGHT {
                    color : rl.Color = {
                        u8(rand.int31() % 255),
                        u8(rand.int31() % 255),
                        u8(rand.int31() % 255),
                        255
                    }
                    rl.DrawPixel(i32(x), i32(y), color)
                }
            }
        rl.EndDrawing()
    }
    rl.CloseWindow()
}
