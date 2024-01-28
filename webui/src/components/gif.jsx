/* eslint-disable */
import React, { memo, useCallback, useEffect, useMemo, useRef } from 'react'

import { parseGIF, decompressFrames } from 'gifuct-js'
import { Image as KonvaImage } from 'react-konva'

export const KonvaGif = memo(({ url, x, y, draggable, width, height, id, ...rest }) => {
  const gifFrames = useRef()
  const frameIndex = useRef(0)
  const frameImageData = useRef()
  const imageRef = React.useRef()
  const playing = useRef(false)

  const { gifCanvas, gifCtx } = useMemo(() => {
    const canvas = document.createElement('canvas')
    canvas.width = width
    canvas.height = height
    const ctx = canvas.getContext('2d')
    return { gifCanvas: canvas, gifCtx: ctx }
  }, [])

  const { tempCanvas, tempCtx } = useMemo(() => {
    const canvas = document.createElement('canvas')
    canvas.width = width
    canvas.height = height
    const ctx = canvas.getContext('2d')
    return { tempCanvas: canvas, tempCtx: ctx }
  }, [])

  const drawPatch = useCallback(
    (frame) => {
      if (frame) {
        const { dims } = frame

        if (
          !frameImageData.current ||
          dims.width !== frameImageData.current.width ||
          dims.height !== frameImageData.current.height
        ) {
          tempCanvas.width =
            // width;
            dims.width
          tempCanvas.height =
            // height;
            dims.height
          frameImageData.current = tempCtx.createImageData(dims.width, dims.height)
        }

        // set the patch data as an override
        frameImageData.current.data.set(frame?.patch)

        // draw the patch back over the canvas
        tempCtx.putImageData(frameImageData.current, 0, 0)

        if (height && width) {
          gifCtx.drawImage(tempCanvas, dims.left, dims.top, width, height)
          if (imageRef.current) imageRef.current.getLayer().draw()
        }
      }
    },
    [gifCtx, height, tempCanvas, tempCtx, width]
  )

  const renderFrame = useCallback(() => {
    // get the frame
    const frame = gifFrames.current[frameIndex.current]

    const start = new Date().getTime()

    if (frame?.disposalType === 2) {
      gifCtx.clearRect(0, 0, width, height)
    }

    // // draw the patch
    drawPatch(frame)

    // perform manipulation
    // manipulate();

    // update the frame index
    frameIndex.current += 1
    if (frameIndex.current >= gifFrames.current.length) {
      frameIndex.current = 0
    }

    const end = new Date().getTime()
    const diff = end - start

    if (playing.current) {
      // delay the next gif frame
      setTimeout(
        function () {
          requestAnimationFrame(renderFrame)
          // renderFrame();
        },
        Math.max(0, Math.floor(Number(frame?.delay) - diff))
      )
    }
  }, [drawPatch, gifCtx, height, width])

  const playpause = useCallback(() => {
    playing.current = !playing.current
    if (playing.current) {
      renderFrame()
    }
  }, [renderFrame])

  const renderGIF = useCallback(
    (frames) => {
      gifFrames.current = frames
      frameIndex.current = 0
      if (!playing.current) {
        playpause()
      }
    },
    [playpause]
  )

  const fetchGif = useCallback(async () => {
    const frames = await fetch(url)
      .then((res) => res.arrayBuffer())
      .then((buff) => parseGIF(buff))
      .then((gif) => decompressFrames(gif, true))
    renderGIF(frames)
  }, [renderGIF, url])

  useEffect(() => {
    fetchGif()
  }, [fetchGif])

  return (
    <KonvaImage
      x={x}
      y={y}
      width={width}
      height={height}
      id={id}
      draggable={draggable}
      image={gifCanvas}
      ref={imageRef}
      alt="canvasgif"
      {...rest}
    />
  )
})

KonvaGif.displayName = 'KonvaGif'
