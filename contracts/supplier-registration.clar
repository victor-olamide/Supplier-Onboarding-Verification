;; Supplier Registration Contract
;; Handles supplier onboarding with fee payment

;; Import supplier trait
(use-trait supplier-trait .supplier.supplier-trait)

;; Constants
(define-data-var registration-fee uint u1000000) ;; 1 STX in microSTX
(define-constant CONTRACT-OWNER tx-sender)

;; Error constants
(define-constant ERR-INSUFFICIENT-FEE (err u100))
(define-constant ERR-REGISTRATION-FAILED (err u101))
(define-constant ERR-UNAUTHORIZED (err u102))

;; Registration function with fee payment
(define-public (register-supplier-with-fee (supplier-contract <supplier-trait>) (name (string-ascii 256)) (location (string-ascii 256)))
  (begin
    ;; Check if fee is paid
    (try! (stx-transfer? (var-get registration-fee) tx-sender CONTRACT-OWNER))
    ;; Call the supplier contract's register function
    (try! (contract-call? supplier-contract register-supplier tx-sender name location))
    (ok true)
  )
)

;; Read-only function to get registration fee
(define-read-only (get-registration-fee)
  (var-get registration-fee)
)

;; Function to update registration fee (only by contract owner)
(define-public (update-registration-fee (new-fee uint))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-UNAUTHORIZED)
    (var-set registration-fee new-fee)
    (ok true)
  )
)

;; Function to withdraw collected fees (only by contract owner)
(define-public (withdraw-fees (amount uint) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-UNAUTHORIZED)
    (try! (as-contract (stx-transfer? amount tx-sender recipient)))
    (ok true)
  )
)

;; Read-only function to get contract STX balance
(define-read-only (get-contract-balance)
  (stx-get-account (as-contract tx-sender))
)