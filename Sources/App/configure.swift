import Vapor
import Leaf

/// Called before your application initializes.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#configureswift)
public func configure(
    _ config: inout Config,
    _ env: inout Environment,
    _ services: inout Services
    
) throws {
    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    try services.register(LeafProvider())
    config.prefer(LeafRenderer.self, for: ViewRenderer.self)
    
    var middleware = MiddlewareConfig.default()
    middleware.use(FileMiddleware.self)
    services.register(middleware)
    
    let myService = NIOServerConfig.default(hostname: "www.chenzhipeng.vip", port: 80, backlog: 256, workerCount: ProcessInfo.processInfo.activeProcessorCount, maxBodySize: 1_000_000, reuseAddress: true, tcpNoDelay: true)
    services.register(myService)
}
