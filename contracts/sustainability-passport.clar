;; Sustainability Passport NFT Contract

;; SIP-009 NFT Trait
(define-trait sip009-nft-trait
  (
    (get-last-token-id () (response uint uint))
    (get-token-uri (uint) (response (optional (string-ascii 256)) uint))
    (get-owner (uint) (response (optional principal) uint))
    (transfer (uint principal principal) (response bool uint))
  )
)

;; NFT Data Structure
(define-non-fungible-token sustainability-passport uint)

;; Passport data map
(define-map passport-data
  uint
  {
    product-name: (string-ascii 256),
    supplier-id: uint,
    sustainability-score: uint,
    carbon-footprint: uint,
    materials: (list 10 (string-ascii 64)),
    certifications: (list 10 (string-ascii 64)),
    ipfs-hash: (string-ascii 64),
    mint-date: uint
  }
)

;; Data variables
(define-data-var last-token-id uint u0)
(define-data-var base-uri (string-ascii 256) "https://api.example.com/passports/")

;; Error constants
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-TOKEN-NOT-FOUND (err u101))
(define-constant ERR-INVALID-SCORE (err u102))

;; SIP-009 Implementation
(define-read-only (get-last-token-id)
  (ok (var-get last-token-id))
)

(define-read-only (get-token-uri (token-id uint))
  (let
    (
      (base (var-get base-uri))
    )
    (ok (some (concat base (uint-to-ascii token-id))))
  )
)