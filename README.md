# A collection of shaders used in Worlds made by pixelqiwi
Written entirely by ChatGPT and/or DeepSeek.

## SubpixelEmissiveGammaShader
Makes the Sprite texture you use on it be rendered as separate Red, Green and Blue lines, imitating an LCD pixel grid. Has settings for distance when the subpixel rendering shows up, so from afar the texture looks the way it should, and when you come close you can count each individual subpixel.

## GrassWave
A shader for waving grass, Minecraft shader-esc style. Has settings.

## WaterWave
Same as above, but for water. IIRC these two are identical.

## Worldborder
A shader that makes the texture appear only when you get close to it. Has settings for fade distance.

## ParallaxLayers10
A 10-layer parallax shader made for glasses lenses with a "looking into another world" effect. Each layer is a transparent texture floating at its own depth behind (or in front of) the lens surface, and the offset follows the viewing angle. Layer 1 is the closest to the surface and Layer 10 is the deepest. Each layer has its own RGBA texture and tiling/offset. You can select how many layers you wish to have, the rest don't cost anything and are skipped.
