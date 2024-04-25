//
//  ZoomAndDragView.swift
//  HexaGone
//

import SwiftUI

struct ZoomAndDragView<Content: View>: View {
    
    // to deal with this error:
    // 'ZoomAndDragView<Content>' initializer is inaccessible due to 'private' protection level
    init(frameWidth: CGFloat, frameHeight: CGFloat, content: Content) {
        self.frameWidth = frameWidth
        self.frameHeight = frameHeight
        self.content = content
    }
    
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @GestureState private var zoomScale: CGFloat = 1.0
    @GestureState private var dragOffset: CGSize = .zero

    // Size of the base frame (this applies to "content")
    public var frameWidth: CGFloat
    public var frameHeight: CGFloat
    
    // Content to be displayed
    public var content: Content

    // Configurable properties for zoom and drag limits
    @State private var minZoom: CGFloat = 0.5
    private var maxZoom: CGFloat = 3.0
    
    // Screen Height and Width for limitDrag method
    @State private var screenWidth: CGFloat = 0.0
    @State private var screenHeight: CGFloat = 0.0

    private var zoomAndDrag: some Gesture {
        SimultaneousGesture(
            MagnificationGesture()
                .updating($zoomScale) { value, state, _ in
                    state = max(minZoom, min(maxZoom, scale * value)) / scale
                }
                .onEnded { value in
                    self.scale = max(minZoom, min(maxZoom, self.scale * value))
                },
            DragGesture()
                .updating($dragOffset) { value, state, _ in
                    state = self.limitDrag(value: value.translation, scale: scale * zoomScale)
                }
                .onEnded { value in
                    let finalOffset = self.limitDrag(value: CGSize(width: self.offset.width + value.translation.width,
                                                                   height: self.offset.height + value.translation.height),
                                                     scale: scale)
                    self.offset = finalOffset
                }
        )
    }

    private func limitDrag(value: CGSize, scale: CGFloat) -> CGSize {
        let maxX = max(frameWidth * scale - screenWidth - 2 * hexSize * scale, 0) / 2
        let maxY = max(frameHeight * scale - screenHeight - 2 * hexSize * HEXRATIO * scale, 0) / 2
        return CGSize(width: min(max(value.width, -maxX), maxX),
                      height: min(max(value.height, -maxY), maxY))
    }

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            GeometryReader { geometry in
                self.content
                    .frame(width: frameWidth, height: frameHeight)
                    .clipShape(Rectangle())
                    .scaleEffect(scale * zoomScale)
                    .offset(x: offset.width + dragOffset.width, y: offset.height + dragOffset.height)
                    .gesture(self.zoomAndDrag)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    .onAppear() {
                        // Creates additional restrictions upon initial load
                        // This works because the user could not finish performing a Zoom/Drag gesture before the screen finishes loading.
                        screenWidth = geometry.size.width
                        screenHeight = geometry.size.height
                        minZoom = max(minZoom, max(screenWidth/frameWidth, (screenHeight * 1.15)/frameHeight))
                    }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
