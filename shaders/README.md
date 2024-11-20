# RTWSM - Minecraft

This is an implementation of [Rectilinear Texture Warping for Fast Adaptive Shadow Mapping](https://www.cspaul.com/publications/Rosen.2012.I3D.pdf) in a Minecraft shader.

In the absence of a programmable pipeline, analysis is done in the previous frame and reprojected into the current frame.

A 1024x2 image is used for the importance maps themselves. The first row is the x component of the importance map and the second row is the y component. This is so `imageAtomicMax` can be used to efficiently calculate the maximum along each row and column.

## Buffers
`colortex0` - main scene colour
`colortex1` - unshaded scene colour (unused so I need to remove this)
`colortex2` - view space normals
`colortex3` - full importance map
`colortex4` - xy importance maps
`colortex5` - undistorted shadow map

## Passes
`deferred` - clear importance map
`composite` - importance calculation
`composite1` - importance map conversion
`composite2` - importance map blur pass 1
`composite3` - importance map blur pass 2
`composite4` - prefix sum (really bad implementation)
`composite5` - warp calculation

