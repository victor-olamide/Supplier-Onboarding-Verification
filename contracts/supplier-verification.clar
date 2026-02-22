;; Supplier Verification Contract with Oracle Integration

;; Import supplier trait
(use-trait supplier-trait .supplier.supplier-trait)

;; Constants for credential types
(define-constant CREDENTIAL-TYPE-LICENSE 1)
(define-constant CREDENTIAL-TYPE-CERTIFICATION 2)
(define-constant CREDENTIAL-TYPE-COMPLIANCE 3)

;; Error constants
(define-constant ERR-INVALID-CREDENTIAL-TYPE (err u200))
(define-constant ERR-ORACLE-NOT-AUTHORIZED (err u201))
(define-constant ERR-SUPPLIER-NOT-FOUND (err u202))

;; Data structures
(define-map oracle-responses
  { supplier-id: uint, credential-type: uint }
  {
    verified: bool,
    oracle-address: principal,
    timestamp: uint,
    data-hash: (string-ascii 64)
  }
)

(define-data-var authorized-oracles (list 10 principal) (list))