;; DAO Governance Contract
;; Contract for voting on supplier approvals, standards, and funding audits

;; Proposal types
(define-constant PROPOSAL-SUPPLIER-APPROVAL u1)
(define-constant PROPOSAL-STANDARD u2)
(define-constant PROPOSAL-FUNDING-AUDIT u3)

;; Proposal structure
(define-map proposals
  uint
  {
    proposer: principal,
    proposal-type: uint,
    description: (string-ascii 256),
    target-id: (optional uint),
    start-block: uint,
    end-block: uint,
    executed: bool
  }
)

;; Vote structure
(define-map votes
  { proposal-id: uint, voter: principal }
  {
    support: bool,
    weight: uint
  }
)

;; Data vars
(define-data-var proposal-nonce uint u0)
(define-data-var quorum uint u1)

;; Error constants
(define-constant ERR-NOT-FOUND (err u100))
(define-constant ERR-NOT-AUTHORIZED (err u101))
(define-constant ERR-ALREADY-VOTED (err u102))
(define-constant ERR-NOT-STARTED (err u103))
(define-constant ERR-ENDED (err u104))
(define-constant ERR-NOT-QUORUM (err u105))

;; Create proposal
(define-public (create-proposal (proposal-type uint) (description (string-ascii 256)) (target-id (optional uint)) (duration uint))
  (let
    (
      (proposal-id (+ (var-get proposal-nonce) u1))
      (start-block block-height)
      (end-block (+ block-height duration))
    )
    (begin
      (map-set proposals proposal-id
        {
          proposer: tx-sender,
          proposal-type: proposal-type,
          description: description,
          target-id: target-id,
          start-block: start-block,
          end-block: end-block,
          executed: false
        }
      )
      (var-set proposal-nonce proposal-id)
      (ok proposal-id)
    )
  )
)

;; Cast vote
(define-public (cast-vote (proposal-id uint) (support bool) (weight uint))
  (let
    (
      (proposal (unwrap! (map-get? proposals proposal-id) ERR-NOT-FOUND))
      (vote-key { proposal-id: proposal-id, voter: tx-sender })
    )
    (begin
      (asserts! (>= block-height (get start-block proposal)) ERR-NOT-STARTED)
      (asserts! (<= block-height (get end-block proposal)) ERR-ENDED)
      (asserts! (is-none (map-get? votes vote-key)) ERR-ALREADY-VOTED)
      (map-set votes vote-key { support: support, weight: weight })
      (ok true)
    )
  )
)

;; Execute proposal
(define-public (execute-proposal (proposal-id uint))
  (let
    (
      (proposal (unwrap! (map-get? proposals proposal-id) ERR-NOT-FOUND))
      (yes-weight (fold (lambda (v acc) (if (get support v) (+ acc (get weight v)) acc)) u0 (filter (lambda (v) (= (get proposal-id v) proposal-id)) (map-values votes))))
      (no-weight (fold (lambda (v acc) (if (not (get support v)) (+ acc (get weight v)) acc)) u0 (filter (lambda (v) (= (get proposal-id v) proposal-id)) (map-values votes))))
    )
    (begin
      (asserts! (>= block-height (get end-block proposal)) ERR-NOT-STARTED)
      (asserts! (not (get executed proposal)) ERR-NOT-AUTHORIZED)
      (asserts! (>= (+ yes-weight no-weight) (var-get quorum)) ERR-NOT-QUORUM)
      (map-set proposals proposal-id (merge proposal { executed: true }))
      (ok { yes: yes-weight, no: no-weight })
    )
  )
)

;; Read-only functions
(define-read-only (get-proposal (proposal-id uint))
  (map-get? proposals proposal-id)
)

(define-read-only (get-vote (proposal-id uint) (voter principal))
  (map-get? votes { proposal-id: proposal-id, voter: voter })
)

(define-read-only (get-quorum)
  (var-get quorum)
)

(define-public (set-quorum (new-quorum uint))
  (begin
    (asserts! (is-eq tx-sender 'SP000000000000000000002Q6VF78) ERR-NOT-AUTHORIZED)
    (var-set quorum new-quorum)
    (ok true)
  )
)

;; DAO contract for voting on supplier approvals, standards, and funding audits