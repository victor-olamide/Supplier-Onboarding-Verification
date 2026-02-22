;; Supplier Registration Contract

;; Import supplier trait
(use-trait supplier-trait .supplier.supplier-trait)

;; Constants
(define-constant REGISTRATION-FEE u1000000) ;; 1 STX in microSTX
(define-constant CONTRACT-OWNER tx-sender)

;; Error constants
(define-constant ERR-INSUFFICIENT-FEE (err u100))
(define-constant ERR-REGISTRATION-FAILED (err u101))