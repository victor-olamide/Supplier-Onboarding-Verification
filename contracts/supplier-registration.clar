;; Supplier Registration Contract

;; Import supplier trait
(use-trait supplier-trait .supplier.supplier-trait)

;; Constants
(define-constant REGISTRATION-FEE u1000000) ;; 1 STX in microSTX
(define-constant CONTRACT-OWNER tx-sender)

;; Error constants
(define-constant ERR-INSUFFICIENT-FEE (err u100))
(define-constant ERR-REGISTRATION-FAILED (err u101))

;; Registration function with fee payment
(define-public (register-supplier-with-fee (supplier-contract <supplier-trait>) (name (string-ascii 256)) (location (string-ascii 256)))
  (begin
    ;; Check if fee is paid
    (try! (stx-transfer? REGISTRATION-FEE tx-sender CONTRACT-OWNER))
    ;; Call the supplier contract's register function
    (try! (contract-call? supplier-contract register-supplier tx-sender name location))
    (ok true)
  )
)