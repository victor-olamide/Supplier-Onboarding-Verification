;; Platform Rewards Token Contract
;; Fungible token contract for rewards, staking, and governance

;; SIP-010 FT Trait
(define-trait sip010-ft-trait
  (
    (get-name () (response (string-ascii 32) uint))
    (get-symbol () (response (string-ascii 32) uint))
    (get-decimals () (response uint uint))
    (get-total-supply () (response uint uint))
    (get-balance (principal) (response uint uint))
    (transfer (principal principal uint) (response bool uint))
    (mint (principal uint) (response bool uint))
    (burn (principal uint) (response bool uint))
  )
)

;; Token data
(define-data-var total-supply uint u0)
(define-data-var decimals uint u6)
(define-data-var token-name (string-ascii 32) "PlatformToken")
(define-data-var token-symbol (string-ascii 32) "PTK")

;; Balances
(define-map balances principal uint)

;; Error constants
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-INSUFFICIENT-BALANCE (err u101))

;; Mint tokens (admin only)
(define-public (mint (recipient principal) (amount uint))
  (begin
    (asserts! (is-eq tx-sender 'SP000000000000000000002Q6VF78) ERR-NOT-AUTHORIZED)
    (map-set balances recipient (+ (default-to u0 (map-get? balances recipient)) amount))
    (var-set total-supply (+ (var-get total-supply) amount))
    (ok true)
  )
)

;; Burn tokens
(define-public (burn (holder principal) (amount uint))
  (let
    (
      (balance (default-to u0 (map-get? balances holder)))
    )
    (begin
      (asserts! (>= balance amount) ERR-INSUFFICIENT-BALANCE)
      (map-set balances holder (- balance amount))
      (var-set total-supply (- (var-get total-supply) amount))
      (ok true)
    )
  )
)

;; Transfer tokens
(define-public (transfer (sender principal) (recipient principal) (amount uint))
  (let
    (
      (balance (default-to u0 (map-get? balances sender)))
    )
    (begin
      (asserts! (>= balance amount) ERR-INSUFFICIENT-BALANCE)
      (map-set balances sender (- balance amount))
      (map-set balances recipient (+ (default-to u0 (map-get? balances recipient)) amount))
      (ok true)
    )
  )
)

;; Read-only functions
(define-read-only (get-name)
  (ok (var-get token-name))
)

(define-read-only (get-symbol)
  (ok (var-get token-symbol))
)

(define-read-only (get-decimals)
  (ok (var-get decimals))
)

(define-read-only (get-total-supply)
  (ok (var-get total-supply))
)

(define-read-only (get-balance (owner principal))
  (ok (default-to u0 (map-get? balances owner)))
)

;; Platform rewards, staking, and governance token contract