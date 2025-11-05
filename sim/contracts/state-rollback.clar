;; State Rollback & Branching Contract
;; Allows rewinding chain state and forking into "what-if" scenarios

(define-constant contract-owner tx-sender)
(define-constant err-not-authorized (err u100))
(define-constant err-snapshot-not-found (err u101))
(define-constant err-deal-not-found (err u102))
(define-constant err-invalid-amount (err u103))

(define-data-var snapshot-counter uint u0)
(define-data-var deal-counter uint u0)

(define-map snapshots
    uint
    {
        block-height: uint,
        state-hash: (buff 32),
        timestamp: uint
    }
)

(define-map deals
    uint
    {
        buyer: principal,
        seller: principal,
        amount: uint,
        paid: bool,
        delivered: bool,
        completed: bool
    }
)

(define-map branched-scenarios
    {snapshot-id: uint, deal-id: uint}
    {
        paid: bool,
        delivered: bool,
        completed: bool,
        scenario-type: (string-ascii 20)
    }
)

(define-public (create-deal (seller principal) (amount uint))
    (let
        (
            (deal-id (var-get deal-counter))
        )
        (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
        (map-set deals deal-id {
            buyer: tx-sender,
            seller: seller,
            amount: amount,
            paid: true,
            delivered: false,
            completed: false
        })
        (var-set deal-counter (+ deal-id u1))
        (ok deal-id)
    )
)

(define-public (create-snapshot)
    (let
        (
            (snapshot-id (var-get snapshot-counter))
            (state-hash (sha256 (concat (unwrap-panic (to-consensus-buff? stacks-block-height)) 
                                       (unwrap-panic (to-consensus-buff? snapshot-id)))))
        )
        (map-set snapshots snapshot-id {
            block-height: stacks-block-height,
            state-hash: state-hash,
            timestamp: stacks-block-height
        })
        (var-set snapshot-counter (+ snapshot-id u1))
        (ok snapshot-id)
    )
)

(define-public (branch-scenario (snapshot-id uint) (deal-id uint) (user-pays bool) (delivered bool))
    (let
        (
            (snapshot (unwrap! (map-get? snapshots snapshot-id) err-snapshot-not-found))
            (deal (unwrap! (map-get? deals deal-id) err-deal-not-found))
            (scenario-type (if user-pays "user-pays" "user-defaults"))
        )
        (map-set branched-scenarios {snapshot-id: snapshot-id, deal-id: deal-id} {
            paid: user-pays,
            delivered: delivered,
            completed: (and user-pays delivered),
            scenario-type: scenario-type
        })
        (ok true)
    )
)

(define-read-only (get-snapshot (snapshot-id uint))
    (map-get? snapshots snapshot-id)
)

(define-read-only (get-deal (deal-id uint))
    (map-get? deals deal-id)
)

(define-read-only (simulate-outcome (snapshot-id uint) (deal-id uint))
    (let
        (
            (branch (unwrap! (map-get? branched-scenarios {snapshot-id: snapshot-id, deal-id: deal-id}) err-snapshot-not-found))
        )
        (ok {
            paid: (get paid branch),
            delivered: (get delivered branch),
            completed: (get completed branch),
            scenario: (get scenario-type branch)
        })
    )
)

(define-read-only (get-deal-count)
    (ok (var-get deal-counter))
)

(define-read-only (get-snapshot-count)
    (ok (var-get snapshot-counter))
)