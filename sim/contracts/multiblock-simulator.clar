;; Multi-Block Simulator
;; ClaritySim Feature #1: Advance blockchain by custom block increments for time-dependent testing

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_NOT_AUTHORIZED (err u401))
(define-constant ERR_INVALID_BLOCKS (err u400))
(define-constant ERR_SIMULATION_FAILED (err u500))

;; Simulation state
(define-data-var current-simulated-height uint u0)
(define-data-var base-block-height uint u0)
(define-data-var simulation-active bool false)

;; Track block advancement sessions
(define-map simulation-sessions 
  { session-id: uint }
  { 
    start-height: uint,
    current-height: uint, 
    blocks-advanced: uint,
    timestamp: uint,
    active: bool 
  })

(define-data-var next-session-id uint u1)

;; Initialize simulation with current block height as baseline
(define-public (init-simulation)
  (begin
    (var-set base-block-height stacks-block-height)
    (var-set current-simulated-height stacks-block-height)
    (var-set simulation-active true)
    (ok { base-height: stacks-block-height, status: "initialized" })
  ))

;; Advance simulation by specified blocks
(define-public (advance-blocks (blocks-to-advance uint))
  (let ((session-id (var-get next-session-id))
        (current-height (var-get current-simulated-height)))
    (asserts! (> blocks-to-advance u0) ERR_INVALID_BLOCKS)
    (asserts! (var-get simulation-active) ERR_SIMULATION_FAILED)
    
    (let ((new-height (+ current-height blocks-to-advance)))
      (var-set current-simulated-height new-height)
      (var-set next-session-id (+ session-id u1))
      
      ;; Record session
      (map-set simulation-sessions 
        { session-id: session-id }
        { 
          start-height: current-height,
          current-height: new-height,
          blocks-advanced: blocks-to-advance,
          timestamp: stacks-block-height,
          active: true 
        })
      
      (ok { 
        session-id: session-id,
        previous-height: current-height,
        new-height: new-height,
        blocks-advanced: blocks-to-advance
      })
    )
  ))

;; Get current simulated block height
(define-read-only (get-simulated-height)
  (ok (var-get current-simulated-height)))

;; Reset simulation to original blockchain height
(define-public (reset-simulation)
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_NOT_AUTHORIZED)
    (var-set current-simulated-height (var-get base-block-height))
    (var-set simulation-active true)
    (ok { status: "reset", height: (var-get base-block-height) })
  ))

;; Pause/resume simulation
(define-public (toggle-simulation (active bool))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_NOT_AUTHORIZED)
    (var-set simulation-active active)
    (ok { status: (if active "active" "paused") })
  ))

;; Get simulation session details
(define-read-only (get-session-info (session-id uint))
  (map-get? simulation-sessions { session-id: session-id }))

;; Utility: Calculate blocks until target height
(define-read-only (blocks-until-height (target-height uint))
  (let ((current (var-get current-simulated-height)))
    (if (> target-height current)
      (ok (- target-height current))
      (ok u0))))

;; Utility: Simulate time-based conditions (e.g., vesting, voting periods)
(define-read-only (simulate-time-condition (blocks-required uint))
  (let ((simulated-height (var-get current-simulated-height))
        (base-height (var-get base-block-height)))
    (ok (>= (- simulated-height base-height) blocks-required))))

;; Get simulation status
(define-read-only (get-simulation-status)
  (ok {
    active: (var-get simulation-active),
    base-height: (var-get base-block-height),
    current-height: (var-get current-simulated-height),
    blocks-simulated: (- (var-get current-simulated-height) (var-get base-block-height)),
    next-session: (var-get next-session-id)
  }))