import Foundation

let ball = OvalShape(width: 50,height: 50)

let funnelPoints = [
    Point(x: 0, y: 50),
    Point(x: 80, y: 50),
    Point(x: 60, y: 0),
    Point(x: 20, y: 0)
]

let funnel = PolygonShape(points: funnelPoints)


var barriers: [Shape] = []
var targets: [Shape] = []
fileprivate func setupBall() {
    ball.position = Point(x: 250, y: 400)
    scene.add(ball)
    ball.hasPhysics = true
    ball.fillColor = .orange
    ball.onCollision = ballCollided(with:)
    ball.isDraggable = false
    
    scene.trackShape(ball)
    ball.onExitedScene = ballExitedScene
    ball.onTapped = resetGame
    
}

fileprivate func addBarrier(at position: Point, width: Double, height: Double, angle: Double) {
    let barrierPoints = [
            Point(x: 0, y: 0),
            Point(x: 0, y: height),
            Point(x: width, y: height),
            Point(x: width, y: 0)
        ]

        let barrier = PolygonShape(points: barrierPoints)

        barriers.append(barrier)
        
    // Add a barrier to the scene.
    barrier.position = position
    barrier.hasPhysics = true
    scene.add(barrier)
    barrier.isImmobile = true
    barrier.fillColor = .yellow
    barrier.angle = angle
    barrier.bounciness = 0.7
}

fileprivate func setupFunnel() {
    // Add a funnel to the scene.
    funnel.position = Point(x: 200, y: scene.height - 25)
    scene.add(funnel)
    funnel.onTapped = dropBall
    funnel.fillColor = .blue
    funnel.isDraggable = false
}

func setup() {
    setupBall()

    // right barrier.
    addBarrier(at: Point(x: 315, y: 175), width: 80, height: 25, angle: 0.2)
    // small barrier
    addBarrier(at: Point(x: 200, y: 150), width: 30, height: 15, angle: 0.2)
    // left top Barrier
    addBarrier(at: Point(x: 51, y: 341), width: 100, height: 25, angle: -0.2)
    // left bottom Barrier
    addBarrier(at: Point(x: 53, y: 162), width: 100, height: 25, angle: -0.3)
    setupFunnel()
    
    // Add a target to the scene.
    addTarget(at: Point(x: 184, y: 563))
    addTarget(at: Point(x: 238, y: 624))
    addTarget(at: Point(x: 269, y: 453))
    addTarget(at: Point(x: 213, y: 348))
    addTarget(at: Point(x: 113, y: 267))
    
    resetGame()
    
    scene.onShapeMoved = printPosition(of:)

}

// Drops the ball by moving it to the funnel's position.
func dropBall() {
    ball.position = funnel.position
    ball.stopAllMotion()
    
    for barrier in barriers {
        barrier.isDraggable = false
    }
}

func addTarget(at position: Point) {
    let targetPoints = [
        Point(x: 10, y: 0),
        Point(x: 0, y: 10),
        Point(x: 10, y: 20),
        Point(x: 20, y: 10)
    ]

    let target = PolygonShape(points: targetPoints)

    targets.append(target)
    
    target.position = position
    target.hasPhysics = true
    target.isImmobile = true
    target.isImpermeable = false
    target.fillColor = .blue

    scene.add(target)
    target.name = "target"
    //target.isDraggable = false
}

// Handles collisions between the ball and the targets.
func ballCollided(with otherShape: Shape) {
    otherShape.fillColor = .green
    func ballCollided(with otherShape: Shape) {
        if otherShape.name != "target" { return }
        otherShape.fillColor = .green
    }
}

func ballExitedScene() {
    for barrier in barriers {
        barrier.isDraggable = true
    }
}
// Resets the game by moving the ball below the scene,
// which will unlock the barriers.
func resetGame() {
    ball.position = Point(x: 0, y: -80)
}
func printPosition(of shape: Shape) {
    print(shape.position)
}
