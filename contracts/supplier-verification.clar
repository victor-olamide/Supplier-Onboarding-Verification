;; Supplier Verification Contract with Oracle Integration

;; Import supplier trait
(use-trait supplier-trait .supplier.supplier-trait)

;; Constants
(define-constant CONTRACT-OWNER tx-sender)

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

;; Function to authorize an oracle (admin only)
(define-public (authorize-oracle (oracle principal))
  (let
    (
      (current-oracles (var-get authorized-oracles))
    )
    (begin
      (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-UNAUTHORIZED)
      (var-set authorized-oracles (append current-oracles oracle))
      (ok true)
    )
  )
)

;; Function for oracle to submit verification response
(define-public (submit-oracle-response (supplier-id uint) (credential-type uint) (verified bool) (data-hash (string-ascii 64)))
  (let
    (
      (oracles (var-get authorized-oracles))
    )
    (begin
      (asserts! (is-some (index-of oracles tx-sender)) ERR-ORACLE-NOT-AUTHORIZED)
      (asserts! (or (= credential-type CREDENTIAL-TYPE-LICENSE) (= credential-type CREDENTIAL-TYPE-CERTIFICATION) (= credential-type CREDENTIAL-TYPE-COMPLIANCE)) ERR-INVALID-CREDENTIAL-TYPE)
      (map-set oracle-responses
        { supplier-id: supplier-id, credential-type: credential-type }
        {
          verified: verified,
          oracle-address: tx-sender,
          timestamp: block-height,
          data-hash: data-hash
        }
      )
      (ok true)
    )
  )
)

;; Function to verify supplier credentials using oracle data
(define-public (verify-supplier-credentials (supplier-contract <supplier-trait>) (supplier-id uint))
  (let
    (
      (license-response (map-get? oracle-responses { supplier-id: supplier-id, credential-type: CREDENTIAL-TYPE-LICENSE }))
      (cert-response (map-get? oracle-responses { supplier-id: supplier-id, credential-type: CREDENTIAL-TYPE-CERTIFICATION }))
      (compliance-response (map-get? oracle-responses { supplier-id: supplier-id, credential-type: CREDENTIAL-TYPE-COMPLIANCE }))
    )
    (begin
      (asserts! (and (is-some license-response) (is-some cert-response) (is-some compliance-response)) ERR-INVALID-CREDENTIAL-TYPE)
      (asserts! (and (get verified (unwrap-panic license-response)) (get verified (unwrap-panic cert-response)) (get verified (unwrap-panic compliance-response))) ERR-INVALID-CREDENTIAL-TYPE)
      (try! (contract-call? supplier-contract verify-supplier supplier-id))
      (ok true)
    )
  )
)

;; Function to authorize an oracle (admin only)
(define-public (authorize-oracle (oracle principal))
  (let
    (
      (current-oracles (var-get authorized-oracles))
    )
    (begin
      (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-UNAUTHORIZED)
      (var-set authorized-oracles (append current-oracles oracle))
      (ok true)
    )
  )
)